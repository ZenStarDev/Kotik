#!/usr/bin/env zsh
# segments/vimode.zsh

kotik::segment::vimode() {
  [[ "${KOTIK_OPT[prompt_vimode]}" == 1 ]] || return
  if [[ "$KOTIK_VIMODE" == "normal" ]]; then
    print -n "$(kotik::fg yellow)N$(kotik::reset)"
  else
    print -n "$(kotik::fg fg_dim)I$(kotik::reset)"
  fi
}

kotik::segment::register vimode kotik::segment::vimode
