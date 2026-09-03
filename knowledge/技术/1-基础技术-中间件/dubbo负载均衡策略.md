# dubbo负载均衡策略

1. **Weighted Random LoadBalance（加权随机）**：这是默认的负载均衡算法，它根据服务提供者的权重随机选择一个节点进行调用。如果权重相同，则平均分配请求
	
	。
	
2. **RoundRobin LoadBalance（加权轮询）**：这种策略借鉴了 Nginx 的平滑加权轮询算法，默认权重相同，循环调用节点
	
	。
	
3. **LeastActive LoadBalance（最少活跃优先 + 加权随机）**：基于“能者多劳”的思想，优先选择活跃调用数最少的节点，如果活跃数相同，则随机选择
	
	。
	
4. **Shortest-Response LoadBalance（最短响应优先 + 加权随机）**：更加关注响应速度，优先选择响应时间最短的节点，如果响应时间相同，则随机选择
	
	。
	
5. **ConsistentHash LoadBalance（一致性哈希）**：适用于有状态请求，确定的入参对应确定的提供者
	
	。
	
6. **P2C LoadBalance（Power of Two Choice）**：随机选择两个节点后，继续选择“连接数”较小的那个节点
	
	。
	
7. **Adaptive LoadBalance（自适应负载均衡）**：在 P2C 算法基础上，选择二者中 load 最小的那个节点
	
	。

    Created at: 2024-11-25T16:44:00+08:00
    Updated at: 2024-11-25T16:44:33+08:00

