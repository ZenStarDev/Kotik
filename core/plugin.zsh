#!/usr/bin/env zsh
# core/plugin.zsh - plugin management system

typeset -gA KOTIK_PLUGINS
typeset -ga KOTIK_PLUGIN_HOOKS

kotik::plugin::register_hook() {
    local name=$1 fn=$2
    KOTIK_PLUGIN_HOOKS+=($name:$fn)
}

kotik::plugin::run_hooks() {
    local hook=$1 arg=${2:-""}
    local h
    for h in "${KOTIK_PLUGIN_HOOKS[@]}"; do
        [[ "$h" == "$hook:"* ]] && eval "${h#$hook:}" "$arg"
    done
}

kotik::plugin::load() {
    local name=$1
    local file="$KOTIK_HOME/plugins.d/${name}.zsh"
    [[ -r "$file" ]] && source "$file" && KOTIK_PLUGINS[$name]=1
}

kotik::plugin::autoload() {
    local dir="$KOTIK_HOME/plugins.d"
    local f
    for f in "$dir"/*.zsh(N); do
        source "$f" || true
    done
}

kotik::plugin::available() {
    local dir="$KOTIK_HOME/plugins.d"
    print -l "$dir"/*.zsh(N) | xargs -n1 basename | sed 's/\.zsh$//'
}

kotik::plugin::status() {
    print "Loaded plugins:"
    print "${(kv)KOTIK_PLUGINS}" 2>/dev/null || print "none"
}

kotik::plugin::validate_config() {
    local config="$KOTIK_CONFIG"
    [[ -f "$config" ]] || return
    while IFS= read -r line; do
        [[ "$line" =~ 'KOTIK_OPT\[([a-z_]+)\]' ]] && {
            local opt=${MATCH[1]}
            case $opt in
                theme|segments_left|segments_right|newline|compact_path|prompt_symbol|prompt_symbol_err|prompt_vimode|duration_threshold|git_max_dirty|nerd_fonts|async|plugins) ;;
                *) print -u2 "kotik: unknown option $opt" ;;
            esac
        }
    done < "$config"
}

if [[ -n "${KOTIK_OPT[plugins]}" ]]; then
    for p in ${${KOTIK_OPT[plugins]}// / }; do
        kotik::plugin::load "$p"
    done
fi