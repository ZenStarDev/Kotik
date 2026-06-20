#!/usr/bin/env zsh
# themes/powerline.zsh

KOTIK_POWERLINE_SEP=""

kotik::theme::powerline::block() {
  local bgc=$1 fgc=$2 text=$3
  [[ -z "$text" ]] && return
  print -n "$(kotik::bg $bgc)$(kotik::fg $fgc) ${text} $(kotik::reset)$(kotik::fg $bgc)${KOTIK_POWERLINE_SEP}$(kotik::reset)"
}

kotik::theme::powerline::left() {
  local out=""
  out+=$(kotik::theme::powerline::block blue bg "%1~")
  command git rev-parse --is-inside-work-tree &>/dev/null && {
    local branch
    branch=$(command git symbolic-ref --short HEAD 2>/dev/null)
    [[ -n "$branch" ]] && out+=$(kotik::theme::powerline::block gray bg "$branch")
  }
  print -n "${out} "
}

KOTIK_THEME=(
  prompt_format  '$(kotik::theme::powerline::left)'
  rprompt_format '$(kotik::render::right)'
)
