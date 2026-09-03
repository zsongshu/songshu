# Java RPC Mesh性能优化方案

Java RPC Mesh性能优化方案

# **零、阶段性进展结论**

1. 
2. 

测算场景：客户端视角固定5k QPS RPC请求观测CPU使用率差异

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| **阶段** | **场景** | **CPU使用率** |     | **收益【相对值】** |
| **Kess-RPC** | **Mesh-RPC** | **(Kess使用率 - Mesh使用率) / Kess使用率** |
| 调优前 | 客户端Mesh化<br><br>![out?code=fcADloETwwv1DTWybKlDVBsXp:-1366951624888495672fcADloETwwv1DTWybKlDVBsXp:1774423344899](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-1366951624888495672fcADloETwwv1DTWybKlDVBsXp:1774423344899) | 26.86% | 37.29% | \-38.83% |
| 调优后 | 客户端Mesh化<br><br>![out?code=fcADloETwwv1DTWybKlDVBsXp:-8673371789413527267fcADloETwwv1DTWybKlDVBsXp:1774423344899](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-8673371789413527267fcADloETwwv1DTWybKlDVBsXp:1774423344899) | 25.44% | 24.40% | 4.08% |
| 【终态】客户端&服务端Mesh化<br><br>![out?code=fcADloETwwv1DTWybKlDVBsXp:-808751280479149486fcADloETwwv1DTWybKlDVBsXp:1774423344899](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-808751280479149486fcADloETwwv1DTWybKlDVBsXp:1774423344899) | 26.11% | 22.21% | 15.28% |

# **一、现状和问题**

Java RPC Mesh项目在H1进行了Mesh版本的Java RPC客户端改造，覆盖核心功能、灰度发布及观测能力。将通信层替换为brpc内核，完成了连接生命周期管理、请求流转及异常处理兼容等核心流程适配，通过ab验证测试集并在两个内部服务试点上线，功能性和稳定性上具备推量条件。

