# InnoDB Adaptive hash index

<http://mysql.taobao.org/monthly/2015/09/01/>



* 功能：若用户的访问模式基本都是类似KV操作的点查询（point select），则InnoDB存储引擎会自动创建哈希索引。
* 好处：在有了哈希索引后，查询无需走B+树搜索，而直接通过hash就能直接定位查询的数据。
* 坏处：
	* 默认AHI参数的设置也是比较合理的，例如参数 innodb\_adaptive\_hash\_index\_parts 设置为 8 ；
	* 问题一
		* 当删除大表，且缓冲池（Buffer Pool，下简称BP）比较大，如超过32G，则MySQL数据库可能会有短暂被hang住的情况发生。
		* 产生这个问题的原因是在删除表的时候，InnoDB存储引擎会将该表在BP中的内存都淘汰掉，释放可用空间。包括数据页、索引页、自适应哈希页等
		* 当BP比较大时，扫描BP中flush\_list链表需要比较长的时间，因此会产生系统的抖动。
		* MySQL 8.0.23 版本已修复上述问题。
	* 问题二
		* 存在严重的锁冲突
	* 问题三
		* 过度内存使用的问题





    Created at: 2023-02-07T10:21:38+08:00
    Updated at: 2023-02-07T11:49:12+08:00

