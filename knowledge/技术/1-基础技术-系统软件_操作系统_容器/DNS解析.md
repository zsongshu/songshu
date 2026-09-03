# DNS解析



|     |
| --- |
| 根据主机名查询IP地址的完整路径是：<br><br>1. **应用程序层**：调用gethostbyname()或getaddrinfo()<br>2. **本地缓存**：检查nscd缓存（如果启用）<br>3. **静态映射**：查询/etc/hosts文件<br>4. **服务配置**：读取/etc/nsswitch.conf确定查询顺序<br>5. **DNS查询**：根据/etc/resolv.conf配置向DNS服务器发起递归查询<br>6. **网络层**：经过根域名服务器→顶级域服务器→权威域名服务器<br>7. **结果返回**：沿查询路径返回，各级缓存结果 |
| #!/bin/bash<br>\# dns\_resolution\_trace.sh<br><br>echo "=== DNS解析完整路径追踪 ==="<br>echo "主机名: $1"<br>echo ""<br><br>\# 1. 检查/etc/hosts<br>echo "1. 检查 /etc/hosts:"<br>grep -w "$1" /etc/hosts \| echo "未在hosts中找到"<br>echo ""<br><br>\# 2. 检查nsswitch配置<br>echo "2. /etc/nsswitch.conf 配置:"<br>grep "^hosts:" /etc/nsswitch.conf<br>echo ""<br><br>\# 3. 检查DNS配置<br>echo "3. DNS服务器配置 (/etc/resolv.conf):"<br>cat /etc/resolv.conf<br>echo ""<br><br>\# 4. 使用getent测试（遵循nsswitch顺序）<br>echo "4. getent hosts 结果:"<br>getent hosts "$1"<br>echo ""<br><br>\# 5. 直接DNS查询<br>echo "5. 直接DNS查询:"<br>dig +short "$1" A<br>echo ""<br><br>\# 6. 完整DNS追踪<br>echo "6. 完整DNS解析路径:"<br>dig +trace "$1" |





    Created at: 2025-11-04T10:38:09+08:00
    Updated at: 2025-11-04T11:44:41+08:00

