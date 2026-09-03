# 实例：利用 elicitation/request 预订会议室

假设你的 **AI 助手（MCP Client）** 连接了一个 **日程管理 MCP Server**，该 Server 负责与公司的日历系统交互。

### 场景：Server 缺少预订所需的关键信息

用户希望通过 AI 助手预订会议室。

|     |     |     |
| --- | --- | --- |
| 角色  | 动作  | 目的  |
| **用户** | 在 AI 助手中说：“请为我的团队会议预订会议室。” | 触发 Server 的预订 **Tool**：book\_meeting\_room()。 |
| **AI Agent (MCP Client + LLM)** | LLM 推理得知需要调用 Tool，并发送请求给 Server：tools/call: book\_meeting\_room()，但**用户没有提供会议时长**。 | Client 将 Tool 调用请求发送给 Server。 |
| **MCP Server (日程管理)** | Server 接收到请求，开始执行预订逻辑，但发现预订 Tool 的 **Schema** 中明确要求 duration（时长）参数，而这个参数缺失了。 | Server 无法继续执行预订操作。 |



---

elicitation/request 的信息诱导流程
在这种情况下，Server 会使用 elicitation/request 方法，将缺失的信息需求“反向”传递给 Client，让 Client 去询问用户：

|     |     |     |     |
| --- | --- | --- | --- |
| 步骤  | 角色  | 动作/方法 | 描述  |
| **1\. Server 发起信息诱导请求** | **MCP Server** | **发送** elicitation/request 请求给 Client。 | 请求的 params 中包含：要求填写的参数（duration）、描述（“请问会议需要持续多久？”）和预期的数据类型（string 或 number）。 |
| **2\. Client 接收并向用户展示** | **MCP Client** | **接收** elicitation/request，并暂停 Tool 的执行。 | Client 在用户界面上**弹出一个结构化提示**，例如：“预订会议室需要会议时长。请问需要预订多长时间（例如：30 分钟或 1 小时）？” |
| **3\. 用户提供信息** | **用户** | 在 UI 中输入：“1 小时”。 | 用户提供 Server 所需的关键信息。 |
| **4\. Client 响应缺失信息** | **MCP Client** | **发送** elicitation/response 响应给 Server。 | Client 将用户输入的信息（duration: "1 小时"）封装在响应中，返回给 Server。 |
| **5\. Server 恢复执行** | **MCP Server** | **接收**到 elicitation/response，Tool 获得所有必要的参数。 | Server 使用包括 duration 在内的完整参数集，**恢复**执行 book\_meeting\_room() Tool 的逻辑，完成会议室预订。 |
| **6\. Server 返回最终结果** | **MCP Server** | 将预订成功的 **Resource**（例如：预订成功的会议室信息）返回给 Client。 | Server 报告任务完成。 |



---

### 总结：elicitation/request 的核心价值

elicitation/request 机制解决了在 **Agent 工作流**中处理**动态、缺失输入**的关键挑战：

1. **保持 Server 专注：** Server 无需自己处理自然语言理解或复杂的 UI 交互，它只负责明确地告诉 Client：“我需要这个参数。”
	
2. **增强用户体验：** Client 可以将这个请求转化为一个**结构化、明确**的 UI 提示，而不是让 LLM 生硬地回复“你没告诉我时长”。
	
3. **确保任务完整性：** 它允许 Server 在关键步骤暂停，**主动获取**完成任务所需的最小信息集，确保 Tool 的执行符合 Schema 和业务逻辑的要求。
	



    Created at: 2025-09-25T14:31:30+08:00
    Updated at: 2025-09-25T14:32:45+08:00

