# 本机卸载 Claude

用户明确要求卸载本机 Claude。已将 `/Applications/Claude.app`、`~/.local/bin/claude` 原生安装入口及 `~/.local/share/claude` 程序版本目录移至废纸篓，可恢复。

卸载前未发现 Claude 运行进程，Homebrew 和 npm 全局安装清单也没有 Claude。卸载后验证上述安装路径不存在，PATH 中不再有 `claude` 命令。

保留 `~/.claude`、`~/.claude.json`、桌面应用用户数据及所有项目文件。本次只移除已发现的桌面应用和命令行程序。
