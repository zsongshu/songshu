# 数据库内核月报 － 2018 / 07 - MySQL · 源码分析 · binlog crash recovery

## **MySQL · 源码分析 · binlog crash recovery**

### **前言**

本文主要介绍binlog crash recovery 的过程
假设用户使用 InnoDB 引擎，sync\_binlog=1
使用 MySQL 5.7.20 版本进行分析
crash recovery 过程中，binlog 需要保证：

1. 所有已提交事务的binlog已存在
2. 所有未提交事务的binlog不存在

### **两阶段提交**

MySQL 使用两阶段提交解决 binlog 和 InnoDB redo log 的一致性的问题
也就是将普通事务当做内部XA事务处理，为每个事务分配一个XID，binlog作为事务的协调者

* 阶段1：InnoDB redo log 写盘，InnoDB 事务进入 prepare 状态
* 阶段2：binlog 写盘，InooDB 事务进入 commit 状态

每个事务binlog的末尾，会记录一个 XID event，标志着事务是否提交成功，也就是说，recovery 过程中，binlog 最后一个 XID event 之后的内容都应该被 purge。
InnoDB 日志可能也需要回滚或者提交，这里就不再展开。

### **binlog 文件的 crash recovery**

mysqld\_main

 init\_server\_components

 MYSQL\_BIN\_LOG::open

 MYSQL\_BIN\_LOG::open\_binlog

binlog recover 的主要过程在 MYSQL\_BIN\_LOG::open\_binlog 中

int MYSQL\_BIN\_LOG::open\_binlog(const char \*opt\_name)
{

 /\* 确保 index 文件初始化成功 \*/
 if (!my\_b\_inited(&index\_file)) 
 {
 /\* There was a failure to open the index file, can't open the binlog \*/
 cleanup();
 return 1;
 }

 /\* 找到 index 中第一个 binlog \*/
 if ((error= find\_log\_pos(&log\_info, NullS, true/\*need\_lock\_index=true\*/)))

 {
 /\* 找到 index 中最后一个 binlog \*/
 do
 {
 strmake(log\_name, log\_info.log\_file\_name, sizeof(log\_name)-1); 
 } while (!(error= find\_next\_log(&log\_info, true/\*need\_lock\_index=true\*/)));

 /\*
 打开最后一个binlog，会校验文件头的 magic number "\\xfe\\x62\\x69\\x6e"
 如果 magic number 校验失败，会直接报错退出，无法完成recovery
 如果确定最后一个binlog没有内容，可以删除binlog 文件再重试
 \*/
 if ((file= open\_binlog\_file(&log, log\_name, &errmsg)) < 0)

 /\*
 如果 binlog 没有正常关闭，mysql server 可能crash过，
 我们需要调用 MYSQL\_BIN\_LOG::recover：

 a) 找到最后一个 XID
 b) 完成最后一个事务的两阶段提交（InnoDB commit）
 c) 找到最后一个合法位点

 因此，我们需要遍历 binlog 文件，找到最后一个合法event集合，并 purge 无效binlog
 \*/
 if ((ev= Log\_event::read\_log\_event(&log, 0, &fdle,
 opt\_master\_verify\_checksum)) &&
 ev->get\_type\_code() == binary\_log::FORMAT\_DESCRIPTION\_EVENT &&
 (ev->common\_header->flags & LOG\_EVENT\_BINLOG\_IN\_USE\_F ||
 DBUG\_EVALUATE\_IF("eval\_force\_bin\_log\_recovery", true, false)))
 {
 sql\_print\_information("Recovering after a crash using %s", opt\_name); 

 /\* 初始化合法位点 \*/ 
 valid\_pos= my\_b\_tell(&log);

 /\* 执行recover 过程 ，并计算出合法位点 \*/
 error= recover(&log, (Format\_description\_log\_event \*)ev, &valid\_pos);
 }
 else
 error=0;

 if (valid\_pos > 0){
 if (valid\_pos < binlog\_size)
 {
 /\* 将 valid\_pos 后面的binlog purge掉 \*/
 if (my\_chsize(file, valid\_pos, 0, MYF(MY\_WME)))
 }
 }
 } 
}

recover 函数的逻辑很简单：遍历最后一个binlog的所有 event，每次事务结尾，或者非事务event结尾更新 valid\_pos(gtid event不更新)。并在一个 hash 中记录所有xid，用于引擎层 recover

