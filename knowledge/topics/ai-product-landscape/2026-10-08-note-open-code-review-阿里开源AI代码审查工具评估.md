# Open Code Review（阿里开源 AI 代码审查工具）评估

- 日期：2026-10-08
- 类型：note
- 触发：张松树转发公众号文章《阿里开源了个神器，给WorkBuddy、豆包挑毛病》（"人人都是产品经理"，作者"怪哥"，2026-10-08 15:38）

## 结论

1. **文章的主角是 Open Code Review（OCR），不是 WorkBuddy**。WorkBuddy 只被借来做流量钩子；作者是自媒体，非腾讯/阿里官方，且**自认文中 WorkBuddy 接入方案未实测**。
2. **工具本身是真东西**：阿里内部跑了两年的 AI 代码审查助手开源，Apache-2.0，`github.com/alibaba/open-code-review`，21k star。卖点是「确定性工程 × Agent 混合架构」，专门治通用 Agent 审代码的三宗罪——覆盖不全、位置漂移、效果不稳定。
3. **"神器"要打折**：官方 AACR-Bench 绝对成绩并不高（准确率 33.9% / 召回 20.0% / F1 25.1%，Claude-4.6-Opus 组合）。它是"低噪声提示器"，不是"上线守门员"。
4. **值得采纳的观点**：Vibe Coding 下一段竞争在「验收」（代码审查 / 自动测试 / 安全检测 / 业务逻辑验收），不在继续拼生成。

## 关键事实

| 项 | 内容 |
|---|---|
| 仓库 | https://github.com/alibaba/open-code-review （Apache-2.0, Copyright 2026 Alibaba） |
| 官网/文档 | https://open-codereview.ai/docs |
| 安装 | `npm install -g @alibaba-group/open-code-review`（前置：Git >= 2.41） |
| 核心命令 | `ocr review`（Git diff，工作区/分支区间/单 commit）、`ocr scan`（全文件扫描，无需 git 历史）、`ocr config provider/model` |
| 输出 | `ocr review --format json --output result.json`（推荐给宿主 agent 读） |
| 委托模式 | `ocr delegate preview` / `ocr delegate rule <files>` —— 不配 LLM，把审查交给宿主编程 agent 自己的模型 |
| 已有集成 | Claude Code / Codex / Cursor / Kimi Code / OpenCode / QCA Forward 插件；MCP Server；Skill-compatible agents；GitHub Actions / GitLab CI / GitFlic CI / Gerrit |
| 基准 | AACR-Bench：50 仓库 × 200 真实 PR × 10 语言，80+ 资深工程师交叉标注，1505 个 ground-truth 缺陷 |
| 数据集 | https://huggingface.co/datasets/Alibaba-Aone/aacr-bench |

### AACR-Bench 成绩（同档 Claude 系模型）

| 工具 | 准确率 Precision | 召回率 Recall | F1 | 耗时 | Token |
|---|---|---|---|---|---|
| Open Code Review | 33.9% | 20.0% | 25.1% | 1m23s | 385K |
| 通用 Agent（Claude Code） | 15.9% | 12.7% | 14.1% | 5m38s | 2,062K |

- 官方口径：F1 / Precision 显著更高，token 约 1/9，更快；**Recall 刻意低于通用 Agent**（换低噪声）。
- 换算成人话：报 3 个问题约 1 个是真的；5 个真缺陷约捞到 1 个。

## 核心设计（值得记）

- **确定性工程管"不能出错"的环节**：精准文件筛选、智能文件打包（关联文件合成一个审查单元，各自 sub-agent 且上下文隔离，可并发）、细粒度规则匹配（模板引擎，比语言驱动稳定）、独立的评论定位 + 评论反思模块。
- **Agent 管动态决策**：场景化 prompt 模板、从海量线上工具调用轨迹里沉淀的专用工具集。
- 设计哲学一句话：**纯语言驱动的架构缺乏对流程的强约束**。

## 对张松树的适用性

1. 技术栈（Java / 中间件 / 数据库 / 分布式）与内置规则（NPE、线程安全、XSS、SQL 注入）高度对口。
2. 他刚接入 Codex —— OCR 有官方 **Codex 插件**与 **Skill-compatible agents** 入口，比文章那套"CLI + 手工提示词"方案干净。
3. 定位必须摆正：与单测 / CI / 业务验收是**正交**的两件事，不能折叠成一件。召回 20% 决定它不可能是最后一道防线。

## 待办 / 下一步

- [ ] （可选）把 OCR 接成 Codex 或 WorkBuddy 的 Skill，跑通 `ocr scan --preview` → 审查 → 中文报告。
- [ ] （可选）挑一个真实项目试跑，用实际命中率验证 benchmark，而不是只看官方数字。

## 备注

- 文章提供的"WorkBuddy 代码检查提示词"可作参考模板，但作者未实测，且需注意：调用外部模型产生 API 费用；商业/隐私项目的代码会发往第三方模型服务。
