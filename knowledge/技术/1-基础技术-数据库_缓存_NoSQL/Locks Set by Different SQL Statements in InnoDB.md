# Locks Set by Different SQL Statements in InnoDB

A [locking read](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_locking_read), an [UPDATE](https://dev.mysql.com/doc/refman/5.7/en/update.html), or a [DELETE](https://dev.mysql.com/doc/refman/5.7/en/delete.html) generally set record locks on every index record that is scanned in the processing of the SQL statement. It does not matter whether there are WHERE conditions in the statement that would exclude the row. InnoDB does not remember the exact WHERE condition, but only knows which index ranges were scanned. The locks are normally [next-key locks](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_next_key_lock) that also block inserts into the “gap” immediately before the record. However, [gap locking](https://dev.mysql.com/doc/refman/5.7/en/glossary.html#glos_gap_lock) can be disabled explicitly, which causes next-key locking not to be used. For more information, see [Section 14.7.1, “InnoDB Locking”](https://dev.mysql.com/doc/refman/5.7/en/innodb-locking.html). The transaction isolation level also can affect which locks are set; see [Section 14.7.2.1, “Transaction Isolation Levels”](https://dev.mysql.com/doc/refman/5.7/en/innodb-transaction-isolation-levels.html).
翻译：锁定读、更新或删除通常对SQL语句处理过程中扫描的每个索引记录设置记录锁_（next-key锁）_。语句中是否有排除该行的条件并不重要。InnoDB不记得确切的位置条件，但只知道哪个索引范围被扫描。这些锁通常是next-key锁，它们也会阻塞插入到记录之前的“间隙”中。但是，可以显式禁用间隙锁定，这将导致不使用next-key锁定。更多信息，见14.7.1节“InnoDB锁”。事务隔离级别也会影响设置的锁;见14.7.2.1节“事务隔离级别”。

If a secondary index is used in a search and index record locks to be set are exclusive, InnoDB also retrieves the corresponding clustered index records and sets locks on them.
翻译：如果在搜索中使用了一个二级索引，并且要设置的索引记录锁是排他的，InnoDB也会检索相应的聚集索引记录并对它们设置锁。

If you have no indexes suitable for your statement and MySQL must scan the entire table to process the statement, every row of the table becomes locked, which in turn blocks all inserts by other users to the table. It is important to create good indexes so that your queries do not unnecessarily scan many rows.
翻译：如果没有适合语句的索引，MySQL必须扫描整个表来处理语句，那么表的每一行都会被锁定，从而阻塞其他用户对表的所有插入。创建良好的索引很重要，这样您的查询就不会扫描很多行。

InnoDB sets specific types of locks as follows.
翻译：InnoDB设置的锁类型如下：

[SELECT ... FROM](https://dev.mysql.com/doc/refman/5.7/en/select.html) is a consistent read, reading a snapshot of the database and setting no locks unless the transaction isolation level is set to [SERIALIZABLE](https://dev.mysql.com/doc/refman/5.7/en/innodb-transaction-isolation-levels.html#isolevel_serializable). For [SERIALIZABLE](https://dev.mysql.com/doc/refman/5.7/en/innodb-transaction-isolation-levels.html#isolevel_serializable) level, the search sets shared next-key locks on the index records it encounters. However, only an index record lock is required for statements that lock rows using a unique index to search for a unique row.
翻译：[SELECT ... FROM](https://dev.mysql.com/doc/refman/5.7/en/select.html)是一致读取，读取数据库的快照并且不设置锁，除非事务隔离级别设置为SERIALIZABLE。对于SERIALIZABLE事务隔离级别，搜索在遇到的索引记录上设置共享的next-key锁。但是，对于使用惟一索引来搜索惟一行来锁定行的语句，只需要一个索引记录锁。

For [SELECT ... FOR UPDATE](https://dev.mysql.com/doc/refman/5.7/en/select.html) or [SELECT ... LOCK IN SHARE MODE](https://dev.mysql.com/doc/refman/5.7/en/select.html), locks are acquired for scanned rows, and expected to be released for rows that do not qualify for inclusion in the result set (for example, if they do not meet the criteria given in the WHERE clause). However, in some cases, rows might not be unlocked immediately because the relationship between a result row and its original source is lost during query execution. For example, in a [UNION](https://dev.mysql.com/doc/refman/5.7/en/union.html), scanned (and locked) rows from a table might be inserted into a temporary table before evaluation whether they qualify for the result set. In this circumstance, the relationship of the rows in the temporary table to the rows in the original table is lost and the latter rows are not unlocked until the end of query execution.
翻译：[SELECT ... FOR UPDATE](https://dev.mysql.com/doc/refman/5.7/en/select.html)或[SELECT ... LOCK IN SHARE MODE](https://dev.mysql.com/doc/refman/5.7/en/select.html)下，对被扫描的_索引_行获取锁_（next-key锁）_，对不符合结果集中包含条件的行释放锁(例如，如果它们不满足WHERE子句中给出的条件)。但是，在某些情况下，可能不会立即解锁行，因为在查询执行期间，结果行与其原始数据源之间的关系丢失了。例如,在一个[UNION](https://dev.mysql.com/doc/refman/5.7/en/union.html)中,从表扫描(加锁)的行可能会插入到临时表之前评估他们是否有资格获得结果集。在这种情况下,临时表中的行之间的关系中的行原始表丢失,后者直到查询执行的结束才能解锁。

[SELECT ... LOCK IN SHARE MODE](https://dev.mysql.com/doc/refman/5.7/en/select.html) sets shared next-key locks on all index records the search encounters. However, only an index record lock is required for statements that lock rows using a unique index to search for a unique row.
翻译： [SELECT ... LOCK IN SHARE MODE](https://dev.mysql.com/doc/refman/5.7/en/select.html)锁定搜索遇到的所有索引记录上的共享的next-key锁定。但是，对于使用惟一索引来搜索惟一行来锁定行的语句，只需要一个索引记录锁。

[SELECT ... FOR UPDATE](https://dev.mysql.com/doc/refman/5.7/en/select.html) sets an exclusive next-key lock on every record the search encounters. However, only an index record lock is required for statements that lock rows using a unique index to search for a unique row.
翻译：[SELECT ... FOR UPDATE](https://dev.mysql.com/doc/refman/5.7/en/select.html)，在搜索遇到的每个记录上设置一个独占的next-key锁。但是，对于使用惟一索引来搜索惟一行来锁定行的语句，只需要一个索引记录锁。

For index records the search encounters, [SELECT ... FOR UPDATE](https://dev.mysql.com/doc/refman/5.7/en/select.html) blocks other sessions from doing [SELECT ... LOCK IN SHARE MODE](https://dev.mysql.com/doc/refman/5.7/en/select.html) or from reading in certain transaction isolation levels. Consistent reads ignore any locks set on the records that exist in the read view.
翻译：对于搜索遭遇的索引记录，[SELECT ... FOR UPDATE](https://dev.mysql.com/doc/refman/5.7/en/select.html)阻止其他会话做[SELECT ... LOCK IN SHARE MODE](https://dev.mysql.com/doc/refman/5.7/en/select.html)或在某些事务隔离级别的读取。一致性读取忽略在read视图中存在的记录上设置的任何锁。

[UPDATE ... WHERE ...](https://dev.mysql.com/doc/refman/5.7/en/update.html) sets an exclusive next-key lock on every record the search encounters. However, only an index record lock is required for statements that lock rows using a unique index to search for a unique row.
翻译：[UPDATE ... WHERE ...](https://dev.mysql.com/doc/refman/5.7/en/update.html) 在搜索遇到的每个记录上设置独占的next-key锁。但是，对于使用惟一索引来搜索惟一行来锁定行的语句，只需要一个索引记录锁。

When [UPDATE](https://dev.mysql.com/doc/refman/5.7/en/update.html) modifies a clustered index record, implicit locks are taken on affected secondary index records. The [UPDATE](https://dev.mysql.com/doc/refman/5.7/en/update.html) operation also takes shared locks on affected secondary index records when performing duplicate check scans prior to inserting new secondary index records, and when inserting new secondary index records.
翻译：当UPDATE修改聚集索引记录时，会对受影响的二级索引记录执行隐式锁。在插入新的二级索引记录之前和插入新的二级索引记录之前执行重复的检查扫描时，更新操作还对受影响的二级索引记录使用共享锁。

[DELETE FROM ... WHERE ...](https://dev.mysql.com/doc/refman/5.7/en/delete.html) sets an exclusive next-key lock on every record the search encounters. However, only an index record lock is required for statements that lock rows using a unique index to search for a unique row.
翻译：[DELETE FROM ... WHERE ...](https://dev.mysql.com/doc/refman/5.7/en/delete.html)在搜索遇到的每个记录上设置独占的next-key锁。但是，对于使用惟一索引来搜索惟一行来锁定行的语句，只需要一个索引记录锁。

[INSERT](https://dev.mysql.com/doc/refman/5.7/en/insert.html) sets an exclusive lock on the inserted row. This lock is an index-record lock, not a next-key lock (that is, there is no gap lock) and does not prevent other sessions from inserting into the gap before the inserted row.
翻译：插入对插入的行设置排他锁。这个锁是索引-记录锁，而不是next-key锁(也就是说，没有间隙锁)，并且不阻止其他会话在插入的行之前插入间隙。

Prior to inserting the row, a type of gap lock called an insert intention gap lock is set. This lock signals the intent to insert in such a way that multiple transactions inserting into the same index gap need not wait for each other if they are not inserting at the same position within the gap. Suppose that there are index records with values of 4 and 7. Separate transactions that attempt to insert values of 5 and 6 each lock the gap between 4 and 7 with insert intention locks prior to obtaining the exclusive lock on the inserted row, but do not block each other because the rows are nonconflicting.
翻译：插入一行之前,一种间隙锁叫做插入意向锁的锁被设置。这把锁以这种方式标志这插入的意向：如果多个事务插入到相同的索引间隙的不同的位置时不需要相互等待。假设有值为4和7的索引记录。尝试插入值为5和6的独立事务，在获得插入行的排他锁之前，使用插入意图锁锁定4和7之间的间隙，但不会相互阻塞，因为行不冲突。

If a duplicate-key error occurs, a shared lock on the duplicate index record is set. This use of a shared lock can result in deadlock should there be multiple sessions trying to insert the same row if another session already has an exclusive lock. This can occur if another session deletes the row. Suppose that an InnoDB table t1 has the following structure:
翻译：如果出现重复键错误，则在重复索引记录上设置共享锁。如果有多个会话试图插入同一行，而另一个会话已经有排他锁，那么使用共享锁会导致死锁。如果另一个会话删除了该行，就会发生这种情况。假设InnoDB表t1的结构如下:
CREATE TABLE t1 (i INT, PRIMARY KEY (i)) ENGINE \= InnoDB;
Now suppose that three sessions perform the following operations in order:
翻译：现在假设有三个会话按顺序执行以下操作:
Session 1:

START TRANSACTION;
INSERT INTO t1 VALUES(1);

Session 2:

START TRANSACTION;
INSERT INTO t1 VALUES(1);

Session 3:

START TRANSACTION;
INSERT INTO t1 VALUES(1);

Session 1:
ROLLBACK;
The first operation by session 1 acquires an exclusive lock for the row. The operations by sessions 2 and 3 both result in a duplicate-key error and they both request a shared lock for the row. When session 1 rolls back, it releases its exclusive lock on the row and the queued shared lock requests for sessions 2 and 3 are granted. At this point, sessions 2 and 3 deadlock: Neither can acquire an exclusive lock for the row because of the shared lock held by the other.
翻译：会话1的第一个操作为该行获取排他锁。会话2和会话3的操作都会导致重复键错误，并且它们都请求该行的共享锁。当会话1回滚时，它释放该行上的独占锁，并授予会话2和3的排队共享锁请求。此时，会话2和3死锁:由于另一方持有共享锁，这两个会话都不能获得该行的排他锁。

A similar situation occurs if the table already contains a row with key value 1 and three sessions perform the following operations in order:
翻译：如果表中已经包含键值为1的行，并且三个会话按顺序执行以下操作，则会出现类似的情况:
Session 1:

START TRANSACTION;
DELETE FROM t1 WHERE i \= 1;

Session 2:

START TRANSACTION;
INSERT INTO t1 VALUES(1);

Session 3:

START TRANSACTION;
INSERT INTO t1 VALUES(1);

Session 1:
COMMIT;
The first operation by session 1 acquires an exclusive lock for the row. The operations by sessions 2 and 3 both result in a duplicate-key error and they both request a shared lock for the row. When session 1 commits, it releases its exclusive lock on the row and the queued shared lock requests for sessions 2 and 3 are granted. At this point, sessions 2 and 3 deadlock: Neither can acquire an exclusive lock for the row because of the shared lock held by the other.
翻译：会话1的第一个操作为该行获取排他锁。会话2和会话3的操作都会导致重复键错误，并且它们都请求该行的共享锁。当会话1提交时，它释放该行上的独占锁，并授予会话2和3的排队共享锁请求。此时，会话2和3死锁:由于另一方持有共享锁，这两个会话都不能获得该行的排他锁。

[INSERT ... ON DUPLICATE KEY UPDATE](https://dev.mysql.com/doc/refman/5.7/en/insert-on-duplicate.html) differs from a simple [INSERT](https://dev.mysql.com/doc/refman/5.7/en/insert.html) in that an exclusive lock rather than a shared lock is placed on the row to be updated when a duplicate-key error occurs. An exclusive index-record lock is taken for a duplicate primary key value. An exclusive next-key lock is taken for a duplicate unique key value.
翻译：[INSERT ... ON DUPLICATE KEY UPDATE](https://dev.mysql.com/doc/refman/5.7/en/insert-on-duplicate.html) 与简单插入的不同之处在于，当发生重复键错误时，将在要更新的行上放置排他锁而不是共享锁。对重复的主键值采取独占索引记录锁。对重复的唯一键值使用独占的next-key锁。

[REPLACE](https://dev.mysql.com/doc/refman/5.7/en/replace.html) is done like an [INSERT](https://dev.mysql.com/doc/refman/5.7/en/insert.html) if there is no collision on a unique key. Otherwise, an exclusive next-key lock is placed on the row to be replaced.
翻译：如果唯一键上没有冲突，替换就像插入一样完成。否则，将在要替换的行上放置一个独占的next-key锁。

INSERT INTO T SELECT ... FROM S WHERE ... sets an exclusive index record lock (without a gap lock) on each row inserted into T. If the transaction isolation level is [READ COMMITTED](https://dev.mysql.com/doc/refman/5.7/en/innodb-transaction-isolation-levels.html#isolevel_read-committed), or [innodb_locks_unsafe_for_binlog](https://dev.mysql.com/doc/refman/5.7/en/innodb-parameters.html#sysvar_innodb_locks_unsafe_for_binlog) is enabled and the transaction isolation level is not [SERIALIZABLE](https://dev.mysql.com/doc/refman/5.7/en/innodb-transaction-isolation-levels.html#isolevel_serializable), InnoDB does the search on S as a consistent read (no locks). Otherwise, InnoDB sets shared next-key locks on rows from S. InnoDB has to set locks in the latter case: During roll-forward recovery using a statement-based binary log, every SQL statement must be executed in exactly the same way it was done originally.
翻译：INSERT INTO T SELECT ... FROM S WHERE ... 在T表上已被插入的每一条记录上设置一个排他的索引记录锁（没有间隙锁） .如果事务隔离级别读已提交,或启用innodb\_locks\_unsafe\_for\_binlog同时事务隔离级别不是序列化,InnoDB在S上执行一个一致读(无锁)的搜索。否则，InnoDB在S的所有行上设置共享的next-key锁。InnoDB在后面这种情况下必须设置锁：在使用statement-based的二进制日志回滚恢复期间，每条SQL语句都必须按照与最初完全相同的方式执行。

[CREATE TABLE ... SELECT ...](https://dev.mysql.com/doc/refman/5.7/en/create-table.html) performs the [SELECT](https://dev.mysql.com/doc/refman/5.7/en/select.html) with shared next-key locks or as a consistent read, as for [INSERT ... SELECT](https://dev.mysql.com/doc/refman/5.7/en/insert-select.html).
翻译：[CREATE TABLE ... SELECT ...](https://dev.mysql.com/doc/refman/5.7/en/create-table.html) 使用共享的next-key锁或作为一致的读取来执行SELECT，例如[INSERT ... SELECT](https://dev.mysql.com/doc/refman/5.7/en/insert-select.html)。

When a SELECT is used in the constructs REPLACE INTO t SELECT ... FROM s WHERE ... or UPDATE t ... WHERE col IN (SELECT ... FROM s ...), InnoDB sets shared next-key locks on rows from table s.
翻译：当在使用SELECT构造REPLACE INTO t SELECT ... FROM s WHERE ... or UPDATE t ... WHERE col IN (SELECT ... FROM s ...)时，InnoDB在表s中的行上设置了共享的next-key锁。

参考mysql官方文档链接：
<https://dev.mysql.com/doc/refman/5.7/en/innodb-locks-set.html>



    Created at: 2024-03-11T17:23:14+08:00
    Updated at: 2024-03-11T17:23:25+08:00

