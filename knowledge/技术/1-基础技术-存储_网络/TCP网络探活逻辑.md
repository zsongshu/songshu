# TCP网络探活逻辑

发送 reset 数据包的情况：

1. 设置 TCP 选项 SO\_LINGER 为 0，暴力关闭连接
2. 第一次握手数据包遇到服务不存在，TCP 发送 reset 数据包
3. 非三次握手数据包到达服务器 TCP，TCP 通过连接信息去找相应的 TCB（TCP 控制块信息），如果没有找到，则发送 reset 数据包给客户端
4. 防火墙/路由器干扰
5. 中途设备程序超时处理
6. reset 攻击
7. Keepalive 检测
8. 操作系统清除连接资源（例如 windows），降低 timewait 数量
9. 清除 TCP 资源




    Created at: 2023-02-16T15:24:37+08:00
    Updated at: 2023-02-16T15:25:18+08:00