性能方面，Mesh版本经过一轮初步调优，完成了跨语言回调合并、连接选择探活异步化等优化项，消除了主流程中的非必要性能开销热点。但在**线上典型场景性能压测的表现上Mesh版本相较于原生Java版本仍然劣化38.83%**，与[年初测算](https://docs.corp.kuaishou.com/k/home/VQ_EDMCSs0dM/fcAAvkT1NdbKd2PtMsgfHSuEf)的 25% _= (100%\[kess-rpc整体\] - 45%\[brpc通信层\] - 30%\[kess-rpc服务治理层\])_ 理论极限优化幅度差距过大。

![out?code=fcADloETwwv1DTWybKlDVBsXp:-2369745665515524346fcADloETwwv1DTWybKlDVBsXp:1774423344899](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-2369745665515524346fcADloETwwv1DTWybKlDVBsXp:1774423344899)

性能劣化成为Mesh版本推量的强卡点，需要进一步深入调优

# **二、目标**

		**性能调优：**优化Java RPC客户端Mesh版本性能，在线上典型场景下比原生Java版本优化20%
	
		**方法沉淀：**沉淀通用Mesh化优化手段，在Java RPC服务端Mesh、其他组件/其他语言Mesh化等场景下复用
	

# **三、调优思路**

## **3.1 性能现状分析**

从RPC框架行为变化和技术指标表现入手，逐层分析技术劣化原因。

### **Mesh化前后主流程行为对比**

![out?code=fcADloETwwv1DTWybKlDVBsXp:-3715559778925022933fcADloETwwv1DTWybKlDVBsXp:1774423344899](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-3715559778925022933fcADloETwwv1DTWybKlDVBsXp:1774423344899)

### **技术指标**

|     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- |
| **模块** | **指标项** | **指标值** |     | **分析** | **性能开销**<br><br>**(总和138.83%)** |
| **Mesh-RPC** | **Kess-RPC** |
| 跨语言转换层 | 【火焰图】JNI同步调用CPU使用率 | 28.86% | \-  | Mesh化后基于JNI跨语言交互的JNI调用、数据交换拷贝直接成本和调度行为变化带来的成本较高，有优化空间 | 63.83% |
| 【火焰图】线程调度、锁、内存管理等CPU使用率 | 34.97% | \-  |
| 【进程指标】线程上下文切换 | 48533/s | 36013/s | Mesh化后线程上下文切换指标明显高于原生Java，说明线程模型、IO策略不合理，有优化空间<br><br>单次线程上下文开销0.3-1.0μs |
| 【进程指标】缺页中断 | 53268/s | 8133/s | Mesh化后缺页中断指标明显高于原生Java，说明内存分配释放等系统调用次数较高，有优化空间<br><br>单次分配回收开销40-160ns |
| 通信层 | TCP连接数 | 每个Server单连接 |     | 通信层相关指标持平，说明计算量对等，Mesh化后没有引入额外的计算任务 | 45% |
| 收发包大小 | 收发包大小持平 |     |
| RT  | 端到端耗时持平 |     |
| 服务治理层 | 【火焰图】服务治理等模块CPU使用率 | CPU开销基本持平 |     | 此部分未Mesh化，开销没变化符合预期 | 30% |

总结Mesh化RPC组件的性能潜在优化方向如下

|     |     |     |     |
| --- | --- | --- | --- |
| **模块** | **方向** | **如何影响性能** | **Mesh化现状及优化空间** |
| 跨语言转换层 | 线程模型 | RPC是典型的多连接高并发场景，不合理的线程模型会出现非必要的线程上下文切换成本 | 为解决跨语言间的线程/协程调度，引入了额外的跨语言桥接线程池执行C++到Java的回调任务，引发了线程切换调度开销 |
| 跨语言调用 | Mesh化场景下特有的影响，通过JNI跨语言调用有额外的安全检查、线程栈帧转换、方法查找等开销，相比纯Java内部调用开销高（预估慢1~2个数量级）；另外RPC高频收发场景下，内存分配、内存回收、内存拷贝等成本也不可忽视 | 1次RPC请求往返需要额外付出2次JNI调用开销，跨JNI交换Java和C++之间的数据，需要额外的内存分配拷贝 |
| 通信层 | 报文协议 | 除传递必要信息外，报文协议越复杂，解析成本越高 | 当前Mesh化后报文协议没有改变，基于brpc内核可以选取更为轻量级的协议 |
| 服务治理层 | 下沉逻辑至Mesh | 在通信层之上封装的负载均衡、路由调度、故障转移、监控观测等服务治理逻辑，有额外的计算开销 | 当前未Mesh化，这部分扩展逻辑进一步下沉到SO基于C++高性能实现能降低开销。**对齐改造成本较高，放大影响面，不是当下首选** |

## **3.2 调优方向**

结合当前性能现状和基本原则，最终调优重点放在以下三个方向

优化项占比不是简单的线性加和关系，叠加后可能互有影响，数据供参考

		**优化线程模型：**优化提升12.47%
	
		**降低跨语言调用开销：**优化提升25.28%
	
		**优化报文协议：**优化提升16.36%
	

![out?code=fcADloETwwv1DTWybKlDVBsXp:-6393336001215683517fcADloETwwv1DTWybKlDVBsXp:1774423344903](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-6393336001215683517fcADloETwwv1DTWybKlDVBsXp:1774423344903)

调优实施后较原始Mesh化版本总体优化提升54.11%

# **四、调优方案**

## **4.1 概览**

|     |     |     |     |
| --- | --- | --- | --- |
| **模块** | **调优方向** | **调优思路** | **调优动作** |
| 跨语言转换层 | 优化线程模型 | 调整线程模型，减少上下文切换开销 | C++层brpc回调去除额外维护的回调线程池，直接使用原生bthread所在的pthread执行回调 |
| 降低跨语言调用开销 | 减少跨语言数据交换内存拷贝 | 使用directbuffer在Java和C++层共享数据 |
| 主流程规避JNI穿透 | 通过任务队列&异步通知的方式规避主流程中通过JNI进行Java和C++通信 |
| 通信层 | 优化报文协议 | 使用更为高效的HTTP/2协议 | 保证协议与功能对齐的情况下使用brpc服务端替换gRpc服务端 |
| 采用轻量级协议baidu\_std | 使用baidu\_std协议替换h2:grpc |
| \-  | 优化代码实现 | 通过常规手段优化核心链路代码实现<br><br>		使用缓存<br>	<br>		规避无效重复调用<br>	<br>		代价高的操作合并、批量<br>	<br>		高效实现 | 内存池<br>	<br>		对象池<br>	<br>		无用调用逻辑短路剪枝<br>	<br>		使用原始对象替换pb规避序列化开销<br>	<br>		。。。 |

## **4.2 调优手段**

### **4.2.1 优化线程模型**

#### **问题**

brpc默认使用bthread（用户态协程）执行RPC逻辑，包括发包、监听fd、收包、执行回调等，一次RPC请求完成需要执行业务回调逻辑。业务逻辑属于Java层，故需要通过JNI从C++发起回调，但由于JNI的安全规范，bthread的stack layout检查不通过无法在bthread内执行回调。当前的实现是另外维护了个JNI回调线程池，回调任务从协程池提交到线程池再发起JNI回调，带来额外的线程池维护、协程切换线程等开销

#### **思路**

客户端回调逻辑主要在框架侧维护较为轻量，可直接使用bthread当前关联的pthread执行回调

#### **方案**

开启brpc提供的phtread模式

![out?code=fcADloETwwv1DTWybKlDVBsXp:9046211869511046290fcADloETwwv1DTWybKlDVBsXp:1774423344904](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:9046211869511046290fcADloETwwv1DTWybKlDVBsXp:1774423344904)

### **4.2.2 降低跨语言调用开销**

#### **问题**

Mesh化后一次RPC请求需要触发Java -> C++、C++ -> Java两次JNI调用，穿透JVM会经过安全检查、线程栈帧转换、参数对象转换、方法查找等操作，JNI调用相比纯Java调用代价高得多（预估慢1~2个数量级），此外因为跨语言数据交换在Java层或在C++层需要重复分配内存承载对应数据

#### **思路**

|     |     |     |     |
| --- | --- | --- | --- |
|  | **JNA/FFM API** | **请求Batch化** | **【采用】通过任务队列&fd通知异步化调用** |
| 思路  | 使用JDK其他跨语言调用实现JNA或FFM API替换JNI | 上层主动积攒请求，通过批量化的方式调用JNI，从1次请求1次JNI往返调用变为多次请求1次JNI往返 | 通过event\_fd通知 + 任务队列 + 直接内存传递数据的异步化方式替代同步JNI调用<br><br>		event\_fd是操作系统成熟的线程间通知机制，天然支持epoll等高效实现，调用开销远低于JNI调用<br>	<br>		异步化后Java与C++间交换数据也可进一步基于直接内存(directbuffer)，减少内存管理开销 |
| 实施成本 | 低   | 低   | 中等  |
| 性能收益 | 低   | 高   | 高   |
| 风险  | JNA优势在于快速集成，性能低于JNI<br>	<br>		FFM API是高版本JDK22特性，官方理论性能略高于JNI，需要升级JDK版本 | 主动Batch化后虽然能降低JNI调用次数，但对延迟有显著影响，业务指标上不可接受 | 无其他副作用 |

#### **方案**

![out?code=fcADloETwwv1DTWybKlDVBsXp:-5242748553223131792fcADloETwwv1DTWybKlDVBsXp:1774423344904](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-5242748553223131792fcADloETwwv1DTWybKlDVBsXp:1774423344904)

### **4.2.3 优化报文协议**

#### **问题**

RPC通信收发请求需要基于约定好的报文协议进行数据编码、数据解析、流控、连接状态转换等处理，越复杂的协议意味着更高的计算开销，甚至在相同的协议规范下未经过调优的实现也会导致计算开销变高

#### **思路**

终态服务端Mesh化后基于brpc内核，协议也有了更多的选择，基于此客户端性能能够进一步提升

##### **更为高效的HTTP/2协议实现**

公司内RPC框架基于HTTP/2协议通信，HTTP/2协议以"帧"为最小的通信单位，所有的数据都在帧中传递，一次RPC请求往返会包含Req Headers、Req Data、Res Headers、Res Data、Res Trailers五个帧

![out?code=fcADloETwwv1DTWybKlDVBsXp:-4876142321509534688fcADwS34desirqnzCx9AKBEms:1774423344905](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-4876142321509534688fcADwS34desirqnzCx9AKBEms:1774423344905)

帧由一个个TCP包承载，根据帧大小不同可能出现一个TCP包有多个帧或多个TCP包组合成一个帧。从公司线上典型场景payload看，一个TCP包能够容纳单次请求的多个帧

受RPC服务端响应数据包发送flush策略影响，相同的帧最终发送的TCP包会有差异，TCP包数量和客户端的epoll wakeup、read syscall、线程上下文切换等操作的频率直接挂钩，TCP包数量越多，客户端性能越差

		【Java gRpc服务端】单请求TCP包多，性能差：单次请求每个帧内存分配松散flush时机随机，TCP包更多
	
		**【brpc服务端（Mesh化服务端）】单请求TCP包少，性能好**：单次请求每个帧内存分配集中flush时机聚合，TCP包更少
	

![out?code=fcADloETwwv1DTWybKlDVBsXp:7622411560327387831fcADloETwwv1DTWybKlDVBsXp:1774423344905](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:7622411560327387831fcADloETwwv1DTWybKlDVBsXp:1774423344905)

除了请求帧分包，Java gRpc服务端的流控是基于Ping帧实现的，会在请求往返中主动地往客户端额外推送大量包含Ping帧的TCP包，进一步影响客户端性能

##### **轻量级协议baidu\_std**

HTTP/2协议因通用性、扩展性、浏览器兼容性等原因，协议设计得较重，解析成本偏高。在公司内网通信的场景，可选用更为高效的轻量级协议，客户端&服务端全面Mesh化后，选用brpc内核实现的baidu\_std协议能够进一步优化端到端性能

【H2:gRpc】解析成本高：应用层 + HTTP/2层 + TCP层、复杂编码头、多帧结构、帧解析成本

【baidu\_std】解析成本低：应用层 + TCP层、固定二进制头、Header + Data固定结构

![out?code=fcADloETwwv1DTWybKlDVBsXp:-3873819588661960161fcADwS34desirqnzCx9AKBEms:1774423344905](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-3873819588661960161fcADwS34desirqnzCx9AKBEms:1774423344905)

#### **方案**

启动服务端Mesh化，使用brpc内核更为高效的HTTP/2的协议实现，终态切换到轻量级协议baidu\_std

## **4.3 性能测算**

压测方式如下

![out?code=fcADloETwwv1DTWybKlDVBsXp:-5764818539447698170fcABrB-N_vmJmeZq2jNGHIG2-:1774423344905](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-5764818539447698170fcABrB-N_vmJmeZq2jNGHIG2-:1774423344905)

### **4.3.1 压测基准环境**

|     |     |     |
| --- | --- | --- |
|  | **环境规格** | **环境校准** |
| **Kess RPC Client** | 容器8c16g<br>	<br>		非业务混部集群<br>	<br>		同宿主机 | [部署产物一致](https://halo.corp.kuaishou.com/devcloud/cloud/environment/2058059/instance/instance-list)<br>	<br><br>![out?code=fcADloETwwv1DTWybKlDVBsXp:-4883250892786852759fcAB5y2nNFbpHBA5aWim7jXBy:1774423344905](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-4883250892786852759fcAB5y2nNFbpHBA5aWim7jXBy:1774423344905)<br><br>		同压力下CPU开销一致<br>	<br><br>![out?code=fcADloETwwv1DTWybKlDVBsXp:790018617930419561fcAB5y2nNFbpHBA5aWim7jXBy:1774423344905](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:790018617930419561fcAB5y2nNFbpHBA5aWim7jXBy:1774423344905) |
| **Mesh RPC Client** |
| **Java RPC Server** | 实例数对等<br>	<br>		同宿主机 | 单次请求响应headers、response body、trailers、status code一致<br>	<br><br>![out?code=fcADloETwwv1DTWybKlDVBsXp:-2104982520417767489fcADloETwwv1DTWybKlDVBsXp:1774423344905](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-2104982520417767489fcADloETwwv1DTWybKlDVBsXp:1774423344905) |
| **C++ RPC Server** |

### **4.3.2 压测场景**

RPC请求计算开销主要受连接数、请求/响应消息大小、服务端处理耗时影响，故压测场景构造主要参考这三个因素组合

|     |     |
| --- | --- |
| **连接数** | 50  |
| **请求/响应消息大小** | 587B/707B |
| **服务端处理耗时** | 1ms |
| **发压QPS** | 5k  |

### **4.3.3 压测记录**

#### **总览**

|     |     |     |
| --- | --- | --- |
| **压测项** | **对照组** | **收益【相对值】** |
| 1. 客户端&服务端Mesh收益 | Java客户端&Java服务端&h2协议<br><br><-><br><br>Mesh客户端&C++服务端&baidu\_std协议 | 15.28% |
| 2. 客户端Mesh收益【Java服务端】 | Java客户端&Java服务端&h2协议<br><br><-><br><br>Mesh客户端&Java服务端&h2协议 | 4.08% |
| 3. 调优前客户端Mesh收益【Java服务端】 | Java客户端&Java服务端&h2协议<br><br><-><br><br>调优前Mesh客户端&Java服务端&h2协议 | \-38.83% |
| 4. 调优前客户端Mesh收益【Java服务端&单连接】 | Java客户端&单连接Java服务端&h2协议<br><br><-><br><br>调优前Mesh客户端&单连接Java服务端&h2协议 | \-84.08% |
| 5. 服务端Mesh收益【Java客户端】 | Java客户端&Java服务端&h2协议<br><br><-><br><br>Java客户端&C++服务端&h2协议 | 5.44% |
| 6. baidu\_std协议收益 | Mesh客户端&C++服务端&h2协议<br><br><-><br><br>Mesh客户端&C++服务端&baidu\_std协议 | 7.23% |
| 7. 服务端Mesh收益【Mesh客户端】 | Mesh客户端&Java服务端&h2协议<br><br><-><br><br>Mesh客户端&C++服务端&h2协议 | 11.95% |
| 8. 客户端Mesh收益【Mesh服务端 & H2】 | Java客户端&C++服务端&h2协议<br><br><-><br><br>Mesh客户端&C++服务端&h2协议 | 5.16% |
| 9. 客户端Mesh收益【Mesh服务端 & baidu\_std】 | Java客户端&C++服务端&h2协议<br><br><-><br><br>Mesh客户端&C++服务端&baidu\_std协议 | 11.58% |

#### **明细**

1. Java客户端&Java服务端&h2协议 <-> Mesh客户端&C++服务端&baidu\_std协议
	

|     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **服务端** | **客户端** | **协议** | **RT** | **CPU利用率** | **收益【绝对值】** | **收益【相对值】** | **相关监控** |
| Java Kess RPC | Java Kess RPC | h2:grpc | 0.96ms | 26.11%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-0&type=diag&diagId=78615&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.204987,java_profile.204989&allowPerf=1764073973&view=java_profile) | 3.99% | 15.28% | ![out?code=fcADloETwwv1DTWybKlDVBsXp:9019112711375833736fcAB5y2nNFbpHBA5aWim7jXBy:1774423344907](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:9019112711375833736fcAB5y2nNFbpHBA5aWim7jXBy:1774423344907)![out?code=fcADloETwwv1DTWybKlDVBsXp:6239737557198168251fcAB5y2nNFbpHBA5aWim7jXBy:1774423344907](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:6239737557198168251fcAB5y2nNFbpHBA5aWim7jXBy:1774423344907) |
| C++ Kess RPC | Java Mesh RPC | baidu\_std | 1.05ms | 22.12%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-1&type=diag&diagId=78616&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.204988,java_profile.204990&view=java_profile) |

