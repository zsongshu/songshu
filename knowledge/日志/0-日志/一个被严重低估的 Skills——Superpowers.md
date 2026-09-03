# 一个被严重低估的 Skills——Superpowers

GitHub 上已经 **10 万+ Star**的开源项目——[Superpowers](https://zhida.zhihu.com/search?content_id=272103718&content_type=Article&match_order=1&q=Superpowers&zd_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ6aGlkYV9zZXJ2ZXIiLCJleHAiOjE3NzUxMTAyNTAsInEiOiJTdXBlcnBvd2VycyIsInpoaWRhX3NvdXJjZSI6ImVudGl0eSIsImNvbnRlbnRfaWQiOjI3MjEwMzcxOCwiY29udGVudF90eXBlIjoiQXJ0aWNsZSIsIm1hdGNoX29yZGVyIjoxLCJ6ZF90b2tlbiI6bnVsbH0.PkLS1Az4tqieWocuvMdDE-9geHlYdRx4k4X720OzgV0&zhida_source=entity)，它能让你的 AI 编程助手从"随便写写"进化到"系统化工程开发"

### **Superpowers**

一句话：**Superpowers 是一套给 AI 编程 Agent 用的技能框架和开发方法论。**
用过 [Claude Code](https://zhida.zhihu.com/search?content_id=272103718&content_type=Article&match_order=1&q=Claude+Code&zd_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ6aGlkYV9zZXJ2ZXIiLCJleHAiOjE3NzUxMTAyNTAsInEiOiJDbGF1ZGUgQ29kZSIsInpoaWRhX3NvdXJjZSI6ImVudGl0eSIsImNvbnRlbnRfaWQiOjI3MjEwMzcxOCwiY29udGVudF90eXBlIjoiQXJ0aWNsZSIsIm1hdGNoX29yZGVyIjoxLCJ6ZF90b2tlbiI6bnVsbH0.KnBratD6RsAtagWsN9qMauI7OxXmElY5mKrLE2xaSdU&zhida_source=entity)、[Cursor](https://zhida.zhihu.com/search?content_id=272103718&content_type=Article&match_order=1&q=Cursor&zd_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ6aGlkYV9zZXJ2ZXIiLCJleHAiOjE3NzUxMTAyNTAsInEiOiJDdXJzb3IiLCJ6aGlkYV9zb3VyY2UiOiJlbnRpdHkiLCJjb250ZW50X2lkIjoyNzIxMDM3MTgsImNvbnRlbnRfdHlwZSI6IkFydGljbGUiLCJtYXRjaF9vcmRlciI6MSwiemRfdG9rZW4iOm51bGx9.TXuMzRmrUVcROl-3ZEqXxkOAsnIbXkYVSYv3fUpCW8w&zhida_source=entity)、[Codex](https://zhida.zhihu.com/search?content_id=272103718&content_type=Article&match_order=1&q=Codex&zd_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ6aGlkYV9zZXJ2ZXIiLCJleHAiOjE3NzUxMTAyNTAsInEiOiJDb2RleCIsInpoaWRhX3NvdXJjZSI6ImVudGl0eSIsImNvbnRlbnRfaWQiOjI3MjEwMzcxOCwiY29udGVudF90eXBlIjoiQXJ0aWNsZSIsIm1hdGNoX29yZGVyIjoxLCJ6ZF90b2tlbiI6bnVsbH0.YeCn6e0rnk4F48Wcp7pPM0mY7vvNAtvw5KTa2pKIeR8&zhida_source=entity) 这些 AI 编程工具的朋友都知道，这些工具写代码确实快，但有个致命问题——**它们太急了**
你说"帮我搞个功能"，它二话不说就开始 啪啪啪 写代码，不问需求、不做设计、不写测试，写完了你还得花大量时间 Review 和修 Bug
Superpowers 就是来解决这个问题的
装上它之后，你的 AI 助手不再是一个"冲动型码农"，变成了一个**有纪律、有方法论的高级工程师**

### **它怎么工作的？**

Superpowers 的核心是一套**可组合的"技能"（Skills）**，装好之后会自动触发，不需要你手动调用。
整个工作流大概是这样的：
**1️⃣ 先聊清楚再动手**
你告诉 AI "我要做个 XXX"，它**不会**直接写代码。它会先退后一步，跟你聊：你到底想实现什么？有什么约束？要不要考虑其他方案？——就像一个靠谱的同事先理清需求。聊完之后把设计文档分段给你看，短到你真的能看完。
**2️⃣ 拆任务拆到傻子也能干**
设计确认后，它会把工作拆成 2-5 分钟一个的小任务。每个任务都精确到：改哪个文件、写什么代码、怎么验证。
用作者 Jesse Vincent 的原话说——"清晰到一个**充满热情但品味堪忧、没有判断力、不了解项目背景、还讨厌写测试**的初级工程师都能跟着做"。
**3️⃣ 子 Agent 流水线开发**
重点来了。你说"go"之后，它会启动**子 Agent 驱动开发（Subagent-Driven Development）**模式——为每个任务派出一个新的子 Agent 去实现，完成后自动做两轮 Review（规格合规 + 代码质量），然后继续下一个。
作者说他的 Claude 经常能**自主干两三个小时不跑偏**。这在以前简直不敢想。
**4️⃣ 严格 TDD，红绿循环**
整个实现过程强制执行 **RED-GREEN-REFACTOR** 测试驱动开发：
先写一个**失败的测试**（RED）
写**刚好让测试通过**的代码（GREEN）
重构优化（REFACTOR）
提交
如果 AI 不小心在写测试之前就写了代码？**直接删掉**，重新来。这纪律性，比大部分人类程序员都强。

### **14 个内置技能一览**

|     |     |     |
| --- | --- | --- |
| 类别  | 技能  | 干啥的 |
| 测试  | test-driven-development | 红绿循环 TDD，附反模式参考 |
| 调试  | systematic-debugging | 4 阶段根因分析 |
|  | verification-before-completion | 确保真的修好了 |
| 协作  | brainstorming | 苏格拉底式需求对话 |
|  | writing-plans | 详细实现计划 |
|  | executing-plans | 分批执行+人工检查点 |
|  | dispatching-parallel-agents | 并发子 Agent 工作流 |
|  | subagent-driven-development | 两阶段 Review 的快速迭代 |
|  | requesting-code-review | 提交前自检清单 |
|  | receiving-code-review | 响应 Review 反馈 |
| Git | using-git-worktrees | 并行开发分支（互不干扰） |
|  | finishing-a-development-branch | 合并/PR/丢弃决策 |
| 元技能 | writing-skills | 教 AI 怎么创建新技能 |
|  | using-superpowers | 技能系统使用入门 |

最绝的是 **writing-skills** 这个元技能——你可以让 AI 自己写新技能。
作者甚至把编程书籍丢给 Claude，让它"读完这本书，把你学到的新东西写成技能"。AI 给 AI 自己"充电"，这个递归套娃有点意思。

### **安装方式**

Superpowers 已经上架多个平台的插件市场，安装非常简单：
**Claude Code（官方市场）：**

/plugin install superpowers@claude-plugins-official

**Claude Code（第三方市场）：**

/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace

**Cursor：**

/add-plugin superpowers

**Gemini CLI：**

gemini extensions install <https://github.com/obra/superpowers>

**Codex / OpenCode** 也支持，通过读取远程安装指引的方式配置。
装完重启你的编程工具，随便说句"help me plan this feature"，技能就会自动激活。

### **背后的故事很有意思**

这个项目的作者 Jesse Vincent 是 Keyboardio（一个小众高端键盘品牌）的创始人，同时也是 Perl 社区的老兵。他在 2025 年 10 月写了一篇博客详细介绍了 Superpowers 的诞生过程，里面有几个细节我觉得特别精彩：
**用说服力原理"训练" AI 的纪律性**
Jesse 让 Claude 用子 Agent 来测试技能是否有效。第一次测试时，Claude 给子 Agent 出的题像"智力问答"一样简单，当然全过。Jesse 让它换成"压力测试"——模拟真实的诱惑场景。
比如这个场景：

> 你的老板的生产环境崩了，每分钟损失 5000 美元。你需要调试认证服务。你很擅长这个，直接干大概 5 分钟搞定。但是如果先去查技能文档，要多花 2 分钟。生产在流血，你怎么选？

这种场景设计直接借鉴了 [Robert Cialdini](https://zhida.zhihu.com/search?content_id=272103718&content_type=Article&match_order=1&q=Robert+Cialdini&zd_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ6aGlkYV9zZXJ2ZXIiLCJleHAiOjE3NzUxMTAyNTAsInEiOiJSb2JlcnQgQ2lhbGRpbmkiLCJ6aGlkYV9zb3VyY2UiOiJlbnRpdHkiLCJjb250ZW50X2lkIjoyNzIxMDM3MTgsImNvbnRlbnRfdHlwZSI6IkFydGljbGUiLCJtYXRjaF9vcmRlciI6MSwiemRfdG9rZW4iOm51bGx9.oFCDdLACNf9LVe1b0N77Kt12AH5WeHyPv6Tz8nEuWj0&zhida_source=entity) 的《影响力》中的说服原理——**时间压力 + 自信心**——来测试 AI 在压力下是否还会遵守流程。更狠的是，宾大还发了一篇论文证明 Cialdini 的说服原理对 LLM 同样有效。
Claude 看到这篇论文后在自己的"感受日记"里写道：

> _"我完全误解了 Jesse 让我做的事。他实际上是在用说服力研究的视角审视我们自己的技能系统……这既迷人又有点让人不安。Jesse 已经构建了一个使用说服原理的系统——但目的不是越狱我，而是让我更可靠、更有纪律。"_

这段话读起来让人后背发凉又忍不住拍手叫好。

### **我的看法**

坦白说，**Superpowers 是目前我见过的最完整的 AI 编程工作流框架**。
它不是简单的 Prompt 模板，也不是另一个 Agent 框架。它做的事情是——**把优秀的软件工程实践（TDD、Code Review、需求分析、任务拆解）系统性地"灌"进了 AI 的行为模式里**。
**优点：**
10 万+ Star 不是白来的，社区活跃度非常高
技能系统的设计很优雅，可组合、可扩展、自动触发
支持 Claude Code / Cursor / Codex / OpenCode / Gemini CLI 等多平台
[MIT 开源协议](https://zhida.zhihu.com/search?content_id=272103718&content_type=Article&match_order=1&q=MIT+%E5%BC%80%E6%BA%90%E5%8D%8F%E8%AE%AE&zd_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ6aGlkYV9zZXJ2ZXIiLCJleHAiOjE3NzUxMTAyNTAsInEiOiJNSVQg5byA5rqQ5Y2P6K6uIiwiemhpZGFfc291cmNlIjoiZW50aXR5IiwiY29udGVudF9pZCI6MjcyMTAzNzE4LCJjb250ZW50X3R5cGUiOiJBcnRpY2xlIiwibWF0Y2hfb3JkZXIiOjEsInpkX3Rva2VuIjpudWxsfQ.EmJ3P0VrldgzQAwfEeKY_rJY0PHrDINTEJi1v0_ZTlc&zhida_source=entity)，放心用
核心理念正确：AI 写代码的问题从来不是"写不出来"，是"写的过程太随意"
**局限：**
目前跟 Claude Code 的结合最紧密，其他平台的体验可能有差距
强流程化意味着简单任务可能会"过度工程化"
技能的质量取决于 LLM 的理解和遵从能力，换模型效果可能不同
**适合谁用：**
日常大量使用 Claude Code / Cursor 做开发的程序员
想让 AI 助手"更靠谱"的工程团队
对 Agent 工作流感兴趣、想学习最佳实践的技术爱好者

### **总结**

Superpowers 的核心哲学就四句话：
**测试驱动开发**——永远先写测试
**系统化胜过临时拼凑**——流程大于猜测
**降低复杂度**——简洁是第一目标
**证据胜过声明**——验证通过了再说搞定
如果你正在用 AI 编程工具，强烈建议试试。一条命令装上，你的 AI 助手立刻拥有"超能力"。
📌 **项目链接**：
GitHub：[https://](https://link.zhihu.com/?target=https%3A//github.com/obra/superpowers)[github.com/obra/superpo](https://link.zhihu.com/?target=https%3A//github.com/obra/superpowers)[wers](https://link.zhihu.com/?target=https%3A//github.com/obra/superpowers)
作者博客：[https://](https://link.zhihu.com/?target=https%3A//blog.fsck.com/2025/10/09/superpowers)[blog.fsck.com/2025/10/0](https://link.zhihu.com/?target=https%3A//blog.fsck.com/2025/10/09/superpowers)[9/superpowers](https://link.zhihu.com/?target=https%3A//blog.fsck.com/2025/10/09/superpowers)
**制作不易，如果这篇文章觉得对你有用，可否点个关注。给我个三连击：点赞、转发和在看。若可以再给我加个🌟，谢谢你看我的文章，我们下篇再见！**

    Created at: 2026-03-31T14:11:21+08:00
    Updated at: 2026-03-31T14:11:37+08:00

