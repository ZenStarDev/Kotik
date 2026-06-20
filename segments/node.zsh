#!/usr/bin/env zsh
# segments/node.zsh

kotik::segment::node() {
  [[ -f package.json || -d node_modules || -f .nvmrc ]] || return
  command -v node >/dev/null || return

  local cache_key="node_version"
  local v
  if kotik::cache::has "$cache_key"; then
    v=$(kotik::cache::get "$cache_key")
  else
    v=$(node -v 2>/dev/null)
    kotik::cache::set "$cache_key" "$v"
  fi
  [[ -z "$v" ]] && return

  local icon=""
  [[ "${KOTIK_OPT[nerd_fonts]}" == 1 ]] && icon=" "

  print -n "$(kotik::fg green)${icon}${v}$(kotik::reset)"
}

kotik::segment::register node kotik::segment::node
