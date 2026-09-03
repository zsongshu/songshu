# RPC on Mesh实施方案与演进计划

RPC on Mesh实施方案与演进计划

# **一、背景**

## **1.1 快手多语言RPC框架现状**

### **1.1.1 多语言RPC框架使用规模**

RPC框架在公司以Java和C++语言为主，有grpcEx、infra-krpc、KESS-RPC、GRPC、BRPC五种框架在并行使用

		从业务规模看：Java覆盖3.8万KSN（80万实例，1868.35万核），C++覆盖1万KSN（20万实例，610.76万核），Python/Go覆盖0.4万KSN（19万实例，43.1万核）
	
		从流量规模看（客户端视角）：Java占总QPS的14%（22500万QPS），C++占总QPS的85%（137600万QPS），其他语言占总QPS的不足1%
	

Java和C++都有多个框架并存，Java rpc占用74%核数仅承接14%流量，存在优化空间

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| **语言** | **框架** | **流量（QPS）**<br><br>**（单位：万/s）** | **业务规模（KSN数/实例数）** | **资源规模（核）** |
| Java | grpcEx | client：10,100<br>	<br>		server：10,900 | client: 28.85K / 531K<br>	<br>		server: 9.43K / 269K | server:260.5万<br>	<br>		client:1113.7万 |
| infra-krpc |
| KESS-RPC（推荐） | client：12,400<br>	<br>		server：5,200 |
| C++ | GRPC | 111,600 （主调侧视角） | 8.98K / 191K | server:723万<br>	<br>		client:815万 |
| BRPC（推荐） | 33,000 (主调侧视角) | 1.175K / 11K |
| Python | grpc | client：30<br>	<br>		server：98 | client：1.14K / 46K<br>	<br>		server：3.58K / 107K | 32.92万 |
| Golang | grpc | client：60<br>	<br>		server：170 | client：0.99K / 32.6K<br>	<br>		server：0.61K / 6.3K | 10.17万 |
| Node.js | node rpc | client：0.015<br>	<br>		server：0.015 | client：0.08K / 0.4K<br>	<br>		server：0.06K / 0.28K | \-  |

补充说明：

		业务规模部分，存在一个服务既是Client又是Server的情况，数据未去重。
	
		流量统计部分，存在一个服务同时调用不同类型框架的情况，数据未去重。
	
		c++ brpc部分缺少被调打点，无法统计被调视角流量。
	

### **1.1.2 多语言RPC框架流量分布及性能表现**

分析Java/C++ RPC Payload分布（[Java Rpc 线上Payload分布统计](https://docs.corp.kuaishou.com/k/home/VEcYmOpvIsjE/fcADWUcFw690VNTCensweewix?ro=false)、[C++ Rpc 线上Payload分布统计](https://docs.corp.kuaishou.com/k/home/VULfJ0nvQVy0/fcABwkK5YoqOhUvDdNw-7E1qs)），压测Java KESS-RPC和C++ gRPC在相应Payload组合下的表现，与同Payload下C++ brpc的表现（[Java/C++ RPC性能压测](https://docs.corp.kuaishou.com/k/home/VIyvBxgStJpo/fcABe1RXluNou9YpekbbQ_wP2?ro=false#section=h.pzwjaripl1uf)）对比，**全部切换到brpc后，预计可节省CPU 124.39万核，年化约1亿元。**

|     |     |     |     |     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **语言** | **Payload**<br><br>**(Request)** | **Payload**<br><br>**(Response)** | **组件类型** | **流量比例** | **A：线上RPC总QPS**<br><br>**（单位：万/s）** | **B：grpc单位cpu消耗**<br><br>**（每万QPS使用核数）** | **C：RPC框架实际使用核数**<br><br>**（QPS \* 单位CPU消耗）**<br><br>**C = A \* B** | **D：同Pyload模型下brpc单位cpu消耗**<br><br>**（每万QPS使用核数）** | **E：同Pyload模型下brpc/grpc消耗CPU**<br><br>**E = D / B** | **F：预计收益测算**<br><br>**（核数）**<br><br>**F =（1 - E）\* C** | **G：RPC框架预计整体收益**<br><br>**G = sum（F）/ cpu运行水位** |
| Java RPC<br><br>(占总QPS的14%) | 135B<br><br>(QPS占Java RPC比例：50%) | 15B | Server | 30% | 2415 | 2.08 | 5023.2 | 0.46 | 22.12% | 3912 | **优化后整体可缩减的核数：63.31w**<br>	<br><br>备注：Java RPC服务平均CPU使用率 P90水位30% |
| Client | 3375 | 4.0 | 13500 | 0.85 | 21.25% | 10631 |
| 3KB | Server | 60% | 4830 | 2.08 | 10046.4 | 0.5 | 24.04% | 7631 |
| Client | 6750 | 4.06 | 27405 | 0.94 | 23.15% | 21060 |
| 200KB | Server | 10% | 805 | 3.93 | 3164.65 | 1.98 | 50.38% | 1570 |
| Client | 1125 | 9.91 | 11148.75 | 4.24 | 42.79% | 5074 |
| 15KB<br><br>(QPS占Java RPC比例：30%) | 10B | Server | 35% | 1610 | 2.4 | 3864 | 0.66 | 27.50% | 2801 |
| Client | 2250 | 4.02 | 9045 | 0.61 | 15.17% | 7673 |
| 10KB | Server | 50% | 2415 | 2.61 | 6301.65 | 0.77 | 29.50% | 4443 |
| Client | 3375 | 4.83 | 16293.75 | 0.78 | 16.15% | 13662 |
| 1.1MB | Server | 15% | 805 | 23.59 | 18994.95 | 17.75 | 75.24% | 4702 |
| Client | 1125 | 43.47 | 48903.75 | 16.74 | 38.51% | 30071 |
| 550KB<br><br>(QPS占Java RPC比例：20%) | 160B | Server | 60% | 1932 | 17.15 | 33157.8 | 4.64 | 27.06% | 24187 |
| Client | 2700 | 15.29 | 41283 | 7.34 | 48.01% | 21465 |
| 5KB | Server | 20% | 644 | 17.94 | 11554.56 | 7.44 | 41.47% | 6763 |
| Client | 900 | 15.74 | 14166 | 5.55 | 35.26% | 9171 |
| 140KB | Server | 20% | 644 | 19.29 | 12423.96 | 7.92 | 41.06% | 7323 |
| Client | 900 | 16.34 | 14706 | 7.68 | 47.00% | 7794 |
| C++ gRPC<br><br>(占总QPS的67%) | 2KB<br><br>(QPS占C++ gRPC比例：40%) | 650B | Server | 50% | 21520 | 1.10 | 23672 | 0.491 | 44.64% | 13067 | **优化后整体可缩减的核数：61.08w**<br>	<br><br>备注：C++ RPC服务平均CPU使用率 P90水位50% |
| Client | 21520 | 1.93 | 41533.6 | 1.112 | 57.62% | 17569 |
| 140KB | Server | 40% | 17216 | 2.34 | 40285.44 | 1.325 | 56.62% | 17484 |
| Client | 17216 | 4.02 | 69208.32 | 3.77 | 93.78% | 4291 |
| 1.8MB | Server | 10% | 4304 | 26.17 | 112635.68 | 24.3 | 92.85% | 7997 |
| Client | 4304 | 33.13 | 142591.52 | 29  | 87.53% | 17396 |
| 270KB<br><br>(QPS占C++ gRPC比例：50%) | 4KB | Server | 50% | 26900 | 4.56 | 122664 | 3.48 | 76.32% | 29071 |
| Client | 26900 | 4.40 | 118360 | 4   | 90.91% | 11836 |
| 12KB | Server | 40% | 21520 | 5.25 | 112980 | 3.32 | 63.24% | 41690 |
| Client | 21520 | 4.60 | 98992 | 4   | 86.96% | 12869 |
| 1.2MB | Server | 10% | 5380 | 18.52 | 99637.6 | 13.1 | 70.73% | 29094 |
| Client | 5380 | 24.39 | 131218.2 | 22.2 | 91.02% | 11810 |
| 900KB<br><br>(QPS占C++ gRPC比例：10%) | 11KB | Server | 40% | 4304 | 14.81 | 63742.24 | 10.24 | 69.14% | 19633 |
| Client | 4304 | 13.59 | 58491.36 | 10  | 73.58% | 15442 |
| 180KB | Server | 40% | 4304 | 16.09 | 69251.36 | 11.87 | 73.77% | 18144 |
| Client | 4304 | 14.04 | 60428.16 | 11.63 | 82.83% | 10394 |
| 1MB | Server | 20% | 2152 | 26.15 | 56274.8 | 19.05 | 72.85% | 15701 |
| Client | 2152 | 30.27 | 65141.04 | 24.71 | 81.63% | 11921 |
| c++ brpc<br><br>(占总QPS的18%)) | 已使用c++ brpc框架 |     |     |     |     |     |     |     |     |     |     |

