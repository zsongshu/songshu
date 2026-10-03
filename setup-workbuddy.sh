#!/bin/bash
# ============================================================
# setup-workbuddy.sh —— 初始化 WorkBuddy 的个人配置 (dotfiles)
# ------------------------------------------------------------
# 作用：把 ~/songshu/workbuddy 下的个人配置软链到 ~/.workbuddy
#       并把 agent 指引 AGENTS.md 软链过去（保证单一真源、自动同步）
# 原则：只建软链、不复制文件。改动永远落回仓库（单一真源）。
# 安全：若 ~/.workbuddy 下有同名真实文件，先备份成 .originals-<名> 再链。
# 可独立运行：换电脑时也可以只跑这一个脚本恢复 WorkBuddy。
# ============================================================

set -e

# 仓库根目录（取本脚本所在目录，换机器路径不同也能用）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR"

echo "🔗 配置 WorkBuddy..."

WB_SRC="$REPO_DIR/workbuddy"
WB_DST="$HOME/.workbuddy"
mkdir -p "$WB_DST"    # ~/.workbuddy 不存在就建

# WorkBuddy 个人配置项
WB_ITEMS="SOUL.md IDENTITY.md USER.md MEMORY.md memory mcp.json settings.json models.json skills"
for it in $WB_ITEMS; do
  if [ -e "$WB_SRC/$it" ]; then
    if [ -L "$WB_DST/$it" ]; then
      echo "  ⏭️  $it 已软链，跳过"
    elif [ -e "$WB_DST/$it" ]; then
      # 目标已有真实文件 → 先备份再链，避免覆盖丢配置
      mv "$WB_DST/$it" "$WB_DST/.originals-$it"
      ln -s "$WB_SRC/$it" "$WB_DST/$it"
      echo "  ✅ $it (已备份原文件到 .originals-$it)"
    else
      ln -s "$WB_SRC/$it" "$WB_DST/$it"
      echo "  ✅ $it"
    fi
  else
    echo "  ⚠️  $it 在仓库中缺失，跳过"
  fi
done

# agent 指引（仓库根 AGENTS.md）→ ~/.workbuddy/AGENTS.md
# 单一真源：WorkBuddy 与 ~/songshu/AGENTS.md 始终同步
if [ -L "$WB_DST/AGENTS.md" ]; then
  echo "  ⏭️  AGENTS.md 已软链，跳过"
else
  ln -sf "$REPO_DIR/AGENTS.md" "$WB_DST/AGENTS.md"
  echo "  ✅ AGENTS.md"
fi

# 入口索引 README.md → ~/.workbuddy/README.md（与 AGENTS.md 并列，确保 agent 开局能读到）
if [ -L "$WB_DST/README.md" ]; then
  echo "  ⏭️  README.md 已软链，跳过"
else
  ln -sf "$REPO_DIR/README.md" "$WB_DST/README.md"
  echo "  ✅ README.md"
fi

# --- 验证：把实际软链打出来，方便肉眼确认 ---
echo "  --- 验证 ---"
for it in $WB_ITEMS AGENTS.md README.md; do
  if [ -L "$WB_DST/$it" ]; then
    echo "  👉 $it -> $(readlink "$WB_DST/$it")"
  else
    echo "  ❌ $it 未软链"
  fi
done

echo "✅ WorkBuddy 配置完成"