2. Java客户端&Java服务端&h2协议 <-> Mesh客户端&Java服务端&h2协议
	

|     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **服务端** | **客户端** | **协议** | **RT** | **CPU使用率** | **收益【绝对值】** | **收益【相对值】** | **相关监控** |
| Java Kess RPC | Java Kess RPC | h2:grpc | 0.96ms | 25.44%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-0&type=diag&diagId=79167&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.206496,java_profile.206499&view=java_profile) | 1.04% | 4.08% | ![out?code=fcADloETwwv1DTWybKlDVBsXp:9045338681738545297fcADloETwwv1DTWybKlDVBsXp:1774423344907](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:9045338681738545297fcADloETwwv1DTWybKlDVBsXp:1774423344907)![out?code=fcADloETwwv1DTWybKlDVBsXp:-8727101394964972460fcAB5y2nNFbpHBA5aWim7jXBy:1774423344907](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-8727101394964972460fcAB5y2nNFbpHBA5aWim7jXBy:1774423344907) |
| Java Kess RPC | Java Mesh RPC | h2:grpc | 1ms | 24.40%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-1&type=diag&diagId=79168&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.206498,java_profile.206500&allowPerf=1764856927&view=java_profile) |

3. Java客户端&Java服务端&h2协议 <-> 调优前Mesh客户端&Java服务端&h2协议
	