### **1.1.3 业务线RPC使用分析**

主站和社科的RPC使用规模最大，迁移到brpc框架后，预计主站可节省30.1万核，社科可节省39.79万核

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| 业务线 | 框架  | 应用场景 | 使用规模 | 成本（计算方式见下方补充说明） |
| 主站  | Java | 评论、直播场景 | Server：<br><br>		QPS：101M<br>	<br>		KSN/实例数：4065/63,827<br>	<br><br>Client：<br><br>		QPS：94M<br>	<br>		KSN/实例数：3952/89,126 | 业务侧使用RPC框架核数消耗：48.23w<br>	<br>		**优化后预计可缩减核数：30.1w** |
| 商业化 | Java | 营销、计费、风控场景 | Server：<br><br>		QPS：10M<br>	<br>		KSN/实例数：840/16,131<br>	<br><br>Client：<br><br>		QPS：24M<br>	<br>		KSN/实例数：1619/22,196 | 业务侧使用RPC框架核数消耗：9w<br>	<br>		**优化后预计可缩减核数：5.62w** |
| 电商  | Java | 库存、交易场景 | Server：<br><br>		QPS：16M<br>	<br>		KSN/实例数：607/37,558<br>	<br><br>Client：<br><br>		QPS：12M<br>	<br>		KSN/实例数：838/36,779 | 业务侧使用RPC框架核数消耗：6.67w<br>	<br>		**优化后预计可缩减核数：4.16w** |
| 风控  | Java | 风控  | Server：<br><br>		QPS： 7.4M<br>	<br>		KSN/实例数：512/13,138<br>	<br><br>Client：<br><br>		QPS：12.6M<br>	<br>		KSN/实例数：1892/23,301 | 业务侧使用RPC框架核数消耗：4.87w<br>	<br>		**优化后预计可缩减核数：3.07w** |
| 社科  | Java | 社科（user\_profiles、follow） | Server：<br><br>		QPS： 13M<br>	<br>		KSN/实例数：298/48,241<br>	<br><br>Client：<br><br>		QPS：79M<br>	<br>		KSN/实例数：2843/641,584 | 业务侧使用RPC框架核数消耗：25.07w<br>	<br>		**优化后预计可缩减核数：15.79w** |
| C++ GRPC | 社科（推荐，广告、搜索） | Server：<br><br>		QPS： 229M<br>	<br>		KSN/实例数：8512/157,372<br>	<br><br>Client：<br><br>		QPS：587M<br>	<br>		KSN/实例数：4810/121,135 | 业务侧使用RPC框架核数消耗：117.04w<br>	<br>		**优化后预计可缩减核数：24w** |

补充说明：

		“业务侧使用RPC框架核数消耗”计算方式：
	
		“优化后预计可缩减核数”计算方式：
	

### **1.1.4 Java框架功能差异**

Java RPC框架有grpcEx、infra-krpc、Kess-rpc三种实现，新功能主要基于Kess-rpc迭代，其余两种框架功能不完整

![out?code=fcAAUNGYppu0o2JjL59M931q0:2171980646247427447fcAAUNGYppu0o2JjL59M931q0:1774423315739](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcAAUNGYppu0o2JjL59M931q0:2171980646247427447fcAAUNGYppu0o2JjL59M931q0:1774423315739)

## **1.2 问题与痛点**

（1）Java/C++存在多个RPC框架，业务RD学习成本高，问题排查困难

		存在多种RPC框架，文档不足，业务学习成本高
	
		**不同框架功能有差异，遇到问题难以排查**
	

（2）中间件团队维护8个RPC框架，需重复开发，存在功能对不齐的情况

		功能需要不同语言重复开发，交付周期长，协调过程复杂，例如单元化相关能力
	
		不同语言SDK的维护团队在排期和优先级上的差异，可能导致一些新功能无法按预期完成
	
		不同语言存在差异，对RD要求高，人力成本也相应增加
	

