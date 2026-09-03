# DRDS事务实现

DRDS事务实现：

分布式事务的实现原理是把DRDS单机事务，通过特定SQL变成分布式事务。

实现流程：
1、通过select last\_txc\_xid()，申请一个xid，并把xid放到当前的TConnection的ITxcTrxContext，并没有放到当前线程；
2、select last\_txc\_xid()做的第二个事情，设置trxPolicy为TXC\_TRANSACTION
3、对于每一条事务内的SQL，使用TxcStyleTransaction
4、执行SQL的时候，使用连接上的XID，SQL执行完毕当即把线程上的xid清理；
5、事务commit或者rollback的时候，如果是发起者，啥也不做；如果是参与者，则提交分支，把连接上的xid设置null；
6、连接close的时候，把线程上的xid清理。

    Created at: 2024-03-09T22:05:52+08:00
    Updated at: 2024-03-09T22:05:52+08:00

