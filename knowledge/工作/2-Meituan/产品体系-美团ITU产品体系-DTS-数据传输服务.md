# 产品体系-美团ITU产品体系-DTS-数据传输服务



|     |     |
| --- | --- |
| DTS产品能力 | * 定义：基于实时数据流的可靠传输服务<br>* 基本能力<br>	* 数据订阅<br>		* DDL订阅<br>		* DML订阅<br>	* 数据同步<br>		* DDL同步<br>		* DML同步<br>		* 数据迁移<br>			* 结构迁移<br>			* 数据迁移<br>			* 全量迁移<br>			* 范围迁移<br>	* 备份恢复<br>		* FlashBack<br>		* 数据归档<br>		* Import/export<br>			* CSV文件<br>			* binlog<br>	* 技术突破<br>		* 分布式存储（堆积能力）<br>		* 热点分片治理<br>		* 事务发送<br>		* 批量发送<br>		* 冲突检测<br>* 运维管控 |
| 多数据源 | * 上游系统<br>	* Mysql<br>		* 单库<br>		* 分库<br>	* Blade<br>	* Mafka<br>* 下游系统<br>	* Mafka<br>	* Thrift<br>	* Mysql<br>		* 单库<br>		* 分库<br>	* Blade<br>	* ES<br>	* Redis<br>	* SDK<br>	* 自定义 |
| 业务场景 | * 数据同步<br>	* 异地多活<br>	* 单向同步<br>	* 双向同步<br>	* 横向扩展读能力<br>	* 不停机迁移/升级<br>	* 业务报表<br>* 数据订阅<br>	* 轻量级缓存更新策略<br>	* 业务异步解耦<br>	* 实时BI<br>* 数据分发<br>	* 泳道<br>	* 灰度<br>* 数据迁移 |
| 数据容灾 | * 库表迁移<br>	* 迁表<br>	* 迁库<br>* 数据清理<br>	* 按指定规则清理<br>	* 定时清理<br>	* 分库分表清理<br>	* 影子表清理<br>* 备份恢复<br>	* flashback<br>	* Import/export<br>		* 按次导入/导出<br>		* 定时导入/导出<br>		* 线上导线下<br>		* 构建影子表数据<br>	* 归档<br>		* 手工归档<br>		* 定时归档 |
| 对标  | * Sqoop<br>* datapipeline<br>* Canal<br>* DRC<br>	* AMG<br>	* TCP<br>* Oracle<br>	* OGG<br>	* Data Guard<br>	* CDP<br>	* RMAN<br>	* IMP/EXP |
| Hint处理 | 1. 影子表<br>	1. 表名：\_shadow\_正式表名\_<br>	2. 生效条件：（1）开启影子表开关（2）影子表名<br>	3. 执行逻辑<br>		1. 订阅：（1）影子表名修改为正式表名 （2）Tracer.setTest(true)<br>		2. 同步：理论上不需要处理<br>2. 泳道（仅线下）<br>3. 过滤Set备份（仅线上）<br>4. 灰度路由（LiteSet）<br>	1. DTS根据Binlog标，分发到下游不同liteset（set=gray-XXX）<br>	2. 标识<br>		* 非gray-release-开头<br>			* SET化<br>				* 不支持<br>			* 非SET化<br>				* 不论是否开启灰度路由标识，均发送到中心<br>		* gray-release-开头<br>			* SET化<br>				* 不支持<br>			* 非SET化<br>				* 灰度路由标识开启则路由到灰度链路；不开启则路由到中心<br>	3. 执行逻辑<br>		* 订阅：设置到Trace<br>		* 同步：设置到Trace<br>5. 消息轨迹<br>6. 透传Hint<br>7. 服务组路由策略 |
| 上下游依赖 | Reader<br><br>* KMS<br>* ZK<br>* S3/EFS<br>* MNS<br>* MySQL/Blade CDC<br>* Lion<br><br> Writer<br><br>* MNS<br>* ZK<br>* Rhino<br>* Lion<br>* MySQL/Blade/Mafka/Thrift/Eagle/Squirrel |
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |
|  |  |





    Created at: 2024-06-04T09:31:10+08:00
    Updated at: 2024-06-04T14:34:28+08:00