int MYSQL\_BIN\_LOG::recover(IO\_CACHE \*log, Format\_description\_log\_event \*fdle,
 my\_off\_t \*valid\_pos)
{

 /\* 初始化 XID hash，用于记录 binlog 中的 xid \*/
 if (! fdle->is\_valid() || 
 my\_hash\_init(&xids, &my\_charset\_bin, TC\_LOG\_PAGE\_SIZE/3, 0,
 sizeof(my\_xid), 0, 0, MYF(0),
 key\_memory\_binlog\_recover\_exec))
 goto err1;

 /\* 依次读取 binlog event \*/
 while ((ev= Log\_event::read\_log\_event(log, 0, fdle, TRUE))
 && ev->is\_valid())
 {
 if (ev->get\_type\_code() == binary\_log::QUERY\_EVENT &&
 !strcmp(((Query\_log\_event\*)ev)->query, "BEGIN"))
 /\* begin 代表事务开始 \*/
 in\_transaction= TRUE;

 if (ev->get\_type\_code() == binary\_log::QUERY\_EVENT &&
 !strcmp(((Query\_log\_event\*)ev)->query, "COMMIT"))
 {
 DBUG\_ASSERT(in\_transaction == TRUE);
 /\* commit 代表事务结束 \*/
 in\_transaction= FALSE;
 }
 else if (ev->get\_type\_code() == binary\_log::XID\_EVENT)
 {
 DBUG\_ASSERT(in\_transaction == TRUE);
 /\* xid event 代表事务结束 \*/
 in\_transaction= FALSE;
 Xid\_log\_event \*xev=(Xid\_log\_event \*)ev;
 uchar \*x= (uchar \*) memdup\_root(&mem\_root, (uchar\*) &xev->xid,
 sizeof(xev->xid));
 /\* 记录 xid \*/
 if (!x || my\_hash\_insert(&xids, x))
 goto err2;
 }

 /\*
 如果不在事务中，且不是gtid event，则更新 valid\_pos
 显然，如果在事务中，最后一段 event 不是一个完整事务，pos并不合法
 \*/
 if (!log->error && !in\_transaction &&
 !is\_gtid\_event(ev))
 \*valid\_pos= my\_b\_tell(log);
 }

 /\*
 存储引擎recover
 所有已经记录 XID 的事务必须在存储引擎中提交
 未记录 XID 的事务必须回滚
 \*/
 if (total\_ha\_2pc > 1 && ha\_recover(&xids))
 goto err2;

### **binlog index 的 crash recovery**

为了保证 binlog index 的 crash safe，MySQL 引入了一个临时文件 crash\_safe\_index\_file
新的 binlog\_file\_name 写入 binlog\_index\_file 流程如下：

* 创建临时文件 crash\_safe\_index\_file
* 拷贝 binlog\_index\_file 中的内容到 crash\_safe\_index\_file
* 新的 binlog\_file\_name 写入 crash\_safe\_index\_file
* 删除 binlog\_index\_file
* 重命名 crash\_safe\_index\_file 到 binlog\_index\_file

这个流程保证了在任何时候crash，binlog\_index\_file 和 crash\_safe\_index\_file 至少有一个可用
这样再recover 时只要判断这两个文件是否可用，如果 binlog\_index\_file 可用则无需特殊处理，如果binlog\_index\_file 不可用则重命名 crash\_safe\_index\_file 到 binlog\_index\_file
binlog index 的 recover 过程主要在 bool MYSQL\_BIN\_LOG::open\_index\_file 中
显然，open\_indix\_file 在 open\_binlog 之前

mysqld\_main

 init\_server\_components

 MYSQL\_BIN\_LOG::open\_index\_file


bool MYSQL\_BIN\_LOG::open\_index\_file(const char \*index\_file\_name\_arg,
 const char \*log\_name, bool need\_lock\_index)
{
 /\* 拼接 index\_file\_name \*/
 fn\_format(index\_file\_name, index\_file\_name\_arg, mysql\_data\_home,
 ".index", opt);

 /\* 拼接 crash\_safe\_index\_file\_name \*/
 if (set\_crash\_safe\_index\_file\_name(index\_file\_name\_arg))

 /\*
 recover 主要体现在这里
 检查 index\_file\_name 和 crash\_safe\_index\_file\_name 是否存在
 如果 index\_file\_name 不存在 crash\_safe\_index\_file\_name 存在，
 那么将 crash\_safe\_index\_file\_name 重命名为 index\_file\_name
 \*/
 if (my\_access(index\_file\_name, F\_OK) &&
 !my\_access(crash\_safe\_index\_file\_name, F\_OK) &&
 my\_rename(crash\_safe\_index\_file\_name, index\_file\_name, MYF(MY\_WME)))
 {
 sql\_print\_error("MYSQL\_BIN\_LOG::open\_index\_file failed to "
 "move crash\_safe\_index\_file to index file.");
 error= true;
 goto end;
 }

}

新的 binlog\_file\_name 写入 binlog\_index\_file 的过程在 MYSQL\_BIN\_LOG::add\_log\_to\_index

int MYSQL\_BIN\_LOG::add\_log\_to\_index(uchar\* log\_name,
 size\_t log\_name\_len, bool need\_lock\_index)
{
 /\* 创建 crash\_safe\_index\_file \*/
 if (open\_crash\_safe\_index\_file())

 /\* 拷贝 index\_file 内容到 crash\_safe\_index\_file \*/
 if (copy\_file(&index\_file, &crash\_safe\_index\_file, 0))

 /\* 写入 binlog\_file\_name \*/
 if (my\_b\_write(&crash\_safe\_index\_file, log\_name, log\_name\_len) ||
 my\_b\_write(&crash\_safe\_index\_file, (uchar\*) "\\n", 1) ||
 flush\_io\_cache(&crash\_safe\_index\_file) ||
 mysql\_file\_sync(crash\_safe\_index\_file.file, MYF(MY\_WME)))

 /\*
 函数内部先 delete binlog\_index\_file 再 rename crash\_safe\_index\_file
 如果 delete 到 rename 之间发生 crash， crash\_safe\_index\_file 会在 recover过程中 rename 成 binlog\_index\_file
 \*/
 if (move\_crash\_safe\_index\_file\_to\_index\_file(need\_lock\_index))

}

### **总结**

MySQL 解决了binlog crash safe 的问题，但是 relay log 依然不保证 crash safe。
relay log 结构和 binlog 一致，可以借鉴 binlog crash safe 的方式，计算出 valid\_pos，将 valid\_pos之后的 event 全部purge。



    Created at: 2020-09-02T20:07:08+08:00
    Updated at: 2020-09-02T20:07:31+08:00

