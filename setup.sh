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
