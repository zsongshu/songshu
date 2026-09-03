# 可排序位点ResolveTs 算法

### **ResolvedTs的意义**

由于我们的事务模型是RC，因此当同步到下游的时候，事务应该需要且只需要按照提交时间排序，即按照CommitTS排序。 更强的一致性要求则同步到下游的时候可能需要额外的保证。
在实际事务执行的过程中，同一Region的不同事务在获得CommitTS后，并不需要保证按照CommitTS的顺序提交RAFT（即WAL）。因此在learner节点回放时，可能出现CommitTS较小的事务，却较晚回放的现象。
因此对于下游的同步程序（TiCDC），是需要一个定时的事件来通知下游程序可以将已获得事件排序的，这就是ResolvedTs Event原本的意义。即KV保证ResolvedTs之前的所有已提交的事务均已发送给了下游，下游可以安全的排序。
通过简单的逻辑推论，就可以得出： ResolvedTs这一时间点应满足如下条件：**在RAFT log的序列中，ResolvedTs这一时间点之后，不会再有比它更小的CommitTs。**

### **现在的实现原理**

在现在的实现中，每个Region(即Raftgroup) 定期发送RaftHeartbeat事件(下面以HBLog代替)，携带timestamp(hb\_ts)。其作用在于：

1. 帮助AutoCommit事务排序。（见下）
2. 当没有事务发生时，帮助下游推动全局时间戳，满足下游业务的需要。

Binlog KV作为raft learner， 只需要关心两种事件：TxnLog和HBLog。 其中TxnLog中存储数据，而HBLog中存储有时间信息可以用来计算ResolvedTs。 具体的排序工作可由binlogKV或TiCDC完成，在现在的实现中由TiCDC进行重组排序，binlogKV负责提供按照raftlog中的顺序输出TxnLog，并且计算可排序位点（ResolvedTs）。 TiCDC重组的原理可参考相关文档。下面描述binlog如何计算ResolvedTs :

* 对于2PC事务，由于存在PREPARE中间状态，则对于任一binlog的时间点：
	* 如果一个事务的PREPARE日志此时尚未到达learner，则其commit\_ts必然大于此时learner上所观测到的最大hb\_ts. (\*)
	* 如果一个事务的PREPARE日志已经到达learner，则其commit\_ts必然大于此事务的start\_ts
	* 综上所述，2PC的事务ResolvedTs = min(start\_ts...)。 如果当前没有活跃事务，则应选取最近的hb\_ts
* 对于AutoCommit事务，由于没有PREPARE的中间状态，因此需要RaftHeartbeat协助进行AutoCommit的排序 ，即由Raft leader保证hb\_ts总是当前最大的autocommit\_ts:
	* 对于AutoCommit事务，其ResolvedTs即当前时间点最近的hb\_ts

    Created at: 2023-02-10T10:03:36+08:00
    Updated at: 2023-02-10T10:04:38+08:00

