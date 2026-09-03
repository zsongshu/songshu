# YARN与Kubernetes



|     |     |     |
| --- | --- | --- |
|  | **YARN** | **Kubernetes (K8s)** |
| **功能** | ### YARN是一个基于容器的分布式资源调度框架，通过ResourceManager全局分配资源、ApplicationMaster协调任务执行，适用于Hadoop生态的大数据批处理场景（如MapReduce、Spark），以资源池化和双层调度机制实现离线计算的高效资源利用。 | ### Kubernetes是一个容器编排平台，通过Horizontal Pod Autoscaler（HPA）动态调整Pod副本数、Cluster Autoscaler自动扩缩节点资源，结合Service与Ingress实现服务发现与负载均衡，适用于微服务架构、混合负载（在线+离线）和云原生场景，以容器化和弹性伸缩能力保障应用的高可用与资源优化。 |





    Created at: 2025-09-11T20:07:21+08:00
    Updated at: 2025-09-11T20:09:02+08:00

