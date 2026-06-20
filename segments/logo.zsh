#!/usr/bin/env zsh
# segments/logo.zsh

kotik::segment::logo() {
    [[ "${KOTIK_OPT[logo]}" != 1 ]] && return
    [[ "${KOTIK_LOGO_SHOWN}" == 1 ]] && return

    local host user os
    host=$(hostname 2>/dev/null) || host="unknown"
    user=$(whoami 2>/dev/null) || user="user"
    os="${OSTYPE}"

    local lines=""
    lines+="$(kotik::fg cyan)kotik$(kotik::reset)\n"
    lines+="$(kotik::fg blue)${host} $(kotik::fg_dim)${@} ${user}$(kotik::reset)\n"
    lines+="os: $(kotik::fg green)${os}$(kotik::reset)"

    print -n "$lines"
    KOTIK_LOGO_SHOWN=1
}

kotik::segment::register logo kotik::segment::logo