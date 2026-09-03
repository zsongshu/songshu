# Zebra核心指标Dashboard

### **1、核心指建设目标**

Zebra的运行方式是以SDK方式运行在业务端，通过对核心指标的监测

* **更充分了解业务使用方式**
* **更加明确组件****性能瓶颈**
* **提供****组件优化****的方向**
* **反馈业务使用可能存在的问题**

Zebra运行的数据不仅仅是一个展示，更要做到数据的沉淀

### **2、核心指标分类**

* 业务规模指标（衡量Zebra接入覆盖范围、使用版本分布、数据源覆盖度等等）
* 系统指标（衡量Zebra运行健康状况，包括执行各种功能SQL每天执行次数、SQL平均时长，QPS，调用量等）
* 运营治理指标（Zebra使用的一些指标和业务使用的SQL是强相关的，执行SQL错误数、获取连接平均时长等）

### **3、接入选型**

数据统计来源：接入服务端 & 运行时CAT打点；
展示平台：魔数 [大盘DashBoard](https://bi.sankuai.com/dashboard/32452) [数据仓库](https://bi.sankuai.com/portal/21758?type=dashboard&id=33007)

### **4、业务指标**

|     |     |     |     |
| --- | --- | --- | --- |
| 指标  | 说明  | 统计规则 | 数据来源 |
| 接入应用统计 | 根据接入appkey数量统计 | 每日统计 | Zebra-admin |
| 数据源种类（连接池） | druid、tomcat-jdbc数量统计 | 每日统计 | ZebraAdmin |
| Zebra版本 | 使用不同Zebra版本分布统计 | 每日统计 | ZebraAdmin |
| 分布式SQL引擎接入数 | 分布式SQL引擎业务使用量 | 每日统计 | Cat每日汇总统计 |
| 分布式SQL引擎日调用量 | 分布式SQL日调用量 | 每日统计 | Cat: DistributedSQL.Statistic |
| 跨库事务接入数 | 跨库事务接入应用数目 | 每日统计 | Cat每日汇总 |
| 跨库事务日调用量 | 跨库事务日调用量 | 每日统计 | Cat: SwanMtxc.GlobalBegin |

### **5、系统指标**

因为Zebra是以sdk形式嵌入到业务中，不存在server端，执行SQL的时间取决于业务怎么用，所以目前定了一条指标；

|     |     |     |
| --- | --- | --- |
| 指标  | 统计规则 | 数据来源 |
| SQL 95线 | 95%SQL执行时长 | Cat->offline |
| SQL 99线 | 99%SQL执行时长 | Cat->offline |
| SQL日调用量 | 每日执行多少次SQL | Cat->offline |
| SHARD日调用量 | 跨库SQL日调用量 | Cat->offline |
| 分布式SQL引擎日调用量 | 分布式SQL日调用量 | Cat->offline |
| 跨库事务日调用量 | 跨库事务日调用量 | Cat->offline |

### **6、运营指标**

FailOver、getConnection这种ERROR暂时从cat上拿不到相关的统计，后面了解业务相关的SLA再做统计

|     |     |     |
| --- | --- | --- |
| 指标  | 统计规则 | 数据来源 |
| SQL日执行错误数 | 每日执行SQL，抛错的个数 | Cat中offline数据 |
| ShardSQL日执行错误数 | 每日执行跨库SQL，抛错条数 | Cat中offline数据 |
| Connection平均时长 | 每个Connection平均获取时长 | Cat中offline统计数据 |



    Created at: 2024-06-25T09:17:53+08:00
    Updated at: 2024-06-25T09:18:00+08:00

