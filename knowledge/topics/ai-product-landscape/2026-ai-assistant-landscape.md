# AI 助手产品形态对比（2026）

> 整理自 2026-10-03 与 WorkBuddy（松果）的一轮对话。聚焦：Grok / Grok Bot 是什么、常驻型个人助理与工作台型 Agent 的差异、中美及全球产品格局、Instinct 补全。

## 一、先分清两个 Grok
- **Grok**：xAI 的对话助手（X 上用的那个）。当前旗舰 Grok 4.6（2026-08-12 发布），另有 4.7 编码版。
- **Grok Bot**：2026-08-11 单独发布的**自主 Agent 平台**，跑云端电脑、多智能体通信、自动化 Routine。$200/月起，只能跑 xAI 模型，无免费档。
- 关键反差：Grok Bot 的 Agent 产品最贵，但底层模型 API 全场最便宜（Grok 4.6 输出 $6/百万 token，对比 GPT-5.6 Sol $30、Claude Opus 类 $25）。订阅贵、API 便宜，是 xAI 两速定价。
- Grok（对话）的唯一硬优势是**实时 X + 网页数据**；短板是准确性垫底（幻觉/事实错误最多被点名），标准档 $30/月比同类 $20 贵 50%。

## 二、适用场景判断框架
适合「高频、重复、错了能撤回」的活；不适合「低频、一次性、做了收不回」的活。三问：会重复吗？能撤回吗？涉及钱/密码/对外发布吗（涉及则保留人工最后一步）？
- Grok Bot 甜区：示范学习（操作一遍录成 Routine），适合无 API 的老旧后台系统机械流程。
- Gemini Spark 甜区：Google 全家桶（邮件/日历/Docs）。
- Meta Muse 甜区：个人购物/事务（隔离 VM + 单次虚拟卡）。
- ChatGPT Dots 甜区：主动研究 + 团队汇总（Slack/Teams），全流程只读。
- Grok（对话）甜区：实时信息（舆情/突发/社交趋势）。
- 护栏：先从只读开始、用限额卡封顶、别把密码丢进对话、留一份操作记录。

## 三、常驻型个人助理 vs 工作台型 Agent（WorkBuddy 类）
六条硬差异：

| 维度 | 常驻型个人助理 | 工作台型 Agent |
|---|---|---|
| 跑在哪 | 厂商云端 VM | 本机 + 指定工作目录 |
| 手伸向哪 | 邮箱/日历/购物/社交（绑账号） | 文件系统/代码库/工具链 |
| 交付什么 | 动作（事办完了） | 资产（文档/表格/PPT/代码/网站） |
| 怎么触发 | 常驻后台，自己判断 | 你派活才动（可配定时） |
| 最大风险 | 外部账户不可逆操作 | 本地文件改错（多可回滚） |
| 你交出什么 | 账号密码/OAuth | 一个目录读写权限 |

本质区别：**交付物**——前者省跑腿，后者省生产；**数据主权**——前者凭据交厂商云，后者留本机。选型互补不二选一。

## 四、Claude Cowork 架构变化（修正）
- 2026-01 发布时在本机隔离 Linux VM；7 月起默认走 Anthropic 云端沙箱；**10-06 起「只在本机运行」选项移除**。
- 与 Grok Bot 同类？**不像**。Cowork 通过本机 Claude Desktop 反向接回你的文件夹/浏览器（computer use）；Grok Bot 是给你一台独立云电脑。Cowork 交付文件，Grok Bot 交付"事办完了"。
- 真实统计：120 万匿名会话，33.4% 业务流程与运营、16.4% 产出 PPT/文档/提案——用户当"做东西"工具。
- 风险：PromptArmor 演示过用网页隐藏指令绕过防御外泄文件。云端沙箱挡"跑坏系统"，挡不住"被骗读走文件"。

