#!/usr/bin/env zsh
# themes/classic.zsh

KOTIK_THEME=(
    prompt_format  '$(kotik::theme::classic::left) $(kotik::prompt::symbol) '
    rprompt_format '$(kotik::render::right)'
)
