---
title: "MCP不止工具调用！MCP联合创建者：绝大多数人用法都太初级！曝MCP五大原语、高阶玩法：丰富人机交"
source: "MCP不止工具调用！MCP联合创建者：绝大多数人用法都太初级！曝MCP五大原语、高阶玩法：丰富人机交.docx"
type: docx
tags: ["docx"]
path: "777-AI-技术"
created: 2026-07-03
---

# MCP不止工具调用！MCP联合创建者：绝大多数人用法都太初级！曝MCP五大原语、高阶玩法：丰富人机交

![[MCP不止工具调用！MCP联合创建者：绝大多数人用法都太初级！曝MCP五大原语、高阶玩法：丰富人机交-bcfc2620.docx]]

## 内容

上周末，Anthropic 一口气放出了很多内部核心贡献工程师的分享。此前小编分享了[[他们内部的 ClaudeCode 的最佳实践指南]{.underline}](https://mp.weixin.qq.com/s?__biz=MjM5ODI5Njc2MA==&mid=2655927959&idx=1&sn=780ad53f8ff3ff8897e00ec8b1e87517&scene=21#wechat_redirect)，今天一不留神，发现他们把 MCP 协议的设计哲学、开发技巧、未来计划也同步放了出来。

如今，没有哪家大厂不拥抱 MCP。不止国内的阿里、字节、腾讯、百度、京东，即便是国外的即便是 Anthropic 死对头的 OpenAI 也表示全面支持 MCP 协议。

所以，这次 Anthropic 将内部分享放出来，可以说是又"哥们儿"了一把。

这次的分享者是，David Soria Parra，是他们 AI 技术团队成员，同时也是MCP 的联合创建者。

"MCP 服务将不再只是本地 Docker 容器，**而是一个网站。Web 化才是 MCP 未来的关键。**"

"**大多数人使用MCP都太简单了**，它不止是工具调用，它**还**可以做很多丰富人机交互体验的部分。"

在"Code w/ Claude" 分享中，David 详细解构了 MCP 的五大原语钥匙：Prompt、Resource、Sampling、Roots、Tool，每一个原语背后都是一个潜力巨大的交互魔法，并进一步阐述了 MCP 团队正在计划开展的工作，比如构建复杂的 MCP 链式调用等。

总之，MCP 协议的设计哲学、原语组合方式、Web 化趋势，包括一些挂件的技术细节，比如：如何鉴权、如何Scaling等等，以及未来它可能带来的革命性变革，全都在这场分享里了。

![](media/cddf4292e0260a1a2615529c3dd71062.webp){width="8.010416666666666in" height="3.8958333333333335in"}

**如果大家正在构建自己的 AI 应用，或者正在研究 MCP，这篇内容，值得你收藏细看。**

**话不多说，分享的原文整理如下。**

![](media/38ecb0ddaf2bc29c4665db1943f7dea8.webp){width="8.010416666666666in" height="1.03125in"}

**联合创建者：大多数人都没有用好MCP**

大家好，我叫 David，是 Anthropic 的一名技术工程师，同时也是 MCP 协议的联合创建者之一。今天我想和大家分享一些关于这个协议的深入内容，特别是它的更多可能性。

![](media/879a17677e475cd873b0ba8fa693c6c2.webp){width="8.010416666666666in" height="4.520833333333333in"}

目前，大多数人使用 MCP 协议主要是为了调用工具（Tool Calls），但实际上它的能力远不止于此。我的目标是向你展示 MCP 协议还能做什么，以及你如何用它构建更丰富的人机交互体验，尤其是超越传统工具调用的那部分。

![](media/bcc087901e8d757814eb91907af08e3d.webp){width="8.010416666666666in" height="4.625in"}

我会先介绍一些我们称为"原语（primitives）"的概念，也就是 MCP 协议中服务器向客户端暴露信息的基本方式。之后，我会分享一些鲜为人知但非常实用的协议能力，最后再谈谈 MCP 的未来发展方向，尤其是如何将它引入 Web 世界。

![](media/eccaa7872eaa9ca757f806163e307faf.webp){width="8.010416666666666in" height="1.03125in"}

**Prompt：被忽视的"预设模版"**

我们先从一种鲜有人知的 MCP 原语说起：Prompt。

这里的 Prompt 并不是我们通常理解的"提示词"，在 MCP 中，它是一种由服务器预设的 AI 交互模版，用户可以直接将这些文本模版添加进上下文窗口，从而引导 AI 如何与你的 MCP 服务交互。

![](media/081363cf6b3649d437972cea285a66dd.webp){width="8.010416666666666in" height="4.489583333333333in"}

主要有两个用途：

1.  **作为使用示例**：你作为 MCP 服务器的开发者最了解它的用法，因此提供 Prompt 给用户，是一个传达最佳使用方式的好方法。

2.  **动态能力**：Prompt 本质上是可以执行的代码，因此不仅是静态文案，而是动态模版。你可以让它根据上下文或参数实时生成内容。

举个例子，我在 Z 编辑器中使用 MCP Prompt 从 GitHub 拉取我提交的 PR 评论，并把它们注入到上下文窗口中，这样我就能直接让模型帮助我修改代码或处理评审反馈。

这与 Tool 的最大区别在于：**Prompt 是用户主动触发的行为，而 Tool 是模型决定何时调用的行为**。

进一步地，Prompt 还能支持"补全"。比如，当用户触发某个 Prompt 时，弹出列表让他选择具体的 Pull Request，这是一个通过参数动态构造 Prompt 的方式。

![](media/b84a096c0fdc959f99b07b23a06f330a.webp){width="8.010416666666666in" height="4.135416666666667in"}

这其实很简单，在 TypeScript 中用不到几行代码就能实现，而且大多数时候 Claude Code + Claude 4 模型本身就能帮你自动完成。

![](media/9acfcf6db256d2adf6dbdf10e4c80092.webp){width="8.010416666666666in" height="4.0in"}

![](media/6ecae8349c57a8408172044f72247bc6.webp){width="8.010416666666666in" height="1.03125in"}

**Resource：上下文之外的资源暴露**

第二个原语是 Resource，资源。

与 Prompt 更偏向文本片段不同，Resource 是暴露给客户端的原始内容或数据，比如文件、数据库结构、网页等等。

![](media/7b85888f07561733ea36c868de4040cc.webp){width="8.010416666666666in" height="4.104166666666667in"}

它的作用：

3.  用户可以选择将其添加进上下文，和 Prompt 类似；

4.  应用层还能基于它进行额外处理，比如构建 Embedding 并进行 RAG（检索增强生成）。

举个例子，我在 Cloud Desktop 中"暴露"了一份 PostgreSQL 数据库的 Schema，并将其作为文件资源加载进来，接着 Claude 自动为我绘制了一张可视化数据库结构图。

![](media/306ede31cfa1840d962da87ff9bda331.webp){width="8.010416666666666in" height="4.114583333333333in"}

Resource 给应用端提供了非常大的扩展空间。

![](media/1ceecb6efcc6f6ce1d602004b8b03be5.webp){width="8.010416666666666in" height="1.03125in"}

**Tool：模型主导的行为调用**

第三个原语是大家最熟悉的------Tool，也就是工具调用。**大多数人开发 MCP 服务就是为了暴露 Tool，让模型可以主动调用某个动作，比如查询数据库、执行脚本等。**

![](media/c9dbad8a8a7ac0f5b96473e74401e161.webp){width="8.010416666666666in" height="4.333333333333333in"}

这是你第一次看到模型"自动做一件你写好的事"时最有魔力的时刻。Tool 是由模型驱动触发的行为。

![](media/30c30b875965be189af24494677925e4.webp){width="8.010416666666666in" height="1.03125in"}

**Interaction Model：三者的协作逻辑**

现在我们已经有了三种原语（Prompt、Resource、Tool），但你可能会问：我该什么时候用哪个？

![](media/12ec50de1997a409efc0219d32a91697.webp){width="8.010416666666666in" height="4.270833333333333in"}

这就需要引入 MCP 中一个被低估的设计：**交互模型（Interaction Model）**。

![](media/e230a6a0c2e4514cc65f722b37814a12.webp){width="8.010416666666666in" height="3.7395833333333335in"}

它描述的是：

- Prompt 是用户主导的（例如 Slash 命令）；

- Resource 是应用主导的（自动加载或推荐）；

- Tool 是模型主导的（由 AI 自动决定何时调用）。

一个完善的 AI 应用，就应该协调好这三者的关系，从而**在用户、应用、模型三者之间建立更丰富的交互链条**。

![](media/3ac4f8c019a0aa02f9c8e10ff5579a9a.webp){width="8.010416666666666in" height="3.8229166666666665in"}

![](media/fe35f4c59f4402dfbdb3d19ed28b1396.webp){width="8.010416666666666in" height="1.03125in"}

**Sampling：让模型调用"由客户端控制"**

接下来介绍一个更高级但目前支持较少的原语：**Sampling**。

假设你做了一个 MCP 服务器，功能是总结 Issue Tracker 的对话。你可能想调用 Claude 来生成摘要，但此时有个问题：你不知道客户端用的是哪种模型，也没有用户的 API Key。

Sampling 提供了解法：**让服务器向客户端发起一个"请求补全"的调用**，由客户端选定模型并返回结果。好处是：

5.  用户完全掌控成本、安全、隐私；

6.  **多个 MCP 服务可以串联，通过 Sampling 递归地请求模型补全**，构建复杂的链式调用（**Chain of MCP Servers**）。(*这里是个重点*)

![](media/a774ad1f83c69555d4e7dfc39b173807.webp){width="8.010416666666666in" height="4.072916666666667in"}

![](media/13162e17403c2fe5520e078dcf0e76ee.webp){width="8.010416666666666in" height="4.072916666666667in"}

虽然目前还不太被广泛支持，但我们计划在今年为官方产品引入 Sampling 能力。

![](media/bddf515d40b9042e5bb4b29554a72245.webp){width="8.010416666666666in" height="1.03125in"}

**Roots：获取客户端环境信息**

另一个很少被提到但很实用的原语是：**Roots**。

比如你想做一个 MCP Git 工具，帮用户在 VS Code 中操作 Git 命令。你需要知道：当前打开的项目路径是啥？Roots 就是让 MCP 服务可以向客户端（如 VS Code）询问这些环境信息，从而限定操作范围，避免误操作。

![](media/1d11c96049174a4a366654447b0badce.webp){width="8.010416666666666in" height="4.083333333333333in"}

![](media/01148f444d0ac6f582130fa0c030af5e.webp){width="8.010416666666666in" height="1.03125in"}

**五大原语总结**

所以 MCP 协议目前包含五个核心原语：

- **Prompt**（用户主动）

- **Resource**（应用主动）

- **Tool**（模型主动）

- **Sampling**（客户端协助补全）

- **Roots**（客户端环境交互）

如何将它们组合，是构建强大 AI 服务体验的关键。

![](media/b3cf2f687841f16bb184fe01bd595358.webp){width="8.010416666666666in" height="4.447916666666667in"}

![](media/27e91c601d8833d9fbe983718178281c.webp){width="8.010416666666666in" height="1.03125in"}

**MCP 的未来：Web 化**

目前超过一万个 MCP 服务都运行在本地环境中。但我们认为 MCP 的未来在 Web。

![](media/f1f04892ca5379c4a1b07add5a960e98.webp){width="8.010416666666666in" height="3.9791666666666665in"}

**Web 化 MCP 服务**意味着：

- **MCP 服务**将不再是本地 Docker 容器，**而是一个网站**；

- 客户端直接连接网站暴露的 MCP 接口进行交互。

为实现这一点，我们必须解决**两个核心问题**：

![](media/ec9abe0c46ae4ecf36185a72c97a1dac.webp){width="8.010416666666666in" height="3.9270833333333335in"}

**1. 鉴权（Authorization）**

我们采用 OAuth 2.1 协议，让用户通过 Web 登录授权后，将其私有数据安全暴露给 MCP 服务。

这不仅让服务更可信（你信的是官网而非陌生开发者），也便于企业集成，例如通过 Azure AD、Okta 等单点登录系统完成企业内部 MCP 服务部署。

![](media/11497e0a8dda81c1b735e4d0218ec540.webp){width="8.010416666666666in" height="4.354166666666667in"}

![](media/6b9c4c39690c1c4bdcd9e7990e471a8f.webp){width="8.010416666666666in" height="4.416666666666667in"}

**2. 扩展性（Scaling）**

为此我们新增了 **可流式传输的 HTTP 模式（Streamable HTTP）**。你可以：

- 直接同步返回 JSON（像普通 REST API）；

- 或者开启流式通道，先返回部分信息，再动态推送更多内容。

这使得 MCP 服务具备现代 API 所需的扩展性，能支持大规模并发。

![](media/6f78505ce5b81b8710325bdcce6c0e06.webp){width="8.010416666666666in" height="3.9166666666666665in"}

![](media/da434d57c7188bf1979717eac969a157.webp){width="8.010416666666666in" height="4.427083333333333in"}

***这里小编多提一嘴，MCP 的 Web 化目前也是一个前沿的研究方向，除了协议层面的流式传输模式外，小编注意到已经有一些创业公司开始着手打造一种 MCP 的 Web UI，目标是"标准化模型和工具如何在客户端应用中请求展示丰富 HTML 界面的方式"。听起来，这种方式和 iOS 或 Android 开发者在 App 中嵌入 WebView 类似。大家可以关注一下。***

![](media/7de738f553e20e5ced4ff2614c2773a9.webp){width="8.010416666666666in" height="1.03125in"}

**即将上线的功能**

我们接下来会推出：

- **异步任务支持**：为 Agent 执行长时间任务奠定基础；

- **用户交互请求（Elicitation）**：服务端可主动向用户请求输入；

- **官方注册中心**：一个用于发布和发现 MCP 服务的统一平台；

- **多模态能力**：如流式多模态输出；

- **新语言 SDK 支持**：如 Ruby（由 Shopify 捐赠）和 Go（由 Google 团队开发）。

![](media/62ce5d4431aa37c9640c4efe49bde318.webp){width="8.010416666666666in" height="3.6666666666666665in"}

**MCP不止tool calls**

**而是丰富交互体验的系统协议**

从去年11月诞生以来，到今年年初的爆火，再到各大互联网巨头的积极拥抱。发展至今，MCP 协议已经远不止是一个"工具调用协议"，它更像是一整套让 LLM 与客户端构建丰富交互体验的系统协议。

好了，今天这篇文章分享就到这里了，如果你也正在使用 MCP 工具，或者正在开发 MCP Server，欢迎评论去交流。

参考链接：

[[https://www.youtube.com/watch?v=HNzH5Us1Rvg&t=432s]{.underline}](https://www.youtube.com/watch?v=HNzH5Us1Rvg&t=432s)

**------好文推荐------**

[[大多数MCP都设计错了！]{.underline}](https://mp.weixin.qq.com/s?__biz=MjM5ODI5Njc2MA==&mid=2655927165&idx=1&sn=471401a1bad32da9f3bad7f69619bcd4&scene=21#wechat_redirect)

[[开源大佬炮轰MCP：我不是MCP的忠实拥趸！MCP是一个死胡同！根本不是为无推理自动化而设计的！绕开MCP，试试代码生成的世界]{.underline}](https://mp.weixin.qq.com/s?__biz=MjM5ODI5Njc2MA==&mid=2655927152&idx=1&sn=61adefc6a1701fed65d477b03f3b8058&scene=21#wechat_redirect)

[[自己打败自己！Claude Opus 4.1紧急上线！再度刷新AI编程记录，未来数周还有重磅！网友：AI圈的八月混战开始了！]{.underline}](https://mp.weixin.qq.com/s?__biz=MjM5ODI5Njc2MA==&mid=2655928034&idx=1&sn=9d3258fa8173f3619cef1de7c412a6ce&scene=21#wechat_redirect)

[[刚刚！Claude Code对外公开了官方内部最佳实践！核心贡献者：CC是一个纯粹Agent工具，揭秘md文件、上下文进阶技巧]{.underline}](https://mp.weixin.qq.com/s?__biz=MjM5ODI5Njc2MA==&mid=2655927959&idx=1&sn=780ad53f8ff3ff8897e00ec8b1e87517&scene=21#wechat_redirect)
