# Gossip协议

## gossip 是一种弱一致算法。

特点：
1，去中心化，集群中各个节点都是对等的。
2，无法保证在某个时刻所有节点状态一致。
3，比较适合小数据量的同步。失败检测、路由同步、Pub/Sub、动态负载均衡

Anti-Entropy（反熵）：以固定的概率传播所有的数据
Rumor-Mongering（谣言传播）：仅传播新到达的数据

### 

### **gossip 在工程上的使用**

gossip 协议可以支持以下需求：

* Database replication
* 消息传播
* Cluster membership
* Failure 检测
* Overlay Networks
* Aggregations (比如计算平均值、最大值以及总和)

在下面的工程上使用到了 gossip 协议。

* Riak（[https://github.com/basho/riak）](https://github.com/basho/riak%EF%BC%89) 使用 gossip 协议来共享和传递集群的环状态（ring state）和存储桶属性（bucket properties）。
* Cassandra：节点间的信息交换使用了 gossip 协议，因此所有节点都可以快速了解集群中的所有其他节点。
* Dynamo：采用基于 gossip 协议的分布式故障检测和成员协议，这样集群中添加或移除节点，其他节点可以快速检测到。
* Consul：使用了称为 SERF 的gossip 协议，主要有两个目的：1、发现新的节点或者发现故障节点；2、为一些重要的事件（比如 Leader 选举）传播提供可靠、快速的传播
* Amazon s3：使用 gossip 协议将服务的状态传递给系统。
* Redis Cluster：集群中的 Nodes 之间使用 gossip 协议向其他 nodes 传播集群信息，以达到自动发现的特性。
* 比特币：著名的比特币网络在发送消息（比如发起一笔比特币转账）的时候会使用 gossip 协议，比确保所有的结点都会收到。
* Akka Cluster：Akka 基于 gossip 协议提供了一种故障检测机制，能够自动发现出现故障而离开集群的成员节点，通过事件驱动的方式，将状态传播到整个集群的其它成员节点。

    Created at: 2023-05-31T19:06:28+08:00
    Updated at: 2023-05-31T19:08:39+08:00

