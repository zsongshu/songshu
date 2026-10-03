# MEMORY.md — 关于张松树（用户）的权威事实

> **重要：云端自动注入的 profile 不可靠。** 其中包含错误信息（"宋书章"、"中央美院"、"腾讯 WorkBuddy 开发"等），用户已明确否认，以本文件与 `~/.workbuddy/USER.md` 为准。

## 基本信息
- 姓名：张松树，希望被称呼 `songshu.zhang` 或「张松树」。macOS 用户名 `timzhang` 是历史遗留，不是他的名字。
- 城市：杭州
- GitHub：https://github.com/zsongshu （主仓库 `zsongshu/songshu`，本地 `~/songshu`）
- 单位：**阿里巴巴**，方向：中间件、数据库、分布式系统（Obsidian 库里有 Alibaba/OceanBase/TXC/中间件/星环 等大量目录佐证）

## 家庭
- 妻子 曹津璇；女儿 包包（育翔小学）；儿子 张淙棋（准备赴美留学，有美签）
- 两套房产：吉第（贷款至 2049）、泊岸（贷款至 2046）；每月记录收支/还贷/理财
- 保险：宏利（人民币+美元）、泰康、招商信诺、京东安联、脐带血等

## 表达方式（他明确要求）
1. 结论先行，先结论后原因
2. 用 1、2、3 组织
3. 不铺垫、不绕弯
4. 技术可以有深度；管理要落到实践
5. 中文
6. 讲解框架/分类时维度必须正交，不能把两个概念折叠进一根轴（他曾指出"资产/动作"与"本机/云端"被混淆）；抽象维度要先落地到他能理解的具体维度（如"产物保存位置"），再展开

## 行事准则
- **数据零丢失优先于效率**：删除前必须验证备份/上传确实完成，不允许"先删再说"
- 长任务主动汇报进度（他习惯反复追问）
- 认可后再动手：整理类任务先给清单，他确认了才执行
- 喜欢批量+循环推进：分批提交、限流就等、失败重试、"不用让我确认了继续干"

## 知识库 / 工作环境
- Obsidian 库：`~/Library/Mobile Documents/iCloud~md~obsidian/Documents/tim-zhang-obs`（约 7900+ md，仍在用但想迁走）
- 迁移目标：全部笔记 → 印象笔记（Evernote 国际版/印象笔记 API token 方式），核心诉求是云端存储
- 中转仓库 `~/songshu`（knowledge + attachments），配置软链到 `~/.pi`，换机器 clone 即可用
- 另一个 agent（pi）的会话记录在 `~/.pi/agent/sessions/`，是了解他的好素材

## 印象笔记数据状态（2026-09-13 实测，2026-09-22 完成全库去重）
- 账号共 56 个笔记本 / 63,041 条笔记；最大的是 `2-Meituan` 43,184 条
- **旧导入的笔记大量是空壳**：`3-衣食住行` 12,092 条里 97.7% 正文 < 200 字节、仅 61 条带附件（图片/扫描件没导入进来）
- **全库真重复**：用 contentHash 指纹判重，132 组 / 209 条副本全部归入新建目录 `9-重复文件`（每组保留创建最早的一条为"原件"），云端笔记总数 63,042 不变（0 删除）
- **判定逻辑**：exclude len≤210 + 模板长度（>50 次频次）共 57,368 条空壳 → 真实内容笔记 5,248 → 取指纹候选 3,141 条 → 同 hash = 同文件
- 原始导出（含附件）还在：`~/Desktop/evernote_export_final`（56 个 enex，32G）、`~/Desktop/evernote_import`（173 个 enex，1.3G）—— 需要时可用来补附件
- **`~/songshu/knowledge` 现为 WorkBuddy 工作记录归档源**（2026-10-03 起启用，md 格式；git 仓库即备份）；`attachments` 仍只有 1 个文件，备份仍需依赖 GitHub 远程 + 印象笔记副本，不能只靠本地
- 访问方式：MCP `yinxiang`（server 在 `~/mcp-servers/yinxiang-mcp`，stdio + HTTP 双模式，端口 8765）
- **Token 注意事项**：Developer Token 会自动失效（9 天后报 INVALID_AUTH），需要时去 https://app.yinxiang.com/api/DeveloperToken.action 重新生成并写到 `~/mcp-servers/yinxiang-mcp/.env`
- **API 配额**：约 300 次/小时，撞限流后等约 2000-2800s（33-47 分钟）才能继续

## 待确认
- 是否关注金融数据（finance-data 插件已装，但标普/穆迪那条是否属于他存疑）
- 3-衣食住行 整理后，要不要从 32G enex 把附件补回印象笔记（他目前还没决定）

## WorkBuddy 工作记录归档约定（用户 2026-10-03 明确指令）
- 所有在 WorkBuddy 里的工作记录，**默认归档到 `~/songshu/knowledge`**（md 格式，作为权威源）。
- **不需要用户每次提示**，agent 主动执行。
- **换话题触发总结**：一旦检测到用户从 A 话题切到 B 话题，立即把 A 话题的对话要点总结成一份 md，存入 `~/songshu/knowledge/topics/<主题>/<日期>-<slug>.md`。
- 分类按主题建子目录（如 `topics/ai-product-landscape/`），细节进文件、不进 memory。
- **闭环（检索-加载-续聊-记录）**：①开新讨论前先扫 `~/songshu/knowledge/topics/`（可 grep 全文）看是否已有类似讨论，命中则先加载该 md 作上下文再接着聊；②换话题时把上一话题总结成 md；③每轮讨论收尾把结论/更新写回对应知识库文件（已有则更新、无则新建），保持与对话同步。
- 备份策略：`~/songshu/knowledge` 是 git 仓库（远程 `zsongshu/songshu`），归档后 `git add` + `git commit`（仅新增/修改，不删）；印象笔记只做单向可读副本，绝不当唯一源。

## WorkBuddy 个人配置 dotfiles 化（用户 2026-10-03 明确指令）
- WorkBuddy 个人配置已 dotfiles 化：真实文件在 `~/songshu/workbuddy/`，`~/.workbuddy/` 对应处为软链（WorkBuddy 路径硬编码，无法改读 songshu）。
- 纳入项（纯文本、可移植）：SOUL.md / IDENTITY.md / USER.md / MEMORY.md / memory/ / mcp.json / settings.json / models.json / skills/。
- 排除项（运行时/缓存/二进制，重装自动重建）：binaries、plugins、logs、traces、security、cache、sessions、workspace、local_storage、*.db、*.port 等。
- `~/songshu/setup.sh` 含重建软链段，换电脑 `git clone` + `./setup.sh` 即可恢复。
- ⚠️ **songshu 仓库为 public**：用户 2026-10-03 知情后选择照推公开库，MEMORY.md/USER.md/memory/ 的家庭·财务·保单信息已公开。以后不再就该库公开性重复报警；如需收紧可一键设为 private。
- ⚠️ 远程地址内嵌明文 PAT（本地 .git/config，未进仓库）。建议轮换该 PAT 并改用 SSH/~/netrc，避免凭据明文暴露。
