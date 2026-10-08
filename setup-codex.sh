#!/bin/bash
# Codex 可移植配置：共用指引 + 仓库技能；已有目标先备份。
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODEX_DST="${CODEX_HOME:-$HOME/.codex}"

link_with_backup() {
  local src="$1" dst="$2" backup
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "  ⏭️  $dst 已正确软链"
    return
  fi
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    backup="${dst}.backup-$(date +%Y%m%d-%H%M%S)-$$"
    while [ -e "$backup" ] || [ -L "$backup" ]; do backup="${backup}-next"; done
    mv "$dst" "$backup"
    echo "  📦 已备份到 $backup"
  fi
  ln -s "$src" "$dst"
  echo "  ✅ $dst -> $src"
}

echo "🔗 配置 Codex..."
link_with_backup "$SCRIPT_DIR/AGENTS.md" "$CODEX_DST/AGENTS.md"
link_with_backup "$SCRIPT_DIR/README.md" "$CODEX_DST/README.md"
# 使用仓库作用域，避免改动 Pi 占用的 ~/.agents/skills。
link_with_backup "$SCRIPT_DIR/codex/skills" "$SCRIPT_DIR/.agents/skills"
# 可选：仅恢复用户已放入仓库、确认可公开的配置，不采集本机凭据。
if [ -f "$SCRIPT_DIR/codex/config.toml" ]; then
  link_with_backup "$SCRIPT_DIR/codex/config.toml" "$CODEX_DST/config.toml"
else
  echo "  ⏭️  未提供 codex/config.toml，保留本机配置"
fi
echo "✅ Codex 配置完成；新会话加载共用约定"
