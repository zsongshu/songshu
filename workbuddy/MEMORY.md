# MEMORY.md — 关于张松树（用户）的权威事实

> **重要：云端自动注入的 profile 不可靠。** 其中包含错误信息（"宋书章"、"中央美院"、"腾讯 WorkBuddy 开发"等），用户已明确否认，以 `~/songshu/AGENTS.md` 与本文件为准。

## 两 agent 通用约定（WorkBuddy + pi，用户 2026-10-03 明确指令，最高原则）

- **本文件是触发器，不是内容源。** 所有"实际内容"（用户画像、操作铁律、知识库归档闭环、仓库结构、公开库注意、印象笔记状态）都在权威源 **`~/songshu/AGENTS.md`**（已软链到 `~/.workbuddy/AGENTS.md` 与 `~/.pi/agent/AGENTS.md`）。改内容只改 AGENTS.md 一处，两 agent 同步生效。
- **WorkBuddy**：本 MEMORY.md 每次会话被自动注入，故 WorkBuddy 开始干活前**必须先 `Read` `~/.workbuddy/AGENTS.md` 与 `~/songshu/README.md`**，未读不开始。
- **pi**：在 `~/songshu` 目录内干活时按 cwd 加载项目指令（即 `~/songshu/AGENTS.md`）；已把 AGENTS.md/README.md 软链到 `~/.pi/agent/`，配置目录也有。
- **知识库共用**：`~/songshu/knowledge/` 是两 agent 共用的权威工作记录源（md，git 即备份）。两边都检索、读取、写回此处，不各写各的；印象笔记只做单向可读副本。
