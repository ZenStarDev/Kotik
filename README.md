# kotik

Modular zsh prompt framework. Async-safe, segment-based, themeable.

## install

```sh
git clone <repo> kotik && cd kotik
bash bin/install.sh
```

Installs to `~/.kotik`, writes `~/.kotik.zsh` (your config), wires `~/.zshrc`.

## uninstall

```sh
bash bin/uninstall.sh
```

## structure

```
core/        bootstrap: colors, cache, async, hooks, render, theme loader
segments/    individual prompt segments (dir, git, venv, status, ...)
themes/      layout definitions (classic, minimal, powerline)
functions/   shared prompt-building helpers (symbol, etc)
plugins.d/   optional third-party integrations, autoloaded in order
bin/         install / uninstall scripts
cache/       async fifo scratch space
```

## config

Everything lives in `~/.kotik.zsh`, sourced after segments are registered.
See `kotik.conf.example.zsh` for the full option surface:

| key | values | default |
|---|---|---|
| `theme` | classic / minimal / powerline | classic |
| `segments_left` | space-separated segment names | `dir git venv` |
| `segments_right` | space-separated segment names | `status duration time` |
| `newline` | 0 / 1 | 1 |
| `compact_path` | 0 / 1 | 1 |
| `prompt_symbol` | any string | ❯ |
| `prompt_vimode` | 0 / 1 | 1 |
| `duration_threshold` | seconds | 3 |
| `nerd_fonts` | 0 / 1 | 1 |

## writing a segment

```sh
kotik::segment::mything() {
  # return early (no output) to hide the segment
  command -v something >/dev/null || return
  print -n "$(kotik::fg cyan)mything$(kotik::reset)"
}
kotik::segment::register mything kotik::segment::mything
```

Add `mything` to `segments_left` / `segments_right` to enable it.

## writing a theme

A theme sets two keys in `KOTIK_THEME`:

```sh
KOTIK_THEME=(
  prompt_format  '$(kotik::render::left) $(kotik::prompt::symbol) '
  rprompt_format '$(kotik::render::right)'
)
```

Drop the file in `themes/<name>.zsh`, set `KOTIK_OPT[theme]=<name>`.

## palette

```sh
kotik::palette::set green "#a3be8c"
```

Falls back to nearest 256-color when `$COLORTERM` isn't truecolor.
