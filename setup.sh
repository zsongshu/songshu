#!/bin/bash
# ============================================================
# setup.sh —— songshu dotfiles 主入口
# ------------------------------------------------------------
# 换电脑 clone 完仓库后，跑一次 ./setup.sh 即可恢复全部 agent 配置。
# 它不自己干活，只按顺序调用三个子脚本：
#   1) setup-pi.sh          —— 初始化 Pi
#   2) setup-workbuddy.sh   —— 初始化 WorkBuddy
#   3) setup-codex.sh       —— 初始化 Codex
# 想单独恢复某一个 agent，直接跑对应的子脚本即可。
# ============================================================

set -e

# 仓库根目录（取本脚本所在目录）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 songshu dotfiles 初始化..."
echo "   仓库位置: $SCRIPT_DIR"
echo ""

echo "===== 1/3  Pi ====="
"$SCRIPT_DIR/setup-pi.sh"

echo ""
echo "===== 2/3  WorkBuddy ====="
"$SCRIPT_DIR/setup-workbuddy.sh"

echo ""
echo "===== 3/3  Codex ====="
"$SCRIPT_DIR/setup-codex.sh"

echo "🎉 全部完成！"
echo ""
echo "下一步:"
echo "  1. Pi:        运行 'pi /login' 登录，或 export ANTHROPIC_API_KEY=sk-ant-..."
echo "  2. WorkBuddy: 重启应用，配置会自动从 ~/songshu/workbuddy 加载"
echo "  3. Codex:     新建会话加载共用指引；从 ~/songshu 开始工作"
