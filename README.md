# songshu —— 张松树的便携配置 + 知识库

这是张松树的 dotfiles 仓库：把 **WorkBuddy / Pi / Codex 的个人配置**和 **三 agent 共用的知识库**（`knowledge/`）存进 git，换电脑 `clone` + 跑脚本即可恢复全部环境。

## 最高原则（所有 agent 必守，优先级最高）

> 不论用哪个 agent（WorkBuddy / pi / Codex / 换电脑后的新 agent）干活，开局都**先读 `README.md` 与 `AGENTS.md`**，未读不开始；`knowledge/` 是三 agent **共用**的知识库，不是各写各的。

1. **先读约定，再动手**：任何 agent 每次会话开始，必须先读 `AGENTS.md`（权威约定源）和本文件 `README.md`（入口索引），建立全局认知后再工作。
2. **知识库共用**：`knowledge/` 是 WorkBuddy、pi 与 Codex 共用的权威工作记录源（md，git 即备份）。三 agent 都检索、读取、写回此处，不另起炉灶；印象笔记只做单向可读副本。
3. **一处修改，三 agent 同步**：约定只写在 `~/songshu/AGENTS.md`（已软链到 `~/.workbuddy/AGENTS.md`、`~/.pi/agent/AGENTS.md` 与 `~/.codex/AGENTS.md`），改一处三 agent 生效。

## 换电脑怎么恢复

> **前置：先安装需要的应用本身。** `~/songshu` 只管配置，不管程序。请先装好 **WorkBuddy**、**Pi（另一个 coding agent）** 与 **Codex**，再跑下面脚本——`setup.sh` 是把配置软链进它们各自的目录，应用不存在则软链无处可挂。

```bash
git clone https://github.com/zsongshu/songshu.git ~/songshu
cd ~/songshu && ./setup.sh
```

`./setup.sh` 会自动建好 Pi、WorkBuddy 与 Codex 的配置软链（含 `pi/skills` → `~/.agents/skills`）。**不需要手动 `ln`。**

## 两份文档，作用不同（不要混）

- **`README.md`（本文件）** —— 给人看的入口：这是什么、怎么装；同时也是**所有 agent 的开局必读**（先建立全局认知）。最高原则见上方。
- **`AGENTS.md`** —— 给 AI agent（WorkBuddy / pi / Codex / 换电脑后的新 agent）看的**权威约定源**：你的个人画像、仓库结构、操作铁律、知识库归档闭环、公开库注意。任何 agent 读这一个文件就能接上你的要求。

## 注意

- 本仓库为 **public**，家庭 / 财务 / 保单信息已公开。不要往里新增敏感文件（私钥、未脱敏账单、凭据）。
- 配置真身在 `~/songshu`，`~/.workbuddy/`、`~/.pi/` 下是软链；改配置要改这里，别去动软链本身。

## Codex

`codex/` 保存 Codex 专用说明和技能，共用根目录 `AGENTS.md` 与 `knowledge/`。运行 `./setup-codex.sh` 可建立共用指引与仓库技能的软链；`./setup.sh` 已接入 Codex。
