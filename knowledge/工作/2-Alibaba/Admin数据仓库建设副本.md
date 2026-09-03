# Admin数据仓库建设副本


审核领域开发模型+审核大数据平台


<https://wiki.corp.kuaishou.com/pages/viewpage.action?pageId=183839417> 这个是数据平台接入的定义
<https://wiki.corp.kuaishou.com/pages/viewpage.action?pageId=201973699> 这个是业务接入的流程文档
<https://grafana.corp.kuaishou.com/d/JU7N-MNWz/2-tong-cao-zuo-ri-zhi?orgId=11&from=now-24h&to=now&fullscreen&panelId=2&var-BIZ=%E7%89%B9%E6%AE%8A%E7%9B%B4%E6%92%AD> 这个是目前接入的一个概况

<https://admin.p.adm-corp.kuaishou.com/frontend/skyeye/index.html#/video/audit/init/summary> 天眼
<https://admin.p.adm-corp.kuaishou.com/frontend/index.html#/audit-center/support/dashboard/monitor> 仪表盘


# 设计文档：<https://wiki.corp.kuaishou.com/pages/viewpage.action?pageId=219362697>



## 3.2 日志采集


根据业务特点，一部分业务流程是确定且收敛的，比如热门A审、头像背景审核等；另一部分业务流程可能在不断演进中，暂时无法收敛。
因此日志采集逻辑也做简单区分：
1、对于流程收敛的业务。按[接入模板](http://wiki.corp.kuaishou.com/pages/viewpage.action?pageId=201973741)进行业务改造，生成格式化的数据流；
2、对于流程为收敛的业务。全量采集业务日志，生成非格式化的数据流。

需求：

	新业务接入，新列表的增删改；
	
	上报信息不对（漏打、核心字段空）
	

---

老的消息体：AdminOperationLog
message AdminOperationLog {
 uint32 biz\_id = 1; // 业务ID，需要预先申请好, 禁止不同业务共用一个biz\_id，会导致数据不能入库
 uint32 action = 2; // 审核员实际操作的结果
 uint64 admin\_id = 3; // 审核员ID
 uint64 timestamp = 4; // 操作发生的时间，精确到毫秒
 string record\_id = 5; // 审核操作的对象ID，可以是视频ID，截图ID，使用字符串为了更好的兼容各个业务
 Event event\_type = 6; // 事件类型
 string session\_id = 7; // 一次操作唯一的会话ID，用于区分一批审核元素是不是在一次操作中进行的领取和提交，进审和出审，都是没有session id的
 uint32 source\_page = 8; // 操作的页面， 如果没有source page的业务，需要通过biz\_id去区分业务
 string ext\_data\_json = 9; // 扩展字段的json格式的字符串
 map<string, string> ext\_data = 1000; // 扩展字段，业务上比较有意义的数据
}

新的消息体：AdminDataOperationLogInfo
message AdminDataOperationLogInfo {
 string app\_id = 1; // 业务线标识,用于标识具体业务线，比如快手主app，acfun等
 uint32 biz\_id = 2; // 业务线内某一业务类型，比如用户操作日志， 视频操作日志等
 uint32 biz\_id\_level2 = 3; // 二级biz\_id 可空
 uint32 biz\_id\_level3 = 4; // 三级biz\_id 可空
 uint32 biz\_id\_level4 = 5; // 四级biz\_id 可空
 uint32 biz\_id\_level5 = 6; // 五级biz\_id 可空
 uint64 operator = 7 \[deprecated = true\]; // 操作人 已废弃
 uint32 raw\_biz\_id = 21; // 原始bizId
 string operator\_id = 24; // 操作员唯一标识(Who)，绝大部分场景是adminId
 uint64 operation\_time = 8; // 操作时间(When)
 uint32 source = 9; // 操作来源(Where)，可以是某一具体页面，也可以是某个页面下的子页面
 uint32 operation = 10; // 操作类型(What)， 比如封禁用户、隔离，置顶音乐等
 uint32 operation\_result = 20; // 操作结果, 0:成功 其余字段由业务自己定义
 string target\_id = 11; // 操作对象唯一标识（To Whom）
 uint32 target\_type = 22; // target类型, 可空
 string trace\_id = 12; // 链路追踪id
 uint32 source\_biz\_id = 13; // 来源bizId，用于和trace\_id结合，串联同一个操作类型
 string request\_id = 23; //requestId
 string extra1 = 14; // 业务扩展字段1
 string extra2 = 15; // 业务扩展字段2
 string extra3 = 16; // 业务扩展字段3
 string extra4 = 17; // 业务扩展字段4
 string process\_info = 18; // 宿主进程信息，json格式,包含serviceName,host,ip,port等信息
 string params = 19; // 操作额外信息, json格式
 AdminDataOperationLogReviewEventType event\_type = 25; // 消息类型
 uint32 source\_page\_code = 26; // sourcePage
 uint32 admin\_action\_code = 27; // adminAction
}

---

1. AdminDataReviewLogBuilder // 审核日志构造主体
2. AdminDataOperationLogBuilder // 日志发送主体
3. AdminDataOperationLogInfo implements AdminDataOperationLogInfoOrBuilder
4. AdminDataLogParam


AdminDataReviewLogUtils 包装工具类

---



* IN\_QUEUE(进审， 进入某一个审核队列)
* OUT\_QUEUE(出审， 从某个审核队列出去到另外的审核队列)
* SUBMITTED(审核提交)
* CLAIMED(审核员领取)


粉丝头条日志接入：
AdminAdFansTopController.sendClaimed:领取任务
AdminAdFansTopBinlogConsumer.send2DataWarehouse:送审
AdminAdFansTopHandler.handle：一般是审核
AdminPhotoFansTopListener


需要在原来的调用点上加上这个，还需要维护下sourcePage和adminAction的映射关系


---




update  admin\_data\_biz\_definition set parent\_biz\_id = 0 where source\_page\_code     in(99, 262, 10408, 73, 425, 10409, 43, 79, 80, 81, 82, 14005, 22, 14006, 14007, 284, 124, 94, 382);
update  admin\_data\_biz\_definition set parent\_biz\_id = 0 where source\_page\_code     in(16, 1108);





    Created at: 2019-08-26T13:34:54+08:00
    Updated at: 2020-07-14T14:17:05+08:00

