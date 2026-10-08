# Codex 工作目录

`~/songshu/codex/` 保存 Codex 专用的可移植说明、技能和可选配置。

运行 `./setup-codex.sh`，或通过 `./setup.sh` 一起恢复三个 agent。

- 根目录 `AGENTS.md` 与 `README.md` 软链到 `${CODEX_HOME:-~/.codex}/`；开始工作先读两份文档。
- `codex/skills/` 软链到本仓库 `.agents/skills/`，由 Codex 按仓库作用域加载；不改动 Pi 的 `~/.agents/skills`。
- 共用知识库 `knowledge/`：新话题先检索，讨论结论写回。
- 可选 `codex/config.toml`：存在才软链恢复；放入公开仓库前必须确认无凭据。已迁入本机配置并建立软链，迁入时未检测到明显凭据。
- 已有目标先备份，重复运行不重复备份正确的软链。
- 不纳入凭据、会话、缓存、日志；脚本不改变桌面聊天的项目归属。

官方说明：[AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md)、[技能加载](https://learn.chatgpt.com/docs/build-skills)。
