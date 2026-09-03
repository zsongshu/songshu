# txc operation manual-Readme

1、新建一个DRDS数据库，增加白名单，以下命令登录到DRDS或者TXC服务器上执行
（1）得到Diamond ip地址: curl [jmenv.tbsite.net:8080/diamond-server/diamond](http://jmenv.tbsite.net:8080/diamond-server/diamond)
 (2) 得到Drds Instance Id，可通过DRDS控制台查询
 (3) 得到Drds 数据库名（appname），可咨询DRDS
 (4) [执行脚本：addDrdsInstance.sh](http://%E6%89%A7%E8%A1%8C%E8%84%9A%E6%9C%AC%EF%BC%9AaddDrdsInstance.sh) $diamondip $drdsInstanceId
 (5) [执行脚本：addDrdsDb.sh](http://%E6%89%A7%E8%A1%8C%E8%84%9A%E6%9C%AC%EF%BC%9AaddDrdsDb.sh) $diamondip $drdsAppname


    Created at: 2026-03-01T21:50:48+08:00
    Updated at: 2026-03-01T21:50:48+08:00

