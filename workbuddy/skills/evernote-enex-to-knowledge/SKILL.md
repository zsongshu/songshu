---
name: evernote-enex-to-knowledge
description: 将印象笔记/Evernote 的 ENEX 导出文件处理为知识库 md + ebook 附件。规则：图片 base64 内嵌 md 主体、文件附件去重落到 ebook/其他、按笔记本建 knowledge/topics/<笔记本>/ 目录。当用户要把印象笔记笔记下载/迁移到本地知识库、或处理 .enex 文件时使用。
---

# ENEX → 知识库 + ebook 附件 流水线

## 适用场景
用户要把印象笔记（Evernote/印象笔记）的笔记落到本地：`~/songshu/knowledge` 作文本库，iCloud `ebook/其他` 作附件库。
核心分流规则（可按需调整）：
- 图片（png/jpg/jpeg/gif/webp）→ **base64 内嵌进 md 正文**（不作为附件）
- 文件附件（pdf/word/ppt/xlsx/未知二进制等）→ 抽到 `ebook/其他/`，**sha256 去重**（同名同内容跳过，同名不同内容加 `_hash8` 后缀，绝不覆盖）
- 每个 enex 文件 = 一个笔记本 → `knowledge/topics/<笔记本名>/<笔记标题>.md`
- 输出 `manifest.csv` 记录每条文件附件的映射

## 关键坑（必看，否则丢数据）
1. **en-media 的 `hash` 是资源数据的 MD5**（不是 SHA1）。匹配 en-media↔resource 必须用 md5。
2. **`<content>` 在部分 enex 里是「转义后的文本」**（`&lt;en-note&gt;...`），不是 XML 子元素。必须读 `content_el.text` 并 `html.unescape`，否则**整段正文会丢空**——只留下末尾追加的图片和附件。
3. **文件名去重必须跨文件累计**：同一笔记本的笔记可能分散在多个 enex 文件，或不同文件有同名笔记。用「按笔记本累计的 used_names 集合」，否则后写的会覆盖先写的（344 篇曾因此丢成 172 篇）。
4. **repl 替换 en-media 时，对图片也要把 hash 记入 att_tokens**：否则 `referenced` 集合缺图片 hash，全部图片被判「未引用」堆到笔记末尾，而非按原文位置内嵌。
5. ENML 用 `<en-note>` 包裹，图片用 `<en-media hash type="image/*"/>` 引用 resource。html2text 可直接转 ENML→MD，en-media 先替换成 `<img src="data:...">` 或 `[[ATT:hash]]` 占位符再替换。
6. 大文件（数万笔记的单 enex）用 `iterparse(events=('end',))` 逐 `<note>` 处理并 `elem.clear()`，避免内存爆炸。

## 用法
```bash
# 试点/全量都用同一个脚本，改 --out/--ebook/--notebook 即可
python enex_to_knowledge.py <enex目录或单文件> \
  --out ~/songshu/knowledge/topics \
  --ebook "/Users/timzhang/Library/Mobile Documents/com~apple~CloudDocs/ebook/其他" \
  --notebook "强制笔记本名(可选)" \
  --manifest <输出csv>
```
- 全量导出时每个 enex=一个笔记本，笔记本名取文件名（去掉 `000_` 前缀）。
- 若 enex 是「每文件一篇笔记」的子集（无笔记本信息），用 `--notebook` 强制归入一个 topic。
- 依赖：python + `html2text`（`pip install html2text`）。

## 验证清单（跑完必查）
- md 文件数 == 笔记数（无覆盖丢失）
- `data:image` 出现在正文位置（非仅末尾）→ 图片按位内嵌
- `_attachments`/ebook 文件数 < 资源数 → 去重生效
- 抽查一篇带附件笔记，末尾「附件」段链接可点开