|     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **服务端** | **客户端** | **协议** | **RT** | **CPU使用率** | **收益【绝对值】** | **收益【相对值】** | **相关监控** |
| Java Kess RPC | Java Kess RPC | h2:grpc | 0.98ms | 26.86%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-0&type=diag&diagId=78722&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.205277,java_profile.205285&allowPerf=1764219156&view=java_profile) | \-10.43% | \-38.83% | ![out?code=fcADloETwwv1DTWybKlDVBsXp:-1501490563409190467fcADloETwwv1DTWybKlDVBsXp:1774423344907](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-1501490563409190467fcADloETwwv1DTWybKlDVBsXp:1774423344907)![out?code=fcADloETwwv1DTWybKlDVBsXp:7971127151123763503fcADloETwwv1DTWybKlDVBsXp:1774423344907](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:7971127151123763503fcADloETwwv1DTWybKlDVBsXp:1774423344907) |
| Java Kess RPC | Java Mesh RPC<br><br>（未调优） | h2:grpc | 1.6ms | 37.29%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-1&type=diag&diagId=78723&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.205278,java_profile.205286&view=java_profile) |

4. Java客户端&单连接Java服务端&h2协议 <-> 调优前Mesh客户端&单连接Java服务端&h2协议
	

|     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **服务端** | **客户端** | **协议** | **RT** | **CPU使用率** | **收益【绝对值】** | **收益【相对值】** | **相关监控** |
| Java Kess RPC<br><br>（单连接） | Java Kess RPC | h2:grpc | 2.48ms | 18.78%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-0&type=diag&diagId=78741&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.205330,java_profile.205332&allowPerf=1764228935&view=java_profile) | \-15.79% | \-84.08% | ![out?code=fcADloETwwv1DTWybKlDVBsXp:-7940941327864173460fcADloETwwv1DTWybKlDVBsXp:1774423344908](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-7940941327864173460fcADloETwwv1DTWybKlDVBsXp:1774423344908)![out?code=fcADloETwwv1DTWybKlDVBsXp:8148610658715632939fcADloETwwv1DTWybKlDVBsXp:1774423344908](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:8148610658715632939fcADloETwwv1DTWybKlDVBsXp:1774423344908) |
| Java Kess RPC<br><br>（单连接） | Java Mesh RPC<br><br>（未调优） | h2:grpc | 1.67ms | 34.57%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-1&type=diag&diagId=78742&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.205331,java_profile.205333&view=java_profile) |

