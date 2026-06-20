#!/usr/bin/env zsh
# segments/duration.zsh

kotik::segment::duration() {
  local threshold=${KOTIK_OPT[duration_threshold]:-3}
  local -F d=$KOTIK_CMD_DURATION
  (( d < threshold )) && return

  local out
  if (( d >= 60 )); then
    local m=$(( d / 60 )) s=$(( d % 60 ))
    out=$(printf "%dm%ds" "$m" "$s")
  else
    out=$(printf "%.1fs" "$d")
  fi

  print -n "$(kotik::fg fg_dim)${out}$(kotik::reset)"
}

kotik::segment::register duration kotik::segment::duration
