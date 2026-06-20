#!/usr/bin/env zsh
# ~/.kotik.zsh — kotik user config
# loaded after core/segments, before theme compose

# theme
KOTIK_OPT[theme]=classic              # classic | minimal | powerline

#  layout
KOTIK_OPT[segments_left]="dir git venv node"
KOTIK_OPT[segments_right]="status duration time"
KOTIK_OPT[newline]=1                  # blank line before each prompt
KOTIK_OPT[compact_path]=1             # %4~ vs full %~

# symbols
KOTIK_OPT[prompt_symbol]="❯"
KOTIK_OPT[prompt_symbol_err]="❯"
KOTIK_OPT[nerd_fonts]=1               # set 0 if your font lacks glyphs

# behavior
KOTIK_OPT[prompt_vimode]=1            # vi keybindings + mode indicator
KOTIK_OPT[duration_threshold]=3       # seconds before showing cmd time
KOTIK_OPT[async]=1

# palette overrides
kotik::palette::set green  "#a3be8c"
kotik::palette::set red    "#bf616a"
kotik::palette::set cyan   "#88c0d0"
kotik::palette::set yellow "#ebcb8b"

# custom segment example
# define your own and add its name to segments_left/right
kotik::segment::kubectx() {
  command -v kubectl >/dev/null || return
  local ctx
  ctx=$(kubectl config current-context 2>/dev/null) || return
  print -n "$(kotik::fg blue)⎈ ${ctx}$(kotik::reset)"
}
kotik::segment::register kubectx kotik::segment::kubectx
# KOTIK_OPT[segments_left]+=" kubectx"

# aliases / misc shell config can live here too
alias ll="ls -lah"
alias gs="git status"
