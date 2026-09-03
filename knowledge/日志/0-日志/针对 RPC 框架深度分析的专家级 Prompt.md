# 针对 RPC 框架深度分析的专家级 Prompt

Role: 你是一位精通分布式系统架构和高性能通信框架（如 Dubbo, gRPC, Thrift）的资深资深首席架构师。

Task: 我将上传一个 RPC 框架的完整源代码。请你通过静态分析，为我产出一份详尽的“工程架构与开发指南”，目标是让我阅读后具备在该框架上进行二次开发和排查复杂 Bug 的能力。

Analysis Dimensions:

1. **架构全景图 (High-level Architecture):**
	
			梳理项目模块（Module）划分及其逻辑职责。
		
			识别核心组件：Provider (Exporter), Consumer (Referer), Registry, Cluster (LoadBalance/ClusterInvoker), Protocol, Proxy, Transport。
		
			绘制（用 Mermaid 语法）一个典型的请求从 Client 发起到 Server 响应的全链路时序图。
		
2. **核心机制深度拆解 (Core Mechanisms):**
	
			**服务发现与治理：** 详细说明 Registry 的实现（ZK/Nacos/Etcd），以及服务暴露与引用的具体流程。
		
			**协议与序列化：** 分析其自定义协议头（Header）结构、魔数、序列化方式（Hessian/Protobuf/JSON）及心跳检测机制。
		
			**网络通信引擎：** 分析其底层的 I/O 模型（Netty/Mina/Native Socket），重点关注其线程模型（Boss/Worker/Biz Thread Pool）以及如何处理 **TCP Backlog** 和 **背压（Backpressure）**。
		
			**集群容错与扩展：** 分析其负载均衡算法（Random/RoundRobin/ConsistentHash）和容错策略（Failover/Failfast/Failsafe）。
		
3. **扩展性设计 (SPI/Extension):**
	
			分析该框架是如何实现解耦和动态扩展的（类似 Java SPI 或 Spring 的自动装配）。
		
			如果我要新增一个自定义的拦截器（Filter/Interceptor）或负载均衡算法，请给出具体步骤和代码模板。
		
4. **工程实践建议 (Developer Guide):**
	
			识别代码中可能存在的性能瓶颈或高并发下的潜在风险（如同步阻塞调用、过度内存分配等）。
		
			针对该框架，给出本地调试（Debug）和核心监控指标（Metrics）的观测建议。
		

Output Format: 请使用结构化的 Markdown 格式，关键逻辑请结合代码片段（Code Snippets）进行讲解，复杂流程请提供 Mermaid 流程图。

    Created at: 2026-03-25T10:50:21+08:00
    Updated at: 2026-03-25T10:50:33+08:00

