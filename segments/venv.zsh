#!/usr/bin/env zsh
# segments/venv.zsh

kotik::segment::venv() {
  local name=""
  if [[ -n "$VIRTUAL_ENV" ]]; then
    name="${VIRTUAL_ENV:t}"
  elif [[ -n "$CONDA_DEFAULT_ENV" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
    name="$CONDA_DEFAULT_ENV"
  else
    return
  fi

  local icon=""
  [[ "${KOTIK_OPT[nerd_fonts]}" == 1 ]] && icon=" "

  print -n "$(kotik::fg yellow)${icon}${name}$(kotik::reset)"
}

kotik::segment::register venv kotik::segment::venv
