# 产品体系-美团ITU产品体系-OCTO-服务治理平台



|     |     |
| --- | --- |
| 组件  | * OCTO<br>	* OCTO为业务提供了标准化微服务治理解决方案，能够轻松实现服务注册发现、负载均衡、容错处理、降级熔断、灰度发布、调用数据可视化等服务治理功能。<br>* Scanner<br>	* Scaner 是 OCTO 框架内一个独立的服务扫描/监控 子系统.<br>* MSGP<br>	* MSGP的核心目标是为公司服务治理提供统一的操作平台。核心指标主要围绕系统的核心价值及核心功能两个维度展开。<br>* Nereus<br>	* Nereus是美团命名服务（MNS）的控制层服务，提供注册中心数据的读、写、营运等工作，意在提供强大的平行扩展能力，增强MNS的性能与可用性。<br>* Watt<br>	* 收集公司所有接入OCTO业务的上报服务调用数据，为各业务线提供系统化、立体化、精细化的性能指标、健康状况、基础告警等。 |
|  |  |
| 服务发现 | * ETCD<br>* Zookeeper<br>* Spring Cloud Eureka<br>* Hashicorp Consul<br>* Config Server<br>* MNS<br>	* 快速实现服务注册、服务自动发现，使分布式服务提供方注册管理服务更加方便、消费方获取后端服务列表更加简单。 |
| 配置中心 | * Diamond（Nacos）<br>* Spring Cloud Config <br>* 携程 Apollo<br>* Lion-配置管理平台 |
| 服务网关 | * Spring Cloud gateway<br>* Zuul |
| RPC | * Feign<br>* Grpc<br>* hession<br>* Thrift |
| 限流与熔断 | * Hystrix<br>* Sentinel<br>* Rhino-服务保护平台 |
| 分布式追踪 | * Eagleeye<br>* Mtrace<br>	* 分布式链路追踪系统，主要用于分析分布式系统的行为，解决系统间的调用瓶颈，监控各个服务的运行状态，采集业务敏感的相关数据。 |





    Created at: 2024-06-04T09:39:35+08:00
    Updated at: 2024-06-04T09:52:45+08:00

