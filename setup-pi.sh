#!/bin/bash
# ============================================================
# setup-pi.sh —— 初始化 Pi（另一个 agent）的个人配置
# ------------------------------------------------------------
# 作用：把 ~/songshu/pi/agent 下的配置文件软链到 ~/.pi/agent
#       并把 Pi 的 skills（~/songshu/pi/skills）软链到 ~/.agents/skills
# 原则：只建软链、不复制文件。改动永远落回仓库（单一真源）。
# 可独立运行：换电脑时也可以只跑这一个脚本恢复 Pi。
# ============================================================

set -e

# 仓库根目录（取本脚本所在目录，换机器路径不同也能用）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR"

echo "🔗 配置 Pi (agent: pi)..."

PI_DST="$HOME/.pi/agent"
mkdir -p "$PI_DST"          # ~/.pi/agent 不存在就建
mkdir -p "$HOME/.agents"    # skills 的软链父目录

# Pi 的个人配置项（settings / models / auth）
PI_ITEMS="settings.json models-store.json auth.json"
for it in $PI_ITEMS; do
  if [ -e "$REPO_DIR/pi/agent/$it" ]; then
    ln -sf "$REPO_DIR/pi/agent/$it" "$PI_DST/$it"
    echo "  ✅ $it"
  else
    echo "  ⚠️  $it 在仓库中缺失，跳过"
  fi
done

# skills：Pi 专用（WorkBuddy 不共用，它有自己的 workbuddy/skills）
# 注意：-n 关键。若 ~/.agents/skills 已是指向目录的软链，
# 不加 -n 时 ln 会把它当目录、在仓库内造出 skills/skills 自循环。
if [ -L "$HOME/.agents/skills" ]; then
  echo "  ⏭️  skills 已软链，跳过"
else
  ln -sfn "$REPO_DIR/pi/skills" "$HOME/.agents/skills"
  echo "  ✅ skills (Pi 专用)"
fi

# 权威约定源 AGENTS.md 与入口索引 README.md → ~/.pi/agent/（与 WorkBuddy 共用同一真源，保证 pi 也能读到）
for doc in AGENTS.md README.md; do
  if [ -L "$PI_DST/$doc" ]; then
    echo "  ⏭️  $doc 已软链，跳过"
  elif [ -e "$REPO_DIR/$doc" ]; then
    ln -sf "$REPO_DIR/$doc" "$PI_DST/$doc"
    echo "  ✅ $doc"
  else
    echo "  ⚠️  $doc 在仓库中缺失，跳过"
  fi
done

# --- 验证：把实际软链打出来，方便肉眼确认 ---
echo "  --- 验证 ---"
for it in $PI_ITEMS; do
  if [ -L "$PI_DST/$it" ]; then
    echo "  👉 $it -> $(readlink "$PI_DST/$it")"
  else
    echo "  ❌ $it 未软链"
  fi
done
if [ -L "$HOME/.agents/skills" ]; then
  echo "  👉 skills -> $(readlink "$HOME/.agents/skills")"
else
  echo "  ❌ skills 未软链"
fi
for doc in AGENTS.md README.md; do
  if [ -L "$PI_DST/$doc" ]; then
    echo "  👉 $doc -> $(readlink "$PI_DST/$doc")"
  else
    echo "  ❌ $doc 未软链"
  fi
done

echo "✅ Pi 配置完成"
