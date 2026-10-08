# Codex 接入 songshu 工作区

用户要求 Codex 以 `/Users/timzhang/songshu` 为工作目录，并参考 Pi 和 WorkBuddy 创建专用目录。

已创建 `codex/`，包含说明、指向根目录共用约定的 `AGENTS.md` 软链和独立 `skills/` 目录。Codex 沿用共用知识库 `knowledge/`。本轮没有修改应用全局配置、连接全局技能路径或改变聊天项目归属。

后续补齐 `setup-codex.sh` 并接入总入口：共用指引软链到 Codex home，专用技能软链到仓库 `.agents/skills`，可选配置存在才恢复，已有目标先备份。未采集本机配置或凭据。

用户随后明确要求迁入本机 `config.toml`：检查未发现明显凭据字段后，原样保存到 `codex/config.toml`，原文件先验证备份，再将 `~/.codex/config.toml` 建为软链。文件内容与备份逐字节一致。
