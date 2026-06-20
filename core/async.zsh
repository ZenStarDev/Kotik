#!/usr/bin/env zsh
# core/async.zsh

typeset -gA KOTIK_ASYNC_FD
typeset -gA KOTIK_ASYNC_RESULT

kotik::async::run() {
  local name=$1 fn=$2
  local fifo="$KOTIK_CACHE_DIR/.async_${name}_$$"

  [[ -p "$fifo" ]] && command rm -f "$fifo"
  mkfifo "$fifo" 2>/dev/null || return 1

  kotik::async::__make_callback "$name"

  {
    local out
    out=$("$fn" 2>/dev/null)
    print -r -- "$out" > "$fifo"
  } &!

  exec {KOTIK_ASYNC_FD[$name]}<"$fifo"
  command rm -f "$fifo"
  zle -F "${KOTIK_ASYNC_FD[$name]}" "kotik::async::__cb_${name}"
}

kotik::async::__make_callback() {
  local name=$1
  eval "kotik::async::__cb_${name}() {
    local line
    IFS= read -r -u \$1 line
    KOTIK_ASYNC_RESULT[$name]=\$line
    exec {1}<&-
    zle -F \$1
    zle reset-prompt
  }"
}

kotik::async::init() {
  [[ "${KOTIK_OPT[async]}" == 1 ]] || return
  mkdir -p "$KOTIK_CACHE_DIR"
}
