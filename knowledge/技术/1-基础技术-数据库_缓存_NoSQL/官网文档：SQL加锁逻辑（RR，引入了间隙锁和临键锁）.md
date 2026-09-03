# 官网文档：SQL加锁逻辑（RR，引入了间隙锁和临键锁）


<https://dev.mysql.com/doc/refman/5.7/en/innodb-locks-set.html>

 锁定[读取](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_locking_read)、锁定 [UPDATE](https://dev.mysql.com/doc/refman/5.7/en/update.html)或 [DELETE](https://dev.mysql.com/doc/refman/5.7/en/delete.html)通常设置的记录锁定在 SQL 语句处理过程中扫描的每个索引记录上。WHERE语句中是否存在排除该行的条件并不重要 。InnoDB不记得确切的WHERE条件，但只知道扫描了哪些索引范围。这些锁通常是 [下一个键锁](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_next_key_lock)，它们也会阻止插入到紧邻记录之前的“间隙”中。但是，可以显式禁用[间隙锁定](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_gap_lock) ，这会导致不使用下一键锁定。有关更多信息，请参见 [第 14.7.1 节 “InnoDB 锁定”](https://dev.mysql.com/doc/refman/5.7/en/innodb-locking.html)。事务隔离级别也会影响设置哪些锁；请参见 [第 14.7.2.1 节“事务隔离级别”](https://dev.mysql.com/doc/refman/5.7/en/innodb-transaction-isolation-levels.html)。
如果在搜索中使用二级索引并且要设置的索引记录锁是独占的，InnoDB则还会检索相应的聚集索引记录并对其设置锁。
如果没有适合您的语句的索引，并且 MySQL 必须扫描整个表来处理该语句，则表的每一行都会被锁定，从而阻止其他用户对该表的所有插入。创建良好的索引非常重要，这样您的查询就不会扫描不必要的行。
InnoDB设置特定类型的锁如下。

* [SELECT ... FROM](https://dev.mysql.com/doc/refman/5.7/en/select.html)是一致性读，读取数据库的快照并且不设置锁，除非将事务隔离级别设置为 [SERIALIZABLE](https://dev.mysql.com/doc/refman/5.7/en/innodb-transaction-isolation-levels.html#isolevel_serializable)。对于 [SERIALIZABLE](https://dev.mysql.com/doc/refman/5.7/en/innodb-transaction-isolation-levels.html#isolevel_serializable)级别，搜索在遇到的索引记录上设置共享的下一键锁。但是，对于使用唯一索引锁定行来搜索唯一行的语句，只需要索引记录锁。
* 对于[SELECT ... FOR UPDATE](https://dev.mysql.com/doc/refman/5.7/en/select.html)或 [SELECT ... LOCK IN SHARE MODE](https://dev.mysql.com/doc/refman/5.7/en/select.html)，会为扫描的行获取锁，并且预计会为不符合包含在结果集中的行释放锁（例如，如果它们不满足子句中给出的条件WHERE）。但是，在某些情况下，行可能不会立即解锁，因为结果行与其原始源之间的关系在查询执行期间丢失。例如，在 a 中 [UNION](https://dev.mysql.com/doc/refman/5.7/en/union.html)，表中扫描（并锁定）的行可能会先插入到临时表中，然后再评估它们是否符合结果集的条件。在这种情况下，临时表中的行与原始表中的行的关系将丢失，并且原始表中的行直到查询执行结束才解锁。
* [SELECT ... LOCK IN SHARE MODE](https://dev.mysql.com/doc/refman/5.7/en/select.html)对搜索遇到的所有索引记录设置共享的下一键锁。但是，对于使用唯一索引锁定行来搜索唯一行的语句，只需要索引记录锁。
* [SELECT ... FOR UPDATE](https://dev.mysql.com/doc/refman/5.7/en/select.html)对搜索遇到的每个记录设置独占的下一键锁定。但是，对于使用唯一索引锁定行来搜索唯一行的语句，只需要索引记录锁。
	对于搜索遇到的索引记录， [SELECT ... FOR UPDATE](https://dev.mysql.com/doc/refman/5.7/en/select.html)会阻止其他会话在某些事务隔离级别中执行 [SELECT ... LOCK IN SHARE MODE](https://dev.mysql.com/doc/refman/5.7/en/select.html)或读取操作。一致读取会忽略对读取视图中存在的记录设置的任何锁定。
	
* [UPDATE ... WHERE ...](https://dev.mysql.com/doc/refman/5.7/en/update.html)对搜索遇到的每个记录设置独占的下一键锁定。但是，对于使用唯一索引锁定行来搜索唯一行的语句，只需要索引记录锁。
* 当[UPDATE](https://dev.mysql.com/doc/refman/5.7/en/update.html)修改聚集索引记录时，将对受影响的辅助索引记录进行隐式锁定。[UPDATE](https://dev.mysql.com/doc/refman/5.7/en/update.html)在插入新的二级索引记录之前执行重复检查扫描时，以及插入新的二级索引记录时， 该 操作还会对受影响的二级索引记录获取共享锁。
* [DELETE FROM ... WHERE ...](https://dev.mysql.com/doc/refman/5.7/en/delete.html)对搜索遇到的每个记录设置独占的下一键锁定。但是，对于使用唯一索引锁定行来搜索唯一行的语句，只需要索引记录锁。
* [INSERT](https://dev.mysql.com/doc/refman/5.7/en/insert.html)在插入的行上设置排它锁。该锁是索引记录锁，而不是下一个键锁（即没有间隙锁），并且不会阻止其他会话插入到插入行之前的间隙中。
	在插入行之前，会设置一种称为插入意向间隙锁的间隙锁。此锁表明插入的意图是，插入同一索引间隙的多个事务如果没有插入间隙内的同一位置，则无需互相等待。假设存在值为 4 和 7 的索引记录。尝试插入值 5 和 6 的单独事务在获得插入行上的排他锁之前，每个事务都使用插入意向锁锁定 4 和 7 之间的间隙，但不这样做相互阻塞，因为行不冲突。
	如果发生重复键错误，则会在重复索引记录上设置共享锁。如果另一个会话已经拥有排它锁，则如果多个会话尝试插入同一行，则使用共享锁可能会导致死锁。如果另一个会话删除该行，则可能会发生这种情况。假设一个InnoDB表 t1具有以下结构：
	
	CREATE TABLE t1 (i INT, PRIMARY KEY (i)) ENGINE \= InnoDB;
	
	现在假设三个会话按顺序执行以下操作：
	第一节：
	
	START TRANSACTION;
	INSERT INTO t1 VALUES(1);
	
	第二节：
	
	START TRANSACTION;
	INSERT INTO t1 VALUES(1);
	
	第三节：
	
	START TRANSACTION;
	INSERT INTO t1 VALUES(1);
	
	第一节：
	
	ROLLBACK;
	
	会话 1 的第一个操作获取该行的排他锁。会话 2 和 3 的操作都会导致重复键错误，并且它们都请求该行的共享锁。当会话 1 回滚时，它会释放其对该行的独占锁，并且会话 2 和 3 的排队共享锁请求将被授予。此时，会话 2 和会话 3 发生死锁：由于对方持有共享锁，双方都无法获取该行的排他锁。
	如果表已包含键值为 1 的行并且三个会话按顺序执行以下操作，则会出现类似的情况：
	第一节：
	
	START TRANSACTION;
	DELETE FROM t1 WHERE i \= 1;
	
	第二节：
	
	START TRANSACTION;
	INSERT INTO t1 VALUES(1);
	
	第三节：
	
	START TRANSACTION;
	INSERT INTO t1 VALUES(1);
	
	第一节：
	
	COMMIT;
	
	会话 1 的第一个操作获取该行的排他锁。会话 2 和 3 的操作都会导致重复键错误，并且它们都请求该行的共享锁。当会话 1 提交时，它会释放其对该行的独占锁，并且会话 2 和 3 的排队共享锁请求将被授予。此时，会话 2 和会话 3 发生死锁：由于对方持有共享锁，双方都无法获取该行的排他锁。
	
* [INSERT ... ON DUPLICATE KEY UPDATE](https://dev.mysql.com/doc/refman/5.7/en/insert-on-duplicate.html)与简单的不同之处 [INSERT](https://dev.mysql.com/doc/refman/5.7/en/insert.html)在于，当发生重复键错误时，将在要更新的行上放置排他锁而不是共享锁。对重复的主键值采用独占索引记录锁定。对重复的唯一键值采取独占的下一键锁定。
* [REPLACE](https://dev.mysql.com/doc/refman/5.7/en/replace.html)[INSERT](https://dev.mysql.com/doc/refman/5.7/en/insert.html)如果唯一键上没有冲突，则完成类似的操作 。否则，将在要替换的行上放置独占的下一键锁。
* INSERT INTO T SELECT ... FROM S WHERE ... 在插入的每一行上设置独占索引记录锁（没有间隙锁）T。如果事务隔离级别为[READ COMMITTED](https://dev.mysql.com/doc/refman/5.7/en/innodb-transaction-isolation-levels.html#isolevel_read-committed)或 [innodb_locks_unsafe_for_binlog](https://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html#sysvar_innodb_locks_unsafe_for_binlog) 已启用，并且事务隔离级别不是 [SERIALIZABLE](https://dev.mysql.com/doc/refman/5.7/en/innodb-transaction-isolation-levels.html#isolevel_serializable)， InnoDB则将搜索 S作为一致性读取（无锁）。否则，InnoDB在 中的行上设置共享下一键锁S。 InnoDB在后一种情况下必须设置锁：在使用基于语句的二进制日志进行前滚恢复期间，每个 SQL 语句必须以与最初执行的方式完全相同的方式执行。
	[CREATE TABLE ... SELECT ...](https://dev.mysql.com/doc/refman/5.7/en/create-table.html)使用共享的下一键锁或作为一致读取来执行 [SELECT](https://dev.mysql.com/doc/refman/5.7/en/select.html)，如 [INSERT ... SELECT](https://dev.mysql.com/doc/refman/5.7/en/insert-select.html).
	当 aSELECT用于构造 REPLACE INTO t SELECT ... FROM s WHERE ... 或时UPDATE t ... WHERE col IN (SELECT ... FROM s ...)，InnoDB对表中的行设置共享下一键锁s。
	
* InnoDB在初始化表上 AUTO\_INCREMENT先前指定的列时，在与该列关联的索引末尾设置排它锁 。AUTO\_INCREMENT
	With [innodb_autoinc_lock_mode=0](https://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html#sysvar_innodb_autoinc_lock_mode)， InnoDB使用一种特殊的 AUTO-INC表锁模式，在访问自增计数器时，获取锁并保持到当前 SQL 语句的末尾（而不是整个事务的末尾）。当AUTO-INC持有表锁时，其他客户端无法向表中插入数据。 使用 的 “批量插入”也会发生相同的行为[innodb_autoinc_lock_mode=1](https://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html#sysvar_innodb_autoinc_lock_mode)。表级AUTO-INC锁不与 一起使用 [innodb_autoinc_lock_mode=2](https://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html#sysvar_innodb_autoinc_lock_mode)。有关更多信息，请参见 [第 14.6.1.6 节，“InnoDB 中的 AUTO_INCREMENT 处理”](https://dev.mysql.com/doc/refman/5.7/en/innodb-auto-increment-handling.html)。
	InnoDB获取先前初始化列的值AUTO\_INCREMENT而不设置任何锁。
	
* 如果FOREIGN KEY在表上定义了约束，则任何需要检查约束条件的插入、更新或删除都会在其查看以检查约束的记录上设置共享记录级锁。 InnoDB在约束失败的情况下也会设置这些锁。
* [LOCK TABLES](https://dev.mysql.com/doc/refman/5.7/en/lock-tables.html)InnoDB设置表锁，但设置这些锁的 是该层之上的更高 MySQL 层 。如果（默认） 和 ，则InnoDB知道表锁 ，并且上面的 MySQL 层知道行级锁。 innodb\_table\_locks = 1[autocommit = 0](https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_autocommit)InnoDB
	否则，InnoDB的自动死锁检测无法检测到涉及此类表锁的死锁。另外，因为在这种情况下，更高的 MySQL 层不知道行级锁，所以有可能在另一个会话当前具有行级锁的表上获取表锁。然而，这不会危及事务完整性，如 [第 14.7.5.2 节“死锁检测”](https://dev.mysql.com/doc/refman/5.7/en/innodb-deadlock-detection.html)中所述。
	
* [LOCK TABLES](https://dev.mysql.com/doc/refman/5.7/en/lock-tables.html)innodb\_table\_locks=1如果（默认）在每个表上获取两个锁。除了MySQL层的表锁外，还获取InnoDB表锁。为了避免获取InnoDB表锁，请设置 innodb\_table\_locks=0.如果没有 InnoDB获取表锁， [LOCK TABLES](https://dev.mysql.com/doc/refman/5.7/en/lock-tables.html)即使表的某些记录被其他事务锁定，也会完成。
	在 MySQL 5.7 中， [innodb_table_locks=0](https://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html#sysvar_innodb_table_locks)对于使用 显式锁定的表没有影响 [LOCK TABLES ... WRITE](https://dev.mysql.com/doc/refman/5.7/en/lock-tables.html)。它确实对通过[LOCK TABLES ... WRITE](https://dev.mysql.com/doc/refman/5.7/en/lock-tables.html)隐式（例如，通过触发器）或通过 锁定进行读或写的表有影响 [LOCK TABLES ... READ](https://dev.mysql.com/doc/refman/5.7/en/lock-tables.html)。
	
* InnoDB当事务提交或中止时，事务持有的 所有锁都会被释放。因此，在模式[LOCK TABLES](https://dev.mysql.com/doc/refman/5.7/en/lock-tables.html)下 调用InnoDB表 没有多大意义， [autocommit=1](https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_autocommit)因为获取的InnoDB表锁将立即释放。
* 您不能在事务中间锁定其他表，因为[LOCK TABLES](https://dev.mysql.com/doc/refman/5.7/en/lock-tables.html) 执行隐式[COMMIT](https://dev.mysql.com/doc/refman/5.7/en/commit.html)and [UNLOCK TABLES](https://dev.mysql.com/doc/refman/5.7/en/lock-tables.html)。



    Created at: 2024-03-11T19:55:43+08:00
    Updated at: 2024-03-12T09:25:39+08:00

