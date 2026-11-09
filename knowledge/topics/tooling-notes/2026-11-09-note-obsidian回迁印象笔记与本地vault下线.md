# 2026-11-09 Obsidian 笔记回迁印象笔记 + 本地 vault 下线

> 结论先行：张松树确认「还是印象笔记好用，找不到替代品」，把本地 Obsidian 库剩余 937 篇全量导入印象笔记云端，随后移除 `~/songshu/vault/`。**本地已无 Obsidian 库**，原始版本由「完整 tar 备份 + 私有 git 仓库」双份保全。

## 一、为什么回迁

- 2026-10-27 曾把 7,934 篇从 iCloud Obsidian 迁到 `~/songshu/vault`（图片 base64 内嵌、附件分流 iCloud `ebook/`、独立私有仓库 `zsongshu/tim-zhang-obs`）。
- 之后多轮清理：删除「指定了附件但附件不存在」的空壳笔记（1,238 篇 + 1,867 篇）、外部提交删除 `zip/` 第三方文档 3,884 篇，最终剩 **937 篇 md / 3.6GB**。
- 2026-11-09 用户决定回到印象笔记：笔记工具的核心价值是随时能写、随处能搜、同步不操心，难替代。

## 二、导入链路（纯本地生成 ENEX → 桌面端 import）

| 环节 | 做法 | 结果 |
|---|---|---|
| token 直连 API | `mcp.json` 的 dev token 已 `AUTH_EXPIRED` | 放弃；且历史实测带二进制接口限速 ~6KB/s，2GB 传不动 |
| 桌面端 `export` | sdef 声明但未实现，51 本全报 -1708 | 放弃 |
| md → 标准 ENEX | `.workbuddy/tmp/md_to_enex.py`：base64 还原成 `<resource>` + `<en-media hash=MD5>`，标题/`Created·Updated at` 还原成 ENEX 字段 | 42 个 enex / 1.32GB / 936 篇 / 4,048 资源，hash 4,048/4,048 匹配、XML 零错误 |
| ENEX → 云端 | `.workbuddy/tmp/yinxiang_enex_import.py`，AppleScript `import (POSIX file ...) to "<笔记本>"`，`OB导入-` 前缀隔离 | **41 文件全成功，应导 935 / 实导 935，0 失败、0 篇数不符**；加 probe 的 1 篇 = **936 篇全部进云端** |

- 体积真相：md 里 72.9MB 是 base64 膨胀，解码后最大单篇资源仅 34.1MB（`jdt-report`），未触发 25MB 上限失败。
- 导入脚本两道保险：全量自动跳过 probe 已导入的 enex（防重复）；每文件记录 ENEX 实际 `<note>` 数与 `import` 回报篇数比对，不符标 `MISMATCH`。
- **必须用户在本机 Terminal 跑**：agent 后台进程调 osascript 触发 macOS -10004 权限拦截，只有 GUI Terminal 能弹授权。

## 三、本地 vault 下线（2026-11-09 23:08）

删除前核验：导入 manifest 全绿（41/41 成功、935/935 篇吻合）；`git ls-remote origin HEAD` = `32f85a9` 可达。

| 项 | 状态 |
|---|---|
| `~/songshu/vault/` | **已移除**（947 文件 / 3.6GB / 48 目录） |
| 完整备份 | `/Users/timzhang/WorkBuddy/2026-10-27-00-55-04/.workbuddy/tmp/vault_full_backup_20261109.tar` — 3.6G、1,411 条目、937 篇 md、378 个 `.git` 对象，`tar -tf` 与抽样提取均通过 |
| 远程兜底 | `git@github.com:zsongshu/tim-zhang-obs.git`（私有，HEAD `32f85a9`，942 篇 md + 全部历史，已验证可达） |
| 云端 | 印象笔记 936 篇，笔记本名 `OB导入-<原目录名>` |
| 废纸篓副本 | `trash` 命令返回成功，但 agent 环境受 macOS TCC 隐私拦截（`scandir` 抛 `Operation not permitted`），**精确路径 10/10 均确认不到，不视为可依赖的恢复源** |
| `~/songshu` 主仓库 | 完好；`.gitignore` 早有 `/vault/` 排除，删它不影响 public 仓库 |

执行遵循铁律：先确认上传完成 → 先做完整备份并验证 → 整目录原子移入废纸篓（非 `rm`）→ 核验。

## 四、恢复方法（三条，任选）

```bash
# ① 从完整 tar 备份还原（含 .git 全部历史，最完整）
mkdir -p /Users/timzhang/songshu && \
tar -xf /Users/timzhang/WorkBuddy/2026-10-27-00-55-04/.workbuddy/tmp/vault_full_backup_20261109.tar \
    -C /Users/timzhang/songshu

# ② 从私有仓库 clone（原始 markdown + 完整提交历史）
git clone git@github.com:zsongshu/tim-zhang-obs.git /Users/timzhang/songshu/vault

# ③ 印象笔记云端：OB导入-* 笔记本里 936 篇（ENML 有损副本）
```

## 五、已知限制与遗留

1. **云端是有损副本**：md → ENML 后，原始 markdown 语法、目录层级（压成笔记本名）、git 历史均丢失；图片虽还原成资源，但 base64 原件格式不在。要原始版本必须用 ① 或 ②。
2. **6 个未提交改动**曾存在于旧工作区（1 个 `.obsidian/workspace.json` + 5 个删除）。那 5 篇本地已不存在、**未导入印象笔记**，只在远程 git 与 tar 备份的历史里。
3. **磁盘**：删除时仅剩 13Gi 可用（97% 满）。tar 备份额外占 3.6GB；废纸篓若真有副本也占 3.6GB。确认云端用顺手后，可删 tar 备份 + 清空废纸篓释放空间（那一步不可逆，需另行确认）。
4. **重复提示**：云端原本已有 60 笔记本 / 69,805 篇，本次新增 936 篇到隔离前缀笔记本，部分内容可能与云端镜像重复。
5. 相关清单：`vault_deletion_scope.csv`（947 路径）、`yinxiang_import_manifest.csv`（41 文件核验）、`vault_shell_final.csv`（此前空壳清理），均在 `.workbuddy/tmp/`。
