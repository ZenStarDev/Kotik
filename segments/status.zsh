#!/usr/bin/env zsh
# segments/status.zsh

kotik::segment::status() {
  (( KOTIK_EXIT_CODE == 0 )) && return
  print -n "$(kotik::fg red)✗${KOTIK_EXIT_CODE}$(kotik::reset)"
}

kotik::segment::register status kotik::segment::status
