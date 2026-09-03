# MDL锁


\* MDL\_INTENTION\_EXCLUSIVE IX // 意向X锁，只用于scope 锁

\* MDL\_SHARED S // 只能读metadata，当能读写数据，如检查表是否存在时用这个锁

\* MDL\_SHARED\_HIGH\_PRIO SH // 高优先级S锁，可以抢占X锁，只能读metadata，不能读写数据，用于填充INFORMATION\_SCHEMA，或者show create table时

\* MDL\_SHARED\_READ SR // 可以读表数据，select语句，lock table xxx read 都用这个

\* MDL\_SHARED\_WRITE SW // 可以更新表数据，insert，update，delete，lock table xxx write, select for update，

\* MDL\_SHARED\_UPGRADABLE SU // 可升级锁，可以升级为SNW或者X锁，ALTER TABLE第一阶段会用到

\* MDL\_SHARED\_NO\_WRITE SNW // 可升级锁，其它线程能读metadata，数据可读不能读，持锁者可以读写，可以升级成X锁，ALTER TABLE的第一阶段

\* MDL\_SHARED\_NO\_READ\_WRITE SNRW // 可升级锁，其它线程能读metadata，数据不能读写，持锁者可以读写，可以升级成X锁，LOCK TABLES xxx WRITE

\* MDL\_EXCLUSIVE X // 排它锁，禁止其它线程的所有请求，CREATE/DROP/RENAME TABLE



    Created at: 2019-11-06T20:27:24+08:00
    Updated at: 2019-11-06T20:27:39+08:00

