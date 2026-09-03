# 深入理解Mysql主从原理-学习笔记-MTS技术

MTS(Multi-Threaded Slaves)


* last\_commited：**代表上一个提交的事务 ID**。 如果两个事务的 last\_commited 相同，说明这两个事务是在同一个 Group 内提交的
* sequence\_number：自增事务 ID


GTID/**sequence\_number/****last\_committed** 解释：

* **gtid是全局事务ID，全局唯一的；**
* **sequence\_number是用来区分事务的，是一个从1开始的自增值；**
* **last\_committed****用来区分组提交，同一个组提交的多个事务，gtid不同，****sequence\_number也不同，但是****last\_committed****是相同的；**
* **连续的两个组，下一个组的****last\_committed****等于上一个组的最后一个****sequence\_number；**


Current\_lwm：这个值代表的是所有在 GAQ 队列上还没有提交完成事务中最早的那个事务的前一个已经提交事务的 seq number，可能后面的事务已经提交完成了，听起来可能比较拗口但很重要，如果都提交完成了那么就是取最新提交的事务的 seq number，下面的图表达的就是这个意思，这个图是源码中的。这个值的获取可参考函数

**关键结论：last\_committed <=** Current\_lwm，可以并行执行，否则需要等待

例子：一个事务只删除一条数据，Event顺序如下：

1. GTID\_EVENT
2. QUERY\_EVENT
3. MAP\_EVENT
4. DELETE\_EVENT
5. XID\_EVENT




    Created at: 2022-06-14T11:10:51+08:00
    Updated at: 2022-06-14T13:21:38+08:00

