# 技术笔记-MySQL

|     |     |
| --- | --- |
| Mysql线程模型 | * Master Thread<br>	* 缓冲池数据异步刷新到磁盘<br>	* 保证数据的一致性（刷新脏页、合并插入缓冲、UNDO页回收）<br>* IO Thread<br>	* insert buffer thread<br>* log thread<br>* innodb\_read\_io\_threads<br>* innodb\_write\_io\_threads<br>* Purge Thread<br>	* 加快UNDO页的回收，同时为了离散地读取UNDO页<br>* Page Cleaner Thread<br>	* 刷新脏页 |
| ORC | * 原理<br><br>* Raft，由主节点负责探活逻辑<br><br>* 能力<br><br>* 故障实例恢复后自动上线<br>* 监控指标<br><br>* 服务端RTO<br>* 端到端RTO<br>* SQL失败绝对量<br>* SQL成功率 |
| binlogserver | * ripple<br>* Mysqlbinlog<br>* Kingbus<br>* Facebook Binlogserver<br>* Mariadb Maxscale |
| 特性  | * fastddl |
|  |  |

    Created at: 2025-03-28T17:04:35+08:00
    Updated at: 2026-01-27T13:29:45+08:00

