# 淘宝内部分享：怎么跳出MySQL的10个大坑（下）



## 淘宝内部分享：怎么跳出MySQL的10个大坑（下）

[[#|分布式系统架构设计艺术]] _2016-04-13_



## 

---

## **MySQL · 捉虫动态· MySQL client crash一例**

**背景**        

客户使用MySQLdump导出一张表，然后使用MySQL -e 'source test.dmp'的过程中client进程crash，爆出内存的segment            fault错误，导致无法导入数据。

**问题定位**        

test.dmp文件大概50G左右，查看了一下文件的前几行内容，发现：



 A partial dump from a server that has GTIDs will by default include the GTIDs of all transactions, even those that changed suppressed parts of the database If you don't want to restore GTIDs pass set-gtid-purged=OFF. To make a complete dump, pass...
 -- MySQL dump 10.13  Distrib 5.6.16, for Linux (x86\_64)
 --
 -- Host: 127.0.0.1    Database: carpath
 -- ------------------------------------------------------
 -- Server version       5.6.16-log
 /\*!40101 SET @OLD\_CHARACTER\_SET\_CLIENT=@@CHARACTER\_SET\_CLIENT \*/;
 /\*!40101 SET @OLD\_CHARACTER\_SET\_RESULTS=@@CHARACTER\_SET\_RESULTS \*/;



问题定位到第一行出现了不正常warning的信息，是由于客户使用MySQLdump命令的时候，重定向了stderr。即:

> MySQLdump ...>/test.dmp 2>&1

导致error或者warning信息都重定向到了test.dmp, 最终导致失败。

**问题引申**        

问题虽然定位到了，但却有几个问题没有弄清楚：

问题1. 不正常的sql，执行失败，报错出来就可以了，为什么会导致crash？

> MySQL.cc::add\_line函数中，在读第一行的时候，读取到了don't,发现有一个单引号，所以程序死命的去找匹配的另外一个单引号，导致不断的读取文件，分配内存，直到crash。                假设没有这个单引号，MySQL读到第六行，发现;号，就会执行sql，并正常的报错退出。

问题2. 那代码中对于大小的边界到底是多少？比如insert语句支持batch insert时，语句的长度多少，又比如遇到clob字段呢？



		首先clob字段的长度限制。clob家族类型的column长度受限于max\_allowed\_packet的大小，MySQL 5.5中，对于max\_allowd\_packet的大小限制在(1024, 1024\*1024\*1024)之间。
	

		MySQLdump导出insert语句的时候，如何分割insert语句？MySQLdump时候支持insert t1 value(),(),();这样的batch insert语句。                 MySQLdump其实是根据opt\_net\_buffer\_length来进行分割，当一个insert语句超过这个大小，就强制分割到下一个insert语句中，这样更多的是在做网络层的优化。又如果遇到大的clob字段怎么办？                    如果一行就超过了opt\_net\_buffer\_length，那就强制每一行都分割。
	
		MySQL client端读取dump文件的时候, 到底能分配多大的内存？MySQL.cc中定义了:#define MAX\_BATCH\_BUFFER\_SIZE (1024L \* 1024L \* 1024L)。                 也就是MySQL在执行语句的时候，最多只能分配1G大小的缓存。
	



所以，正常情况下，max\_allowed\_packet现在的最大字段长度和MAX\_BATCH\_BUFFER\_SIZE限制的最大insert语句，是匹配的。

**RDS问题修复原则**        

从问题的定位上来看，这一例crash属于客户错误使用MySQLdump导致的问题，Aliyun RDS分支对内存导致的crash问题，都会定位并反馈给用户。            但此例不做修复，而是引导用户正确的使用MySQLdump工具。

---

## MySQL · 捉虫动态· 设置 gtid\_purged 破坏AUTO\_POSITION复制协议

**bug描述**        

Oracle 最新发布的版本 5.6.22 中有这样一个关于GTID的bugfix，在主备场景下，如果我们在主库上 SET GLOBAL GTID\_PURGED            = "some\_gtid\_set"，并且 some\_gtid\_set 中包含了备库还没复制的事务，这个时候如果备库接上主库的话，预期结果是主库返回错误，IO线程挂掉的，但是实际上，在这种场景下主库并不报错，只是默默的把自己            binlog 中包含的gtid事务发给备库。这个bug的造成的结果是看起来复制正常，没有错误，但实际上备库已经丢事务了，主备很可能就不一致了。

**背景知识**        



		binlog GTID事件
	



binlog 中记录的和GTID相关的事件主要有2种，Previous\_gtids\_log\_event 和 Gtid\_log\_event，前者表示之前的binlog中包含的gtid的集合，后者就是一个gtid，对应一个事务。一个            binlog 文件中只有一个 Previous\_gtids\_log\_event，放在开头，有多个 Gtid\_log\_event，如下面所示



Previous\_gtids\_log\_event   // 此 binlog 之前的所有binlog文件包含的gtid集合

Gtid\_log\_event // 单个gtid event
Transaction
Gtid\_log\_event
Transaction
.
.
.
Gtid\_log\_event
Transaction





		备库发送GTID集合给主库
	



我们知道备库的复制线程是分IO线程和SQL线程2种的，IO线程通过GTID协议或者文件位置协议拉取主库的binlog，然后记录在自己的relay            log中；SQL线程通过执行realy log中的事件，把其中的操作都自己做一遍，记入本地binlog。在GTID协议下，备库向主库发送拉取请求的时候，会告知主库自己已经有的所有的GTID的集合，Retrieved\_Gtid\_Set            + Executed\_Gtid\_Set，前者对应 realy log 中所有的gtid集合，表示已经拉取过的，后者对应binlog中记录有的，表示已经执行过的；主库在收到这2个总集合后，会扫描自己的binlog，找到合适的binlog然后开始发送。



		主库如何找到要发送给备库的第一个binlog
	



主库将备库发送过来的总合集记为 slave\_gtid\_executed，然后调用 find\_first\_log\_not\_in\_gtid\_set(slave\_gtid\_executed)，这个函数的目的是从最新到最老扫描binlog文件，找到第一个含有不存在            slave\_gtid\_executed 这个集合的gtid的binlog。在这个扫描过程中并不需要从头到尾读binlog中所有的gtid，只需要读出            Previous\_gtids\_log\_event ，如果Previous\_gtids\_log\_event 不是 slave\_gtid\_executed的子集，就继续向前找binlog，直到找到为止。

这个查找过程总会停止的，停止条件如下：

> 1. 找到了这样的binlog，其Previous\_gtids\_log\_event 是slave\_gtid\_executed子集
> 	

		在往前读binlog的时候，发现没有binlog文件了（如被purge了），但是还没找到满足条件的Previous\_gtids\_log\_event，这个时候主库报错
	
		一直往前找，发现Previous\_gtids\_log\_event 是空集
	

在条件2下，报错信息是这样的

Got fatal error 1236 from master when reading data from binary log: 'The            slave is connecting using CHANGE MASTER TO MASTER\_AUTO\_POSITION = 1, but            the master has purged binary logs containing GTIDs that the slave requires.

其实上面的条件3是条件1的特殊情况，这个bugfix针对的场景就是条件3这种，但并不是所有的符合条件3的场景都会触发这个bug，下面就分析下什么情况下才会触发bug。

**bug 分析**        

假设有这样的场景，我们要用已经有MySQL实例的备份重新做一对主备实例，不管是用 xtrabackup 这种物理备份工具或者MySQLdump这种逻辑备份工具，都会有2步操作，

> 1. 导入数据
> 	

		SET GLOBAL GTID\_PURGED ="xxxx"
	

步骤2是为了保证GTID的完备性，因为新实例已经导入了数据，就需要把生成这些数据的事务对应的GTID集合也设置进来。

正常的操作是主备都要做这2步的，如果我们只在主库上做了这2步，备库什么也不做，然后就直接用 GTID 协议把备库连上来，按照我们的预期这个时候是应该出错的，主备不一致，并且主库的binlog中没东西，应该报之前停止条件2报的错。但是令人大跌眼镜的是主库不报错，复制看起来是完全正常的。

为啥会这样呢，SET GLOBAL GTID\_PURGED 操作会调用 MySQL\_bin\_log.rotate\_and\_purge切换到一个新的binlog，并把这个GTID\_PURGED                集合记入新生成的binlog的Previous\_gtids\_log\_event，假设原有的binlog为A，新生成的为B，主库刚启动，所以A就是主库的第一个binlog，它之前啥也没有，A的Previous\_gtids\_log\_event就是空集，并且A中也不包含任何GTID事件，否则SET                GLOBAL GTID\_PURGED是做不了的。按照之前的扫描逻辑，扫到A是肯定会停下来的，并且不报错。

**bug 修复**            

官方的修复就是在主库扫描查找binlog之前，判断一下 gtid\_purged 集合不是不比slave\_gtid\_executed大，如果是就报错，错误信息和条件2一样                Got fatal error 1236 from master when reading data from binary log: 'The                slave is connecting using CHANGE MASTER TO MASTER\_AUTO\_POSITION = 1, but                the master has purged binary logs containing GTIDs that the slave requires。

---

## MySQL · 捉虫动态· replicate filter 和 GTID 一起使用的问题

**问题描述**            

当单个 MySQL 实例的数据增长到很多的时候，就会考虑通过库或者表级别的拆分，把当前实例的数据分散到多个实例上去，假设原实例为A，想把其中的5个库（db1/db2/db3/db4/db5）拆分到5个实例（B1/B2/B3/B4/B5）上去。

拆分过程一般会这样做，先把A的相应库的数据导出，然后导入到对应的B实例上，但是在这个导出导入过程中，A库的数据还是在持续更新的，所以还需在导入完后，在所有的B实例和A实例间建立复制关系，拉取缺失的数据，在业务不繁忙的时候将业务切换到各个B实例。

在复制搭建时，每个B实例只需要复制A实例上的一个库，所以只需要重放对应库的binlog即可，这个通过 replicate-do-db 来设置过滤条件。如果我们用备库上执行                show slave status\\G 会看到Executed\_Gtid\_Set是断断续续的，间断非常多，导致这一列很长很长，看到的直接效果就是被刷屏了。

为啥会这样呢，因为设了replicate-do-db，就只会执行对应db对应的event，其它db的都不执行。主库的执行是不分db的，对各个db的操作互相间隔，记录在binlog中，所以备库做了过滤后，就出现这种断断的现象。

除了这个看着不舒服外，还会导致其它问题么？

假设我们拿B1实例的备份做了一个新实例，然后接到A上，如果主库A又定期purge了老的binlog，那么新实例的IO线程就会出错，因为需要的binlog在主库上找不到了；即使主库没有purge                老的binlog，新实例还要把主库的binlog都从头重新拉过来，然后执行的时候又都过滤掉，不如不拉取。

有没有好的办法解决这个问题呢？SQL线程在执行的时候，发现是该被过滤掉的event，在不执行的同时，记一个空事务就好了，把原事务对应的GTID位置占住，记入binlog，这样备库的Executed\_Gtid\_Set就是连续的了。

**bug 修复**            

对这个问题，官方有一个相应的bugfix，参见 revno:                  5860 ，有了这个patch后，备库B1的 SQL 线程在遇到和 db2-db5 相关的SQL语句时，在binlog中把对应的GTID记下，同时对应记一个空事务。

这个 patch 只是针对Query\_log\_event，即 statement 格式的 binlog event，那么row格式的呢？ row格式原来就已经是这种行为，通过check\_table\_map                函数来过滤库或者表，然后生成一个空事务。

另外这个patch还专门处理了下 CREATE/DROP TEMPORARY TABLE 这2种语句，我们知道row格式下，对临时表的操作是不会记入binlog的。如果主库的binlog格式是                statement，备库用的是 row，CREATE/DROP TEMPORARY TABLE 对应的事务传到备库后，就会消失掉，Executed\_Gtid\_Set集合看起来是不连续的，但是主库的binlog记的gtid是连续的，这个                patch 让这种情况下的CREATE/DROP TEMPORARY TABLE在备库同样记为一个空事务。

---

## TokuDB·特性分析· Optimize Table

来自一个TokuDB用户的“投诉”:

https://mariadb.atlassian.net/browse/MDEV-6207            

现象大概是:

用户有一个MyISAM的表test\_table:



 CREATE TABLE IF NOT EXISTS \`test\_table\` (
   \`id\` int(10) unsigned NOT NULL,
   \`pub\_key\` varchar(80) NOT NULL,
   PRIMARY KEY (\`id\`),
   KEY \`pub\_key\` (\`pub\_key\`)
 ) ENGINE=MyISAM DEFAULT CHARSET=latin1;



转成TokuDB引擎后表大小为92M左右:



 47M     \_tester\_testdb\_sql\_61e7\_1812\_main\_ad88a6b\_1\_19\_B\_0.tokudb
 45M     \_tester\_testdb\_sql\_61e7\_1812\_key\_pub\_key\_ad88a6b\_1\_19\_B\_1.tokudb



执行"OPTIMIZE TABLE test\_table":



 63M     \_tester\_testdb\_sql\_61e7\_1812\_main\_ad88a6b\_1\_19\_B\_0.tokudb
 61M     \_tester\_testdb\_sql\_61e7\_1812\_key\_pub\_key\_ad88a6b\_1\_19\_B\_1.tokudb



再次执行"OPTIMIZE TABLE test\_table":



 79M     \_tester\_testdb\_sql\_61e7\_1812\_main\_ad88a6b\_1\_19\_B\_0.tokudb
 61M     \_tester\_testdb\_sql\_61e7\_1812\_key\_pub\_key\_ad88a6b\_1\_19\_B\_1.tokudb



继续执行:



 79M     \_tester\_testdb\_sql\_61e7\_1812\_main\_ad88a6b\_1\_19\_B\_0.tokudb
 61M     \_tester\_testdb\_sql\_61e7\_1812\_key\_pub\_key\_ad88a6b\_1\_19\_B\_1.tokudb



基本稳定在这个大小。

主索引从47M-->63M-->79M，执行"OPTIMIZE TABLE"后为什么会越来越大？

这得从TokuDB的索引文件分配方式说起，当内存中的脏页需要写到磁盘时，TokuDB优先在文件末尾分配空间并写入，而不是“覆写”原块，原来的块暂时成了“碎片”。

这样问题就来了，索引文件岂不是越来越大？No, TokuDB会把这些“碎片”在checkpoint时加入到回收列表，以供后面的写操作使用，看似79M的文件其实还可以装不少数据呢！

嗯，这个现象解释通了，但还有2个问题:

> 1. 在执行这个语句的时候，TokuDB到底在做什么呢？                         在做toku\_ft\_flush\_some\_child，把内节点的缓冲区(message buffer)数据刷到最底层的叶节点。
> 	
> 2. 在TokuDB里，OPTIMIZE TABLE有用吗？                         作用非常小，不建议使用，TokuDB是一个"No Fragmentation"的引擎。
> 	

本文转载自MySQL.taobao.org ，感谢淘宝数据库项目组丁奇、鸣嵩、彭立勋、皓庭、项仲、剑川、武藏、祁奚、褚霸、一工。审校：刘亚琼



    Created at: 2019-10-22T20:36:04+08:00
    Updated at: 2019-10-22T20:36:04+08:00

