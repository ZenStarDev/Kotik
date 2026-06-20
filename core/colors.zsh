#!/usr/bin/env zsh
# core/colors.zsh

typeset -gA KOTIK_PALETTE
KOTIK_PALETTE=(
  fg          "#d4d4d4"
  fg_dim      "#7a7a7a"
  bg          "#1e1e1e"
  red         "#e06c75"
  green       "#98c379"
  yellow      "#e5c07b"
  blue        "#61afef"
  magenta     "#c678dd"
  cyan        "#56b6c2"
  orange      "#d19a66"
  gray        "#5c6370"
)

kotik::color::has_truecolor() {
  [[ -n "$COLORTERM" && "$COLORTERM" == (truecolor|24bit) ]] && return 0
  [[ "$TERM" == *direct* || "$TERM" == *truecolor* ]] && return 0
  return 1
}

kotik::color::hex_to_256() {
  local hex=${1#\#}
  local r=$((16#${hex[1,2]})) g=$((16#${hex[3,4]})) b=$((16#${hex[5,6]}))
  local levels=(0 95 135 175 215 255)
  local ri gi bi
  for ((i=0;i<6;i++)); do
    (( r >= levels[i] - 18 )) && ri=$i
    (( g >= levels[i] - 18 )) && gi=$i
    (( b >= levels[i] - 18 )) && bi=$i
  done
  echo $((16 + 36*ri + 6*gi + bi))
}

kotik::fg() {
  local key=$1 hex
  hex=${KOTIK_PALETTE[$key]:-$key}
  if kotik::color::has_truecolor; then
    print -n "%{%F{$hex}%}"
  else
    print -n "%{%F{$(kotik::color::hex_to_256 $hex)}%}"
  fi
}

kotik::bg() {
  local key=$1 hex
  hex=${KOTIK_PALETTE[$key]:-$key}
  if kotik::color::has_truecolor; then
    print -n "%{%K{$hex}%}"
  else
    print -n "%{%K{$(kotik::color::hex_to_256 $hex)}%}"
  fi
}

kotik::reset() { print -n "%{%f%k%b%}"; }

kotik::palette::set() {
  local key=$1 val=$2
  KOTIK_PALETTE[$key]=$val
}