5. Java客户端&Java服务端&h2协议 <-> Java客户端&C++服务端&h2协议
	

|     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **服务端** | **客户端** | **协议** | **RT** | **CPU使用率** | **收益【绝对值】** | **收益【相对值】** | **相关监控** |
| Java Kess RPC | Java Kess RPC | h2:grpc | 0.95ms | 25.74%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-0&type=diag&diagId=78663&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.205105,java_profile.205107&view=java_profile) | 1.4% | 5.44% | ![out?code=fcADloETwwv1DTWybKlDVBsXp:-9077126586421719360fcAB5y2nNFbpHBA5aWim7jXBy:1774423344908](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-9077126586421719360fcAB5y2nNFbpHBA5aWim7jXBy:1774423344908)![out?code=fcADloETwwv1DTWybKlDVBsXp:8449044696840139657fcAB5y2nNFbpHBA5aWim7jXBy:1774423344908](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:8449044696840139657fcAB5y2nNFbpHBA5aWim7jXBy:1774423344908) |
| C++ Kess RPC | Java Kess RPC | h2:grpc | 1.03ms | 24.34%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-1&type=diag&diagId=78664&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.205106,java_profile.205108&view=java_profile) |

6. Mesh客户端&C++服务端&h2协议 <-> Mesh客户端&C++服务端&baidu\_std协议
	

