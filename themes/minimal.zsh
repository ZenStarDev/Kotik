#!/usr/bin/env zsh
# themes/minimal.zsh

kotik::theme::minimal::left() {
  print -n "$(kotik::fg cyan)%1~$(kotik::reset) $(kotik::prompt::symbol) "
}

KOTIK_THEME=(
  prompt_format  '$(kotik::theme::minimal::left)'
  rprompt_format ''
)
