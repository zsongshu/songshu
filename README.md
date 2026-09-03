# dotfiles

Personal configuration for development environment.

## What's included

```
├── pi/                    # Pi coding agent config
│   └── agent/
│       ├── settings.json  # Pi settings
│       ├── models-store.json
│       └── auth.json      # API keys (private)
├── skills/                # Skills for pi
│   ├── anthropic/         # Anthropic official skills
│   └── pi/               # Pi built-in skills
└── README.md
```

## Setup on new machine

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

# Skills
ln -sf ~/songshu/skills ~/.agents/skills
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
