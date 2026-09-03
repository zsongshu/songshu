# 非典型用户的一周体验：不止写代码，我用 CodeFlicker 搞调研、做PPT、写文档、生图，差点以为自己有了助理

文章摘要：很多同学可能还停留在"CodeFlicker = AI编程助手"的认知上。今天我想分享一下过去几周的真实体验：CodeFlicker 远不止写代码，它帮我完成了产品设计、PPT制作、文档审校、网站部署等各种任务。
📌

很多同学可能还停留在"CodeFlicker = AI编程助手"的认知上。今天我想分享一下过去几周的真实体验：CodeFlicker 远不止写代码，它帮我完成了产品设计、PPT制作、文档审校、网站部署等各种任务，体验下来真的有点像 Cursor + Manus + Loveable + Others —— 一个能帮你做各种事情的 AI 助手。

![1d054d91-5e6b-4bb8-95fc-2d39e822c262.png](https://cdnfile.corp.kuaishou.com/kc/files/a/design-ai/poify-comfy/1d054d91-5e6b-4bb8-95fc-2d39e822c262.png)

# 📊 这周我用 CodeFlicker 做过的事情

|     |     |     |
| --- | --- | --- |
| 工作分类 | 做了啥 | 交付的项目数 |
| 📄 文档类 | 文档审校、文案撰写、技术调研 | 5+  |
| 🖥️ 开发类 | 前端开发、可视化、UI设计 | 5+  |
| 🎨 创意类 | PPT制作、配图生成 | 2+  |
| 🚀 运维类 | 网站部署、性能优化 | 3+  |

下面我会按类别分享具体案例，每个案例都会详细说明我是怎么用 CodeFlicker 一步步完成的，希望能给大家一些参考。

---

# 📄 文档类场景

## 案例1：技术文档审校

![d0c3b3dac2f1437457ed44943a4899ba.png](https://h23.static.yximgs.com/udata/pkg/EE-KSTACK/d0c3b3dac2f1437457ed44943a4899ba.png)

背景：有一篇内部文档《万人组织 AI研发范式 跃迁之路》，需要检查错别字、格式错误和数据描述问题。

我做了什么：

![f5f31689505076eb2a479c75e9b6d05a.png](https://h4.static.yximgs.com/udata/pkg/EE-KSTACK/f5f31689505076eb2a479c75e9b6d05a.png)

CodeFlicker 做了什么：

* 发现1处描述错误（包含关系表述错误）
* 发现1处格式错误（列表编号顺序颠倒）
* 验证了核心数据计算是否正确（如180.21%的提升率）

💡 学习要点：CodeFlicker 不仅能找错别字，还能验证数据计算、检查逻辑一致性。

---

## 案例2：Agent 架构技术调研

![9c34a00e844573c96a3c0c626b6ebacd.png](https://h23.static.yximgs.com/udata/pkg/EE-KSTACK/9c34a00e844573c96a3c0c626b6ebacd.png)

背景：需要研究业界主流的 Agent 架构设计。

我做了什么：

* 第一步：帮我调研目前业界主流的 Agent 架构设计
* 第二步：重点分析一下编排层的设计
* 第三步：根据调研结果，设计一个6层的 Agent Infra 理想架构

CodeFlicker 做了什么：

* 生成了完整的6层架构设计页面，包含30+核心组件，可直接访问查看。

💡 学习要点：调研类任务可以分步骤进行，先广度后深度，最后生成可交付的成果。

---

# 🖥️ 开发类场景

## 案例3：D3.js 关系图可视化开发

![2dd6884ef5c1a61222e2f107046733f3.png](https://h23.static.yximgs.com/udata/pkg/EE-KSTACK/2dd6884ef5c1a61222e2f107046733f3.png)

背景：我需要为一个企业AI工程师分析项目创建一个交互式关系图，展示48个工作任务和9种Agent类型之间的关系。

我做了什么：

* 第一步：描述需求
	* 我：帮我实现一个关系图可视化功能，展示工作任务和Agent类型的关系
* 第二步：迭代细化
	* 我：添加缩放控制功能，支持放大/缩小/重置/适应窗口
* 第三步：调试优化
	* 我：节点有点挤，帮我调整一下布局

CodeFlicker 做了什么：

1. 自动创建了 network-graph.js，使用 D3.js 实现力导向图
2. 添加了完整的缩放控件和交互逻辑
3. 实现了节点拖拽、连线高亮等交互效果
4. 自动适配了项目的CSS风格

💡 学习要点：不需要一次性描述清楚所有需求，可以先给大方向，然后逐步迭代细化。

---

## 案例4：详情页开发

背景：需要为9种Agent类型各创建一个详细介绍页面。

我做了什么：

就这一句话：为9种Agent类型创建详细的介绍页面，包含技术特点、实现原理、应用场景和产品案例

CodeFlicker 做了什么：

创建了完整的HTML+CSS页面，为每种Agent设计了统一的卡片模板，填充了技术架构图和产品案例。

💡 学习要点：如果任务比较明确，可以一次性描述清楚，让 CodeFlicker 一次性完成。

---

# 🎨 创意类场景

### 案例5：专业 PPT 制作

![c02f152d3d3ba9cf43c280270e8094ae.png](https://h23.static.yximgs.com/udata/pkg/EE-KSTACK/c02f152d3d3ba9cf43c280270e8094ae.png)

我做了什么：

* 我：帮我创建一个 PPT
* CodeFlicker：您想创建什么主题的 PPT？
* 我：企业AI工程师产品体系

CodeFlicker 做了什么：

1. 分析了项目内容，提取核心信息
2. 设计了配色方案（深海军蓝主题）
3. 创建了8页幻灯片
4. 使用 pptxgenjs 生成了真正的 .pptx 文件

最终效果：221KB 的专业演示文稿，可以直接用于汇报。

💡 学习要点：CodeFlicker 可以直接生成 .pptx 文件，不只是给你代码。

---

# 🚀 运维类场景

## 案例6：多平台网站部署

![58bb27cb5f726ce0c505b1b452f2670a.png](https://h23.static.yximgs.com/udata/pkg/EE-KSTACK/58bb27cb5f726ce0c505b1b452f2670a.png)

我做了什么：项目能否在中国国内完成部署，让别人不登录VPN也能访问？

CodeFlicker 做了什么：依次尝试了 Gitee Pages（已关闭）→ 腾讯云（需验证）→ Cloudflare（安全验证）→ GitHub Pages（成功！）

💡 学习要点：遇到问题时，CodeFlicker 会自动尝试替代方案。

---

## 案例7：网站性能优化

![cd158e2f722660179e8f7fe3e25fb3b4.png](https://h23.static.yximgs.com/udata/pkg/EE-KSTACK/cd158e2f722660179e8f7fe3e25fb3b4.png)

我做了什么：页面访问比较卡顿，能否提升一下页面加载性能？

CodeFlicker 做了什么：自动开始优化网页

优化效果：

* 图片：16 MB → 483 KB（减少 97%）
* CSS：130 KB → 95 KB（减少 27%）
* JS：63 KB → 34 KB（减少 46%）

---

# 🧠 我直观感受到的3种产品新能力

## 它有记忆 —— 越用越懂我

![ede5b8bae790c361b370b8d9a7cde8bd.png](https://h23.static.yximgs.com/udata/pkg/EE-KSTACK/ede5b8bae790c361b370b8d9a7cde8bd.png)

💡 学习要点：多用几次，CodeFlicker 会越来越懂你，效率越来越高。

---

## Duet Space 模式 —— 多任务并行

![6c76e4e1157d526af6854dff829d0007.png](https://h2.static.yximgs.com/udata/pkg/EE-KSTACK/6c76e4e1157d526af6854dff829d0007.png)

Hub

💡 学习要点：复杂任务拆分成多个会话并行执行，像有多个助理同时帮你干活。

---

## Skills 技能系统 —— 让 AI 掌握专业技能

![095188cd71f12f4580a32d8043f7a2d8.png](https://h23.static.yximgs.com/udata/pkg/EE-KSTACK/095188cd71f12f4580a32d8043f7a2d8.png)

💡 学习要点：安装专业技能包，让 CodeFlicker 在特定领域表现得像专家一样专业。

# 🎓 总结：如何用好 CodeFlicker

1. 不要局限于"写代码" —— 它能做PPT、审校文档、部署网站、技术调研...
2. 学会"渐进式交互" —— 先给大方向，然后逐步迭代
3. 遇到问题不要放弃 —— CodeFlicker 会自动尝试替代方案
4. 善用"继续"和"进一步" —— 它会继续深入优化
5. 让它学习特定风格 —— 先分析目标风格，再按风格创作

---

# 🚀 最后

这篇文章本身，也是用 CodeFlicker 帮我写的 😄，我来指导，它来分析我一周内做过的所有的项目，自己进行提炼、总结、生成文章。我在开会的空挡，定期看一眼，给它反馈，它就能持续出活。真是我的好助手。

# 🚀 怎么体验

* 了解产品：[CodeFlicker：从 Code Copilot 到 Agentic Coding](https://docs.corp.kuaishou.com/k/home/VUOzPbLd4vEk/fcAAprgD8Zgo_0FRZKF7CBUk5)
* 推荐用法：

1. 下载原生AI IDE：[<u>链接</u>](https://codeflicker.corp.kuaishou.com/download)
2. 开启Duet Space + Auto模式，布置你的任务
	

![321f03d7375eafb49ebf08761753007d.png](https://h23.static.yximgs.com/udata/pkg/EE-KSTACK/321f03d7375eafb49ebf08761753007d.png)

1. _🔥 友情提示：第一次用可能会觉得"这也能做？"，多尝试几次，你会发现它能做的远超你的想象！如果你也有类似的体验，欢迎在评论区分享！_

    Created at: 2026-03-31T15:39:05+08:00
    Updated at: 2026-03-31T19:38:04+08:00

