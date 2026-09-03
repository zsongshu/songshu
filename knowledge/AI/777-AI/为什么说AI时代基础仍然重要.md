# 为什么说AI时代基础仍然重要

文章摘要：进入到2026年3月，整个行业弥漫着兴奋、焦虑和迷茫，仿佛一瞬间软件工程已经死亡，只要一个提示词，最多再加上几个Skills，你想要什么Agent马上可以提供给你。那么，曾经我们为此骄傲的技术还重要吗？

进入到2026年3月，整个行业弥漫着兴奋、焦虑和迷茫，仿佛一瞬间软件工程已经死亡，只要一个提示词，最多再加上几个Skills，你想要什么Agent马上可以提供给你。那么，曾经我们为此骄傲的技术还重要吗？或者说在AI时代，作为一位软件工程师还有什么是重要的？有人说是判断力，有人说是品味......

正好最近碰到一个线上高CPU问题，借着这个问题的排查和优化整个过程，聊一下大模型目前仍然不能替代扎实的基础知识，不过我也不知道3个月后会不会替代（大家都说AI一天，人间一年）。

问题的背景在这篇文章里有介绍：[记一次epoll_ctl系统调用开销高排查](https://kstack.corp.kuaishou.com/article/15179?userSource=kim-bot-user)，看到这个问题我当时就基本知道出问题的代码，因为之前已经碰到过memcached server主动断连，但是客户端（spymemcached）没有反应，等到业务应用下一次访问Memcached的时候才触发重连，当时看过代码，发现spymemcached使用Java NIO的方式有点不寻常，不过这个问题不是特别严重，就没有去修复。

问题的分析文档在这里，就不重复了：[spymemcached性能问题优化](https://docs.corp.kuaishou.com/d/home/fcAB5fWw86lGCq-idWz8tcOf7)，本文主要聊一下我在修复这个问题之前使用AI来分析，修复后使用AI进行评估，以及几个同事用不同的AI模型对代码进行Review的过程。

## 咨询AI优化建议

### 修复前第一次尝试(Cursor + Claude Opus 4.6)

```
我：这是一个memcached的客户端，@src/main/java/net/spy/memcached/MemcachedConnection.java 是网络处理部分，使用的是java nio，请你根据java高性能NIO的一些最佳实践，仔细审阅这个类的代码，看看有什么优化建议 AI：## Java NIO 高性能最佳实践审阅报告 ### 1. `Selector.wakeup()` 过度调用 — 严重性能瓶颈 ```1351:1364:src/main/java/net/spy/memcached/MemcachedConnection.java   protected void addOperation(final MemcachedNode node, final Operation o) {     if (!node.isAuthenticated()) {       retryOperation(o);       return;     }     o.setHandlingNode(node);     o.initialize();     node.addOp(o);     addedQueue.offer(node);     metrics.markMeter(OVERALL_REQUEST_METRIC);     Selector s = selector.wakeup();     assert s == selector : "Wakeup returned the wrong selector.";   } ``` **问题**: 每次 `addOperation`、`insertOperation`、`broadcastOperation` 都会调用 `selector.wakeup()`。`wakeup()` 在 Linux 上底层是通过 pipe 写入一个字节来实现的，这是一个**系统调用**。在高吞吐场景下（例如每秒数万次操作），这会成为主要瓶颈。 **优化建议**: 采用 Netty 风格的 **wakeup 合并（coalescing）** 策略，使用 `AtomicBoolean` 标志位减少实际 wakeup 调用次数： ```java private final AtomicBoolean wakenUp = new AtomicBoolean(false); protected void addOperation(final MemcachedNode node, final Operation o) {     // ... existing logic ...     node.addOp(o);     addedQueue.offer(node);     metrics.markMeter(OVERALL_REQUEST_METRIC);     if (wakenUp.compareAndSet(false, true)) {         selector.wakeup();     } } // 在 handleIO() 开头重置 public void handleIO() throws IOException {     wakenUp.set(false);     // ... rest of handleIO ... } ``` 这样在一个 select 周期内，多个并发 `addOperation` 只会触发**一次** wakeup 系统调用。 --- ### 2. `selectedKeys()` 迭代方式未优化 ```480:486:src/main/java/net/spy/memcached/MemcachedConnection.java       Iterator iterator = selector.selectedKeys().iterator();       while(iterator.hasNext()) {         SelectionKey sk = iterator.next();         handleIO(sk);         iterator.remove();       } ``` **问题**: JDK 默认的 `Selector.selectedKeys()` 返回的是 `HashSet`。每次 `iterator.remove()` 涉及 hash 计算和节点移除，在高连接数场景下开销不可忽视。 **优化建议**: 参考 Netty 的 `SelectedSelectionKeySet`，通过反射将 `selectedKeys` 替换为基于数组的实现，将 `add()` 操作从 O(1) amortized HashMap 降低为 O(1) 数组追加，并消除 `remove()` 开销（直接重置 size 即可）。这是 Netty 验证过的核心优化之一。 如果不想引入反射，至少可以改为： ```java Set selectedKeys = selector.selectedKeys(); if (!selectedKeys.isEmpty()) {     Iterator iterator = selectedKeys.iterator();     while (iterator.hasNext()) { :        SelectionKey sk = iterator.next();         iterator.remove();  // remove before handle to avoid double processing         handleIO(sk);     } } ``` 注意顺序上，应该**先 remove 再处理**，以防 `handleIO` 抛异常导致 key 未被移除，在下一轮 select 中被重复处理。 ---
```

总共给列了12个问题，不过只有第一个问题（不必要的selector.wakeup调用）算是一个值得解决的问题，不过也与当前的问题无关。感觉可能是上下文太多了，所以我缩小了上下文，直接告诉AI具体的方法。

### 修复前第二次尝试，缩小上下文（Cursor + Claude Opus 4.6）

```
我：@src/main/java/net/spy/memcached/MemcachedConnection.java 的handleInputQueue方法有什么可以优化的么 AI：--- ### 问题 1：每次调用都创建两个 `HashSet` — GC 压力 ```644:645:src/main/java/net/spy/memcached/MemcachedConnection.java       Collection toAdd = new HashSet<>();       Collection todo = new HashSet<>(); ``` `handleInputQueue()` 在每一轮 `handleIO()` 循环中都被调用（第460行），只要 `addedQueue` 不为空就会创建两个 `HashSet`。在高 QPS 场景下，`addedQueue` 几乎永远不为空，意味着每秒可能创建数千对 `HashSet` 对象。`HashSet` 内部维护一个 `HashMap`，初始化还涉及 `Node[]` 数组分配，开销不小。 **优化**：提升为实例变量，复用集合： ```java private final Set handleInputToAdd = new HashSet<>(); private final Set handleInputTodo = new HashSet<>(); private void handleInputQueue() {     if (!addedQueue.isEmpty()) {         handleInputToAdd.clear();         handleInputTodo.clear();         // ... 使用这两个集合 ...     } } ``` ---
```

AI又给我分析出了4个问题，但没有一个问题命中要害...

好吧，我接着进一步缩小上下文，已经缩小到没几行代码了

### 修复前第三次尝试（Cursor + Claude Opus 4.6）

```
我：@src/main/java/net/spy/memcached/MemcachedConnection.java handleInputQueue方法里的node.fixupOps();可以看看是不是有性能问题 AI：--- ## `fixupOps()` 性能分析 `fixupOps()` 的完整调用链是： ```634:644:src/main/java/net/spy/memcached/protocol/TCPMemcachedNodeImpl.java   public final void fixupOps() {     SelectionKey s = sk;     if (s != null && s.isValid()) {       int iops = getSelectionOps();       s.interestOps(iops);     } else {       logger.debug("Selection key is not valid.");     }   } ``` 其中 `getSelectionOps()` → `hasReadOp()` → `readQ.isEmpty()`、`hasWriteOp()` → `writeQ.isEmpty()`。 本身每次调用的开销不大，但问题在于**调用场景和频率**： ### 问题 1：对不活跃节点调用 `fixupOps()` 完全无效 回看 `handleInputQueue`： ```652:672:src/main/java/net/spy/memcached/MemcachedConnection.java       for (MemcachedNode node : todo) {         boolean readyForIO = false;         if (node.isActive()) {           if (node.getCurrentWriteOp() != null) {             readyForIO = true;           }         } else {           toAdd.add(node);      // 不活跃节点         }         node.copyInputQueue();         // ...         node.fixupOps();        // 无论活不活跃都调用       }       addedQueue.addAll(toAdd);  // 不活跃节点塞回去 ``` 不活跃的节点（`!isActive()`）被收集到 `toAdd` 里，最后又塞回 `addedQueue`。对这些节点调用 `fixupOps()` 时： - `sk` 大概率已经是 null 或 invalid（连接断开了），直接走进 `logger.debug()` 分支 - 即使 `sk` 意外 valid，注册了 interestOps 也无意义，因为底层 channel 已经断了 结合上一轮讨论的问题 —— 不活跃节点每轮 IO 循环都被 poll 出来再塞回去 —— 这意味着 `fixupOps()` **每轮循环都对这些节点白白调用一次**。
```

又给出了4个问题，但仍然没有什么用，而且AI直接给出s.interestOps(iops)调用成本不高（所以这个问题不用优化了）。

## 开始手动优化

到这个时候我已经不准备继续分析了（虽然我的token配额还没用完），所以准备手动去优化。从AI给出的分析能看出来几个点：

1. AI没有深入调用链路里去看代码，然后分析。比如在handleInputQueue方法里，node.getCurrentWriteOp()的方法就是判断writeQ是否为空，而node.copyInputQueue()才是向writeQ里写数据的代码，现在node.copyInputQueue()方法调用在node.getCurrentWriteOp()之后，只要AI往里再看一步，应该就能发现这个问题；
2. AI好像并不能理解interestOps意味着什么，这个有点奇怪，理论上AI的训练数据里应该已经有相关的知识；

## 优化后评估（Cursor + Claude Opus 4.6）

优化完成后，告诉AI修改的代码，评估一下这些优化的效果。AI评估的是减少selector.wakeup()的调用优化贡献最大，而对于interestOps的优化，AI只识别出 if(s.interestOps() != iops) 这个条件的添加，而根本没有识别出来对getSelectionOps里的优化的影响。

```
我：你比较一下从commit 6183224b0f1b8a3655927f10a8d1cabd68f93b46 到当前版本所有的变更对性能的影 AI：Let me do a detailed analysis. 现在我对所有变更有了全面的了解。以下是对从 `6183224b` 到当前版本共 **8 个提交** 的逐一性能分析： --- ## 变更总览 涉及两个文件：`MemcachedConnection.java` 和 `TCPMemcachedNodeImpl.java`，共 8 个提交，核心围绕 **NIO 事件循环的优化**。 --- ## 逐项分析 ### 1. 避免 `Selector.wakeup()` 重复调用（commit `67b4827`） ```1360:1363:/Users/zhaohui/work/projects/spymemcached/src/main/java/net/spy/memcached/MemcachedConnection.java     if (wakeUp.compareAndSet(false, true)) {       Selector s = selector.wakeup();       assert s == selector : "Wakeup returned the wrong selector.";     } ``` **性能影响：高** - **原逻辑**：每次 `addOperation` 都调用 `selector.wakeup()`。 - **新逻辑**：用 `AtomicBoolean` 做去重，多个并发的 `addOperation` 只有第一个会真正调用 `wakeup()`。 - **分析**：`Selector.wakeup()` 是一个系统调用（Linux 上写 eventfd/pipe），在高并发场景下代价不小。如果短时间内有大量请求入队，原来每次都要触发一次系统调用，现在合并为一次。**在高 QPS 场景下（比如批量操作），这个优化效果 显著**，减少了大量无意义的系统调用开销。 --- --- ### 2. 读事件始终注册 + `fixupOps` 避免重复 `interestOps` 设置（commit `153c6b0`） ```417:428:/Users/zhaohui/work/projects/spymemcached/src/main/java/net/spy/memcached/protocol/TCPMemcachedNodeImpl.java   public final int getSelectionOps() {     int rv = 0;     if (getChannel().isConnected()) {       rv |= SelectionKey.OP_READ;       if (toWrite > 0) {         rv |= SelectionKey.OP_WRITE;       }     } else {       rv = SelectionKey.OP_CONNECT;     }     return rv;   } ``` ```633:645:/Users/zhaohui/work/projects/spymemcached/src/main/java/net/spy/memcached/protocol/TCPMemcachedNodeImpl.java   public final void fixupOps() {     SelectionKey s = sk;     if (s != null && s.isValid()) {       int iops = getSelectionOps();       if (s.interestOps() != iops) {         s.interestOps(iops);       }     } else {       logger.debug("Selection key is not valid.");     }   } ``` **性能影响：中高** 这个提交做了两件事： - **OP_READ 始终注册**：去掉了 `hasReadOp()` 的判断。原来只有队列里有读操作才注册读事件，但 memcached 连接建立后几乎始终需要读（响应随时可能到达），原来的条件判断是多余的计算。简化后减少了每次循环中的方法调用和队列检查开 销。 - **`fixupOps` 中增加 `interestOps()` 相等判断**：`SelectionKey.interestOps(int)` 本身也是有一定开销的操作（涉及 key 状态的同步更新），如果值没变就跳过。**在稳态运行时（大部分时候只有 OP_READ），这个优化避免了大量无效的 `interestOps` 调用**。 ---
```

我又进一步追问interestOps方法的开销，然后AI又煞有介事的分析起来，从分析结果上看AI仍然没有理解interestOps意味着什么，大概只“看到”了Java层面的代码，如果仅仅Java层面的代码开销确实不高。

```
我：SelectionKey.interestOps(int)操作本身没什么性能开销吗 AI：好问题。`SelectionKey.interestOps(int)` 的开销取决于 JDK 版本，我来细说。 ## JDK 8（及更早版本） 在 JDK 8 中，`interestOps(int)` 的实现大致是： ```java public SelectionKey interestOps(int ops) {     ensureValid();     return nioInterestOps(ops); } public SelectionKey nioInterestOps(int ops) {     if ((ops & ~channel().validOps()) != 0)         throw new IllegalArgumentException();     channel.translateAndSetInterestOps(ops, this);  // 与 Selector 交互     interestOps = ops;     return this; } ``` `translateAndSetInterestOps` 会将这个 key 加入 Selector 的待更新集合（涉及同步操作），然后在下一次 `select()` 时触发 `epoll_ctl` 系统调用。**即使值没变，这些操作也会执行**，所以外部加一层 `if (s.interestOps() != iops)` 判断是有意义的。 ## JDK 11+ / 17+ 在较新的 JDK 中，OpenJDK 已经做了类似的优化： ```java public SelectionKey interestOps(int ops) {     ensureValid();     if ((ops & ~channel().validOps()) != 0)         throw new IllegalArgumentException();     int oldOps = (int) INTERESTOPS.getAndSet(this, ops); // VarHandle 原子操作     if (ops != oldOps) {         selector().setEventOps(this);  // 仅值变化时才通知 Selector     }     return this; ``` JDK 自身已经做了 `ops != oldOps` 的短路判断。这种情况下，外部的检查仍然能省掉： - `ensureValid()` 的校验 - `VarHandle.getAndSet` 的原子操作（比普通读写更重） - 方法调用本身的开销 但节省的量**确实不大了**。 ## 结论 你说得对，我之前说"中高"可能稍微高估了这一项。更准确地说： - 如果项目跑在 **JDK 8** 上，这个优化是有实际意义的，避免了不必要的 Selector 交互和后续的 `epoll_ctl`。 - 如果跑在 **JDK 11+**，JDK 内部已经做了类似优化，外部检查只省了一次方法调用 + `ensureValid` + 原子操作，**开销很小**，属于微优化的范畴。 在 `handleInputQueue` 的循环里，每个 node 每轮事件循环都会调用一次 `fixupOps`，如果节点数不多（通常 memcached 集群节点数有限），这里的调用频次并不算特别高，所以整体影响确实有限。
```

所以我再次追问了一下，并且让其重新评估这个改动的收益

```
我：我觉得你没理解这个优化更深层次的意义，原来的代码会导致interestOps频繁调用，而且参数每次都会发生变 AI：你说得对，我确实没有把这两个改动联系起来看。让我重新分析。 ## 原来的问题：interestOps 值在不断"抖动" 原来的 `getSelectionOps()`： ```java if (hasReadOp()) {     rv |= SelectionKey.OP_READ; } if (toWrite > 0 || hasWriteOp()) {     rv |= SelectionKey.OP_WRITE; } ``` `hasReadOp()` 和 `hasWriteOp()` 的返回值随队列状态频繁变化。一个典型的请求生命周期中，interestOps 的值会经历： 1. 请求入队前：readQ 可能为空 → `hasReadOp()` = false → 可能是 `0` 2. `copyInputQueue` 后有写操作 → `hasWriteOp()` = true → 变成 `OP_WRITE` 3. 写完后进入 readQ 等响应 → `hasReadOp()` = true, `hasWriteOp()` = false → 变成 `OP_READ` 4. 响应读完后 readQ 清空 → `hasReadOp()` = false → 又变成 `0` **每个请求的处理周期中，interestOps 的值在不断跳变**。而 `fixupOps` 每次事件循环都会被调用，由于值每次都不同，`interestOps(int)` 每次都会真正生效，导致每轮 `select()` 都要对每个节点执行 `epoll_ctl` 系统调用。 ## 改动后：interestOps 值趋于稳定 新的 `getSelectionOps()`： ```java rv |= SelectionKey.OP_READ;        // 始终注册 if (toWrite > 0) {                  // 仅 socket 缓冲区写满时     rv |= SelectionKey.OP_WRITE; } ``` 在正常工况下： - OP_READ **永远是开的**，不再抖动 - OP_WRITE 只在 socket 缓冲区写满、数据没写完时才开启，**这在正常网络条件下极少发生** 所以 `getSelectionOps()` 几乎每次都返回同一个值：`OP_READ`。加上 `fixupOps` 中的 `if (s.interestOps() != iops)` 判断，**稳态下 `interestOps(int)` 几乎不会被调用**，也就意味着 `select()` 时不需要执行 `epoll_ctl`。 ## 真正的性能收益 这两个改动是**配合起来工作**的： - **改变 interestOps 的计算逻辑** → 让返回值在稳态下保持不变 - **加上相等性判断** → 利用这个稳定性跳过 `interestOps(int)` 调用 核心收益不是省掉一次 Java 方法调用，而是**大幅减少了 `epoll_ctl` 系统调用的次数**。原来几乎每轮事件循环、每个节点都要调用一次 `epoll_ctl`，现在只有在 socket 缓冲区写满/恢复这种极少的状态转换时才需要。如果集群有 N 个节点，事件循环每秒转 M 次，原来每秒约 N×M 次 `epoll_ctl`，现在接近 0。 这个优化的影响程度我之前确实低估了，应该是**高**级别的优化。谢谢纠正。
```

到目前为止，无论是优化前咨询AI给优化建议，还是优化后让AI评估优化效果，AI的表现都很一般。因为这是一次对Memcached Client的核心逻辑进行修改，所以修改后让几位同事对代码进行仔细评审，不过仿佛到了2026年，大家已经不再进行人肉Code Review了，基本上都是靠AI来Review。

我截取一些AI Code Review的片段，发现这些AI Code Review的能力也不怎么样

## Code Review

### AI Code Review1：OP\_WRITE事件是否可以一直注册

下面是某国产大模型（就不点名了）给出的结论，完全是胡扯，我感觉这个大模型应该是从CSDN上抓取了中文语料进行了训练。

![ec12a7cdfacf52dad0497f606e16e5db.png](https://h23.static.yximgs.com/udata/pkg/EE-KSTACK/ec12a7cdfacf52dad0497f606e16e5db.png)

### AI Code Review2：wakeUp是否存在竞态条件

AI说的是减少wakeUp的调用次数这个逻辑存在静态条件，我先贴一下源代码：

```
  //业务逻辑开始发数据   protected void addOperation(final MemcachedNode node, final Operation o) {     if (!node.isAuthenticated()) {       retryOperation(o);       return;     }     o.setHandlingNode(node);     o.initialize();     node.addOp(o);     addedQueue.offer(node);     metrics.markMeter(OVERALL_REQUEST_METRIC);     //只需要第一次wakeup即可，后续的wakeup可以消除掉     if (wakeUp.compareAndSet(false, true)) {       Selector s = selector.wakeup();       assert s == selector : "Wakeup returned the wrong selector.";     }   }
```

AI说的是如果这个时候业务逻辑发数据，但是因为wakeUp已经设置为true了，所以selector.wakeup不会生效，这样就会漏一次wakeup，导致业务发的数据要等1秒之后再发送。这里主要的是AI没有理解，Selector的wakeup是有状态的，也就是在Selector.select调用之前，只要调用了Selector.wakeup，就会记录一个标记，然后再调用Selector.select会立即返回，所以这个竞态条件其实也不存在。

![04fdee99a6ad34be214e1dfcf62fee95.png](https://h23.static.yximgs.com/udata/pkg/EE-KSTACK/04fdee99a6ad34be214e1dfcf62fee95.png)

## 总结

写本文不是想说使用AI不好，而是想表达在使用AI的时候要有判断力，你能否判断AI给出的结论是正确的。前一阵有位行业大佬来公司交流，他说的一句话我觉得挺对：使用AI正确的姿势是指导AI，指挥AI去做事，而不是把AI当做老师，去请教AI。

## 后续

刚才又补充了一个实验，把下面两个Java NIO最佳实践给到AI：

```
你根据下面的思路再看看吧  关于Java NIO的两点共识： 1. OP_READ事件可以一直注册，只要Socket上有数据，该事件就会被触发，一般只有在实现背压机制的时候，才会取消OP_READ事件，比如从Socket读取数据后，将数据放到内存的一个队列，队列满之后取消OP_READ事件（spymemcached中未实现背压机制）。 2. OP_WRITE只有当Socket buffer满之后才需要注册，当Socket buffer变得可写后会触发，不要一直注册OP_WRITE，会导致空循环。
```

然后让其再继续分析，他根据这个Java NIO最佳实践，分析出原来的代码存在bug：

![11a2fe7e1683caee618294907911ed99.png](https://h23.static.yximgs.com/udata/pkg/EE-KSTACK/11a2fe7e1683caee618294907911ed99.png)

然后将优化代码改对了：

![e69df0fb1faf8d04a1776c4c3a846390.png](https://h23.static.yximgs.com/udata/pkg/EE-KSTACK/e69df0fb1faf8d04a1776c4c3a846390.png)

在评论里，有同学提示可能是harness没做好，这个好像也对，对于一个使用Java NIO编写的网络客户端，在其“宪法”里应该写上Java NIO最佳实践的一切。不过，这也回应了上面说的，不要把AI当做老师，去请教AI，应该是指挥他，给他制定规则。

所以写了一个Java NIO的Skill，有涉及Java NIO相关开发的时候可以安装使用：[Java NIO Skill](https://wanqing.corp.kuaishou.com/proj-h598e3-1764918492747655955/skills-square/detail/skill-3nonln-1774438418136465914)

    Created at: 2026-03-31T15:59:35+08:00
    Updated at: 2026-03-31T15:59:59+08:00

