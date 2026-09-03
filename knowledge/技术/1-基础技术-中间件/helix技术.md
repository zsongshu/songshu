# helix技术



|     |     |
| --- | --- |
| SPECTOR | 观察者，监控角色，不讨论。每个 “DTS任务在每个writer机器上”存在一个 |
| PARTICIPANT | 参与者，实际承接分片。每个 “DTS任务在每个writer机器上” 存在一个<br>主要监听的目录<br><br>1. /sg\_product\_task\_dispatch\_dts\_stage/INSTANCES/set-xr-dts-shangou-writer05-staging01.mt\_6e6706a9-e93f-4c43-baae-37b07f41b404/MESSAGES **参与者消息信箱** |
| CONTROLLER | 控制者，负责分片分配和其他运维，每个 “DTS任务在每个writer机器上” 一个，但只有一个是leader<br>主要监听的目录<br><br>1. /sg\_product\_task\_dispatch\_dts\_stage/CONTROLLER 主节点选举目录（临时节点）<br>2. /sg\_product\_task\_dispatch\_dts\_stage/LIVEINSTANCES 存活实例（临时节点）<br>3. /sg\_product\_task\_dispatch\_dts\_stage/INSTANCES/set-xr-dts-shangou-writer05-staging01.mt\_6e6706a9-e93f-4c43-baae-37b07f41b404/CURRENTSTATES/609bc5160c60048 **当前状态**(主要是)（其中 绿色的为writer机器名，红色为partition角色）<br>4. /sg\_product\_task\_dispatch\_dts\_stage/IDEALSTATES **理想状态** (主要是分片总量) |
| helix分片调度规则 | 由CONTROLLER观察 **当前状态** 和 **理想状态 ，**经过分配策略，决定决定 “分片” 与 “PARTICIPANT”的对应关系，并想结果发送到**参与者消息信箱**， |
| helix分片调度触发 | 由“消息”触发，这个消息包括 “zk注册目录的回调消息”、“zk连接状态变更”两种。没有持续巡检，持续判断（仅少量监控、缓存刷新由低频schedule任务完成） |
|  |  |
| 数据目录 | 1. /sg\_product\_task\_dispatch\_dts\_stage/INSTANCES/set-xr-dts-shangou-writer05-staging01.mt\_6e6706a9-e93f-4c43-baae-37b07f41b404/MESSAGES<br>2. /sg\_product\_task\_dispatch\_dts\_stage/INSTANCES/set-xr-dts-shangou-writer05-staging01.mt\_6e6706a9-e93f-4c43-baae-37b07f41b404/CURRENTSTATES/609bc5160c60048 **当前状态**<br>3. /sg\_product\_task\_dispatch\_dts\_stage/CONTROLLER 主节点选举目录（临时节点）<br>4. /sg\_product\_task\_dispatch\_dts\_stage/LIVEINSTANCES 存活实例（临时节点）<br>5. /sg\_product\_task\_dispatch\_dts\_stage/IDEALSTATES **理想状态** (主要是分片总量) |
|  |  |





    Created at: 2023-11-03T11:03:52+08:00
    Updated at: 2023-11-03T19:11:15+08:00

