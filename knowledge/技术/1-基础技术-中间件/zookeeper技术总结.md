# zookeeper技术总结




# zookeeper的四种类型的节点




zk 集群中有3种节点：leader，follower，observer，其中 observer 节点没有投票权，即它不参与选举和写请求的投票。

|     |     |
| --- | --- |
| PERSISTENT | 持久化节点 |
| PERSISTENT\_SEQUENTIAL | 顺序自动编号持久化节点，这种节点会根据当前已存在的节点数自动加 1 |
| EPHEMERAL | 临时节点， 客户端session超时这类节点就会被自动删除 |
| EPHEMERAL\_SEQUENTIAL | 临时自动编号节点 |







# ZAB



|     |     |     |
| --- | --- | --- |
| ZAB中，写操作必须在主节点（比如节点A）上执行。如果客户端访问的节点是备份节点（比如节点B），它会将写请求转发给主节点。 | Zookeeper提供的是最终一致性，也就是读操作可以在任何节点上执行，客户端会读到旧数据；Zookeeper提供了一个解决办法，那就是sync命令。你可以在执行读操作前执行sync | 事务标识符是64位的long型变量，有任期编号epoch和计数器counter两部分组成（为了形象和方便理解，我把epoch翻译成任期编号），格式为，高32位为任期编号，低32位为计数器 |
| ZAB支持3种成员身份（领导者、跟随者、观察者）；<br>定义了4种成员状态：LOOKING、FOLLOWING、LEADING、OBSERVING | 选主：<br><br>* 优先检查任期编号（Epoch），任期编号大的节点作为领导者；<br>* 如果任期编号相同，比较事务标识符的最大值，值大的节点作为领导者；<br>* 如果事务标识符的最大值相同，比较集群ID，集群ID大的节点作为领导者。 | <br> |
| SessionTimeout | 服务端：<br>tickTime = 2S<br>maxSessionTimeout = 20 \* tickTime minSessionTimeout = 2 \* tickTime | 客户端负责保活：<br>1、任意zk读写请求都会续约session<br>2、在客户端空闲超过 1/3 sessionTimeOut（13.3s）的情况下，客户端会自动发起一次PING续约<br>3、服务端负责踢掉过期的session ： 默认每2s巡检一次。<br> |







    Created at: 2020-07-15T18:05:36+08:00
    Updated at: 2024-03-10T08:49:36+08:00

