# 8个DBA最常用的监控Oracle数据库的常用shell脚本

本文介绍了8个常用的监控数据shell脚本。首先回顾了一些DBA常用的Unix命令，以及解释了如何通过Unix Cron来定时执行DBA脚本。网上也有好多类似的文章，但基本上都不能正常运行，花点时间重新整理了下，以后就能直接使用了。 

一．同时文章还介绍了8个重要的脚本来监控Oracle数据库： 
1.检查实例的可用性 
2.检查监听器的可用性 
3.检查alert日志文件中的错误信息 
4.在存放log文件的地方满以前清空旧的log文件 
5.分析table和index以获得更好的性能 
6.检查表空间的使用情况 
7.找出无效的对象 
8.监控用户和事务 

二．DBA需要的Unix基本知识 
基本的UNIX命令，以下是一些常用的Unix命令： 
ps--显示进程 
grep--搜索文件中的某种文本模式 
mailx--读取或者发送mail 
cat--连接文件或者显示它们 
cut--选择显示的列 
awk--模式匹配语言 
df--显示剩余的磁盘空间 

以下是DBA如何使用这些命令的一些例子： 

1\. 显示服务器上的可用实例： 
$ ps -ef| grep smon 
 oracle 22086     1  0 02:32:24 ?        0:04 ora\_smon\_PPRD10 
oracle  5215 28972  0 08:10:19 pts/4    0:00 grep smon 

2\. 显示服务器上的可用监听器： 
$ ps -ef grep listener grep -v grep 
（grep命令应该加上-i参数，即grep -i listener，该参数的作用是忽略大小写，因为有些时候listener是大写的，这时就会看不到结果） 
$ ps -ef|grep -i listener 
 oracle  9655     1  0   Mar 12 ?        0:01 /data/app/oracle/9.2.0/bin/tnslsnr LISTENER -inherit 
 oracle 22610     1  0 02:45:02 ?        0:02 /data/app/oracle/10.2.0/bin/tnslsnr LISTENER -inherit 
oracle  5268 28972  0 08:13:02 pts/4    0:00 grep -i listener 

3\. 查看Oracle存档目录的文件系统使用情况 
$ df -k | grep /data 
/dev/md/dsk/d50      104977675 88610542 15317357    86%    /data 

4\. 统计alter.log文件中的行数： 
$ cat alert\_PPRD10.log | wc -l 
 13124 
$ more alert\_PPRD10.log | wc -l 
 13124 

5\. 列出alert.log文件中的全部Oracle错误信息： 
$ grep ORA-\* alert.log 
ORA-00600: internal error code, arguments: \[kcrrrfswda.1\], \[\], \[\], \[\], \[\], \[\] 
ORA-00600: internal error code, arguments: \[1881\], \[25860496\], \[25857716\], \[\] 

6\. CRONTAB基本 
一个crontab文件中包含有六个字段： 
分钟 0-59 
小时 0-23 
月中的第几天 1-31 
月份 1 - 12 
星期几 0 - 6, with 0 = Sunday 

7\. Unix命令或者Shell脚本 
要编辑一个crontab文件，输入： Crontab -e 
要查看一个crontab文件，输入： Crontab -l 
0 4 \* \* 5 /dba/admin/analyze\_table.ksh 
30 3 \* \* 3,6 /dba/admin/hotbackup.ksh /dev/null 2>&1 
在上面的例子中，第一行显示了一个分析表的脚本在每个星期5的4：00am运行。第二行显示了一个执行热备份的脚本在每个周三和周六的3：00a.m.运行。 

三．监控数据库的常用Shell脚本 
以下提供的8个shell脚本覆盖了DBA每日监控工作的90%，你可能还需要修改UNIX的环境变量。 

1\. 检查Oracle实例的可用性 
oratab文件中列出了服务器上的所有数据库 
$ cat /var/opt/oracle/oratab 
# 

\# This file is used by ORACLE utilities.  It is created by root.sh 
\# and updated by the Database Configuration Assistant when creating 
\# a database. 

\# A colon, ':', is used as the field terminator.  A new line terminates 
\# the entry.  Lines beginning with a pound sign, '#', are comments. 
# 
\# Entries are of the form: 
#   $ORACLE\_SID:$ORACLE\_HOME:<N|Y>: 
# 
\# The first and second fields are the system identifier and home 
\# directory of the database respectively.  The third filed indicates 
\# to the dbstart utility that the database should , "Y", or should not, 
\# "N", be brought up at system boot time. 
# 
\# Multiple entries with the same $ORACLE\_SID are not allowed. 
# 
# 
\# \*:/data/app/oracle/9.2.0:N 
TRNG:/data/app/oracle/9.2.0:Y 
\*:/data/app/oracle/9.2.0:N 
PPRD:/data/app/oracle/10.2.0:Y 
PPRD10:/data/app/oracle/10.2.0:N 

