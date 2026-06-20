#!/usr/bin/env zsh
# kotik — modular zsh prompt/config framework
# entry point: source this file from .zshrc

0=${(%):-%N}
KOTIK_HOME=${KOTIK_HOME:-${0:A:h}}
KOTIK_CONFIG=${KOTIK_CONFIG:-$HOME/.kotik.zsh}
KOTIK_CACHE_DIR=${KOTIK_CACHE_DIR:-$KOTIK_HOME/cache}

typeset -gA KOTIK_OPT
KOTIK_OPT=(
  theme            classic
  segments_left    "dir git venv"
  segments_right   "status duration time"
  prompt_symbol    "❯"
  prompt_symbol_err "❯"
  prompt_vimode    1
  newline          1
  transient        0
  async            1
  duration_threshold 3
  git_max_dirty    50
  nerd_fonts       1
  compact_path     1
  plugins          ""
)

autoload -Uz add-zsh-hook colors && colors

for f in "$KOTIK_HOME"/core/*.zsh; do
  [[ -r "$f" ]] && source "$f"
done

for f in "$KOTIK_HOME"/segments/*.zsh; do
  [[ -r "$f" ]] && source "$f"
done

for f in "$KOTIK_HOME"/functions/*.zsh; do
  [[ -r "$f" ]] && source "$f"
done

for f in "$KOTIK_HOME"/plugins.d/*.zsh; do
  [[ -r "$f" ]] && source "$f"
done

[[ -r "$KOTIK_CONFIG" ]] && source "$KOTIK_CONFIG"

kotik::init
kotik::theme::load "${KOTIK_OPT[theme]}"

kotik::help() {
    cat <<'EOF'
kotik - modular zsh prompt framework

USAGE:
  kotik::help              Show this help
  kotik::palette::set k v   Set color palette (e.g., kotik::palette::set blue "#88c0d0")
  kotik::theme::load name   Load theme by name (classic|minimal|powerline)

OPTIONS (~/.kotik.zsh):
  theme            prompt theme (classic|minimal|powerline)
  segments_left    space-separated segments for left side
  segments_right   space-separated segments for right side
  newline          1 = blank line before prompt
  compact_path     1 = shorten path display
  prompt_symbol    prompt symbol (default: ❯)
  prompt_vimode    1 = show vi mode indicator
  duration_threshold seconds before showing command duration
  nerd_fonts       1 = enable nerd font glyphs
  async            1 = enable async rendering

SEGMENTS:
  dir      Current directory (cyan, red if read-only)
  git      Git branch with status
  venv     Python virtualenv/conda env name
  node     Node.js version (if package.json/node_modules/.nvmrc exists)
  status   Exit code indicator (red X for errors)
  duration Command execution time (if >= threshold seconds)
  time     Clock (HH:MM:SS)
  vimode   Vi mode indicator (N/I)
  jobs     Background jobs count
  python   Python version (if project files exist)

Add custom segments to ~/.kotik.zsh:
  kotik::segment::myseg() { ... }
  kotik::segment::register myseg kotik::segment::myseg
KOTIK_OPT[segments_left]+=" myseg"
}

kotik::version() {
    print "kotik 1.0.0"
}

kotik::reload() {
    source "$KOTIK_HOME/kotik.zsh"
    print "kotik: reloaded"
}

kotik::edit() {
    "\$EDITOR" "\$KOTIK_CONFIG"
}

kotik::debug() {
    print "KOTIK_OPT:"
    print "${KOTIK_OPT[@]}"
    print "KOTIK_THEME:"
    print "${KOTIK_THEME[@]}"
}

kotik::devmode() {
    KOTIK_OPT[duration_threshold]=0
    KOTIK_OPT[git_max_dirty]=1000
    [[ "${KOTIK_OPT[devmode]}" != 1 ]] && KOTIK_DEV_MODE=1
    KOTIK_OPT[devmode]=1
    print "kotik: dev mode enabled (debug segments, no duration threshold)"
}
