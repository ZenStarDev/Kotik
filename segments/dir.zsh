#!/usr/bin/env zsh
# segments/dir.zsh

kotik::segment::dir() {
  local path
  if [[ "${KOTIK_OPT[compact_path]}" == 1 ]]; then
    path="%(5~|%-1~/…/%2~|%4~)"
  else
    path="%~"
  fi

  local icon=""
  [[ "${KOTIK_OPT[nerd_fonts]}" == 1 ]] && icon=" "

  local color="cyan"
  [[ ! -w "$PWD" ]] && color="red"

  print -n "$(kotik::fg $color)${icon}${path}$(kotik::reset)"
}

kotik::segment::register dir kotik::segment::dir