## 五、Claude 有无对标 Grok Bot 的消费级产品
**没有一比一克隆**，能力拆散到多款：
- 最像常驻云电脑的是 **Managed Agents**（面向开发者，REST API + Console，需自搭，非消费级开箱体验）。
- 最接近"替你操作 App"的是 **Claude in Chrome**（驱动你自己的浏览器/cookie）与 Cowork 内置浏览器（side panel，不碰你的 tab）。
- 空缺：命名 Bot 群聊、开箱角色市场（Claude 靠 200+ Connectors 覆盖）。

## 六、中美产品形态四象限（两根正交轴）
- **横轴＝运行位置/数据主权**：本机 ↔ 云端。
- **纵轴＝交付性质**：创造新物（给你可持有对象）↔ 执行动作（改变既有状态）。
- 两轴正交；"产物保存位置"是导出结果，不是第三根轴。
- 左上 本机·创造：WorkBuddy、Claude Code、Copilot、Cursor、Amazon Q、Windsurf、OpenHands·Aider、Trae、通义灵码、CodeBuddy、文心快码、CodeGeeX、Kimi Code。
- 右上 云端·创造：Codex、Devin、Jules、Factory、Managed Agents、Cursor Cloud、OpenHands Cloud、MarsCode。
- 左下 本机·执行：Claude in Chrome、WorkBuddy+邮件连接器、OpenClaw、Apple Intelligence/Siri。
- 右下 云端·执行：Grok Bot、Meta Muse、ChatGPT dots(Aeon)、Operator、Claude Tag、**Instinct**。
- 底部基座层：纯对话助手（ChatGPT/Gemini/Claude/Grok；豆包/通义/DeepSeek/Kimi/元宝/文小言/智谱清言），部分已叠加 Agent 能力。

## 七、其他地区玩家（主权 AI 主线）
- 欧洲：Mistral（Le Chat/agents，GDPR-native、可私有部署，欧洲唯一前沿模型）、Aleph Alpha、LightOn、Apertus、DeepL、Hugging Face。
- 日韩：Naver（HyperCLOVA X 2.0 + Cloud Agents）、Kakao Kanana、Samsung Gauss、Sakana AI、PFN、SoftBank、NTT tsuzumi、Rakuten。
- 中东：TII/Falcon（主权 AI 指数第一，进 UAE TAMM 超级 App）、沙特 ALLAM、卡塔尔 Fanar、阿曼 Mu'een。
- 印度：Sarvam AI、Krutrim（Ola）、BharatGPT、Hanooman。
- 其他：俄罗斯 Sber/GigaChat、加拿大 Cohere（欧盟运营，主权基础设施）。
- 反差：多落在基座层 + 部分云端·资产（企业内、数据不出域）；真正常驻跑腿与成熟本机工作台仍主要由中美供应；消费级"AI 同事"全球仅中美认真做。

## 八、Instinct（补全，2026-08 发布）
- 公司 Spear Street Technology，创始人 Noah Shinn（Reflexion 一作、前 Sierra）。
- 2026-09-28 Series C：$1B，估值 $10B（红杉/Benchmark/Coatue），一个月前才 $2.5B。
- 核心：**Zero UI + Agent 即实体**——你拿到的是个电话号码，短信/打电话指挥；背后常驻云电脑 + 缓存凭据，替你订票/买东西/付账单/取消订阅/打电话（Concierge）；**Trusted Person Network** 让两个人的 agent 直接互聊协调。
- 落在右下象限（云端·执行动作），是该格估值最高、最极致的纯跑腿形态。
- 风险：条款将其法律任命为你的代理人（行为可约束你）；8 月隐私条款因收权过宽被批已修订；已有未授权取消被扣费、误发邮件案例。

## 关键结论
1. 订阅贵 API 便宜是 xAI 两速定价；实时信息是 Grok 护城河。
2. 选助手看"交付物"与"数据主权"，二者正交。
3. 中国本机工作台赛道最成熟且贴合中文/私有化；常驻跑腿还在智能体平台阶段。
4. 全球其他玩家主线是主权 AI，不是消费级 AI 同事。

## 资料来源与时效
2026-09 至 10 月公开评测与定价页汇总；行情变化快，下单前对官网。Instinct 数据截至 2026-09-28。
