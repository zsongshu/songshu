# songshu —— 张松树的便携配置 + 知识库

这是张松树的 dotfiles 仓库：把 **WorkBuddy / Pi 的个人配置**和 **WorkBuddy 工作记录知识库**（`knowledge/`）存进 git，换电脑 `clone` + 跑脚本即可恢复全部环境。

## 换电脑怎么恢复

```bash
git clone https://github.com/zsongshu/songshu.git ~/songshu
cd ~/songshu && ./setup.sh
```

`./setup.sh` 会自动建好 Pi 与 WorkBuddy 的全部软链（含 `pi/skills` → `~/.agents/skills`）。**不需要手动 `ln`。**

## 两份文档，作用不同（不要混）

- **`README.md`（本文件）** —— 给人看的入口：这是什么、怎么装。仅此而已。
- **`AGENTS.md`** —— 给 AI agent（pi / WorkBuddy / 换电脑后的新 agent）看的**权威约定源**：你的个人画像、仓库结构、操作铁律、知识库归档闭环、公开库注意。任何 agent 读这一个文件就能接上你的要求。

## 注意

- 本仓库为 **public**，家庭 / 财务 / 保单信息已公开。不要往里新增敏感文件（私钥、未脱敏账单、凭据）。
- 配置真身在 `~/songshu`，`~/.workbuddy/`、`~/.pi/` 下是软链；改配置要改这里，别去动软链本身。