|     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **服务端** | **客户端** | **协议** | **RT** | **CPU使用率** | **收益【绝对值】** | **收益【相对值】** | **相关监控** |
| C++ Kess RPC | Java Mesh RPC | h2:grpc | 1.03ms | 22.00%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-0&type=diag&diagId=78660&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.205099,java_profile.205101&view=java_profile) | 1.59% | 7.23% | ![out?code=fcADloETwwv1DTWybKlDVBsXp:-12808128826473167fcAB5y2nNFbpHBA5aWim7jXBy:1774423344908](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-12808128826473167fcAB5y2nNFbpHBA5aWim7jXBy:1774423344908)![out?code=fcADloETwwv1DTWybKlDVBsXp:9100109159061763955fcAB5y2nNFbpHBA5aWim7jXBy:1774423344908](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:9100109159061763955fcAB5y2nNFbpHBA5aWim7jXBy:1774423344908) |
| C++ Kess RPC | Java Mesh RPC | baidu\_std | 0.99ms | 20.41%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-1&type=diag&diagId=78661&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.205100,java_profile.205102&view=java_profile) |

7. Mesh客户端&Java服务端&h2协议 <-> Mesh客户端&C++服务端&h2协议
	

|     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **服务端** | **客户端** | **协议** | **RT** | **CPU使用率** | **收益【绝对值】** | **收益【相对值】** | **相关监控** |
| Java Kess RPC | Java Mesh RPC | h2:grpc | 0.99ms | 24.76%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-0&type=diag&diagId=78669&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.205121,java_profile.205123&allowPerf=1764141080&view=java_profile) | 2.96% | 11.95% | ![out?code=fcADloETwwv1DTWybKlDVBsXp:-9093573284133063734fcAB5y2nNFbpHBA5aWim7jXBy:1774423344909](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-9093573284133063734fcAB5y2nNFbpHBA5aWim7jXBy:1774423344909)![out?code=fcADloETwwv1DTWybKlDVBsXp:-7057697696825297375fcAB5y2nNFbpHBA5aWim7jXBy:1774423344909](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-7057697696825297375fcAB5y2nNFbpHBA5aWim7jXBy:1774423344909) |
| C++ Kess RPC | Java Mesh RPC | h2:grpc | 1.08ms | 21.80%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-1&type=diag&diagId=78670&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.205122,java_profile.205124&view=java_profile) |

