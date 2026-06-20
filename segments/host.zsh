#!/usr/bin/env zsh
# segments/host.zsh

kotik::segment::host() {
  if [[ -z "$SSH_CONNECTION" && "${KOTIK_OPT[host_always]}" != 1 ]]; then
    return
  fi
  print -n "$(kotik::fg magenta)%n@%m$(kotik::reset)"
}

kotik::segment::register host kotik::segment::host
