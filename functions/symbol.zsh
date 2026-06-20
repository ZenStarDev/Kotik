#!/usr/bin/env zsh
# functions/symbol.zsh

kotik::prompt::symbol() {
  if (( KOTIK_EXIT_CODE == 0 )); then
    print -n "$(kotik::fg green)${KOTIK_OPT[prompt_symbol]}$(kotik::reset)"
  else
    print -n "$(kotik::fg red)${KOTIK_OPT[prompt_symbol_err]}$(kotik::reset)"
  fi
}

kotik::prompt::left() {
  print -n "$(kotik::render::left) $(kotik::prompt::symbol) "
}