8. Java客户端&C++服务端&h2协议 <-> Mesh客户端&C++服务端&h2协议
	

|     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **服务端** | **客户端** | **协议** | **RT** | **CPU使用率** | **收益【绝对值】** | **收益【相对值】** | **相关监控** |
| C++ Kess RPC | Java Kess RPC | h2:grpc | 1.01ms | 23.53%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-0&type=diag&diagId=78654&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.205084,java_profile.205087&allowPerf=1764129508&view=java_profile) | 1.32% | 5.61% | ![out?code=fcADloETwwv1DTWybKlDVBsXp:-3805840105932970335fcAB5y2nNFbpHBA5aWim7jXBy:1774423344909](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-3805840105932970335fcAB5y2nNFbpHBA5aWim7jXBy:1774423344909)![out?code=fcADloETwwv1DTWybKlDVBsXp:-6443734323988383844fcAB5y2nNFbpHBA5aWim7jXBy:1774423344909](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:-6443734323988383844fcAB5y2nNFbpHBA5aWim7jXBy:1774423344909) |
| C++ Kess RPC | Java Mesh RPC | h2:grpc | 1.04ms | 22.21%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-1&type=diag&diagId=78655&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.205085,java_profile.205086&view=java_profile) |

9. Java客户端&C++服务端&h2协议 <-> Mesh客户端&C++服务端&baidu\_std协议
	

