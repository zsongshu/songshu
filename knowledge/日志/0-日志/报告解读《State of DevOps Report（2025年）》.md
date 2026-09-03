# 报告解读《State of DevOps Report（2025年）》

文章摘要：DevOps领域（研发效能）国际最具影响力的报告，本文为2025年报告解读，首次对AI对研发效能的影响进行了系统性的洞察，并建立了「DORA 人工智能能力模型」。
📌

2014年至2024年，DevOps现状报告走过了十一年历程。它的发行公司DORA，在国内不像 Gartner 有那么高的知名度，但在全球，DORA 是研发效能 / DevOps 领域最具影响力的报告。

从2014年开始，每年会出一份，2020年因为疫情的原因没有出，所以到2025年一共有 11份。这个系列报告详细解释了行业中各类企业的效能水平以及高效能企业如何开展DevOps工作。自2014年首次报告发布以来，就一直延续着这种体系化的风格，提供数据、案例以及许多深入的研究分析结果。报告累计调研了业界36000多名实践者，为我们提供了丰富的学习和实践材料，分享了诸多最佳实践内容，总结了许多宝贵的经验。

这份报告的业界解读也非常多，此处我就直接引用我比较喜欢的一点内容，来帮助大家快速了解这份报告。

注1：DORA 一开始是一家独立的研究机构，不过在 2018 年底加入了谷歌云。总体来讲 DORA 的报告是整个 DevOps 行业里面最为专业和客观的，这也应该是它当初受到谷歌青睐的原因。即使是加入谷歌后，它的报告也基本可以保持中立性。

注2：本文内容引用来源包括QECon、DevOps中国社区、DevOps个人爱好者等多篇解读文章。

# 0\. 核心精要

|     |     |     |
| --- | --- | --- |
| ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/394a438441581ac8037df8146b953aaf.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/ef882a86d76ebf0e6d2e38b6e48767fe.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/65f556464473a86c117bc07066a7fc5e.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |

# 1\. 2025年有什么新的发现？

📌

概览：

1\. AI 在软件开发中的定位是“放大器”而非“万能药”

* 放大高效组织优势，也放大低效组织缺陷；价值取决于组织系统基础。
* 最大回报来自对内部平台、流程清晰度和团队协同的战略投入，而非工具采购本身。

2\. AI 采纳普及但效果分化

* 2025 年 90% 技术人员使用 AI（日均 2 小时），生成式 AI 已成常态。
* 80% 感知个人效能提升，59% 认为代码质量改善；AI 与组织/团队效能正相关。
* 但未缓解工作摩擦与职业倦怠，且因流程未适配，交付不稳定性仍存。

3\. DORA AI 能力模型：7 项关键能力决定 AI 成效

* 共识的 AI 立场、健康数据生态、AI 可访问内部数据、稳健版本控制、小批量工作模式、以用户为中心、高质量内部平台。缺一将导致价值停滞或偏航。

4\. 团队效能启示：速度与稳定可兼得

* 聚类识别出 7 类团队，“和谐高成就者”（20%）实现高吞吐、低不稳定、低倦怠，打破“速度-稳定权衡”迷思。
* 单靠交付指标不足，需结合摩擦阻力、有价值工作占比等维度诊断问题，如“流程受限型”应优化协作而非工具。

5\. 平台工程与 VSM 是 AI 价值倍增器

* 平台工程普及率达 90%，高质量平台强化 AI 效益并降低风险；需以开发者体验为核心，避免“技术先行”或“工单运维”。
* VSM 可视化全流程，确保 AI 解决核心瓶颈；成熟 VSM 组织更易将 AI 局部提升转化为全局优势。

6\. AI 是组织系统的 “镜子” 与 “倍增器”

* 高效组织用 AI 进一步提效，低效组织则暴露并加剧问题。
* AI 采纳应为系统级转型：同步优化验证部署流程，调整角色（如提示工程师、审核者），而非仅培训使用工具。

7\. 度量框架选择

* 无需重构度量体系，整合 DORA、HEART、SPACE 框架，新增“AI 建议采纳率”“AI 输出验证耗时”等指标。

## 1.1 AI的作用：AI 是 “放大器”，价值依赖底层组织系统

