# MySQL字段类型解析

<https://dev.mysql.com/doc/refman/8.0/en/datetime.html>

|     |     |     |     |
| --- | --- | --- | --- |
| 类型  | 字节数 | 取值范围 | 描述  |
| DATETIME | 8   | '1000-01-01 00:00:00.000000' to '9999-12-31 23:59:59.999999' | * DATETIME 默认秒<br>* DATETIME(3) 毫秒<br>* DATETIME(6) 微妙 |
| TIMESTAMP | 4   | '1970-01-01 00:00:01.000000' to '2038-01-19 03:14:07.999999' | 表示当前时间到 Unix元年经过的秒数<br><br>* TIMESTAMP 默认秒<br>* TIMESTAMP(3) 毫秒<br>* TIMESTAMP(6) 微妙 |



MySQL converts TIMESTAMP values from the current time zone to UTC for storage, and back from UTC to the current time zone for retrieval.

    Created at: 2023-03-14T18:13:40+08:00
    Updated at: 2023-03-14T18:50:01+08:00

