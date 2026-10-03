# dotfiles

Personal configuration for development environment.

## What's included

```
├── pi/                    # Pi coding agent config
│   ├── agent/
│   │   ├── settings.json  # Pi settings
│   │   ├── models-store.json
│   │   └── auth.json      # API keys (private)
│   └── skills/            # Pi skills (NOT shared with WorkBuddy)
│       ├── anthropic/     # Anthropic official skills
│       └── pi/           # Pi built-in skills
└── README.md
```

## Setup on new machine

> 💡 推荐直接运行 `./setup.sh`（自动建好 Pi + WorkBuddy 的全部软链，含 `pi/skills` → `~/.agents/skills`）。下面手动步骤仅作参考，且不包含 WorkBuddy / knowledge 的配置。

### 1. Clone this repo

```bash
git clone https://github.com/zsongshu/songshu.git ~/songshu
cd ~/songshu
```

### 2. Create symlinks

```bash
# Pi config
mkdir -p ~/.pi/agent
ln -sf ~/songshu/pi/agent/settings.json ~/.pi/agent/settings.json
ln -sf ~/songshu/pi/agent/models-store.json ~/.pi/agent/models-store.json
ln -sf ~/songshu/pi/agent/auth.json ~/.pi/agent/auth.json

# Skills (Pi only)
ln -sf ~/songshu/pi/skills ~/.agents/skills
```

### 3. Authenticate Pi

```bash
pi /login
# or set your API key
export ANTHROPIC_API_KEY=sk-ant-...
```

## Notes

- `auth.json` contains sensitive API tokens - don't share
- Session data is stored in `~/.pi/agent/sessions/` (not synced)
- Update models: `pi update --models`
