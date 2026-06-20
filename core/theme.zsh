#!/usr/bin/env zsh
# core/theme.zsh

typeset -gA KOTIK_THEME

kotik::theme::load() {
  local name=$1
  local file="$KOTIK_HOME/themes/${name}.zsh"
  if [[ ! -r "$file" ]]; then
    print -u2 "kotik: theme '$name' not found, falling back to classic"
    file="$KOTIK_HOME/themes/classic.zsh"
  fi
  source "$file"
  kotik::theme::compose
}

kotik::theme::compose() {
  if [[ "${KOTIK_OPT[newline]}" == 1 ]]; then
    PROMPT=$'\n'"${KOTIK_THEME[prompt_format]}"
  else
    PROMPT="${KOTIK_THEME[prompt_format]}"
  fi
  RPROMPT="${KOTIK_THEME[rprompt_format]}"
}
