# 测试ON UPDATE CURRENT_TIMESTAMP



|     |     |
| --- | --- |
|  | CREATE TABLE \`test\_utime\` ( <br>\`id\` [bigint](https://www.zhihu.com/search?q=bigint&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra=%7B%22sourceType%22%3A%22answer%22%2C%22sourceId%22%3A2264677294%7D)(20) NOT NULL, <br>\`created\_time\` datetime NOT NULL DEFAULT CURRENT\_TIMESTAMP, <br>\`update\_time\` timestamp NOT NULL DEFAULT CURRENT\_TIMESTAMP ON UPDATE CURRENT\_TIMESTAMP, <br>PRIMARY KEY (\`id\`)<br> ) ENGINE=InnoDB DEFAULT CHARSET=latin1; |
| 问题  | 执行Update的时候，MySQL引擎会首先获取当前时间，再参与排队提交事务，因此，在大量并发的时候，假若排队时间过程，获得的utime可能早于 Binlog实际生成的时间；<br><br>内核确定5.7肯定有这个问题，是个社区问题，8.0不确定是否解决 |





    Created at: 2022-08-02T19:03:13+08:00
    Updated at: 2024-10-22T12:16:06+08:00