|     |     |
| --- | --- |
| 核心结论 | 报告详情 |
| AI 在软件开发中的核心角色是放大器：它会放大高效能组织的优势（如加速交付、提升代码质量），也会放大困境组织的功能障碍（如加剧交付不稳定性、流程摩擦）。<br><br>AI 投资的最大回报并非来自工具本身，而是依赖对底层组织系统的战略性投入 —— 包括内部平台质量、工作流程清晰度、团队协调一致性。若缺乏这一基础，AI 仅能带来局部生产力提升，且易在下游混乱中流失。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/1183dacabdfe135a10df0f6f58c22ae7.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0)<br><br>该图以标准化预估效应为纵轴，展示 AI 对 10 项关键成果的影响，其中：<br><br>* AI 对 “个人效能”“代码质量”“团队效能”“组织效能” 呈正向效应（0.05-0.15）<br>* AI 对 “软件交付不稳定性” 呈负向效应（约 0.1）<br>* AI 对 “摩擦”“倦怠” 无显著影响。<br><br>直观印证了 AI 的 “放大” 属性 —— 仅在健康组织系统中，正向效应才会凸显，而系统缺陷会被 AI 放大为不稳定性等问题。 |

## 1.2 软件交付效能：七种团队类型揭示效能差异

|     |     |
| --- | --- |
| 核心结论 | 报告详情 |
| DORA 通过聚类分析（综合团队效能、产品效能、吞吐量、不稳定性、个体效能、有价值工作、摩擦、倦怠 8 项因素），识别出七种截然不同的团队类型，覆盖从 “高效能且可持续” 到 “困境型” 的全光谱。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/969ce1aefd368e5187472d9b5c4b3536.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |
| 其中：<br><br>* “和谐高成就者”（20%）与 “务实执行者”（20%）为顶尖团队，可同时实现高吞吐量与低不稳定性，打破 “速度与稳定性权衡” 的误区<br>* 而 “基础性挑战型”（10%）“遗留瓶颈型”（11%）等团队则面临效能与幸福感双重困境。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/574addd6915691b9cb35deac92e728c6.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |

## 1.3 AI 采纳与使用：普及度高，对生产力提升有明显助力，但依赖与信任呈 “谨慎态”

|     |     |
| --- | --- |
| 核心结论 | 报告详情 |
| 采纳率与使用强度：90% 的受访者在工作中使用 AI（较 2024 年提升 14.1%），日均与 AI 交互2 小时（占 8 小时工作日的 25%），2023 年底 - 2024 年中期为采纳高峰。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/a14919102365b6caff7e9831542849d0.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0)![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/a658e1e88c6761332317440800335082.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |
| 应用场景Top3（受访者使用比例）：<br><br>* 71% 用于 “编写新代码”<br>* 68% 用于 “文献综述”<br>* 66% 用于 “修改现有代码 / 校对 / 创建图像” | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/16b814a8ee04b67d30c3fa680cb27e0b.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |
| 使用频率（受访者使用比例）：<br><br>* 高频（每天数次）：聊天模式 25%、预测文本（比如代码补全）22%<br>* 低频（从不使用）：智能体模式（人工智能后台自主运行且无人监督下直接修改）61%；协作模式（广泛、协同的代码修改）38% | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/604819ca2ff28627a9a39e6432ad0a2d.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |
| 交互形式Top3（受访者使用比例）：<br><br>* 55% 使用 会话式机器人<br>* 41% 使用 开发环境（IDE）<br>* 21% 使用外部网页界面 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/dc6d05356269690488ceb3ef9a0c0020.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |
| 使用效果（受访者使用比例）：<br><br>* 个体生产力：<br>	* 超过 80% 的调查受访者表示，他们感知到人工智能提升了自身的生产力。<br>	* 有超过 40% 的人认为生产力提升仅为“轻微”。<br>	* 不到10%的受访者认为人工智能对其生产力产生了任何下降影响。<br>* 代码质量：<br>	* 59%的受访者也观察到人工智能对其代码质量产生了正面作用。<br>	* 31% 的人认为这种提升仅为“轻微”。<br>	* 30% 的人未观察到正面或负面影响。<br>	* 10%的受访者认为人工智能的使用对其代码质量带来了负面影响。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/f2c663a6b16238bbdf504e6596c52f3d.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0)![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/720013922d0082a7641ee0575531f52a.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |
| 依赖与信任：<br><br>* 70% 保持 “一定程度信任”<br>* 30% 态度保留（23%“略有信任”+7%“完全不信任”），类似对 Stack Overflow 的 “健康怀疑” 态度。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/7066cab330666bd77174b189f060b1b6.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0)<br><br>* 24% 对 AI 输出质量 “高度信任”。<br>* 65% 的用户对 AI 依赖度为 “中等及以上”。 |

