---
title: "股票持仓监控 Agent 搭建手册"
source: "股票持仓监控 Agent 搭建手册.docx"
type: docx
tags: ["docx"]
path: "777-AI-技术"
created: 2026-07-03
---

# 股票持仓监控 Agent 搭建手册

![[股票持仓监控 Agent 搭建手册-37a92566.docx]]

## 内容

\## 概述

每30分钟自动获取股票持仓数据，计算盈亏，并通过飞书发送报告。

\## 环境准备

\`\`\`bash

\# 1. 创建Python虚拟环境

python3 -m venv \~/.venv

\# 2. 安装依赖

\~/.venv/bin/pip install pandas openpyxl requests

\`\`\`

\## 核心文件

\- 脚本: \`\~/.openclaw/workspace/stock_monitor.py\`

\- 持仓: \`\~/zss/gupiao.xlsx\`

\- 日志: \`/tmp/stock_monitor.log\`

\## 搭建步骤

\### 1. 准备持仓Excel

格式要求：

\| 券商 \| 资产项 \| 比例 \| 单价 \| 数量 \| 金额 \|

\|\-\-\-\-\--\|\-\-\-\-\-\-\--\|\-\-\-\-\--\|\-\-\-\-\--\|\-\-\-\-\--\|\-\-\-\-\--\|

\| 平安 \| 腾讯-00700 \| 0.1058 \| 510.5 \| 600 \| 275670 \|

\### 2. 创建Python脚本

参考 \`stock_monitor.py\`，核心功能：

\- \`read_portfolio()\` - 读取Excel

\- \`get_realtime_price()\` - 获取实时股价

\- \`get_usd_cny_rate()\` - 获取汇率

\- \`analyze_portfolio()\` - 分析盈亏

\- \`send_feishu_message()\` - 发送飞书

\### 3. 配置Crontab

\`\`\`bash

\# 每30分钟运行

\*/30 \* \* \* \* \~/.venv/bin/python \~/.openclaw/workspace/stock_monitor.py \>\> /tmp/stock_monitor.log 2\>&1

\`\`\`

\### 4. 获取飞书群ID

\`\`\`bash

\# 方法：让OpenClaw发送测试消息到群，从响应中获取chat_id

openclaw message send \--channel feishu \--target \"群名\"

\`\`\`

\## 价格数据源

\| 市场 \| 接口 \|

\|\-\-\-\-\--\|\-\-\-\-\--\|

\| A股/ETF \| 新浪财经 \`hq.sinajs.cn\` \|

\| 港股 \| 新浪财经 \`hq.sinajs.cn/list=hk{code}\` \|

\| 美股 \| Yahoo Finance \`[[query1.finance.yahoo.com]{.underline}](http://query1.finance.yahoo.com/)\` \|

\| 汇率 \| Yahoo Finance \`USDCNY=X\` \|

\## 飞书消息发送

\`\`\`python

import subprocess

subprocess.run(\[

    \"openclaw\", \"message\", \"send\",

    \"\--channel\", \"feishu\",

    \"\--target\", FEISHU_CHAT_ID,

    \"\--message\", \"内容\"

\])

\`\`\`

\## 注意事项

1\. 新浪财经接口需要带Headers模拟浏览器

2\. 港股代码处理（如 00700 → hk00700）

3\. 汇率换算：美元资产需要转换为人民币

4\. 避免重复发送：可以对比上次消息内容

![](media/7fa67db4495397a7baa0e9afef9f5837.png){width="8.010416666666666in" height="6.1875in"}