以下的脚本检查oratab文件中列出的所有数据库，并且找出该数据库的状态（启动还是关闭） 
################################################################### 
\## ckinstance.ksh ## 
################################################################### 
ORATAB=/var/opt/oracle/oratab 
echo "\`date\` " 
echo "Oracle Database(s) Status \`hostname\` :/n" 
db=\`egrep -i ":Y|:N" $ORATAB | cut -d":" -f1 | grep -v "/#" | grep -v "/\*"\` 
pslist="\`ps -ef | grep pmon\`" 
for i in $db ; do 
echo "$pslist" | grep "ora\_pmon\_$i" > /dev/null 2>$1 
if (( $? )); then 
echo "Oracle Instance - $i: Down" 
else 
echo "Oracle Instance - $i: Up" 
fi 
done 

使用以下的命令来确认该脚本是可以执行的： 
$ chmod 744 ckinstance.ksh 
$ ls -l ckinstance.ksh 
\-rwxr--r-- 1 oracle dba 657 Mar 5 22:59 ckinstance.ksh 

以下是实例可用性的报表： 
$ sh ckinstance.ksh 
Wed May 13 12:51:20 PDT 2009 
Oracle Database(s) Status gambels : 
Oracle Instance - PPRD: Up 
Oracle Instance - PPRD10: Up 

2\. 检查Oracle监听器的可用性 
以下有一个类似的脚本检查Oracle监听器。假如监听器停了，该脚本将会重新启动监听器： 
##################################################################### 
\## cklsnr.sh ## 
##################################################################### 
#!/bin/ksh 
TNS\_ADMIN=/var/opt/oracle; export TNS\_ADMIN 
ORACLE\_SID= PPRD10; export ORACLE\_SID 
ORAENV\_ASK=NO; export ORAENV\_ASK 
PATH=$PATH:/bin:/usr/local/bin; export PATH 
. oraenv 
DBALIST="tianlesoftware@vip.qq.com,tianlesoftware@hotmail.com";export DBALIST 
cd /var/opt/oracle 
rm -f lsnr.exist 
ps -ef | grep PPRD10 | grep -v grep > lsnr.exist 
if \[ -s lsnr.exist \] 
then 
echo 
else 
echo "Alert" | mailx -s "Listener 'PPRD10' on \`hostname\` is down" $DBALIST 
lsnrctl start PPRD10 
fi 

3\. 检查Alert日志（ORA-XXXXX） 
#################################################################### 
\## ckalertlog.sh ## 
#################################################################### 
#!/bin/ksh 

EDITOR=vi; export EDITOR 
ORACLE\_SID=PPRD10; export ORACLE\_SID 
ORACLE\_BASE=/data/app/oracle; export ORACLE\_BASE 
ORACLE\_HOME=$ORACLE\_BASE/10.2.0; export ORACLE\_HOME 
LD\_LIBRARY\_PATH=$ORACLE\_HOME/lib; export LD\_LIBRARY\_PATH 
TNS\_ADMIN=/var/opt/oracle;export TNS\_ADMIN 
NLS\_LANG=american; export NLS\_LANG 
NLS\_DATE\_FORMAT='Mon DD YYYY HH24:MI:SS'; export NLS\_DATE\_FORMAT 
ORATAB=/var/opt/oracle/oratab;export ORATAB 
PATH=$PATH:$ORACLE\_HOME:$ORACLE\_HOME/bin:/usr/ccs/bin:/bin:/usr/bin:/usr/sbin:/sbin:/usr/openwin/bin:/opt/bin:.; export PATH 
DBALIST="tianlesoftware@vip.qq.com,tianlesoftware@hotmail.com";export DBALIST 

cd $ORACLE\_BASE/admin/PPRD10/bdump 
if \[ -f alert\_PPRD10.log \] 
then 
mv alert\_PPRD10.log alert\_work.log 
touch alert\_PPRD10.log 
cat alert\_work.log >> alert\_PPRD10.hist 
grep ORA- alert\_work.log > alert.err 
fi 
if \[ \`cat alert.err | wc -l\` -gt 0 \] 
then 
mailx -s " PPRD10  ORACLE  ALERT  ERRORS" $DBALIST < alert.err 
fi 
rm -f alert.err 
rm -f alert\_work.log 


4\. 清除旧的归档文件 
以下的脚本将会在log文件达到90%容量的时候清空旧的归档文件： 
$ df -k | grep arch 
Filesystem kbytes used avail capacity Mounted on 
/dev/vx/dsk/proddg/archive 71123968 30210248 40594232 43% /u08/archive 

####################################################################### 
\## clean\_arch.ksh ## 
####################################################################### 
#!/bin/ksh 
df -k | grep arch > dfk.result 
archive\_filesystem=\`awk -F" " '{ print $6 }' dfk.result\` 
archive\_capacity=\`awk -F" " '{ print $5 }' dfk.result\` 

if \[ $archive\_capacity > 90% \] 
then 
echo "Filesystem ${archive\_filesystem} is ${archive\_capacity} filled" 
\# try one of the following option depend on your need 
find $archive\_filesystem -type f -mtime +2 -exec rm -r {} ; 
tar 
rman 
fi 

5\. 分析表和索引（以得到更好的性能） 
以下我将展示假如传送参数到一个脚本中： 
#################################################################### 
\## analyze\_table.sh ## 
#################################################################### 
#!/bin/ksh 
\# input parameter: 1: passWord # 2: SID 
if (($#<1)) then echo "Please enter 'oracle' user password as the first parameter !" exit 0 
fi 
if (($#<2)) then echo "Please enter instance name as the second parameter!" exit 0 
fi 
要传入参数以执行该脚本，输入： 
$ analyze\_table.sh manager oradb1 
脚本的第一部分产生了一个analyze.sql文件，里面包含了分析表用的语句。脚本的第二部分分析全部的表： 
################################################################# 
\## analyze\_table.sh ## 
################################################################# 
sqlplus -s '/ as sysdba' <<EOF 
set heading off 
set feed off 
set pagesize 200 
set linesize 100 
spool analyze\_table.sql 
select 'ANALYZE TABLE ' || owner || '.' || segment\_name || 
' ESTIMATE STATISTICS SAMPLE 10 PERCENT;' 
from dba\_segments 
where segment\_type = 'TABLE' 
and owner not in ('SYS', 'SYSTEM'); 
spool off 
exit 
EOF 
sqlplus -s '/ as sysdba' <<EOF 
@./analyze\_table.sql 
exit 
EOF 

以下是analyze.sql的一个例子： 
$ cat analyze.sql 
ANALYZE TABLE HIRWIN.JANUSAGE\_SUMMARY ESTIMATE STATISTICS SAMPLE 10 PERCENT; 
ANALYZE TABLE HIRWIN.JANUSER\_PROFILE ESTIMATE STATISTICS SAMPLE 10 PERCENT; 
ANALYZE TABLE APPSSYS.HIST\_SYSTEM\_ACTIVITY ESTIMATE STATISTICS SAMPLE 10 PERCENT; 
ANALYZE TABLE HTOMEH.QUEST\_IM\_VERSION ESTIMATE STATISTICS SAMPLE 10 PERCENT; 
ANALYZE TABLE JSTENZEL.HIST\_SYS\_ACT\_0615 ESTIMATE STATISTICS SAMPLE 10 PERCENT;


6\. 检查表空间的使用 
以下的脚本检测表空间的使用。假如表空间只剩下10%，它将会发送一个警告email。 
##################################################################### 
\## ck\_tbsp.sh ## 
##################################################################### 
#!/bin/ksh 

EDITOR=vi; export EDITOR 
ORACLE\_SID=PPRD10; export ORACLE\_SID 
ORACLE\_BASE=/data/app/oracle; export ORACLE\_BASE 
ORACLE\_HOME=$ORACLE\_BASE/10.2.0; export ORACLE\_HOME 
LD\_LIBRARY\_PATH=$ORACLE\_HOME/lib; export LD\_LIBRARY\_PATH 
TNS\_ADMIN=/var/opt/oracle;export TNS\_ADMIN 
NLS\_LANG=american; export NLS\_LANG 
NLS\_DATE\_FORMAT='Mon DD YYYY HH24:MI:SS'; export NLS\_DATE\_FORMAT 
ORATAB=/var/opt/oracle/oratab;export ORATAB 
PATH=$PATH:$ORACLE\_HOME:$ORACLE\_HOME/bin:/usr/ccs/bin:/bin:/usr/bin:/usr/sbin:/sbin:/usr/openwin/bin:/opt/bin:.; export PATH 
DBALIST="tianlesoftware@vip.qq.com,tianlesoftware@hotmail.com";export DBALIST 


sqlplus -s '/ as sysdba' <<EOF 
set feed off 
set linesize 100 
set pagesize 200 
column "USED (MB)" format a10 
column "FREE (MB)" format a10 
column "TOTAL (MB)" format a10 
column PER\_FREE format a10 
spool tablespace.alert 
SELECT F.TABLESPACE\_NAME, 
TO\_CHAR ((T.TOTAL\_SPACE - F.FREE\_SPACE),'999,999') "USED (MB)", 
TO\_CHAR (F.FREE\_SPACE, '999,999') "FREE (MB)", 
TO\_CHAR (T.TOTAL\_SPACE, '999,999') "TOTAL (MB)", 
TO\_CHAR ((ROUND ((F.FREE\_SPACE/T.TOTAL\_SPACE)\*100)),'999')||' %' PER\_FREE 
FROM ( 
SELECT TABLESPACE\_NAME, 
ROUND (SUM (BLOCKS\*(SELECT VALUE/1024 
FROM V/$PARAMETER 
WHERE NAME = 'db\_block\_size')/1024) 
) FREE\_SPACE 
FROM DBA\_FREE\_SPACE 
GROUP BY TABLESPACE\_NAME 
) F, 
( 
SELECT TABLESPACE\_NAME, 
ROUND (SUM (BYTES/1048576)) TOTAL\_SPACE 
FROM DBA\_DATA\_FILES 
GROUP BY TABLESPACE\_NAME 
) T 
WHERE F.TABLESPACE\_NAME = T.TABLESPACE\_NAME 
AND (ROUND ((F.FREE\_SPACE/T.TOTAL\_SPACE)\*100)) < 80; 
spool off 
exit 
EOF 
if \[ \`cat tablespace.alert|wc -l\` -gt 0 \] 
then 
cat tablespace.alert > tablespace.tmp 
mailx -s "TABLESPACE  ALERT  for  PPRD10" $DBALIST < tablespace.tmp 
fi 

警告email输出的例子如下： 
TABLESPACE\_NAME                USED (MB)  FREE (MB)  TOTAL (MB) PER\_FREE 
\------------------------------ ---------- ---------- ---------- ---------- 
SYSTEM                              519        401        920     44 % 
MILLDATA                            559        441      1,000     44 % 
SYSAUX                              331        609        940     65 % 
MILLREPORTS                         146        254        400     64 % 

7\. 查找出无效的数据库对象 
以下查找出无效的数据库对象： 
##################################################################### 
##invalid\_object\_alert.sh 
##################################################################### 
#!/bin/ksh 
EDITOR=vi; export EDITOR 
ORACLE\_SID=PPRD10; export ORACLE\_SID 
ORACLE\_BASE=/data/app/oracle; export ORACLE\_BASE 
ORACLE\_HOME=$ORACLE\_BASE/10.2.0; export ORACLE\_HOME 
LD\_LIBRARY\_PATH=$ORACLE\_HOME/lib; export LD\_LIBRARY\_PATH 
TNS\_ADMIN=/var/opt/oracle;export TNS\_ADMIN 
NLS\_LANG=american; export NLS\_LANG 
NLS\_DATE\_FORMAT='Mon DD YYYY HH24:MI:SS'; export NLS\_DATE\_FORMAT 
ORATAB=/var/opt/oracle/oratab;export ORATAB 
PATH=$PATH:$ORACLE\_HOME:$ORACLE\_HOME/bin:/usr/ccs/bin:/bin:/usr/bin:/usr/sbin:/sbin:/usr/openwin/bin:/opt/bin:.; export PATH 
DBALIST="tianlesoftware@vip.qq.com,tianlesoftware@hotmail.com";export DBALIST 

sqlplus -s '/ as sysdba' <<EOF 
set feed off 
set heading off 
column OWNER format a10 
column OBJECT\_NAME format a35 
column OBJECT\_TYPE format a10 
column STATUS format a10 
spool invalid\_object.alert 
SELECT OWNER, OBJECT\_NAME, OBJECT\_TYPE, STATUS FROM DBA\_OBJECTS WHERE STATUS = 'INVALID' ORDER BY OWNER, OBJECT\_TYPE, OBJECT\_NAME; 
spool off 
exit 
EOF 
if \[ \`cat invalid\_object.alert | wc -l\` -gt 0 \] then 
mailx -s "INVALID OBJECTS for PPRD10" $DBALIST < invalid\_object.alert 
fi 

$ more invalid\_object.alert 

PUBLIC     ALL\_WM\_LOCKED\_TABLES                SYNONYM    INVALID 
PUBLIC     ALL\_WM\_VERSIONED\_TABLES             SYNONYM    INVALID 
PUBLIC     DBA\_WM\_VERSIONED\_TABLES             SYNONYM    INVALID 
PUBLIC     SDO\_CART\_TEXT                       SYNONYM    INVALID 
PUBLIC     SDO\_GEOMETRY                        SYNONYM    INVALID 
PUBLIC     SDO\_REGAGGR                         SYNONYM    INVALID 
PUBLIC     SDO\_REGAGGRSET                      SYNONYM    INVALID 
PUBLIC     SDO\_REGION                          SYNONYM    INVALID 
PUBLIC     SDO\_REGIONSET                       SYNONYM    INVALID 
PUBLIC     USER\_WM\_LOCKED\_TABLES               SYNONYM    INVALID 
PUBLIC     USER\_WM\_VERSIONED\_TABLES            SYNONYM    INVALID 
PUBLIC     WM\_COMPRESS\_BATCH\_SIZES             SYNONYM    INVALID 

8\. 监视用户和事务（死锁等） 
以下的脚本在死锁发生的时候发送一个警告e-mail： 
################################################################### 
\## deadlock\_alert.sh ## 
################################################################### 
#!/bin/ksh 

EDITOR=vi; export EDITOR 
ORACLE\_SID=PPRD10; export ORACLE\_SID 
ORACLE\_BASE=/data/app/oracle; export ORACLE\_BASE 
ORACLE\_HOME=$ORACLE\_BASE/10.2.0; export ORACLE\_HOME 
LD\_LIBRARY\_PATH=$ORACLE\_HOME/lib; export LD\_LIBRARY\_PATH 
TNS\_ADMIN=/var/opt/oracle;export TNS\_ADMIN 
NLS\_LANG=american; export NLS\_LANG 
NLS\_DATE\_FORMAT='Mon DD YYYY HH24:MI:SS'; export NLS\_DATE\_FORMAT 
ORATAB=/var/opt/oracle/oratab;export ORATAB 
PATH=$PATH:$ORACLE\_HOME:$ORACLE\_HOME/bin:/usr/ccs/bin:/bin:/usr/bin:/usr/sbin:/sbin:/usr/openwin/bin:/opt/bin:.; export PATH 
DBALIST="tianlesoftware@vip.qq.com,tianlesoftware@hotmail.com";export DBALIST 

sqlplus -s '/ as sysdba' <<EOF 
set feed off 
set heading off 
spool deadlock.alert 
SELECT SID, DECODE(BLOCK, 0, 'NO', 'YES' ) BLOCKER, 
DECODE(REQUEST, 0, 'NO','YES' ) WAITER 
FROM V/$LOCK 
WHERE REQUEST > 0 OR BLOCK > 0 
ORDER BY block DESC; 
spool off 
exit 
EOF 
if \[ \`cat deadlock.alert | wc -l\` -gt 0 \] 
then 
mailx -s "DEADLOCK ALERT for PPRD10" $DBALIST < deadlock.alert 
fi 

四． 结论 
0,20,40 7-17 \* \* 1-5 /dba/scripts/ckinstance.sh > /dev/null 2>&1 
0,20,40 7-17 \* \* 1-5 /dba/scripts/cklsnr.sh > /dev/null 2>&1 
0,20,40 7-17 \* \* 1-5 /dba/scripts/ckalertlog.sh > /dev/null 2>&1 
30 \* \* \* 0-6 /dba/scripts/clean\_arch.sh > /dev/null 2>&1 
\* 5 \* \* 1,3 /dba/scripts/analyze\_table.sh > /dev/null 2>&1 
\* 5 \* \* 0-6 /dba/scripts/ck\_tbsp.sh > /dev/null 2>&1 
\* 5 \* \* 0-6 /dba/scripts/invalid\_object\_alert.sh > /dev/null 2>&1 
0,20,40 7-17 \* \* 1-5 /dba/scripts/deadlock\_alert.sh > /dev/null 2>&1 
通过以上的脚本，可大大减轻你的工作。你可以使用这些是来做更重要的工作，例如性能调整。

    Created at: 2013-08-23T22:19:38+08:00
    Updated at: 2025-04-09T10:03:28+08:00

