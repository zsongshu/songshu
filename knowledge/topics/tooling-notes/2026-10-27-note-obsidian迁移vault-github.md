# 2026-10-27 Obsidian 库迁移 GitHub（脱离 iCloud）——完整复盘

## 最终结果
- **md**：7936 篇 → `~/songshu/vault`（保持原目录结构），**8200 处图片 base64 内嵌**（含按魔数识别的伪 .bin 图片）
- **ebook**（`~/Library/Mobile Documents/com~apple~CloudDocs/ebook`）：平铺移入 **7955 个** pdf/word/ppt/excel/视频（16G）；475 个同名不同内容加 `_hash8` 后缀；403 个内容重复只保留一份
- **暂存区**（`~/songshu/attachments-staging/`）：845 个不符合 ebook 规则的附件（txt 713 / zip / chm / bin 等）。**用户已决定（13:15）：平铺搬到 `ebook/其他/`**，搬运记录 `ebook/其他/_moved_from_staging.csv`；暂存区现只留 2 个流程记录 csv。
- **GitHub**：私有仓库 `zsongshu/tim-zhang-obs`（用 songshu 仓库内嵌 PAT 经 API 创建，gh 未安装）；52 个提交按顶层目录分批推送，本地与远程 HEAD 一致（7e3d9d8）
- **清单**：`vault/attachments-manifest.csv`（12980 行）：md↔图片内嵌↔附件 ebook/暂存区 映射；not_found 仅 81 条（dup 副本，内容在 ebook）
- 源 iCloud 库只读未动，确认无误后用户自行处理

## 用户规则（中途收紧过一次，最终版）
1. md 内所有图片 base64 内嵌
2. ebook 只放 pdf/word/ppt/excel/视频
3. 其他附件不进 ebook（先暂存）
4. vault 单独私有仓库（因含证件/合同/体检等敏感内容，不能进 public 的 songshu 主仓库）；`songshu/.gitignore` 已加 `vault/` 和 `attachments-staging/`

## 踩坑记录（重要）
1. **库里非 md 文件 50370 个**，远超 md 引用数——`_resources` 里大量无引用的网页快照图片（Evernote/网页剪藏遗留），只有 1 个 md 用 `<img>` 标签
2. **GitHub 100MB 单文件硬限制**：`0-日志/2023形成性练习.md` 内嵌后 116.95MB 被 pre-receive 拒绝（`GH001: Large files detected`）。修复：Pillow 把内嵌大图降采样（max_dim 2400, JPEG q85）→ 14.2MB。50-100MB 只警告可通过
3. **HTTPS 大推送不可靠**：批量 push 报 `failed to push`（同样原因）；SSH 一次推 1.6G 也会被远端掐断（`Connection closed by remote host`，半夜 Mac 休眠加重）。**可靠做法：逐提交增量推送 + caffeinate 防休眠 + 重试循环**
4. **shell 重试循环的坑**：`until git push | tail -1; do` 管道退出码取的是 tail 的，重试和失败判断全部失效——必须直接检查 git 退出码
5. **后台命令不继承 cwd**：`git -C` 显式指定
6. v1 脚本曾按旧规则把所有附件无差别移入 ebook；规则变更后 TaskStop + 按类型回撤 845 个到暂存区，无数据丢失（shutil.move 的映射靠 csv 记录）

## 关键脚本（本会话 .workbuddy/tmp/ 下）
scan_vault.py（只读扫描）/ migrate_vault.py（md+base64）/ restage_ebook.py / migrate_v2.py（合格附件移动）/ gen_manifest.py / shrink_big_md.py / git_push_v2.sh（分批提交+推送）

## 最终状态（2026-10-27 完成）
- attachments-staging 845 个已平铺搬入 `ebook/其他/`（搬运记录 `_moved_from_staging.csv`），staging 现仅留流程 csv
- 源库剩余 41949 孤儿附件按"同名同内容跳过 / 同名不同内容加哈希后缀"全部归集进 `ebook/其他/`（moved 6837 / renamed 8923 / skipped_dup 54）
- **源 iCloud 库（tim-zhang-obs）已于本会话移入 iCloud 废纸篓（可逆，未真删）**；vault 已含全部 7934 篇 md 于 GitHub 私有仓库 `zsongshu/tim-zhang-obs`（本地=远程 f7fae00）
- ebook：顶层约 7956 个（pdf/word/ppt/excel/视频）+ `其他/` 约 17502 个，共约 33G
- MD 里 510 条失效引用原样保留
