# 让 Agent 具备管理电脑文件的能力



|     |
| --- |
| ### 🛠️ 步骤 1：编写“文件助手” Agent 定义<br><br>创建一个新文件：~/.openclaw/agents/file\_master.json<br>JSON<br>{<br>  "name": "file\_master",<br>  "description": "一个能读写、列出和搜索本地文件的文件管理专家。",<br>  "prompt": "你是一个文件管理专家。你可以访问本地目录。当用户要求查看、列出或搜索文件时，请调用相应的工具。如果用户要求删除文件，请务必先询问用户确认。当前工作目录为：/Users/songshuzhang/Documents/AI\_Workspace",<br>  "provider": "ollama",<br>  "model": "qwen2.5:7b",<br>  "tools": \["list\_files", "read\_file"\]<br>}<br><br><br>### 🛠️ 步骤 2：编写 Python 工具（Tools）<br><br>OpenClaw 会自动扫描 ~/.openclaw/tools/ 目录下的 Python 文件。<br>创建一个文件：~/.openclaw/tools/file\_tools.py<br>Python<br>import os<br><br>def list\_files(directory="."):<br>    """<br>    列出指定目录下的所有文件和文件夹。<br>    :param directory: 目录路径，默认为当前目录。<br>    """<br>    try:<br>        files = os.listdir(directory)<br>        return "\\n".join(files)<br>    except Exception as e:<br>        return f"错误: {str(e)}"<br><br>def read\_file(file\_path):<br>    """<br>    读取指定文件的内容。<br>    :param file\_path: 文件的完整路径。<br>    """<br>    try:<br>        with open(file\_path, 'r', encoding='utf-8') as f:<br>            return f.read(1000)  # 限制读取前1000字符，防止上下文溢出<br>    except Exception as e:<br>        return f"读取失败: {str(e)}"<br><br><br>### 🛠️ 步骤 3：让 OpenClaw 加载并运行<br><br>1. **修改全局配置**： 在 openclaw.json 中将默认 Agent 改为 file\_master。<br>	<br>2. **重启网关**（确保之前的 PID 已清理）：<br>	Bash<br>	openclaw gateway start |
|  |




    Created at: 2026-03-04T10:23:25+08:00
    Updated at: 2026-03-04T11:00:14+08:00

