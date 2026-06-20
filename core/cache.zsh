#!/usr/bin/env zsh
# core/cache.zsh

typeset -gA KOTIK_CACHE_DIRTY
typeset -gA KOTIK_CACHE_TIME
typeset -g KOTIK_CACHE_PWD=""
typeset -g KOTIK_CACHE_TTL=${KOTIK_CACHE_TTL:-5}

kotik::cache::invalidate_dir_dependent() {
  if [[ "$PWD" != "$KOTIK_CACHE_PWD" ]]; then
    KOTIK_CACHE_PWD=$PWD
    KOTIK_CACHE_DIRTY=()
    KOTIK_CACHE_TIME=()
  fi
}

kotik::cache::get() {
  local key=$1
  local now=$EPOCHREALTIME
  local cached_time=${KOTIK_CACHE_TIME[$key]:-0}
  (( now - cached_time > KOTIK_CACHE_TTL )) && return 1
  print -n -- "${KOTIK_CACHE_DIRTY[$key]}"
}

kotik::cache::set() {
  local key=$1 val=$2
  KOTIK_CACHE_DIRTY[$key]=$val
  KOTIK_CACHE_TIME[$key]=$EPOCHREALTIME
}

kotik::cache::has() {
  local key=$1
  (( ${+KOTIK_CACHE_DIRTY[$key]} )) || return 1
}

kotik::cache::get() {
  local key=$1
  print -n -- "${KOTIK_CACHE_DIRTY[$key]}"
}

kotik::cache::set() {
  local key=$1 val=$2
  KOTIK_CACHE_DIRTY[$key]=$val
}

kotik::cache::has() {
  (( ${+KOTIK_CACHE_DIRTY[$1]} ))
}
