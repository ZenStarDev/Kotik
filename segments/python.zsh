#!/usr/bin/env zsh
# segments/python.zsh

kotik::segment::python() {
    [[ -f pyproject.toml || -f setup.py || -f requirements.txt || -n "$VIRTUAL_ENV" ]] || return
    command -v python3 >/dev/null || return

    local cache_key="python_version"
    local v
    if kotik::cache::has "$cache_key"; then
        v=$(kotik::cache::get "$cache_key")
    else
        v=$(python3 -c 'import sys;print(f"{sys.version_info.major}.{sys.version_info.minor}")' 2>/dev/null)
        kotik::cache::set "$cache_key" "$v"
    fi
    [[ -z "$v" ]] && return

    local icon=""
    [[ "${KOTIK_OPT[nerd_fonts]}" == 1 ]] && icon=" "

    print -n "$(kotik::fg green)${icon}${v}$(kotik::reset)"
}

kotik::segment::register python kotik::segment::python