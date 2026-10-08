# Codex 工作目录

`~/songshu/codex/` 用于保存 Codex 专用的可移植配置、说明和技能。

- 工作目录：`/Users/timzhang/songshu`。
- 共用约定：开始工作先读根目录 `AGENTS.md` 和 `README.md`；本目录 `AGENTS.md` 软链到根目录的权威源。
- 共用知识库：新话题先检索 `../knowledge/topics/`，讨论结论写回 `../knowledge/`。
- `skills/`：Codex 专用技能目录，与 Pi 和 WorkBuddy 分别维护。此目录尚未连接到 Codex 的全局技能加载路径。
- 凭据、会话、缓存和日志不放入本目录。

本目录目前只建立仓库结构，没有修改 Codex 应用的全局配置或项目归属。
