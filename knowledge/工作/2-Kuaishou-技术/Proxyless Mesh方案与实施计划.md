# Proxyless Mesh方案与实施计划

Proxyless Mesh方案与实施计划

# **一、背景**

## **1.1 业务现状**

### **服务研发 / 变更流程**

![out?code=fcADJcl-SDDUgSUUbYn5EvUc4:4420216086755441644fcADJcl-SDDUgSUUbYn5EvUc4:1774423265721](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADJcl-SDDUgSUUbYn5EvUc4:4420216086755441644fcADJcl-SDDUgSUUbYn5EvUc4:1774423265721)

（1）发版次数多

		2023年1月至今，中间件SDK共**发版242次**，其中Java发版117次、 go发版30次，python发版15次、c++发版80次
	
* AZ架构迭代项目中，Redis、数据库、RPC等各个中间件产品进行了适配改造，发版10余次，这些改动不仅增加了开发和测试的复杂性，也要求业务进行了多轮升级。
	以社科为例，每个服务编译/部署需2小时，灰度观察需2小时，**每轮升级耗费人力成本约30人月**，总耗费人力超过300人月（[【社科推荐】PAZ调度开启、去除 VAZ](https://docs.corp.kuaishou.com/k/home/VfvR7-ZUzVeM/fcAAINQaROMVnIgG7lNEavUzU)）
	
		各语言服务数：Java语言3.2万，C++语言2.5万，Go语言2000+，Python语言6000+
	

（2）SDK版本收敛慢

		Java SDK发布3个月可以覆盖90%节点，覆盖55% KSN
	
		C++ SDK发版2个月可以覆盖60%节点，发版8个月可以覆盖80%节点，发版1年可以覆盖90%节点
	
		造成SDK存在多个版本共存的现象，比如当前Redis SDK线上约35个版本，Kafka SDK有50个版本，RPC SDK有72个版本
	
		多版本共存造成已知问题反复发生，跨多个版本升级时会遇到困难，24年因使用错误版本的SDK而引发的故障超过3起
	

（3）SDK召回慢，历次故障后SDK召回的耗时都比较长

		[20240417](https://halo.corp.kuaishou.com/helheim/fault-report/draft/71538)  ES NPE问题，召回长尾服务用时3天左右
	
		[20240102](https://halo.corp.kuaishou.com/helheim/fault-report/draft/70990) C++ kconf SDK整体召回到安全线大约2天左右
	
		[20231201](https://docs.corp.kuaishou.com/d/home/fcABNRdp1rgH6L58Eqb2liqQO)Rocketmq SDK 消费者实例启动失败，故障召回耗时2天左右
	
		[20230616](https://halo.corp.kuaishou.com/helheim/fault-report/draft/69535) C++ Redis SDK 整体召回到安全线大约1天左右
	
		[20230420](https://halo.corp.kuaishou.com/helheim/fault-report/draft/69183) Java Redis SDK 整体召回到安全线大约1天左右
	
		[20230210](https://halo.corp.kuaishou.com/helheim/fault-report/draft/68669) Java MySQL SDK故障后旧版本召回用时2天
	
		[20221214](https://halo.corp.kuaishou.com/helheim/fault-report/draft/68153) Java Redis SDK 整体召回到安全线大约2天左右
	
		[20221201](https://halo.corp.kuaishou.com/helheim/fault-report/draft/68056) C++ RPC SDK 召回主要服务用时10天左右
	
		[20221018](https://halo.corp.kuaishou.com/helheim/fault-report/draft/67738) ES SDK 故障后旧版本召回用时3天
	
		[20220817](https://halo.corp.kuaishou.com/helheim/fault-report/draft/66968) C++ kafka sdk 故障后旧版本召回用时7天
	
		[20210831](https://halo.corp.kuaishou.com/helheim/#/fault-report/draft/2162) Java Redis SDK 故障后旧版本召回用时2天
	
		[20210419](https://halo.corp.kuaishou.com/helheim/#/fault-report/draft/1157) C++ Kafka SDK 故障后旧版本召回用时3天
	
		[20210105](https://halo.corp.kuaishou.com/helheim/#/fault-report/draft/746)Java Jedis SDK 故障后旧版本召回用时6天
	

### **多语言客户端研发现状**

![out?code=fcADJcl-SDDUgSUUbYn5EvUc4:9214093515074958070fcADJcl-SDDUgSUUbYn5EvUc4:1774423265722](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADJcl-SDDUgSUUbYn5EvUc4:9214093515074958070fcADJcl-SDDUgSUUbYn5EvUc4:1774423265722)

（1）语言栈多、组件多，需要业务重新发版升级才能升级 / 召回

		涉及Java SDK 30+，C++ SDK 21+，Python SDK 11个，Golang SDK 12个
	
		多语言功能长期对不齐，部分场景下处理行为存在逻辑冲突
	

（2）多语言客户端逻辑不一致造成故障风险

		[20240612](https://docs.corp.kuaishou.com/d/home/fcADDR2fJx4Pc1eBC0754bDrQ) kconf go sdk 老版本环境逻辑判断问题
	
		[20240802](https://docs.corp.kuaishou.com/d/home/fcACrCfX8Yor8i1lBBcg13dPZ) kconf低版本sdk导致kds桥检测页面空白
	
		[20220701](https://halo.corp.kuaishou.com/helheim/fault-report/draft/66517)Java下发有问题的路由表后C++ json decode异常导致路由表不更新
	

（3）交付周期慢、多语言开发成本高

		功能需要不同语言重复开发，交付周期长，协调过程复杂
	
		不同SDK的维护团队在排期和优先级上的差异，可能导致一些新功能无法按预期完成
	
		不同语言存在差异，对RD要求高，人力成本也相应增加
	

总体来说，多语言客户端重复开发、功能对不齐、灰度周期长是亟需解决的问题。

## **1.2 行业现状**

随着公司软件架构的演进和组织分工的细化，上述问题也愈加突出。

Service Mesh因其对服务粒度的精细控制、跨语言兼容性、安全性、可观测性和容错能力，成为许多互联网公司应对上述挑战的重要选择。

Service Mesh主要有Sidecar模式和Proxyless模式，常见的开源框架如Istio、Dubbo和Spring Cloud对此提供了支持。

在Java技术栈中，OSGI技术通过Classloader实现类隔离和热更新，Apache Felix和Knopflerfish等框架采用了该技术，阿里的Pandora、蚂蚁的SofaARK也借鉴了这一理念。

阿里和蚂蚁在Service Mesh的应用上走在前列，其中蚂蚁的Sofa ARK在技术上处于领先地位，字节在架构改造上进展迅速，而美团则因业务特点仍在试点阶段，实际应用较少。

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| 方案  | 传统SDK模式 | Java Classloader | Proxyless Mesh | Sidecar Mesh |
| 架构  | 中间件SDK与业务代码运行在同一个进程 | 通过Classloader隔离 | 中间件与业务代码运行在同一个进程<br><br>（其中不变部分和业务代码编译到一个软件包，可变部分以动态连接库形式存在） | 中间件作为边车形态独立部署 |
| 多语言支持 | 不支持 | 不支持 | 支持  | 支持  |
| 适用场景 | 重/轻客户端逻辑均适用 | 重/轻客户端逻辑均适用 | 重/轻客户端逻辑均适用 | 轻客户端逻辑适用<br><br>重客户端逻辑的不适用，如分库分表 |
| 变更流程 | 走完整发版流程 | 部分场景支持热更新 | 进程重启生效 | 实时生效 |
| 资源成本 | 未引入额外成本 | 未引入额外成本 | 未引入额外成本 | 通过代理进行通信，增加延迟和CPU等资源开销。以Redis Sidecar为例，经过测试，业务实例上内存占用增长大约40M，每1W qps请求，CPU增长约20%；<br><br>需独立部署，额外占用资源 |
| 侵入性 | 高   | 低   | 低   | 低   |
| 互联网公司选型 | 快手（当前）<br><br>美团<br><br>拼多多 | 阿里  | 快手（意向） | 蚂蚁<br><br>字节 |
| 选型理由 | 美团：业务团队主导技术方案，改造意愿低（[OCTO 2.0：美团基于Service Mesh的服务治理系统详解](https://tech.meituan.com/2021/03/08/octo-2.0-service-mesh.html)，[复杂环境下落地Service Mesh的挑战与实践](https://tech.meituan.com/2020/12/03/service-mesh-in-meituan.html)）<br><br>拼多多：重业务轻架构，架构复杂度低，改造意愿低 | 阿里：技术栈以Java为主，较早期已通过Pandora实现类隔离 | 快手：多语言技术栈，迭代快，性能要求高 | 蚂蚁：技术架构自上而下驱动，性能要求低场景使用Sidecar，高性能场景使用SDK（[蚂蚁金服 Service Mesh 大规模落地系列（消息篇）](https://www.infoq.cn/article/WJrfS2b5URE5is8wmQFO)，[蚂蚁金服 Service Mesh 大规模落地系列（运维篇）](https://www.infoq.cn/article/4PVdZwCeX4LrbH1y1aec?utm_source=related_read_bottom&utm_medium=article)）<br><br>字节：Sidecar模式在RPC和DB场景落地，覆盖大部分在线业务，有完善的sidecar发布管理机制（[字节跳动云原生微服务多运行时架构实践](https://mp.weixin.qq.com/s/fslIwjJd3I-oWOhVviZhVQ)，[抖音春晚活动背后的 Service Mesh 流量治理技术](https://mp.weixin.qq.com/s/dA9bTQm0llLyy-AbE3gO-w)，[字节跳动开源 Shmipc：基于共享内存的高性能 IPC](https://mp.weixin.qq.com/s/f8SoJELaBoieePwMtRlj-Q)） |

# **二、建设目标**

结合快手业务特点，以及业界技术现状，我们期望通过引入Proxyless Mesh技术，来解决如下问题：

		**降开发及维护成本：**解决多语言SDK重复开发、功能对不齐，维护成本高的问题
	
		**解耦发版流程：**SDK独立发版召回，提升发布效率、降低维护成本，提升稳定性
	
		**提升质量：**减少风险语言栈的SDK数量（减少C++代码范围），采用安全语言提升SDK质量
	

# **三、Proxyless实施方案与实施规划**

## **3.1 降低SDK开发维护成本**

### **实现原理**

![out?code=fcADJcl-SDDUgSUUbYn5EvUc4:-6819538703558129283fcADJcl-SDDUgSUUbYn5EvUc4:1774423265724](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADJcl-SDDUgSUUbYn5EvUc4:-6819538703558129283fcADJcl-SDDUgSUUbYn5EvUc4:1774423265724)

### **目标架构**

![out?code=fcADJcl-SDDUgSUUbYn5EvUc4:-6105164454304144306fcADJcl-SDDUgSUUbYn5EvUc4:1774423265724](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADJcl-SDDUgSUUbYn5EvUc4:-6105164454304144306fcADJcl-SDDUgSUUbYn5EvUc4:1774423265724)

		将SDK拆分为用户接口和逻辑实现两个部分。用户接口不经常变化，集成到业务代码中，而逻辑实现迭代频繁，以动态链接库（.so）的形式进行统一管理
	
		解决多语言客户端重复开发、功能对不齐问题
	

## **3.2 解耦发版流程**

![out?code=fcADJcl-SDDUgSUUbYn5EvUc4:1832714858711053877fcADJcl-SDDUgSUUbYn5EvUc4:1774423265724](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADJcl-SDDUgSUUbYn5EvUc4:1832714858711053877fcADJcl-SDDUgSUUbYn5EvUc4:1774423265724)

		**开发阶段：**中间件能力内聚，归一化内核能力解决共性问题，对业务屏蔽复杂度；通过so动态链接库形态统一管控
	
		**部署阶段：**体系化管理so动态链接库，提供统一的可观测、可灰度、可回滚能力，屏蔽业务对so的感知，业务研发仅重启即可实现版本升级
	
		**结果：**解决多语言客户端灰度周期长，多版本共存问题
	

## **3.3 减少高风险语言SDK数量**

|     |     |     |
| --- | --- | --- |
|  | C++ | Golang |
| 产出物 | so动态链接库 | 可编译成兼容C语言的共享库 |
| 内存管理 | 手动控制，Core风险高 | 有自动垃圾回收 |
| 跨平台 | 不支持 | 支持  |
| 性能  | 高   | 有GC开销，比C++略低 |
| 维护成本 | 高   | 低   |
| 开发效率 | 低   | 高   |
| 语言选择 | Redis、Memcached、RPC等 | ABTest、Kconf、IPIP、Kcenter等 |

语言选择：对于性能要求较高且变化不频繁的组件，使用C++来实现；对于性能要求较低且需要频繁迭代的组件，则可以选择Golang，以提高开发效率

风险防控：考虑到C++实现可能带来的Coredump风险，对于流量较小且CPU使用率不高的组件，优先使用更安全的Golang语言

## **3.4 实施规划**

![out?code=fcADJcl-SDDUgSUUbYn5EvUc4:181112594037970192fcADJcl-SDDUgSUUbYn5EvUc4:1774423265725](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADJcl-SDDUgSUUbYn5EvUc4:181112594037970192fcADJcl-SDDUgSUUbYn5EvUc4:1774423265725)

# **四、阶段性进展**

## **4.1 基于BTQ验证Python调用so**

### **实现原理**

![out?code=fcADJcl-SDDUgSUUbYn5EvUc4:7198677441297608490fcADJcl-SDDUgSUUbYn5EvUc4:1774423265725](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADJcl-SDDUgSUUbYn5EvUc4:7198677441297608490fcADJcl-SDDUgSUUbYn5EvUc4:1774423265725)

Python程序使用BTQ进行消息收发时，只需直接调用Python接口，例如produce()和consume()。

BTQ的复杂逻辑，如点对点传输、缓存管理和动态配置处理，都被隐藏在C++动态库。

### **开发成本**

|     |     |
| --- | --- |
| **原生SDK** | **Proxyless Mesh** |
| 实现Java、C++、Python三种版本；<br><br>BTQ C++ SDK有3w行左右代码 | 仅实现C++ 版本BTQ SDK；<br><br>Python SDK封装部分只需要300行代码 |

### **性能对比**

对比Proxyless Mesh SDK与原生BTQ Python SDK在性能上的差异，Mesh版本在CPU消耗方面降低了约80%，而其极限QPS则提升了约250%。

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| 消息大小 | 原版Python SDK | proxyless mesh版本 | 原版Python SDK | proxyless mesh版本 |
| 10B | CPU：51% | CPU：10.3% | QPS：582 | QPS：2036 |
| 100B | CPU：53% | CPU：10.7% | QPS：576 | QPS：1852 |
| 1KB | CPU：54% | CPU：12% | QPS：567 | QPS：2124 |
| 1MB | CPU：54% | CPU：12.7% | QPS：562 | QPS：1996 |

## **4.2 基于IPIP验证Go调用so**

![out?code=fcADJcl-SDDUgSUUbYn5EvUc4:2608923687626815920fcADJcl-SDDUgSUUbYn5EvUc4:1774423265725](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADJcl-SDDUgSUUbYn5EvUc4:2608923687626815920fcADJcl-SDDUgSUUbYn5EvUc4:1774423265725)

相比较c++ IPIP sdk代码行数为2593行，Mesh版本的Go SDK封装部分仅需要114行代码，开发成本提升明显。

go语言可以通过cgo来调用c代码，sdk自上而下分为四个部分：

		最上层业务直接可见的部分为go语言对外暴露的sdk接口
	
		中间层是cgo层，这一层会通过cgo让go的函数调用c语言的函数
	
		再下一层为c语言封装层，用c语言封装了c++ sdk对外暴露的c++接口
	
		最下层为c++原始的sdk，以动态库的形式链接到业务的进程中
	

## **4.3 通过MC验证架构优化效果**

### **实现原理**

![out?code=fcADJcl-SDDUgSUUbYn5EvUc4:4592798600035833976fcADJcl-SDDUgSUUbYn5EvUc4:1774423265726](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADJcl-SDDUgSUUbYn5EvUc4:4592798600035833976fcADJcl-SDDUgSUUbYn5EvUc4:1774423265726)

当前Java应用通过原生的spymemcached来读写memcached集群。

引入JNI Memcached后，jni memcached客户端在接口层代理了spymemcached的处理逻辑。当代码执行到spymemcached接口层，流量会转发到JNI Memcached客户端的Java对接层。在这一层，主要任务是将请求打包成适合C++层处理的格式。随后，相关的请求参数通过JNI接口传递到C++共享库。当C++层收到来自Java的参数时，会将这些参数转换为Ketama Memcached客户端所需的格式，最终将请求发送到服务器。当服务器返回结果后，系统会从TCP流中提取相应的字节流，并将其解析为所需的格式。

### **架构收益**

|     |     |     |
| --- | --- | --- |
|  | 原生SDK | Proxyless Mesh |
| 开发成本 | 开发Java、C++、Python、Golang四种版本 | 仅开发JNI MC一种版本 |
| 发布成本 | 每个服务均需要发版，经过完整发版流程 | 仅JNI MC走发版流程，业务KSN仅灰度重启 |
| 管理成本 | 灰度成本高，发版周期长，线上版本多 | 发版成本低，发版周期短，回滚快 |

### **性能收益**

（1）进程内操作单Memcached集群的优化效果

我们对spymemcached和JNI Memcached Client整体进行每部分的拆分测试，测试的结果如下图。我们下面将通过图片来展示当QPS为1w、getbulk batch的key为50的时候各部分大致的CPU的消耗整体情况，并展示了JNI Memcached Client对比spymemcached有收益的部分的CPU消耗差别。

![out?code=fcADJcl-SDDUgSUUbYn5EvUc4:-7416868915848078393fcAA5ffXFVVurYS2wNF2di7r3:1774423265726](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADJcl-SDDUgSUUbYn5EvUc4:-7416868915848078393fcAA5ffXFVVurYS2wNF2di7r3:1774423265726)

可以通过分析上图可以得知在QPS为1w、getbulk batch的key为50的时候，主要的收益分为两部分：

		通过减少parser的CPU消耗，JNI Memcached Client优化parser后，CPU消耗比spymemcached低了0.42个核左右，占spymemcached的CPU消耗的16.7%。
	
		Key Hash & 负载均衡消耗的减少，JNI Memcached Client在Key Hash & 负载均衡这部分的CPU消耗比spymemcached低了0.16个核左右，占spymemcached的CPU消耗的6.4%。
	

所以整体来说，在这个场景下，JNI Memcached Client对比spymemcached的CPU消耗减少了为23.9%左右。

（2）模拟实际业务场景，进程内同时操作150个Memcached集群

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
|  | **QPS 1.5w** | **QPS 4w** | **QPS 5w** | **QPS 6w** |
| **SPY** | 关闭协程：CPU：18.53%<br><br>开启协程：CPU：22.55% | 关闭协程：CPU：49.60%<br><br>开启协程：CPU：47.71% | 关闭协程：CPU：65.87%<br><br>开启协程：CPU：57.89% | 关闭协程：CPU：75.79%<br><br>开启协程：CPU：60.64% |
| **JNI（优化前）** | 关闭协程：CPU：16.23%<br><br>开启协程：CPU：18.17% | 关闭协程：CPU：45.25%<br><br>开启协程：CPU：45.86% | 关闭协程：CPU：56.39%<br><br>开启协程：CPU：53.53% | 关闭协程：CPU：72.7%<br><br>开启协程：CPU：82.95% |
| **JNI（优化后）** | 关闭协程：CPU：12.35%<br><br>开启协程：CPU：14.63% | 关闭协程：CPU：32.75%<br><br>开启协程：CPU：34.56% | 关闭协程：CPU：40.74%<br><br>开启协程：CPU：39.92% | 关闭协程：CPU：47.75%<br><br>开启协程：CPU：42.40% |
| **JNI（优化前） vs SPY**<br><br>**优化效果** | 关闭协程：12.4%<br><br>开启协程：19.4% | 关闭协程：8.8%<br><br>开启协程：3.9% | 关闭协程：14.4%<br><br>开启协程：7.5% | 关闭协程：4.1%<br><br>开启协程：-36.8% |
| **JNI（优化后） vs SPY**<br><br>**优化效果** | 关闭协程：33.4%<br><br>开启协程：35.1% | 关闭协程：34.0%<br><br>开启协程：27.6% | 关闭协程：38.2%<br><br>开启协程：31.0% | 关闭协程：37.0%<br><br>开启协程：30.1% |

实际业务场景中，一般会在进程内同时操作多个Memcached集群，因此我们构建了进程内同时访问150个Memcached集群的测试场景。结果显示：

		在没有开启Java协程的情况下，JNI相较原生SPY的CPU消耗减少了 4.1%~14.4%
	
		开启Java协程后，当QPS小于5w时，JNI相较原生SPY的CPU消耗减少了3.9%~19.4%，但当QPS大于6w时，出现了JNI使用CPU高于SPY的情况
	

经分析，产生劣化的原因是JNI线程无法被Wisp协程代理，过多的线程在高QPS下产生锁争抢，为此我们针对JNI线程多的问题进行了优化，通过固定个数的线程来代理Memcached集群的读写操作，优化效果如下：

		在没有开启Java协程的情况下，JNI相较原生SPY的CPU消耗减少了 33.4%~38.2%
	
		开启Java协程后，JNI相较原生SPY的CPU消耗减少了 27.6%~35.1%
	

### **主站测试效果（弹幕服务）**

对主站弹幕服务进行性能测试（容器规格：26c40g），当业务服务的QPS在1000、2000、3000、3300时，对应访问MC的QPS为5000、10000、15000，17000。

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
|  | **弹幕QPS1000，MC QPS5000** | **弹幕QPS2000，MC QPS10000** | **弹幕QPS3000，MC QPS15000** | **弹幕QPS3300，MC QPS17000** |
| **SPY** | 关闭协程：CPU：29.0%<br><br>开启协程：CPU：26.1% | 关闭协程：CPU：59.1%<br><br>开启协程：CPU：52.7% | 关闭协程：CPU：压不到目标QPS<br><br>开启协程：CPU：79.9% | 关闭协程：CPU：压不到目标QPS<br><br>开启协程：CPU：86.5% |
| **JNI（优化前）** | 关闭协程：CPU：28.4%<br><br>开启协程：CPU：26.0% | 关闭协程：CPU：57.8%<br><br>开启协程：CPU：53.2% | 关闭协程：CPU：压不到目标QPS<br><br>开启协程：CPU：82.3% | 关闭协程：CPU：压不到目标QPS<br><br>开启协程：CPU：89.5% |
| **JNI（优化后）** | 关闭协程：CPU：27.4%<br><br>开启协程：CPU：25.1% | 关闭协程：CPU：55.6%<br><br>开启协程：CPU：51.3% | 关闭协程：CPU：压不到目标QPS<br><br>开启协程：CPU：77.3% | 关闭协程：CPU：压不到目标QPS<br><br>开启协程：CPU：84.4% |
| **JNI（优化前） vs SPY**<br><br>**优化效果** | 关闭协程：2.1%<br><br>开启协程：0.3% | 关闭协程：2.2%<br><br>开启协程：-0.9% | 关闭协程：-<br><br>开启协程：-3.0% | 关闭协程：-<br><br>开启协程：-3.4% |
| **JNI（优化后） vs SPY**<br><br>**优化效果** | 关闭协程：5.5%<br><br>开启协程：3.8% | 关闭协程：5.9%<br><br>开启协程：2.7% | 关闭协程：-<br><br>开启协程：3.3% | 关闭协程：-<br><br>开启协程：2.5% |

弹幕服务在进程内同时操作189个Memcached集群。测试结果如下：

		在没有开启Java协程的情况下，访问MC的QPS在10000时系统处理能力达到上限。JNI（优化前）相较原生SPY的CPU消耗减少了2.2%，JNI（优化后）相较原生SPY的CPU消耗减少了5.9%
	
		开启Java协程后，JNI（优化前）相较原生SPY的CPU消耗有所增加，JNI（优化后）相较原生SPY的CPU消耗减少了2.5%~3.8%
	

## **4.2 实现多语言内核归一**

![out?code=fcADJcl-SDDUgSUUbYn5EvUc4:3443898173616025320fcADJcl-SDDUgSUUbYn5EvUc4:1774423265728](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADJcl-SDDUgSUUbYn5EvUc4:3443898173616025320fcADJcl-SDDUgSUUbYn5EvUc4:1774423265728)

详细进展：

|     |     |     |     |
| --- | --- | --- | --- |
| **SDK** |     | **归一化语言** | **当前进展** |
| **服务类** | **KESS-RPC** | C++ | 进行中 |
| **数据存储类** | **Redis** | C++ | 未启动 |
| **MySQL** | C++，Java | 未启动 |
| **Memcached** | C++ | **编码完成，正在适配Java协程** |
| **Kcstore** | Golang | 未启动 |
| **Blobstore** | Golang | 未启动 |
| **Elasticsearch** | Golang | 未启动 |
| **消息类** | **BTQ** | C++ | **完成验证，python上线** |
| **Kafka** | C++ | 未启动 |
| **Rocketmq** | C++ | 未启动 |
| **监控类** | **Perflog** | Golang | 未启动 |
| **Ktrace** | Golang | 未启动 |
| **Runtimemetrics** | Golang | 未启动 |
| **KLog** | Golang | 未启动 |
| **Kcomp** | Golang | 未启动 |
| **Falcon** | Golang | **已有C++实现** |
| **配置类** | **Kconf** | Golang | 未启动 |
| **Kswitch** | Golang | 未启动 |
| **Keycenter** | Golang | 未启动 |
| **dsc** | Golang | 未启动 |
| **应用类** | **IPIP** | Golang | **已有C++实现** |
| **ABTest** | Golang | **已有C++实现** |

# **五、风险与挑战分析**

## **Core风险预防措施及应对策略**

![out?code=fcADJcl-SDDUgSUUbYn5EvUc4:-660173872759332217fcADJcl-SDDUgSUUbYn5EvUc4:1774423265729](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADJcl-SDDUgSUUbYn5EvUc4:-660173872759332217fcADJcl-SDDUgSUUbYn5EvUc4:1774423265729)

### **Core的原因**

		内存访问越界：包括数组下标越界、错误的字符串操作（如使用\`strcpy\`、\`strcat\`等函数时超出目标字符串的边界）等
	
		堆栈溢出：使用过大的局部变量或递归函数调用深度过大，导致超出系统允许的堆栈大小
	
		非法指针操作：如使用空指针、未初始化的指针或错误的指针类型转换
	
		多线程问题：多线程读写同一数据而未加锁保护，或使用了线程不安全的函数
	
		除以零：程序中存在除以零的操作
	
		非法指令：程序尝试执行计算机无法理解的指令
	

### 应对策略

		AddressSanitizer (ASan)：快速的内存错误检测工具，与编译器集成，支持内存泄漏和越界访问等问题的检测。在编译时期进行插桩，在开发阶进行内存泄漏和越界访问等问题的检测；
	
		流量录制与长稳测试：通过线上真实流量，验证so可靠性
	
		Valgrind：灰度验证阶段使用Valgrind进行全面的内存风险检测，预防内存泄漏、使用未初始化的内存、内存越界等问题
	

# **六、实施节奏**

![out?code=fcADJcl-SDDUgSUUbYn5EvUc4:-3133428572969544532fcADJcl-SDDUgSUUbYn5EvUc4:1774423265729](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADJcl-SDDUgSUUbYn5EvUc4:-3133428572969544532fcADJcl-SDDUgSUUbYn5EvUc4:1774423265729)

# **七、附录** 

## **Java框架版本收敛耗时（天）**

![out?code=fcADJcl-SDDUgSUUbYn5EvUc4:5279073037323631939fcAAfni0MTxJatzyooUP7nnha:1774423265729](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADJcl-SDDUgSUUbYn5EvUc4:5279073037323631939fcAAfni0MTxJatzyooUP7nnha:1774423265729)

## **CPP客户端版本收敛耗时（天）**

![out?code=fcADJcl-SDDUgSUUbYn5EvUc4:820707087280486553fcAAfni0MTxJatzyooUP7nnha:1774423265729](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADJcl-SDDUgSUUbYn5EvUc4:820707087280486553fcAAfni0MTxJatzyooUP7nnha:1774423265729)



    Created at: 2026-03-25T14:51:00+08:00
    Updated at: 2026-03-30T17:12:53+08:00

