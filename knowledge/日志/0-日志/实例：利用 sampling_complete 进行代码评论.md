# 实例：利用 sampling/complete 进行代码评论

假设你正在使用一个 **AI 代码编辑器（MCP Client）**，该编辑器连接了一个运行在云端的 **专业代码分析服务器（MCP Server）**。
这个 **MCP Server** 负责管理和执行复杂的、针对特定语言的代码规则检查，但它**本身不具备 LLM 的推理能力**。

### 

### 场景：Server 需要 LLM 智能

用户要求 Server 对一段代码进行风格和可读性评论。

|     |     |     |
| --- | --- | --- |
| 角色  | 动作  | 目的  |
| **MCP Client (AI 编辑器)** | 用户在代码中选中一段代码，并调用 Server 的 **Tool**：analyze\_code\_style(snippet)。 | Client 将请求发送给 Server，要求执行复杂的分析。 |
| **MCP Server (代码分析)** | Server 开始执行分析，发现代码逻辑符合规则，但它需要 LLM 来撰写一段**更人性化、更具教育意义**的评论。 | Server 需要 LLM 的智能，但不想自己部署或调用 LLM API。 |



### sampling/complete 的反向调用流程

在这种情况下，Server 会使用 sampling/complete 方法，将任务“外包”给 Client 侧的 LLM：

|     |     |     |     |
| --- | --- | --- | --- |
| 步骤  | 角色  | 动作/方法 | 描述  |
| **1\. Server 发起采样请求** | **MCP Server** | **发送** sampling/complete 请求给 Client。 | 请求的 params 中包含一个 **Prompt**，例如：“你是一名资深软件工程师。请针对以下代码片段，用鼓励的语气撰写一段关于其风格和可读性的评论。” |
| **2\. Client 接收并执行** | **MCP Client** | **接收** sampling/complete 请求，并在**内部调用**其集成的 LLM（可能是本地模型，也可能是云端 LLM API）。 | Client 将 Server 提供的 Prompt、用户选择的代码片段，以及其他上下文（如编程语言）发送给自己的 LLM 进行推理。 |
| **3\. Client 返回结果** | **MCP Client** | **返回** sampling/complete 的结果给 Server。 | LLM 生成的评论文本（例如：“这段代码逻辑清晰，但变量命名可以更具描述性！”）被封装在响应中，返回给 Server。 |
| **4\. Server 整合与返回** | **MCP Server** | **接收**到 LLM 的评论文本，将该文本整合到其 Tool 的最终输出（Resource）中。 | Server 完成 Tool 执行，并将最终结果（包含 LLM 撰写的评论 Resource）返回给 Client。 |
| **5\. 用户看到结果** | **MCP Client** | 在编辑器界面中展示 Server 返回的分析结果和 LLM 撰写的评论。 | 用户获得了 Server 的专业检查和 LLM 的人性化反馈。 |

### 

### 总结：sampling/complete 的核心价值

sampling/complete 的存在解决了 MCP 生态中的一个关键问题：

	**Server 侧无需 LLM 能力：** 专业的 Server（如数据库、代码仓库）可以专注于其核心业务逻辑，而无需承担部署和维护 LLM 的成本和复杂度。
	
	**利用 Client 侧的资源：** Server 能够安全、标准地利用 Client 侧**已认证、已配置**的 LLM 资源（例如，用户已经付费的 Claude Pro 或本地运行的 Llama 3）。
	

它实现了 **“Server 知道需要什么智能，Client 知道如何提供这种智能”** 的高效协作模式。

    Created at: 2025-09-25T14:29:35+08:00
    Updated at: 2025-09-25T14:30:54+08:00

