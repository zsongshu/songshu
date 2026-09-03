# 产品体系-美团ITU产品体系-入口



|     |     |
| --- | --- |
| IaaS | * IDC<br>	* POWER-IDC动环监控平台<br>* 运维&运营<br>	* Nova-美团基础设施资源运维平台<br>	* TCO - 基础设施成本管理系统<br>	* Billing-私有云计费账单<br>	* IDOP-基础设施资源数据运营平台<br>	* SCM-供应链管理系统<br>	* CMP-基础设施容量管理系统<br>* 服务器<br>	* Terra-物理机故障运营管理平台<br>	* Saturn-线上选型系统<br>	* M-ARM-美团ARM服务器<br>	* Mercury-ODM服务器<br>* 网络<br>	* M-NIC-美团智能网卡<br>	* MGW-四层负载均衡<br>	* MDNS-美团权威DNS<br>	* M-NOS-美团交换机网络操作系统<br>	* MFW-内网防火墙<br>	* Dipper-北斗网络运维平台<br>	* HttpDNS-直连应用层域名解析系统<br>	* NSA-网络安全保障系统<br>	* Hunter-网络故障定位系统<br>* 容器<br>	* Hulk-容器集群平台<br>	* METCD-ETCD管理平台<br>	* [[产品体系-美团ITU产品体系-MKE-美团容器集群引擎\|产品体系-美团ITU产品体系-MKE-美团容器集群引擎]]<br>	* HDR-Hulk诊断修复工具<br>	* MTOS-美团操作系统 |
| PaaS | * 数据库<br>	* Zebra-数据库访问层中间件<br>	* RDS-关系数据库托管服务平台<br>	* [[产品体系-美团ITU产品体系-DTS-数据传输服务\|产品体系-美团ITU产品体系-DTS-数据传输服务]]<br>	* DAS-数据库自治服务<br>	* SwimlaneStore-测试环境数据管理工具<br>	* ORC-数据库高可用服务<br>	* MTSQL-美团MySQL发行版<br>	* Blade-分布式关系型数据库<br>* 存储（[[产品体系-美团ITU产品体系\|产品体系-美团ITU产品体系]]）<br>	* Squirrel-分布式缓存服务<br>	* Cellar-分布式KV存储<br>	* S3Plus-分布式对象存储系统<br>	* MAS-归档存储<br>	* EBS-分布式弹性块存储服务<br>	* [[产品体系-美团ITU产品体系-MStore - 分布式存储底座\|产品体系-美团ITU产品体系-MStore - 分布式存储底座]]<br>	* EFS-兼容POSIX接口的分布式文件存储服务<br>* 中间件<br>	* 消息<br>		* Kafka<br>		* RocketMQ<br>			* 核心能力<br>				* Exactly-Once投递语义<br>				* 集群消费<br>				* 广播消费<br>				* 定时消息<br>				* 延时消息<br>				* 事务消息<br>				* 顺序消息<br>					* 全局顺序消息<br>					* 分区顺序消息<br>				* 消息堆积<br>				* 消息过滤<br>				* 消息轨迹<br>				* 重置消费位点<br>				* 死信队列<br>		* Pulsar<br>		* Mafka-消息队列服务<br>			* 底层基于Apache Kafka，增加了自研的基于机房粒度的中心化调度、时间回溯、粘性分配、死信、延迟队列、适用于美团自用的同步/异步客户端、机房容灾等高阶特性<br>	* 应用组件<br>		* Crane-分布式任务调度<br>		* Lion-配置管理平台<br>		* Swan-分布式事务服务<br>		* BCP-业务正确性校验平台<br>		* Nest-Serverless计算平台<br>		* Shepherd-API网关<br>		* Leaf-分布式ID生成服务<br>		* WebStatic-静态网站托管服务<br>	* 服务框架<br>		* MDP Framework<br>		*  JBox-Java应用容器<br>		* [[产品体系-美团ITU产品体系-OCTO-服务治理平台\|产品体系-美团ITU产品体系-OCTO-服务治理平台]]<br>	* 接入<br>		* Shark-前端网络框架<br>		* Oceanus-七层网关服务<br>		* Pike-双向通信服务<br>		* MGW-四层负载均衡<br>	* 工具服务<br>		* Gravity-流程平台<br>		* Cerberus-分布式锁<br>		* Dayu-SET化治理平台<br>	* 多媒体<br>		* Swarm-音视频转码服务<br>		* Riverrun-直播服务<br>		* Venus-图片服务<br>		* MRTC-实时音视频通信系统<br>	* 稳定性<br>		* Rhino-服务保护平台<br>		* Scalpel-性能诊断优化平台<br>		* Logan-前端日志系统<br>		* Monkey-故障演练平台<br>		* Raptor-监控平台<br>		* Mtrace-分布式链路追踪系统 |
| 安全  | * KMS-密钥托管服务<br>* PKI-公钥基础设施<br>* Anti-DDoS防护系统 |
| SRE | * 故障管理<br>	* Radar-雷达3.0<br>	* Seer-先知<br>	* COE-复盘分析工具<br>	* AC-告警中心<br>	* MOD-运维数据仓库<br>	* Horae，可扩展的时序数据异常检测系统<br>* 资源管理<br>	* SC-服务图谱<br>	* Dora-机器猫<br>	* MCDN-CDN管理平台<br>	* Domain-域名管理<br>* 变更管理<br>	* CF-变更风险管控平台<br>	* Avatar-阿凡达<br>	* Rocket-主机管理<br>	* Jumper-跳板机 |
| 开发工具 | * WebCI-前端持续交付平台<br>* MNPM-JS包管理平台<br>* MTD-设计体系工具<br>* MSM-中间件SDK管理中心<br>* Air-前端工程研发框架 |
| MWS-美团私有云平台 | * MWS-Mobile-美团私有云移动端 |





    Created at: 2024-06-04T09:17:39+08:00
    Updated at: 2024-06-04T10:34:03+08:00

