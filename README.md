# kotik

Modular zsh prompt framework. Async-safe, segment-based, themeable.

## Install

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ZenStarDev/Kotik/main/bin/install.sh)"
```

## Usage

```sh
kotik::help     # Show commands
kotik::reload   # Reload config
kotik::devmode  # Enable dev mode
```

## Config (`~/.kotik.zsh`)

| Option | Default |
|--------|---------|
| `theme` | classic |
| `segments_left` | `dir git venv` |
| `segments_right` | `status duration time` |
| `newline` | 1 |
| `compact_path` | 1 |

## Plugins

Place `.zsh` files in `plugins.d/`. Set `KOTIK_OPT[plugins]="fzf zoxide"` to load.

## Tools

- `bin/dashboard.sh` - Terminal Command Center
- `bin/auto-rice.sh` - Auto desktop setup script