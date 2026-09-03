# 快手RPC使用现状

快手RPC使用现状

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

    Created at: 2026-03-25T14:15:24+08:00
    Updated at: 2026-03-25T14:15:32+08:00

