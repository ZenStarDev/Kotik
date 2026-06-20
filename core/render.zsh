#!/usr/bin/env zsh
# core/render.zsh

typeset -gA KOTIK_SEGMENTS

kotik::segment::register() {
  local name=$1 fn=$2
  KOTIK_SEGMENTS[$name]=$fn
}

kotik::render::side() {
  local side=$1
  local -a names
  names=(${(z)KOTIK_OPT[segments_${side}]})
  local out=""
  local name fn piece
  for name in $names; do
    fn=${KOTIK_SEGMENTS[$name]}
    [[ -z "$fn" ]] && continue
    piece=$("$fn")
    [[ -z "$piece" ]] && continue
    out+="$piece "
  done
  print -n -- "${out% }"
}

kotik::render::left() { kotik::render::side left }
kotik::render::right() { kotik::render::side right }