## 1.4 AI 与关键成果的关系：积极效应与顽固问题并存

|     |     |
| --- | --- |
| 核心结论 | 报告详情 |
| 1. 持续积极效应：<br><br>* AI 采纳与 “个人效能”“代码质量”“团队效能”“组织效能”“有价值工作”“产品效能”“软件交付吞吐量” 呈正向关联（较 2024 年，“有价值工作”“吞吐量”“产品效能” 从负向 / 中性转为正向，体现适应性调整）。<br><br>2. 顽固问题：<br><br>* AI 对 “摩擦”“倦怠” 无显著改善<br>* 仍与 “软件交付不稳定性” 呈负向关联（AI 采纳率每提升 25%，不稳定性约增 7.2%）。根源在于：AI 仅优化 “键盘端” 工作（如代码生成），但未解决系统性问题（如流程低效、文化倦怠）。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/0dee13c5399a3470add5947d1a75e496.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0)<br><br>* 纵轴标注 “预估效应（标准化）”，橙色标注 “负向效应为理想” 的指标（如倦怠）。<br>* “软件交付不稳定性” 预估效应约 0.1（正向，非理想结果）<br>* “个人效能”“组织效能” 约 0.1（正向，理想结果）<br>* “摩擦”“倦怠” 接近 0（无显著影响） |

## 1.5 DORA 人工智能能力模型：七项能力放大 AI 价值

|     |     |
| --- | --- |
| 核心结论 | 报告详情 |
| DORA 首次提出AI 能力模型，包含七项关键能力，可显著放大 AI 的组织级价值，覆盖技术与文化层面。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/829dde5cd91e79562721c4a6e320dfa4.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |
| 1. 明确且已共识的 AI 立场：清晰传达 AI 使用政策，减少开发者保守 / 放任行为，增强 AI 对个体 / 组织效能的正向影响。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/d9cc5e57daa3fa0d804c560553eb004e.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0)![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/a971d90dd5104661e0fe93c01e52cea1.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |
| 2. 健康的数据生态系统：高质量、可访问、低孤岛化的数据，放大 AI 对组织效能的提升。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/9b2b6f18dd831e4d0ab420ac71973c22.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |
| 3. AI 可访问的内部数据：AI 连接内部代码库、文档，显著提升个体效能与代码质量。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/40bc88e0e30aaf16b9895a626731bfa8.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |
| 4. 稳健的版本控制实践：频繁提交、快速回滚，缓解 AI 引发的不稳定性，提升团队效能。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/dcbe1f382722e65e2479362459434637.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0)![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/ce6ae070c79674692bbae47d4381dddc.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |
| 5. 小批量工作：减少单次变更规模，提升产品效能、降低摩擦。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/87688423dfa4b328d68d02bf36305a6b.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |
| 6. 以用户为中心：聚焦用户需求，避免 AI 偯离目标 —— 缺乏此能力时，AI 可能损害团队效能。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/a4d70ebc03f4cacb24b07b5ecf242108.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |
| 7. 高质量的内部平台：提供标准化工具与安全防护，放大 AI 对组织效能的正向影响。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/4169b75c05d3184eb6e7c4742d8d52ee.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |

## 1.6 平台工程：普及度高，优质平台是 AI 价值倍增器。但目前平台普遍是技术功能强、用户体验弱

|     |     |
| --- | --- |
| 核心结论 | 报告详情 |
| * 核心价值：优质平台是 AI 的 “力量倍增器”—— 当平台质量高时，AI 对组织效能的正向影响显著增强；同时，平台可作为 “风险管理引擎”，在保障安全的同时支持 AI 创新（允许轻微稳定性波动）。<br>* 普及现状：<br>	* 90% 的企业已部署平台工程。<br>	* 76% 设立专职平台团队，多平台并行（29%）成为趋势，管理焦点从 “搭建平台” 转向 “治理多元生态”。<br>* 体验差距：<br>	* 平台在 “安全”“可靠性” 得分高<br>	* 但在 “反馈响应”“任务自动化” 等用户体验维度表现不足，需以 “产品思维” 打造平台（如避免 “工单运维陷阱”“象牙塔式平台”）。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/079a9130be9b71f0bec3996c44d0aeea.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0)<br><br>* 横轴为 “受访者比例”，纵轴为 “平台能力”，其中：<br>	* “安全应用构建”“可靠应用构建” 受访者认同率超 75%<br>	* “团队反馈响应机制”“自动化任务执行” 不足 50%<br>* 直观呈现 “技术功能强、用户体验弱” 的体验差距。<br><br>![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/345ef10e22b33ee3f29569d545462b06.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0)<br><br>* 横轴为 “平台分数标准化（极低 - 极高）”，纵轴为 “AI 对组织效能的影响（无实质影响 - 显著提升）”<br>* 平台分数 “极高” 时，AI 对组织效能的 “显著提升” 占比超 40%，印证 “优质平台放大 AI 价值”。 |

