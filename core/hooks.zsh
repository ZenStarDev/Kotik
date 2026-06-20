#!/usr/bin/env zsh
# core/hooks.zsh

typeset -g KOTIK_EXIT_CODE=0
typeset -g KOTIK_CMD_START=0
typeset -g KOTIK_CMD_DURATION=0
typeset -g KOTIK_VIMODE="insert"

kotik::hook::preexec() {
   KOTIK_CMD_START=$EPOCHREALTIME
   kotik::cache::invalidate_dir_dependent
}

kotik::hook::winch() {
    kotik::cache::invalidate_dir_dependent
}

kotik::hook::vimode() {
    case $KEYMAP in
        vicmd) KOTIK_VIMODE="normal" ;;
        main|viins) KOTIK_VIMODE="insert" ;;
    esac
    zle reset-prompt
}

kotik::hook::precmd() {
    KOTIK_EXIT_CODE=$?
    if [[ "$KOTIK_CMD_START" != 0 ]]; then
        (( KOTIK_CMD_DURATION = $EPOCHREALTIME - $KOTIK_CMD_START ))
        KOTIK_CMD_START=0
    fi
}

kotik::init() {
   zmodload zsh/datetime 2>/dev/null
   autoload -Uz add-zsh-hook
   add-zsh-hook preexec kotik::hook::preexec
   add-zsh-hook precmd kotik::hook::precmd

   if [[ "${KOTIK_OPT[prompt_vimode]}" == 1 ]]; then
     function zle-keymap-select { kotik::hook::vimode }
     zle -N zle-keymap-select
     bindkey -v
   fi

   add-zsh-hook zshaddwinend kotik::hook::winch 2>/dev/null

   kotik::async::init
   setopt prompt_subst
}
