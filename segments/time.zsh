#!/usr/bin/env zsh
# segments/time.zsh

kotik::segment::time() {
  print -n "$(kotik::fg fg_dim)%D{%H:%M:%S}$(kotik::reset)"
}

kotik::segment::register time kotik::segment::time
