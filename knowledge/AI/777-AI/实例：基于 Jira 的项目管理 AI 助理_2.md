# 实例：基于 Jira 的项目管理 AI 助理

假设你的公司使用一个名为 **Jira** 的云服务来管理所有项目任务和 Bug。你希望构建一个 AI 助手（MCP Client），让它能够回答关于项目进度的实时问题。
你需要搭建一个 **远程 Jira MCP Server**。

### 1\. 远程 Server 的能力定义

你的远程 Jira MCP Server 运行在一个云端服务器上，它不会直接暴露你所有的 Jira 数据，而是暴露以下能力：

|     |     |     |
| --- | --- | --- |
| MCP 原语 | 名称  | 作用  |
| **Tool** | search\_jira\_issues(project\_key, status) | 允许 AI **执行操作**：查询特定项目的任务。 |
| **Resource** | JiraIssue | 定义了单个 Jira 任务的**结构化数据格式**，包括 ID、标题、状态、分配人、描述等。 |



### 2\. Resources 的利用过程

整个过程涉及到 MCP 客户端、LLM 和远程 MCP Server 之间的交互：

|     |     |     |     |
| --- | --- | --- | --- |
| 步骤  | 角色  | 动作描述 | Resources 的作用 |
| **Step 1: 用户提问** | **用户** | 在 AI 助手中提问：“**我的项目中，标记为 'Bug' 的任务有哪些处于‘待办’状态？**” | 触发对外部信息的依赖。 |
| **Step 2: 意图推理与工具调用** | **AI Agent (MCP Client + LLM)** | LLM 推理得知：回答这个问题需要访问 Jira 系统。它决定调用 search\_jira\_issues 这个 **Tool**，并构造参数：project\_key='我的项目', status='待办', type='Bug'。 | LLM 知道调用 Tool 后会返回 **Resources** 作为上下文。 |
| **Step 3: 远程 Server 执行** | **远程 Jira MCP Server** | 1\. Server 接收到 Tool 调用请求。 2. Server 使用**预先授权的 OAuth 凭证**安全地调用 Jira Cloud 的 REST API。 3. Jira API 返回一堆原始 JSON 数据。 | Server **从外部 API 获取数据**，但数据尚未格式化。 |
| **Step 4: 结构化为 Resources** | **远程 Jira MCP Server** | Server 将 Jira 返回的原始 JSON 数据进行解析和清理，并将其**封装**成符合其 JiraIssue **Resource Schema** 的标准化列表。 | **Server 桥接了 API 原始数据与 LLM 可理解的结构化上下文。** 确保数据格式统一、简洁。 |
| **Step 5: 结果返回与上下文注入** | **远程 Jira MCP Server** | Server 将包含多个 JiraIssue **Resources** 的列表作为 Tool 的结果，通过网络**返回**给 MCP Client。 | **Resources 是 Tool 调用的最终产物。** |
| **Step 6: 模型生成答案** | **AI Agent (LLM)** | MCP Client 将返回的 **Resources** 列表注入到 LLM 的 **Prompt** 中。LLM 依据这些结构化的实时数据，生成准确的答案，例如：“在您的项目中，有 3 个待办的 Bug，分别是：ID-101 '登录界面卡顿'，ID-105 '邮件通知失败'，以及 ID-112 '导出按钮失效'。” | **Resources 成为 LLM 准确回答的实时依据。** |



### 总结

在这个远程模式的实例中，**Resources** 扮演了两个关键角色：

1. **数据契约 (Data Contract)：** 它定义了远程 Server 和客户端之间传递**企业知识**的**标准化格式**，解决了不同 API 接口的差异问题。
	
2. **安全上下文 (Secure Context)：** 远程 Server 通过**身份验证**和 **Tool 封装**，确保只有经过授权、且符合 **Resource** 定义的**实时数据**才会被安全地获取并发送给 AI 模型。
	

无论是本地还是远程，Resources 都是 AI **获取知识**的核心载体。远程模式下，它扩展了 AI 模型的知识边界，使其能安全地访问整个互联网和企业的云服务。

    Created at: 2025-09-25T14:33:32+08:00
    Updated at: 2025-09-25T14:34:29+08:00

