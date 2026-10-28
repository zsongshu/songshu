#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ENEX(印象笔记/Evernote 导出) -> 知识库 + ebook 附件 处理流水线。

规则（按用户决策 2026-10-27）：
- 每个 enex 文件 = 一个笔记本 -> knowledge/topics/<笔记本名>/ 目录
- 图片(png/jpg/jpeg/gif/webp) -> base64 内嵌进 md 正文（不作为附件）
- 文件附件(pdf/doc/ppt/xlsx/未知二进制等) -> iCloud ebook/其他/，sha256 去重
  （同名同内容跳过，同名不同内容加 _hash8 后缀，绝不覆盖）
- ENML 正文 -> Markdown（标题/列表/表格/链接尽量保留）
- 输出 manifest.csv：每一条文件附件的 笔记本/笔记/原名/ebook路径/大小/sha256/mime

内存安全：用 iterparse 逐条 <note> 处理，适配数万笔记的单文件。
"""
import os, re, sys, csv, json, base64, hashlib, argparse, html
import xml.etree.ElementTree as ET
import html2text

IMAGE_MIME_PREFIX = ("image/png", "image/jpeg", "image/jpg", "image/gif", "image/webp", "image/bmp")
MIME_EXT = {
    "image/png": "png", "image/jpeg": "jpg", "image/jpg": "jpg", "image/gif": "gif",
    "image/webp": "webp", "image/bmp": "bmp",
    "application/pdf": "pdf", "application/msword": "doc",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document": "docx",
    "application/vnd.ms-powerpoint": "ppt",
    "application/vnd.openxmlformats-officedocument.presentationml.presentation": "pptx",
    "application/vnd.ms-excel": "xls",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": "xlsx",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.template": "xltx",
    "text/plain": "txt", "text/csv": "csv", "application/zip": "zip",
    "application/octet-stream": "bin",
}

def local(tag):
    return tag.split('}')[-1] if isinstance(tag, str) else ''

def find_one(elem, name):
    for c in elem.iter():
        if local(c.tag) == name:
            return c
    return None

def find_all(elem, name):
    return [c for c in elem.iter() if local(c.tag) == name]

def sha256_bytes(b):
    return hashlib.sha256(b).hexdigest()

def sha1_bytes(b):
    return hashlib.sha1(b).hexdigest()

def sanitize_filename(name, maxlen=80):
    name = name.strip().replace('\n', ' ').replace('\r', ' ')
    # 去掉路径非法字符（保留中文/空格/点/连字符/括号）
    name = re.sub(r'[/\\:*?"<>|]', '_', name)
    name = re.sub(r'\s+', ' ', name).strip(' .')
    if not name:
        name = "未命名"
    return name[:maxlen]

def derive_notebook(enex_path, forced):
    if forced:
        return sanitize_filename(forced)
    fn = os.path.splitext(os.path.basename(enex_path))[0]
    fn = re.sub(r'^\d+[_.\-]', '', fn)  # 去掉可能的 000_ 前缀
    return sanitize_filename(fn)

# ---------- 资源(附件/图片) ----------
def get_resources(note):
    out = []
    for r in find_all(note, "resource"):
        de = find_one(r, "data")
        b64 = (de.text or "").strip() if de is not None else ""
        raw = base64.b64decode(b64) if b64 else b""
        mime = (find_one(r, "mime").text or "application/octet-stream") if find_one(r, "mime") is not None else "application/octet-stream"
        fname = ""
        ra = find_one(r, "resource-attributes")
        if ra is not None:
            fn = find_one(ra, "file-name")
            if fn is not None and fn.text:
                fname = fn.text
        out.append({
            "md5": hashlib.md5(raw).hexdigest(),
            "sha1": sha1_bytes(raw),
            "sha256": sha256_bytes(raw),
            "mime": mime,
            "b64": b64,
            "raw": raw,
            "fname": fname,
        })
    return out

def save_attachment(res, ebook_dir, written_sha):
    """把文件附件落到 ebook_dir，去重。返回 (final_path, action)"""
    mime = res["mime"]
    ext = os.path.splitext(res["fname"])[1]
    if not ext:
        ext = "." + MIME_EXT.get(mime, "bin")
    stem = sanitize_filename(os.path.splitext(res["fname"])[0] or ("附件_" + res["sha256"][:8]))
    name = stem + ext
    path = os.path.join(ebook_dir, name)
    if os.path.exists(path):
        if written_sha.get(path) == res["sha256"]:
            return path, "dup_skip"
        if sha256_bytes(open(path, "rb").read()) == res["sha256"]:
            written_sha[path] = res["sha256"]
            return path, "dup_skip"
        name = f"{stem}_{res['sha256'][:8]}{ext}"
        path = os.path.join(ebook_dir, name)
    with open(path, "wb") as f:
        f.write(res["raw"])
    written_sha[path] = res["sha256"]
    return path, "moved"

# ---------- ENML -> Markdown ----------
ENMEDIA_RE = re.compile(r'<en-media\b[^>]*?>', re.I)
ATTR_RE = re.compile(r'(\w+)="([^"]*)"')

def enml_to_markdown(content_el, res_by_md5, att_tokens):
    # <content> 内的 ENML 可能是「XML 子元素」或「转义后的文本」，两种都要兼容
    if len(list(content_el)):
        inner = "".join(ET.tostring(c, encoding="unicode") for c in list(content_el))
    else:
        inner = content_el.text or ""
    inner = html.unescape(inner)
    def repl(m):
        tag = m.group(0)
        attrs = dict(ATTR_RE.findall(tag))
        h = attrs.get("hash", "").lower()
        t = (attrs.get("type") or "").lower()
        att_tokens.append(h)  # 始终记录被正文引用的 hash（图片/附件都记），供后续判重
        r = res_by_md5.get(h)
        if r is None:
            return ""
        if t.startswith("image/") or r["mime"].startswith("image/"):
            return f'<img alt="" src="data:{r["mime"]};base64,{r["b64"]}"/>'
        # 文件附件：留占位符，稍后替换为 ebook 链接
        return f"[[ATT:{h}]]"
    new = ENMEDIA_RE.sub(repl, inner)
    h = html2text.HTML2Text()
    h.body_width = 0
    h.ignore_links = False
    h.ignore_images = False
    h.protect_links = True
    md = h.handle(new)
    return md

def note_fields(note):
    title = find_one(note, "title")
    title = title.text if title is not None and title.text else "未命名"
    created = find_one(note, "created")
    updated = find_one(note, "updated")
    tags = [t.text for t in find_all(note, "tag") if t.text]
    content_el = find_one(note, "content")
    return title, created, updated, tags, content_el

def yaml_escape(s):
    s = (s or "").replace('"', '\\"')
    return '"' + s + '"'

def process_enex(enex_path, out_base, ebook_dir, notebook, written_sha, manifest_rows, stats, used_names):
    os.makedirs(os.path.join(out_base, notebook), exist_ok=True)
    nb_dir = os.path.join(out_base, notebook)
    for event, elem in ET.iterparse(enex_path, events=("end",)):
        if local(elem.tag) != "note":
            continue
        try:
            title, created, updated, tags, content_el = note_fields(elem)
            resources = get_resources(elem)
            res_by_md5 = {r["md5"]: r for r in resources}
            att_tokens = []
            md_body = ""
            if content_el is not None:
                md_body = enml_to_markdown(content_el, res_by_md5, att_tokens)
            referenced = set(att_tokens)  # 正文中通过 <en-media> 引用到的 resource hash(MD5)
            att_links = []
            unref_images = []
            for r in resources:
                if r["mime"].startswith("image/"):
                    if r["md5"] in referenced:
                        continue  # 已被正文 <en-media> 内嵌为 base64
                    unref_images.append(r)  # 未被引用的图片：末尾补内嵌，避免丢失
                    continue
                # 文件附件：【全部抽取到 ebook】，无论是否被正文引用
                path, action = save_attachment(r, ebook_dir, written_sha)
                aname = r["fname"] or os.path.basename(path)
                md_body = md_body.replace(f"[[ATT:{r['md5']}]]", f"[{aname}]({path})")
                att_links.append((aname, path, action, r))
                manifest_rows.append({
                    "notebook": notebook, "note_title": title,
                    "attach_name": aname,
                    "ebook_path": path, "size": len(r["raw"]),
                    "sha256": r["sha256"], "mime": r["mime"],
                    "action": action,
                })
                stats["file_attachments"] += 1
            # 未被正文引用的图片：追加到正文末尾内嵌
            for r in unref_images:
                uri = f"data:{r['mime']};base64,{r['b64']}"
                md_body += f"\n\n![]({uri})"
                stats["images_unreferenced"] = stats.get("images_unreferenced", 0) + 1
            # 笔记文件名
            base = sanitize_filename(title)
            fname = base + ".md"
            i = 1
            while fname in used_names:
                fname = f"{base}_{i}.md"; i += 1
            used_names.add(fname)
            # 组装 md
            fm = [
                "---",
                f"title: {yaml_escape(title)}",
                f"notebook: {yaml_escape(notebook)}",
                f"tags: {yaml_escape(', '.join(tags)) if tags else '[]'}",
                f"created: {created.text if created is not None else ''}",
                f"updated: {updated.text if updated is not None else ''}",
                f"source_enex: {yaml_escape(os.path.basename(enex_path))}",
                f"attachments: {len(att_links)}",
                "---",
                "",
                f"# {title}",
                "",
                md_body.strip(),
            ]
            if att_links:
                fm.append("")
                fm.append("## 附件")
                for an, ap, _, _ in att_links:
                    fm.append(f"- [{an}]({ap})")
            with open(os.path.join(nb_dir, fname), "w", encoding="utf-8") as f:
                f.write("\n".join(fm) + "\n")
            stats["notes"] += 1
            if any(r["mime"].startswith("image/") for r in resources):
                stats["notes_with_images"] += 1
            stats["images_inline"] += sum(1 for r in resources if r["mime"].startswith("image/"))
        except Exception as e:
            stats["errors"] += 1
            stats["error_samples"].append(f"{os.path.basename(enex_path)}: {e}")
        finally:
            elem.clear()

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("enex_dir", help="含 .enex 的目录（或单个文件）")
    ap.add_argument("--out", default="/Users/timzhang/songshu/knowledge/topics", help="知识库 topics 根")
    ap.add_argument("--ebook", default="/Users/timzhang/Library/Mobile Documents/com~apple~CloudDocs/ebook/其他", help="附件目标目录")
    ap.add_argument("--notebook", default=None, help="强制统一笔记本名（试点用）")
    ap.add_argument("--manifest", default=None, help="manifest 输出路径")
    args = ap.parse_args()

    if os.path.isfile(args.enex_dir):
        enex_files = [args.enex_dir]
    else:
        enex_files = sorted([os.path.join(args.enex_dir, f) for f in os.listdir(args.enex_dir) if f.lower().endswith(".enex")])

    os.makedirs(args.out, exist_ok=True)
    os.makedirs(args.ebook, exist_ok=True)
    written_sha = {}
    manifest_rows = []
    stats = {"notes": 0, "notes_with_images": 0, "images_inline": 0, "file_attachments": 0, "errors": 0, "error_samples": []}
    manifest_path = args.manifest or os.path.join(args.out, "..", "yinxiang_manifest.csv")
    used_by_nb = {}

    for ef in enex_files:
        nb = derive_notebook(ef, args.notebook)
        process_enex(ef, args.out, args.ebook, nb, written_sha, manifest_rows, stats, used_by_nb.setdefault(nb, set()))

    with open(manifest_path, "w", encoding="utf-8-sig", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["notebook","note_title","attach_name","ebook_path","size","sha256","mime","action"])
        w.writeheader()
        w.writerows(manifest_rows)

    print(json.dumps({"enex_files": len(enex_files), "stats": stats, "manifest": os.path.abspath(manifest_path)}, ensure_ascii=False, indent=2))

if __name__ == "__main__":
    main()
