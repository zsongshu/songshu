# 举报专项-用户详情页举报 ARES 数仓

REPORT\_USER\_DETAIL\_REVIEW(22502, "reportUserDetailReview", "举报专项-用户详情页举报”),


ares。sourcekey = 132

\[
 {
 "label": "封禁",
 "value": "401"
 },
 {
 "label": "降权",
 "value": "412"
 },
 {
 "label": "隔离",
 "value": "411"
 },
 {
 "label": "梯度封禁",
 "value": "399"
 },
 {
 "label": "永久降权",
 "value": "421"
 },
 {
 "label": "跳过",
 "value": "400"
 }
\]



"132": {
 "bizConfigKey": "safety\_report\_user\_detail\_review",
 "operationConfigs": {
 "default": {
 "operator": null,
 "targetType": "target\_type\_user\_id"
 }
 },
 "submitOperationMap": {
 "401": "op\_user\_ban",
 "412": "op\_user\_demote"
 "411": "op\_user\_isolate"
 "399": "op\_user\_grad\_ban"
 "421": "op\_user\_demote\_forever"
 "400": "op\_user\_skip"
 }
 }


op\_user\_ban(401, "封禁", "userban"), //
op\_user\_demote(412, "降权", "userdemote"), //
op\_user\_isolate(411, "隔离", "userisolate"), //
op\_user\_grad\_ban(399, "梯度封禁", "usergradban"),
op\_user\_demote\_forever(421, "永久降权", "userdemoteforever"),
op\_user\_skip(400, "跳过", "userskip"), //

select \* from admin\_data\_meta\_definition where meta\_config\_key in('op\_user\_ban','op\_user\_demote','op\_user\_isolate','op\_user\_grad\_ban','op\_user\_demote\_forever','op\_user\_skip')

update admin\_data\_meta\_definition set admin\_action\_code = 401 where meta\_config\_key = 'op\_user\_ban';

update admin\_data\_meta\_definition set admin\_action\_code = 412 where meta\_config\_key = 'op\_user\_demote';
update admin\_data\_meta\_definition set admin\_action\_code = 411 where meta\_config\_key = 'op\_user\_isolate';


    Created at: 2019-09-09T16:03:26+08:00
    Updated at: 2019-09-09T17:37:21+08:00