|     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **服务端** | **客户端** | **协议** | **RT** | **CPU使用率** | **收益【绝对值】** | **收益【相对值】** | **相关监控** |
| C++ Kess RPC | Java Kess RPC | h2:grpc | 1.02ms | 24.86%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-0&type=diag&diagId=78645&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.205065,java_profile.205067&allowPerf=1764086386&view=java_profile) | 2.88% | 11.58% | ![out?code=fcADloETwwv1DTWybKlDVBsXp:6511652487410148057fcAB5y2nNFbpHBA5aWim7jXBy:1774423344909](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:6511652487410148057fcAB5y2nNFbpHBA5aWim7jXBy:1774423344909)![out?code=fcADloETwwv1DTWybKlDVBsXp:2217283898231583585fcAB5y2nNFbpHBA5aWim7jXBy:1774423344909](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcADloETwwv1DTWybKlDVBsXp:2217283898231583585fcAB5y2nNFbpHBA5aWim7jXBy:1774423344909) |
| C++ Kess RPC | Java Mesh RPC | baidu\_std | 1.03ms | 21.98%<br><br>[火焰图](https://syslab.corp.kuaishou.com/jvmDiag/onlineDiagnosis/diagPanel?service=infra-rpc-preformance-test-service-client-api&podname=cloud-4829818-2058059-1730117-duplicateset-1&type=diag&diagId=78646&host=public-bjy-rs6-kce-node318.idchb1az2.hb1.kwaidc.com&results=jvm_list.205066,java_profile.205068&view=java_profile) |

# **五、后续工作计划**

1. 基于性能优化版本打磨实现，在极限吞吐、协程等更多场景充分验证，达到线上可推量状态
	
2. 启动服务端Mesh化改造，并基于客户端&服务端Mesh化测算终态收益
	
3. 异步化通知机制封装成组件，在跨语言交互是性能瓶颈的Mesh化场景复用

    Created at: 2026-03-25T14:52:21+08:00
    Updated at: 2026-03-30T17:15:54+08:00

