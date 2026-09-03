# OceanBase数据链路-OBProxy


连接OB的几种方式


* 直连ObServer: 用户 <--> MySQL驱动 <--> ObServer
* ObProxy代理: 用户 <--> MySQL驱动 <--> ObProxy <--> OceanBase集群
* OCJ: 用户 <--> OCJ <--> OceanBase集群


OBProxy特点


* 高性能转发: ObProxy完整兼容MySQL协议, 采用异步框架和流式转发的设计, 保证了数据的高性能转发(单核5万QPS), 以及自身对机器资源的最小消耗(内存不超过50M,单cpu不超过20%).
* 最佳路由: ObProxy需要充分考虑用户请求涉及的副本位置、用户的读写分离期望路由、OceanBase多地部署时的最优链路, 以及OceanBase各机器的状态以及负载情况, 将用户请求路由到最佳的ObServer.
* 连接管理: 针对一个Client端的物理连接, ObProxy维持自身到后端多个ObServer的连接, 保证了Client高效访问各个ObServer, 同时屏蔽了ObServer端连接异常关闭对Client端连接的影响.
* 定制协议: 原生MySQL协议报文存在CRC校验缺失, Request Id校验缺失的正确性缺陷, 而ObProxy和ObServer了之间链路则可通过配置OceanBase定制协议予以解决.
* 易运维: ObProxy采用无状态独立部署, 支持无限水平扩展, 并且可以通过丰富的内部命令实现对自身状态的实时监控, 实现自身冷热升级/下线/重启等常见运维操作, 可以提供极大的运维便利性.


最佳实践

OBProxy本身是无状态的，可以将其部署到Client侧，来规避Client到OBProxy的一次额外的网络开销






    Created at: 2019-07-30T20:47:14+08:00
    Updated at: 2025-12-31T15:51:58+08:00

