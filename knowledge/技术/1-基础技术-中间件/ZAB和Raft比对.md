# ZAB和Raft比对

1. 都有选主逻辑，区别是 ZAB 要求新 Leader 与其他节点完成数据同步后才能响应请求，而 Raft 在选主完成后无需同步数据即可响应请求。
	
2. 都是由 Leader 将数据分发给其他节点，Leader 收到多数 ACK 后执行 Commit。区别是 ZAB 需要将 Commit 消息广播给所有节点，而 Raft 仅需在本地进行隐式 Commit，通过异步发送 AppendEntries 通知其他节点提交。
	



---

### **1\. 关于选主后是否需要同步数据**

**ZAB 的 Sync 阶段**：
ZAB 的选主流程（Crash Recovery）包含 **Discovery + Sync 阶段**，要求新 Leader 与所有 Follower 同步日志后才能处理请求。这是为了确保所有节点状态一致，避免因旧 Leader 在分区期间提交的日志导致冲突。

**示例**：若旧 Leader 在分区期间提交了部分日志，新 Leader 必须补传这些日志并截断 Follower 的不一致部分，才能开始处理新请求。


**Raft 的异步同步**：
Raft 选主后会立即响应请求（通过心跳和日志复制异步同步日志），无需等待所有 Follower 完成同步。这是 Raft 的设计目标之一：**快速恢复服务**，即使部分 Follower 暂时滞后，Leader 也能继续处理请求。

---

### **2\. 关于 Commit 机制**

**ZAB 的显式 Commit**：
ZAB 要求 Leader 在收到多数 Follower 的 ACK 后，**显式广播 Commit 消息**，确保所有节点提交事务。这是 ZAB 实现 **严格顺序一致性** 的关键机制，例如 ZooKeeper 的 ZAB 协议通过此机制保障客户端的线性一致性。

**Raft 的隐式 Commit**：
Raft 的 Commit 是隐式的，Leader 收到多数 Follower 的 ACK 后，**本地标记日志为已提交**，并通过 AppendEntries 中的 commitIndex 字段通知 Follower 提交。这种方式减少了网络开销，但依赖 Follower 的被动更新机制。



    Created at: 2025-09-18T20:26:45+08:00
    Updated at: 2025-09-18T20:34:03+08:00