## 1.7 价值流管理（VSM）：AI 价值的 “倍增器”

|     |     |
| --- | --- |
| 核心结论 | 报告详情 |
| 价值流管理（VSM）是AI 投资转化为竞争优势的关键，通过可视化、分析、优化 “从创意到客户” 的工作流，确保 AI 解决系统性瓶颈，而非制造局部混乱。核心价值：<br><br>1. 提升 “有价值工作” 占比 —— 理解价值流的团队，更易聚焦关键任务。<br>2. 放大 AI 价值 —— 成熟 VSM 实践可将 AI 的局部生产力提升，转化为组织级效能（如缓解 AI 引发的不稳定性）。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/ed0c20a4cc3dfe3fe8931066cad644cb.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0)<br><br>* 横轴为 “价值流图成熟度（极低 - 极高）”，纵轴为 “AI 对组织效能的影响（未经证实 - 中等增幅）”。<br>* VSM 成熟度 “极高” 时，AI 对组织效能的 “中等增幅” 占比超 30%，显著高于 “极低” 组，印证 “VSM 是 AI 价值倍增器”。 |

## 1.8 AI 之镜：AI 反映并放大组织的真实能力

|     |     |
| --- | --- |
| 核心结论 | 报告详情 |
| AI 是组织系统的 “镜子” 与 “倍增器”：<br><br>* 反映能力：AI 会暴露组织的隐性问题（如流程低效、知识孤岛）—— 依赖脆弱流程的团队，AI 会加剧不稳定性；具备优质实践的团队（如低摩擦、高协作），AI 会加速效能提升。<br>* 系统转型必要性：AI 价值释放需配套系统变革（如优化流程、培养文化），而非仅部署工具。例如：AI 加速代码生成后，需同步升级测试、部署流水线（否则吞吐量提升会被下游瓶颈抵消）。 | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/66222505e25b37fcf182181985574ef1.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |

## 1.9 度量框架：选择适合组织目标的度量框架

|     |     |
| --- | --- |
| 度量框架类型 | 不同框架的指标选择 |
| ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/f6b00384d46644c595516d41306171dc.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) | ![resize,w_2000,m_lfit,limit_0](https://static.yximgs.com/udata/pkg/EE-KSTACK/aff9f72a182360351a85863d8b4b6814.png?x-oss-process=image/resize,w_2000,m_lfit,limit_0) |

## 2.0 从洞察到行动

1. AI 落地关键：不只是工具采购，而是 “系统重构”—— 需结合 DORA AI 能力模型、VSM、平台工程，解决底层组织问题。
2. 行动建议：

* 诊断团队类型，针对性改进（如 “遗留瓶颈型” 优先解决系统稳定性）。
* 明确 AI 立场，开放内部数据，优化版本控制。
* 以 VSM 梳理价值流，定位 AI 的最佳应用场景。

# 3\. 更多细节：完整版报告

[<u>完整版报告</u>](https://docs.corp.kuaishou.com/k/home/VPzsT13Cb4u0/fcABMyPjKLDi53T_1Ho0YAuix#section=h.lfex3q8d94ap)

# 4\. 了解更多

    Created at: 2026-03-31T15:45:53+08:00
    Updated at: 2026-03-31T19:38:01+08:00

