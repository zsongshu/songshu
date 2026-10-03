#!/bin/bash
# songshu dotfiles setup script
# Run this on a new machine after cloning the repo

set -e

REPO_DIR="$HOME/songshu"

echo "🚀 Setting up songshu dotfiles..."

# Create directories
echo "📁 Creating directories..."
mkdir -p "$HOME/.pi/agent"
mkdir -p "$HOME/.agents"

# Create symlinks for pi config
echo "🔗 Creating symlinks for pi config..."
ln -sf "$REPO_DIR/pi/agent/settings.json" "$HOME/.pi/agent/settings.json"
ln -sf "$REPO_DIR/pi/agent/models-store.json" "$HOME/.pi/agent/models-store.json"
ln -sf "$REPO_DIR/pi/agent/auth.json" "$HOME/.pi/agent/auth.json"

# Create symlink for skills
echo "🔗 Creating symlink for skills..."
ln -sf "$REPO_DIR/skills" "$HOME/.agents/skills"

# Create symlinks for WorkBuddy personal config (dotfiles)
echo "🔗 Creating symlinks for WorkBuddy config..."
WB_SRC="$REPO_DIR/workbuddy"
WB_DST="$HOME/.workbuddy"
WB_ITEMS="SOUL.md IDENTITY.md USER.md MEMORY.md memory mcp.json settings.json models.json skills"
mkdir -p "$WB_DST"
for it in $WB_ITEMS; do
  if [ -e "$WB_SRC/$it" ]; then
    if [ -L "$WB_DST/$it" ]; then
      echo "  ⏭️  $it already linked"
    elif [ -e "$WB_DST/$it" ]; then
      mv "$WB_DST/$it" "$WB_DST/.originals-$it"
      ln -s "$WB_SRC/$it" "$WB_DST/$it"
      echo "  ✅ $it (backed up original)"
    else
      ln -s "$WB_SRC/$it" "$WB_DST/$it"
      echo "  ✅ $it"
    fi
  else
    echo "  ⚠️  $it not found in repo, skipped"
  fi
done

# Verify
echo ""
echo "✅ Setup complete!"
echo ""
echo "Symlinks created:"
ls -la "$HOME/.pi/agent/settings.json" 2>/dev/null && echo "  ✅ settings.json"
ls -la "$HOME/.pi/agent/models-store.json" 2>/dev/null && echo "  ✅ models-store.json"
ls -la "$HOME/.pi/agent/auth.json" 2>/dev/null && echo "  ✅ auth.json"
ls -la "$HOME/.agents/skills" 2>/dev/null && echo "  ✅ skills"

echo ""
echo "Next steps:"
echo "  1. Run 'pi /login' to authenticate"
echo "  2. Or set your API key: export ANTHROPIC_API_KEY=sk-ant-..."
echo "  3. Restart pi"
