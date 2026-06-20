#!/usr/bin/env zsh
# segments/git.zsh

kotik::git::info() {
  local branch ahead behind staged unstaged untracked stashed

  branch=$(command git symbolic-ref --short HEAD 2>/dev/null) \
    || branch=$(command git describe --tags --exact-match 2>/dev/null) \
    || branch=$(command git rev-parse --short HEAD 2>/dev/null)
  [[ -z "$branch" ]] && return 1

  local porcelain
  porcelain=$(command git status --porcelain --branch 2>/dev/null)

  ahead=$(grep -c '^##.*ahead' <<<"$porcelain")
  [[ "$ahead" != 0 ]] && ahead=$(grep -oE 'ahead [0-9]+' <<<"$porcelain" | grep -oE '[0-9]+')
  behind=$(grep -oE 'behind [0-9]+' <<<"$porcelain" | grep -oE '[0-9]+')

  staged=$(grep -cE '^[MADRC]' <<<"$porcelain")
  unstaged=$(grep -cE '^.[MD]' <<<"$porcelain")
  untracked=$(grep -cE '^\?\?' <<<"$porcelain")
  stashed=$(command git rev-list --walk-reflogs --count refs/stash 2>/dev/null)

  print -r -- "${branch}|${ahead:-0}|${behind:-0}|${staged:-0}|${unstaged:-0}|${untracked:-0}|${stashed:-0}"
}

kotik::segment::git() {
  command -v git >/dev/null || return
  command git rev-parse --is-inside-work-tree &>/dev/null || return

  local cache_key="git_info"
  local info
  if kotik::cache::has "$cache_key"; then
    info=$(kotik::cache::get "$cache_key")
  else
    info=$(kotik::git::info) || return
    kotik::cache::set "$cache_key" "$info"
  fi
  [[ -z "$info" ]] && return

  local branch ahead behind staged unstaged untracked stashed
  IFS='|' read -r branch ahead behind staged unstaged untracked stashed <<<"$info"

  local dirty=$(( staged + unstaged + untracked ))
  local color="green"
  (( dirty > 0 )) && color="yellow"

  local icon="" sep=""
  [[ "${KOTIK_OPT[nerd_fonts]}" == 1 ]] && icon=" "

  local out="$(kotik::fg $color)${icon}${branch}"

  local extra=""
  (( ahead > 0 ))  && extra+="↑${ahead}"
  (( behind > 0 )) && extra+="↓${behind}"
  (( staged > 0 )) && extra+=" ●${staged}"
  (( unstaged > 0 )) && extra+=" ✚${unstaged}"
  (( untracked > 0 )) && extra+=" …${untracked}"
  (( stashed > 0 )) && extra+=" ⚑${stashed}"

  [[ -n "$extra" ]] && out+="$(kotik::fg fg_dim) ${extra}"

  out+="$(kotik::reset)"
  print -n -- "$out"
}

kotik::segment::register git kotik::segment::git
