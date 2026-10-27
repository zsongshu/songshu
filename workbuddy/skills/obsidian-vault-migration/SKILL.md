---
name: obsidian-vault-migration
description: 将 Obsidian（iCloud）知识库迁移到 git 仓库：md 图片 base64 内嵌、附件按类型分流平铺、GitHub 私有仓库分批推送。适用于笔记库脱离 iCloud / 换存储 / 库搬家类任务。
agent_created: true
---

# Obsidian 库迁移（iCloud → git 仓库）

## 需求确认（必须先书面确认，用户常中途收紧规则）
1. md 是否全部迁移、目录结构是否保持
2. 图片：base64 内嵌？还是保留附件目录
3. 附件（pdf/word/ppt/excel/视频/zip/txt...）各自去向：哪个文件夹、是否平铺、类型白名单
4. 目标仓库：**检查敏感目录**（证件/合同/体检/简历）→ 必须 private 单独仓库，不进 public 主仓库；主仓库 .gitignore 排除
5. 源库只读不动，任务完成后由用户确认再删

## 关键事实（踩过的坑）
- Obsidian 库非 md 文件数常**远超** md 引用数（`_resources` 有大量无引用网页快照），`<img>` 标签引用极少，可忽略
- `.bin/.dat` 等未知扩展名要**按魔数判断**是否图片（FFD8FF=jpeg, 89504E47=png, GIF87a/89a, RIFF+WEBP, BM）
- `![[xxx]]` 无扩展名是笔记内链，**不要动**
- **GitHub 100MB 单文件硬限制**：内嵌 base64 后 md 可能超限，被 `pre-receive hook declined / GH001` 拒绝。超限文件用 Pillow 把内嵌大图降采样转 JPEG（max_dim 2400, q85 起步）重内嵌，通常一轮达标。50-100MB 仅警告可通过
- **大推送不可靠**：HTTPS 和 SSH 一次推 1-2G 都可能被远端掐断（`Connection closed by remote host`）。可靠做法：**按顶层目录分批提交 + 逐批/逐提交推送 + 重试循环 + `caffeinate -is` 防休眠**
- shell 重试循环**不能用管道**：`until git push | tail -1` 的退出码是 tail 的，判断失效；直接检查 `$?`
- 平铺去重：同名先比 sha256，相同跳过（dup），不同加 `_hash8` 后缀
- 后台命令不继承 cwd，git 一律 `git -C <path>`
- 建 GitHub 仓库：无 gh 时用已有仓库远程 URL 里的 PAT 调 `POST /user/repos {"private":true}`；推送远程用 `https://<PAT>@github.com/...`（小批）或 SSH `git@github.com:...`（大批更稳）

## 流程（Python 脚本单趟完成）
1. **扫描**：walk 源库，建 md 列表 + 非 md 文件名索引（basename → paths，用于 Obsidian shortest-path 解析，含 URL decode）
2. **md 迁移**：保持相对路径写目标目录；四种引用都处理——`![alt](ref)` / `![[ref|alias]]` / `[text](ref)` / `[[ref]]`：
   - 图片（按扩展名 + 魔数）→ 读文件 b64 → `data:<mime>;base64,...` 内嵌
   - 附件 → `📎 文件名`，记录原路径待移动
   - 失效引用 → 原样保留
   - 编码：utf-8 失败试 gb18030，再失败原样复制
3. **附件分流**：按类型白名单移动到指定文件夹（sha256 平铺去重），其余留在源库；全程记 manifest CSV（md、原始引用、原路径、动作、新路径、大小、sha256）
4. **超限修复**：目标 md `find -size +95M`，Pillow 压缩重内嵌
5. **git**：目标目录 `git init -b main`，按顶层目录分批 `add+commit+push`（每批 push 后确认成功再下一批），最后 README+manifest 单独一批
6. **收尾**：验证 `git rev-parse main origin/main` 一致 + API 查仓库 private/size；知识库复盘归档 `~/songshu/knowledge/topics/`
