# ORACLE中ID自增得方法-转自J

作者：jeru
email: [jeru@163.net](mailto:jeru@163.net)
日期：6/27/2001 10:00:04 AM
由 amtd 发布于: 2001-03-09 08:28



如何在Oracle 中实现类似自动增加 ID 的功能?
整理编辑：China ASP

我们经常在设计数据库的时候用一个系统自动分配的ID来作为我们的主键，但是在ORACLE 中没有这样的

功能，我们可以通过采取以下的功能实现自动增加ID的功能
1.首先创建 sequence
create sequence seqmax increment by 1
2.使用方法
select seqmax.nextval ID from dual
就得到了一个ID
如果把这个语句放在 触发器中，就可以实现和ms sql 的自动增加ID相同的功能！





    Created at: 2026-03-01T21:50:46+08:00
    Updated at: 2026-03-10T10:16:42+08:00