（3）升级/召回需要逐个KSN发布上线，成本高、周期长，同时框架版本收敛慢

		2024年1月到2025年1月，RPC框架总发版53次，其中Java RPC框架发版24次、C++ RPC框架发版16次，GO RPC框架发版7次，Python RPC框架发版6次
	
		Java SDK发布3个月可以覆盖90%节点，覆盖55% KSN
	
		C++ SDK发版2个月可以覆盖60%节点，发版8个月可以覆盖80%节点，发版1年可以覆盖90%节点
	
		造成SDK存在多个版本共存的现象，RPC SDK线上有72个版本
	
		多版本共存造成已知问题反复发生，跨多个版本升级时会遇到困难，24年因使用错误版本的SDK而引发的故障超过3起
	
		[20221201](https://halo.corp.kuaishou.com/helheim/fault-report/draft/68056) C++ RPC SDK 召回主要服务用时10天左右
	

（4）gRPC框架相较brpc，性能差，消耗服务器成本高

		**gRPC 基于 HTTP/2 协议，引入了额外的协议开销，brpc传输协议更高效，相同性能表现情况下使用CPU更少**
	
		brpc引入bthread类协程机制，线程调度和并发处理比gRPC更高效
	

## **1.3 项目目标**

		**研发归一化内核，降低研发/资源成本：**研发统一RPC内核支持多语言框架，研发成本降低200%，性能提升100%，预计年化收益达1亿
	
		**优化发布流程，加速服务发布/召回/版本收敛**：解耦SDK与业务代码的强绑定关系，实现SDK的自主热更新，服务发布/召回周期从“天级别”缩短至“小时级”
	
		**提升RPC框架质量**：通过高质量统一内核，消除多版本情况存在的功能差异，解决版本收敛慢引发的问题排查难、问题反复出现问题
	

# **二、实施方案**

## **2.1  建设思路**

### **2.1.1 技术选型**

![out?code=fcAAUNGYppu0o2JjL59M931q0:-4311582865709615795fcAAUNGYppu0o2JjL59M931q0:1774423315741](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcAAUNGYppu0o2JjL59M931q0:-4311582865709615795fcAAUNGYppu0o2JjL59M931q0:1774423315741)

通过Proxyless Mesh模式，解决多语言RPC框架重复开发问题。做到开发1次，不同框架可实现功能复用。彻底解决重复开发、功能对不齐问题。

### **2.1.2 服务发布流程**

![out?code=fcAAUNGYppu0o2JjL59M931q0:-3577560274459280222fcAAUNGYppu0o2JjL59M931q0:1774423315741](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcAAUNGYppu0o2JjL59M931q0:-3577560274459280222fcAAUNGYppu0o2JjL59M931q0:1774423315741)

改变SDK发版机制，从逐个KSN发布上线模式，变更为由中间件团队统一管理SDK版本，实现动态加载不同版本的so内核，做到重启即生效。

机制运转成熟后，可再次升级为在线热更新，做到版本变更过程业务RD 0参与。

### **2.1.3 框架选型**

对于RPC框架选型，我们有如下的要求：

		兼容性要求：需要支持当前RPC框架无缝迁移到新框架
	
		性能要求：需要具备低延迟，低成本的要求
	
		成熟度要求：需要是一个广泛采用且比较成熟的RPC框架
	

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
|  | **Dubbo** | **Thrift** | **gRPC** | **brpc** |
| 通信协议 | Dubbo、Rmi、Hessian、HTTP、WebService | Tsocket、TFramedTransport、TFileTransport等 | HTTP/2.0 | grpc、tcp |
| 序列化 | Hessian、Kryo、FST、Protobuf、Avro、Msgpack、Gson等 | 自定义二进制协议、JSON | ProtoBuf | ProtoBuf、自定义 |
| 负载均衡 | Random、RoundRobin、ConsistentHash、LeastActive | 自定义负载均衡 | 可插拔负载均衡器机制 | RoundRobin、ConsistentHash、LeastActive等多种 |
| 注册与发现 | Nacos、ZK、Redis、Multicas、Simple等 | ZK、自定义 | Nacos、Consul、Etcd等 | 自定义注册中心 |
| 兼容性 | 主要面向Java，通过Dubbo协议进行通信，对其他语言支持有限 | 跨语言支持友好 | 跨语言支持友好 | 主要基于C++，但支持多种协议的客户端，包括gRPC、Thrift等 |
| 成熟度 | 高，社区活跃度高，互联网应用广泛 | 高，社区活跃度相对较低，但应用广泛 | 高，社区活跃度高，文档资料丰富 | 高，在互联网有成熟应用 |
| 性能  | 中   | 中   | 高   | 最高  |

结论：

		兼容性方面，brpc框架完全涵盖grpc框架的功能，满足公司业务需求；
	
		性能方面，brpc表现出高吞吐量、低延迟和低资源消耗的优异特性；
	
		成熟度方面，bprc在互联网行业有成熟应用，并且覆盖我司10w实例，承担了18%业务流量。
	

综上，在本次技术选型中，我们决定以brpc为基础，实现RPC框架的统一化改造。

## **2.2 技术方案**

### **2.2.1 整体架构**

![out?code=fcAAUNGYppu0o2JjL59M931q0:2500495649034629665fcAAUNGYppu0o2JjL59M931q0:1774423315742](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcAAUNGYppu0o2JjL59M931q0:2500495649034629665fcAAUNGYppu0o2JjL59M931q0:1774423315742)

策略：选定典型服务，确定最小化版本功能范围；提供请求级别灰度能力，无灰度不上线；只允许经过验证的能力上线，识别非预期功能，一键止损

### **2.2.2 RPC功能全景图**

![out?code=fcAAUNGYppu0o2JjL59M931q0:-1688889957139517679fcAAUNGYppu0o2JjL59M931q0:1774423315742](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcAAUNGYppu0o2JjL59M931q0:-1688889957139517679fcAAUNGYppu0o2JjL59M931q0:1774423315742)

### **2.2.3 功能梳理与实施策略**

#### **客户端**

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| 功能分类 | 功能点 | Java Kess-rpc现有能力 | C++ brpc现有能力diff | 实施策略 |
| 预热  | 客户端预热 | 接入autowarmup和jwarmup，提前创建连接 | 暂不支持 | 沿用Java客户端逻辑 |
| 初始化 | 创建形式 | 支持注解调用和手动调用 | 仅支持手动调用 | 不改变用户行为，补齐逻辑 |
| rpc调用 | 服务发现 | 本地发现、kstable配置跨域发现、支持canditate环境 | 均支持 | 已支持 |
| 路由顺序 | 单元路由>泳道路由>分组路由>Shard路由>AZ路由 | 单元路由>分组路由>泳道路由>az路由>shard 路由 | 保持Java侧行为 |
| 直连路由 | 指定ip:port访问，跳过路由选择 | 暂不支持 | 补齐能力 |
| random-shuffle | 根据hashkey, weight， 将请求随机分组，缩小故障域影响 | 不支持 | 补齐能力 |
| 单元路由 | 支持单元化 | 建设中 | 补齐能力 |
| 泳道路由 | 泳道回落、kstable配置回落开关、识别tracecontext中的泳道标记、通过参数指定泳道 | 仅不支持通过参数指定泳道 | 补齐能力 |
| 分组路由 | 业务分组、灰度分组、分组染色 | 均支持，并且额外支持按照abtest分组流量 | 已支持 |
| shard路由 | shard选择，支持指定shard访问，shard间不回落 | 能力一致 | 已支持 |
| az路由 | az就近、az转发、region就近、az2.0功能 | 能力一致 | 已支持 |
| 负载均衡 | 支持以下五个策略：<br><br>weight-random（默认）<br><br>weight-roundroubin<br><br>hrw<br><br>local-prefer<br><br>least-request | 仅支持<br><br>weight-random<br><br>hrw | 补齐能力 |
| 调用形式 | oneway，同步，异步 | 同步，异步 | 补齐能力 |
| 服务治理-超时 | 支持多种途径配置调用超时时间，kstable配置>函数接口传参>默认5s | 能力一致 | 已支持 |
| 服务治理-隔板 | 支持对被调服务和方法限制并法度和线程池占比 | 能力一致 | 已支持 |
| 服务治理-熔断 | 支持被调服务维度和被调方法维度的动态配置滑动窗口内失败阈值，触发熔断 | 能力一致 | 已支持 |
| 服务治理-一键降级 | 支持被调服务维度client一键降级请求 | 不支持 | 补齐能力 |
| 服务治理-重试 | 支持被调服务维度和被调方法维度的动态配置 | 暂未支持，建设中 | 补齐能力 |
| 错误处理 | 支持failfast、failover、failsafe、broadcast、bulkcall和dead-letter模式 | 仅支持failfast | 补齐能力 |
| 流量录制 | 录制流量 | 支持  | 已支持 |
| 全链路压测 | 短路压测流量 | 支持  | 已支持 |
| interceptor扩展 | 提供多个业务interceptor执行点，可回调业务逻辑 | 支持，但不支持多个interceptor | 补齐能力 |
| interceptor能力 | 支持获取/修改header/request/response | 均可获取，但仅支持修改header，不可修改request，response | 补齐能力 |
| 后台与旁路逻辑 | 消息传输格式 | protobuf3 | protobuf3 | 补齐能力 |
| h2协议 | 默认使用plaintext，额外支持选用h2 tls | 仅支持plaintext | 补齐能力 |
| 网络通信能力 | 支持远程通信和进程内本地调用 | 仅支持远程通信 | 补齐能力 |
| 静态配置获取 | yaml，api等静态指定 | 不支持 | 补齐能力 |
| 动态配置获取 | 支持kstable配置动态配置：<br><br>		应用配置：服务端线程池配置<br>	<br>		调用参数：超时，重试<br>	<br>		路由调度：泳道，分组，az<br>	<br>		负载均衡<br>	<br>		熔断降级：隔板，熔断<br>	<br>		过载保护：系统限流，qps限流<br>	<br>		服务端鉴权: acl | 基本与java相同 | 已支持 |
| 建连策略 | 支持lazy和eager两种模式 | 仅支持lazy | 补齐能力 |
| 连接模式 | 支持单连接（默认）、多连接和subset | 不支持subset | 补齐能力 |
| 健康检查 | 具有主动健康检查、被动健康检查和恐慌模式三种 | 均不支持 | 补齐能力 |
| 可观测性 | perf基础打点 | 基础成功失败等的打点 | 维度对齐，但是打点字段有区别 | 补齐能力 |
| perf kstable打点 | kstable相关逻辑打点 | 不依赖kstable sdk，有c++ 自身的 sentinel sdk | 补齐能力 |
| rpcmonitor | client上报调用记录 | 支持  | 已支持 |
| sentinel | 打点告警 | 能力支持，但是打点体系有区别 | 补齐能力 |
| ktrace | 记录并上报span调用关系 | 支持  | 已支持 |

#### **服务端**

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| 功能分类 | 功能点 | Java Kess-rpc现有能力 | C++ brpc现有能力diff | 实施策略 |
| 初始化 | 服务注册发现 | 注册KESS名<br><br>注册实例的shard名<br><br>注册服务别名 | 不支持服务别名 | 补齐能力 |
| 服务预热 | 自动预热<br><br>手动预热 | 不支持预热功能 | 补齐能力 |
| 服务权重爬坡 | 同步爬坡<br><br>异步爬坡，时间和权重可配置 | 不支持同步爬坡 | 补齐能力 |
| 服务注册 | 多服务模式 | 单端口多服务<br><br>多端口多服务 | 功能相同 | 已支持 |
| 响应调用 | 服务治理-QPS限流 | 支持单机/集群维度限流<br><br>支持服务整体/方法维度/主调维度/主调类型（flink）限流 | 不支持主调类型（flink）限流 | 补齐能力 |
| 服务治理-自适应限流 | 支持根据CPU/MEM/LOAD决定是否限流 | 不支持 | 补齐能力 |
| 服务治理-压测流量降级 | 服务端一键降级压测流量 | 不支持压测流量降级 | 补齐能力 |
| 服务治理-访问控制 | 自定义主调白名单限制访问 | 功能相同 | 已支持 |
| interceptor扩展 | 提供多个业务interceptor执行点，可回调业务逻辑 | 不支持多业务interceptor，interceptor执行点能力有差异 | 补齐能力 |
| interceptor能力 | 支持获取/修改header/request/response | 仅支持修改header，不可修改request/response | 补齐能力 |
| scope信息透传和注入 | 服务端取出header内容，注入服务端scope，应用内可以读取 | 支持，c++ 中对应 kenv context | 补齐能力 |
| 关闭与下线 | 优雅停机 | 支持配置静默等待时间/最大等待时间/server停机时间 | 功能相同 | 已支持 |
| 后台与旁路逻辑 | 消息传输格式 | protobuf3 | protobuf3 | 补齐能力 |
| 报文协议 | 默认使用plaintext，支持h2 TLS | 仅支持plaintext | 补齐能力 |
| 网络通信能力 | 支持远程调用和进程内调用 | 不支持进程内调用 | 补齐能力 |
| 静态配置获取 | 支持通过yaml/api方式指定 | 不支持 | 补齐能力 |
| 动态配置获取 | 支持kstable配置动态配置 | 基本相同 | 已支持 |
| 健康检查 | 支持主动健康检查/被动健康检查/恐慌模式 | 只支持被动健康检查，健康检查接口只会返回健康状态 | 补齐能力 |
| 框架内置接口 | 元信息获取接口<br><br>单元化补标字段接口 | 不支持 | 补齐能力 |
| 注册信息 | 支持注册host/port/ksn/group/paz/az/lane\_id/kwsInfo字段 | 功能相同 | 已支持 |
| 可观测性 | perf-基础打点 | 成功/失败/耗时等打点 | 功能一致，但是打点字段有区别 | 补齐能力 |
| perf-kstable打点 | 使用kstable sdk打点 | 使用c++的sentinel sdk打点 | 补齐能力 |
| sentinel打点 | 打点告警 | 功能一致，但是打点字段有区别 | 补齐能力 |
| ktrace | 记录并上报span调用关系 | 功能相同 | 已支持 |

### **2.2.4 RPC JNI分层架构**

方案目标是在不改变 Java 用户开发方式的情况下，将 RPC 内核能力封装到C++ RPC 归一化内核，并支持跨语言调用。

因此，我们引入了 wrapper（包装）层，用于衔接 Java 层用户接口和 C++ 内核实现。wrapper 负责 Java 和 C++ 的对象转换、函数调用以及线程管理。

调用示意图如下所示：

![out?code=fcAAUNGYppu0o2JjL59M931q0:5318716526350973823fcAAUNGYppu0o2JjL59M931q0:1774423315744](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcAAUNGYppu0o2JjL59M931q0:5318716526350973823fcAAUNGYppu0o2JjL59M931q0:1774423315744)

#### **客户端**

![out?code=fcAAUNGYppu0o2JjL59M931q0:-6627586577644950976fcAAUNGYppu0o2JjL59M931q0:1774423315744](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcAAUNGYppu0o2JjL59M931q0:-6627586577644950976fcAAUNGYppu0o2JjL59M931q0:1774423315744)

#### **服务端**

![out?code=fcAAUNGYppu0o2JjL59M931q0:-7546542561378775192fcAAUNGYppu0o2JjL59M931q0:1774423315744](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcAAUNGYppu0o2JjL59M931q0:-7546542561378775192fcAAUNGYppu0o2JjL59M931q0:1774423315744)

#### **代码示例**

基于流量治理、注册发现、数据路由等框架能力下沉到内核层的原则，输出JNI接口定义：[KESS-RPC 与JNI层交互接口设计(V2)](https://docs.corp.kuaishou.com/k/home/VFPuHUAZ-qOg/fcACXx27CCjUGTkOmmKyzXVlt?ro=false)

|     |     |     |
| --- | --- | --- |
|  | **客户端代码** | **服务端代码** |
| Java框架层（与KESS-RPC使用方式保持一致） | <br><br>```<br>/* 编写服务引用配置并发布引用 */ /* 还可以加入其他配置 */ KrpcTestService2Grpc.ITestService2 testService = ReferenceConfig.newBuilder()     .interfaceName(KrpcTestService2Grpc.ITestService2.class.getName()) // 指定接口     .protocol("grpc") // 指定调用协议     .sticky(true)     .lazy(true)     .loadBalancer("random")     .directUrl("grpc://127.0.0.1:8765")     .cluster("failover")     .serviceNames(Collections.singletonList("krpc-demo-service-local")) //指定注册名称     .registry(Collections.singletonList(DefaultConfigs.generateDefaultRegistryConfig()))     .build()     .refer();<br>```<br><br> | <br><br>```<br>/* 编写服务发布配置 */ ServiceConfig serviceConfig = ServiceConfig                 .newBuilder()   .interfaceName(KrpcTestService2Grpc.ITestService2.class.getName()) // 指定接口   .ref(new KrpcTestServiceImpl()) // 指定实现类   .serviceNames(Arrays.asList("service-name-1", "service-name-2")) //指定注册名称   .register(true)   .aliases(Arrays.asList("alias-name-1", "alias-name-2")) // 指定别名   .serverConfig(ServerConfig.newBuilder()                 .host("localhost")                 .port(8765)                 .protocol("grpc")                 .shutdownMaxWaitMs(1)                 .shutdownServerWaitMs(1)                 .shutdownSilenceWaitMs(1)                 .executor(ExecutorConfig.newBuilder()                           .coreThreadSize(10) //核心线程数                           .maxThreadSize(10)  //最大线程数                           .queueSize(1000)     //队列大小                           .build())                 .build()) // 指定服务端配置   .registry(Collections.singletonList(DefaultConfigs.generateDefaultRegistryConfig()))   .build(); // 发布服务 serviceConfig.export();<br>```<br><br> |
| Java包装层 | <br><br>```<br>// 先加载SO RpcClientJni rpcClientJni = RpcClientJniUtils.getRpcClientJni(); // 服务预热，仅触发一次 warmup(serviceName) // 创建配置 InitOption input = new InitOption(); // 创建客户端并缓存住 rpcClientJni = rpcClientJni.createClient(input); // 下面是每一次请求的逻辑   // 获取client long jniClientPointer = rpcClientJni.getJniClientPointer(request.getServiceUniqueName()); // 序列化request Object[] methodArgs = request.getMethodArgs(); GenericObject object = (GenericObject) methodArgs[1]; // 构建fullMethodName String interfaceName = getClusterConfig().getInterfaceName(); String methodFullName = "/" + RequestCommonUtils.generateFullMethod(interfaceName, request.getMethodName()); // 触发请求 byte[] response = RpcClientJniUtils.getJniClient().syncSend(jniClientPointer, methodFullName, object.getRawBytes()); KrpcResponse jniResponse = new KrpcResponse(); GenericObject genericObject = GenericObject.newBuilder()   .rawBytes(response)   .build(); jniResponse.setResp(genericObject); return jniResponse;<br>```<br><br> | <br><br>```<br>// 先加载SO RpcServerJni rpcServerJni = RpcServerJniUtils.getRpcServerJni(); // 然后创建代理对象 Object ref = serviceConfig.getRef(); implInvokerProxy = new ImplInvokerProxy(ref); // 将服务配置转换为JNI接口的入参，创建RPC Server InitOption input = new InitOption(serviceConfig) long serverPtr = rpcServerJni.createClient(InitOption input, implInvokerProxy, "(Ljava/lang/String;[B)[B"); // 逐个注册业务方法 implInvokerProxy.getFullMethodNames().forEach(methodName -> { rpcServerJni.addService(serverPtr, methodName, new Startcall()); }); // 启动RPC Server rpcServerJni.start(serverPtr);<br>```<br><br> |
| JNI层接口定义 | <br><br>```<br>JNIEXPORT jlong JNICALL Java_com_kuaishou_krpc_cluster_utils_RpcClientJni_makeCClient   (JNIEnv *, jobject, jstring); JNIEXPORT jbyteArray JNICALL Java_com_kuaishou_krpc_cluster_utils_RpcClientJni_syncSend   (JNIEnv *, jobject, jlong, jstring, jbyteArray);<br>```<br><br> | <br><br>```<br>JNIEXPORT jlong JNICALL Java_com_kuaishou_krpc_bootstrap_RpcServerJni_createJniServer   (JNIEnv *, jobject, jstring, jint, jobject, jstring); JNIEXPORT jboolean JNICALL Java_com_kuaishou_krpc_bootstrap_RpcServerJni_addService   (JNIEnv *, jobject, jlong, jstring); JNIEXPORT void JNICALL Java_com_kuaishou_krpc_bootstrap_RpcServerJni_start   (JNIEnv *, jobject, jlong);<br>```<br><br> |
| C++实现层（动态链接库） | 统一C++内核实现 |     |

## **2.3 技术难点与解决思路**

![out?code=fcAAUNGYppu0o2JjL59M931q0:-144120959973278648fcAAUNGYppu0o2JjL59M931q0:1774423315744](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcAAUNGYppu0o2JjL59M931q0:-144120959973278648fcAAUNGYppu0o2JjL59M931q0:1774423315744)

在传统RPC-SDK模式下，RPC执行在Java内部完成。而在Proxyless Mesh模式中，执行流程需要在Java层、JNI层和C++层之间切换。这其中涉及JVM/Native线程切换、线程和协程切换、数据传输等，会导致性能下降。因此，我们需要针对线程切换和内存拷贝等进行针对性的优化。

|     |     |     |
| --- | --- | --- |
| 难点问题 | 问题详细描述 | 解决思路 |
| 【难点1】跨语言C++线程回调Java扩展逻辑时性能劣化 | 在跨语言通信过程中，C++ Native线程需要通过JNI AttachCurrentThread动态绑定到JVM执行回调，执行完成后解绑。**频繁绑定/解绑JVM会引发显著的性能损耗**。该过程与Java自身回调相比，性能显著下降。 | 思路一： 预绑定线程池<br>	<br><br>      在服务初始化阶段创建固定规模的C++连接线程池，通过JNI接口将每个池中每个C++Native线程预绑定到JVM。当触发C++→Java回调时，直接调用已绑定JVM的Native线程执行任务，避免动态绑定JVM线程产生的性能开销。线程销毁时同步释放绑定的JVM资源。<br><br>		思路二：桥接式异步分发器<br>	<br><br>       C++侧将回调任务封装为跨语言任务队列，并部署少量专用的桥接线程。桥接线程监听到对应事件后，获取任务并转发到Java侧线程池进行执行。 |
| 【难点2】C++ bthread（协程） 性能优势弱化 | 当前C++ GRPC处理业务逻辑及调用其他组件时强依赖ThreadLocal，而brpc底层通过bthread处理业务逻辑，过程中可能跨多个pthread，直接访问ThreadLocal会造成数据错乱。归一化内核仍需兼容GRPC框架，因此**无法直接利用 bthread处理业务请求**，目前只在IO层使用 bthread，业务处理时需将 bthread转换为pthread，导致性能下降。 | ThreadLocal消除方案：修改框架内其他组件ThreadLocal逻辑，用bhread\_key代替pthread\_key等方式，消除其带来的影响。会涉及到相关组件的改动。<br><br>       优化逻辑分层：尽量将业务逻辑下沉到 bthread 中执行，仅当必须与JVM交互时触发pthread转换。 |
| 【难点3】跨语言线程/协程模型间的调度 | 在C++回调Java扩展逻辑的场景下，需要将C++ pthread绑定到JVM并通过C++线程执行Java代码，C++线程无法被Java协程框架代理。<br><br>      Java/C++跨语言处理ThreadLocal时，涉及C++ bthread、C++ pthread、Java pthread间转换，目前未解决。 | 跨语言协程协作优化：C++ 线程通过JNI绑定JVM后，在Java层建立协程异步分发通道。当C++回调Java时，在Java 侧将回调任务提交至协程池执行。该过程中需考虑任务分发过程带来的延迟，及线程数据的安全问题。<br><br>       ThreadLocal传输方案：在C++中提取bthread本地存储的local对象，并将其写入pthread的ThreadLocal中，然后再通过JNI将该对象传递给 Java线程。 |
| 【难点4】跨语言数据传输的性能损耗 | Java/C++跨语言调用过程中，需通过数据拷贝实现传参，带来额外的对象创建/析构成本，造成性能下降。 | 零拷贝共享机制：通过DirectBuffer构建跨语言共享内存空间，实现Java与C++间数据零拷贝传输。同时可以预初始化可复用的内存区域，避免高频分配/回收空间带来的性能损耗。<br><br>      线程级共享内存池管理：采用线程 DirectBuffer 实现跨语言不同线程的内存分区，避免并发读写时的线程竞争。<br><br>      智能内存监控体系：跟踪DirectBuffer生命周期，实现内存泄漏检测、自动回收、阈值告警等辅助功能。 |

# **三、稳定性保障**

## **3.1 稳定性保障方案**

### **3.1.1 质量保障机制**

稳定性保障方案目标是从研发、推全、维稳阶段的全部环节提高工程质量，降低变更风险，减少故障对业务的影响。基于用户侧接口向后兼容性约束原则，需构建完善的自动化测试和线上观测流程阶段，划分为**“集成测试阶段”、“健壮性测试阶段”、“性能测试阶段”、“预发布阶段”、“生产运行阶段”**，通过**建设自动化验证体系以覆盖RPC mesh链路全量功能**，通过**持续完善稳定性指标运营和故障处置预案以保证RPC mesh框架的稳定运行**，为框架功能迭代、归一化改造打好稳定性基础。详细参考：[RPC 稳定性保障方案](https://docs.corp.kuaishou.com/k/home/VbdEbWL6aT3c/fcACMhb8sbZ7GGLZllk7JlNiI)

![out?code=fcAAUNGYppu0o2JjL59M931q0:-5421706760695075414fcAAUNGYppu0o2JjL59M931q0:1774423315745](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcAAUNGYppu0o2JjL59M931q0:-5421706760695075414fcAAUNGYppu0o2JjL59M931q0:1774423315745)

质量保障机制建设总览图

### **3.1.2 Core问题预防专项**

#### **产生原因**

|     |     |
| --- | --- |
| 原因归纳 | 具体分析 |
| **程序BUG类** | 内存访问或管理异常：空指针、野指针、内存越界、double-free、多线程写错数据<br><br>		有一些场景通常会间接引起segmentation fault，比如use after free或越界等，取决于实际访问地址是否可由本进程访问；<br>	<br>		一些是allocator内部发现异常后主动abort后造成的；<br>	<br>		一些多线程写错数据的情况，影响可大可小，取决于被写错的地址影响了什么 |
| 除0（SIGFPE）、栈溢出（SIGSEGV） |
| 异常或错误处理：未捕获异常、线程退出不正常、OOM后未处理异常（bad\_alloc）或者指针等 |
| 主动退出：主动abort，assert等。其实上述部分场景也是库函数中被动调用了abort |
| 进程外因素 | 硬件或shm数据被truncate等（如SIGBUS） |
| 另外其它一些极端情况，比如二进制错误导致的SIGILL、地址对齐问题等，暂时不展开讨论 |

#### **解决思路**

![out?code=fcAAUNGYppu0o2JjL59M931q0:-3893518626906826864fcADfBpwhOc2KiNNSO8LeYd_v:1774423315745](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcAAUNGYppu0o2JjL59M931q0:-3893518626906826864fcADfBpwhOc2KiNNSO8LeYd_v:1774423315745)

## **3.2 灰度升级方案**

### **3.2.1 灰度升级**

灰度流程如下：

![out?code=fcAAUNGYppu0o2JjL59M931q0:-5538393037489503769fcAAUNGYppu0o2JjL59M931q0:1774423315745](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcAAUNGYppu0o2JjL59M931q0:-5538393037489503769fcAAUNGYppu0o2JjL59M931q0:1774423315745)

Client/Server JNI链路&协议切换方式：

|     |     |     |
| --- | --- | --- |
| 类型  | 链路切换 or 协议切换 | 行为  |
| Server | JNI链路切换 | 被调单实例会创建JNI server 或 Java server（二选一），两种模式可通过开关进行动态切换 & 回滚<br>	<br>		归一化版本的server在注册路由表时会携带特定标识 |
| 通信协议切换 | JNI server可同时兼容baidu & http2两种协议 |
| Client | JNI链路切换 | **主调服务单实例内会同时创建JNI client & Java client，可根据流量比例进行动态流量分配**<br>	<br>		归一化版本的client可识别路由表中携带特殊标识的server实例，原Java kess-rpc client不识别携带特殊标识的server实例 |
| 通信协议切换 | JNI client可识别被调端支持的协议，从而完成baidu & http2协议的切换 |

具体切换的过程中可能会遇到以下四种场景，每个场景中新老版本均能正常运作：

|     |     |     |     |     |
| --- | --- | --- | --- | --- |
| **灰度场景** | **Client流量路由** | **Client读取路由表** | **Server注册路由表** | **Server通信协议** |
| **灰度Client，Server使用旧版本** | 开关控制单实例内部X%流量走JNI逻辑(h2协议)，其他流量走原有的kess-rpc逻辑 | 新老版本client读取路由表的行为无变化 | 无变化 | 无变化，提供旧版本server服务，整体链路仅采取http2协议 |
| **灰度Client，Server使用新版本** | 开关控制单实例内部X%流量走brpc JNI逻辑(baidu协议)，其他流量走原有的kess-rpc逻辑 | 新版本client可额外识别携带特殊标识的节点，重新计算权重进行路由<br>	<br>		kess-rpc client无变化 | 新版本server在注册路由表时携带特定标识 | 对于旧版本client+新版本 JNI server的链路采取http2协议；<br>	<br>		对于新版本client+新版本JNI server的链路采取baidu协议 |
| **灰度Server，Client使用旧版本** | 无变化 | 老版本client只能读取路由表中不携带特殊标识的实例 | 新版本server在注册路由表时携带特定标识<br>	<br>		新版本server无变化 | 旧版本server链路采取http2协议<br>	<br>		新版本JNI server链路也采取http2协议 |
| **灰度Server，Client使用新版本** | 新版本Client用brpc访问新版本Server；<br><br>新版本client用grpc访问旧版本server | 新版本client可额外识别携带特殊标识的节点，重新计算权重进行路由 | 新版本server在注册路由表时携带特定标识<br>	<br>		新版本server无变化 | 旧版本server链路采取http2协议<br>	<br>		新版本server链路采取baidu协议 |

补充说明：旧版本client/server指的是现有的Java kess-rpc client/server；新版本client/server指的是归一化改造后的JNI client/server

### **3.2.2 灰度流控逻辑**

按照3.2.1的灰度场景大表，放量时需要客户端和服务器支持流量控制，逻辑大致如下：

![out?code=fcAAUNGYppu0o2JjL59M931q0:3567134354002243626fcAAUNGYppu0o2JjL59M931q0:1774423315746](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcAAUNGYppu0o2JjL59M931q0:3567134354002243626fcAAUNGYppu0o2JjL59M931q0:1774423315746)

为了支持放量流控，客户端和服务端需要支持的功能如下：

服务端：

（1）支持服务注册时携带jni-rpc的标识，并且客户端能识别。

（2）调整权重或者拆分port，并把权重注册到kess，将jni-rpc的server流量拆分达到流控目的。

客户端：

（1）支持服务发现识别出JNI server标识

（2）需要有一个选取用krpc客户端还是jni-rpc客户端的模块，流控主要功能之一

（3）需要有一个选取server类型的模块（此处是流控、优先级、server权重等待讨论）

### **3.2.3 回滚&降级方案**

#### **回滚**

回滚是基于监控异常后，人工介入做处理，以配置下发为手段，达到关闭JNI流量，恢复成JAVA KRPC为目的。

		**server回滚：**一键回滚，直接关闭JNI服务，回退到JAVA KRPC，保证业务稳定性。RPC初期灰度的首选方案，需要RPC代码支持热切换，从JNI RPC切换到JAVA RPC。回滚后重新注册KESS，告诉主调已不支持BRPC协议；
	
		**client回滚**：一键回滚，主调将JNI RPC流量比例降为0，切换到JAVA KRPC。
	

回滚流程：

![out?code=fcAAUNGYppu0o2JjL59M931q0:-4279981439148316273fcAAUNGYppu0o2JjL59M931q0:1774423315747](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcAAUNGYppu0o2JjL59M931q0:-4279981439148316273fcAAUNGYppu0o2JjL59M931q0:1774423315747)

#### **降级**

降级是自动化的，需要代码自动识别出降级指标，降级指标可以参考回滚（coredump、内存异常、CPU异常、响应码异常、延迟异常等），降级的实现逻辑可以视为回滚的自动化，但降级的触发条件应该是更严格。

|     |     |
| --- | --- |
| 降级指标 | 触发方式 |
| coredump | （1）轮询/data/coredump/目录，看是否有coredump文件<br><br>（2）考虑到实例漂移，需要从coredump平台拉取信息后触发 |
| 容器资源异常（mem、cpu） | 针对性能敏感的业务，可设置一个CPU和MEM的上限水位，超过水位后视为明显异常，自动降级，不影响业务 |
| 致命错误码 | 比如method\_not\_found这种不应该出现的错误，视为致命错误码 |

## **3.3 关键指标运营**

|     |     |     |
| --- | --- | --- |
| 指标模块 | 具体指标 | kwaiBI看板 |
| 灰度放量指标 | client放量百分比（当前放量核数/总核数） |  |
| server放量百分比（当前放量核数/总核数） |  |
| 稳定性指标 | SO加载成功率 |  |
| coredump检测相关指标 |  |
| SLA指标 | 请求RT |  |
| 请求成功率 |  |

# **四、实施节奏**

![out?code=fcAAUNGYppu0o2JjL59M931q0:-7466314460626281138fcAAUNGYppu0o2JjL59M931q0:1774423315747](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcAAUNGYppu0o2JjL59M931q0:-7466314460626281138fcAAUNGYppu0o2JjL59M931q0:1774423315747)

# **五、附录**

## **5.1 成本计算公式**

假设目前公司内平均CPU使用率为U，其中RPC组件使用CPU总核数为X，业务使用CPU总核数为Y，极限CPU使用率设为Z，则理论上最大CPU使用容量为：

若组件可优化降低CPU使用40%，则优化后CPU使用容量为：

为了使CPU使用率回到Z，可对服务进行缩容，设缩容后所需的总CPU数量为O，则：

由上式可得：

则可缩容的核数，即最终收益为：

## **5.2 辅助验证材料**

		性能压测报告：[PRC on Mesh Server侧性能压测](https://docs.corp.kuaishou.com/k/home/VNXSxO6xWYT4/fcACZYA0X5-5lNA4OuyfAg6xz)
	
		功能集合梳理：[rpc mesh功能集合梳理](https://docs.corp.kuaishou.com/k/home/VLJd3yRVEdfg/fcAD8CyJT-Nfrb-GIajccv1sv)、[KESS-RPC框架功能梳理](https://docs.corp.kuaishou.com/k/home/Vb2i-E8M8BFo/fcAAnlwzs_aHiabu3rBp5R2Hh#section=h.tl6vbdptna6c)
	
		开源RPC框架压测：<https://brpc.apache.org/zh/docs/benchmark/>
	
		RPC稳定性保障方案细则：[RPC 稳定性保障方案](https://docs.corp.kuaishou.com/k/home/VbdEbWL6aT3c/fcACMhb8sbZ7GGLZllk7JlNiI)
	

性能测试情况

		**brpc vs grpc性能（bprc官方数据）：**
	
			**吞吐方面：**当请求包小于2KB时，brpc吞吐是gRPC的5倍；
		
			延迟方面：brpc平均延时短，几乎没有被长尾影响，gRPC初期不错，到长尾区域后表现糟糕
		
			资源使用率：
		
		**brpc vs KESS-RPC性能压测**：基于8c16g的机器进行压测，压测模型输入输出均为1KB，具体压测报告：[PRC on Mesh Server侧性能压测](https://docs.corp.kuaishou.com/k/home/VNXSxO6xWYT4/fcACZYA0X5-5lNA4OuyfAg6xz)
	

|     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- |
| QPS<br><br>（payload：1KB/1KB） | 组件类型 | 延迟（客户端视角P99） | CPU使用率 | 内存  | 对比  |
| 1K  | java kess-rpc | 0.9ms | 4.45% | 36% | C++ brpc较Java kess rpc：<br><br>		CPU使用率**降低30%**<br>	<br>		请求RT**降低15%** |
| c++ brpc | 0.75ms | 3.14% | 1.27% |
| 5K  | java kess-rpc | 0.77ms | 16.96% | 36% | C++ brpc较Java kess rpc：<br><br>		CPU使用率**降低31%**<br>	<br>		请求RT**降低15%** |
| c++ brpc | 0.65ms | 11.65% | 1.4% |
| 2w  | java kess-rpc | 0.98ms | 51% | 36.1% | C++ brpc较Java kess rpc：<br><br>		CPU使用率**降低34%**<br>	<br>		请求RT**降低18%** |
| c++ brpc | 0.8ms | 33.7% | 1.53% |
| 极限QPS | java kess-rpc（**6.6w**） | 6.1ms | 88% | 37.6% | c++ brpc较kess-rpc **极限QPS提升188%** |
| c++ brpc（**19w**） | 7.3ms | 97% | 2.32% |

结论：c++ brpc较kess-rpc，同QPS场景下CPU平均使用率优化幅度超30%，极限性能提升188%。

## **5.3 Client/Server交互流程**

![out?code=fcAAUNGYppu0o2JjL59M931q0:-4409580456299174567fcAAUNGYppu0o2JjL59M931q0:1774423315748](https://docs.corp.kuaishou.com/image/api/external/load/out?code=fcAAUNGYppu0o2JjL59M931q0:-4409580456299174567fcAAUNGYppu0o2JjL59M931q0:1774423315748)

归一化链路调用时序图

    Created at: 2026-03-25T14:51:52+08:00
    Updated at: 2026-03-30T17:12:52+08:00

