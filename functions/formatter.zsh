#!/usr/bin/env zsh
# functions/formatter.zsh

kotik::format::duration() {
    local -F d=${1:-$KOTIK_CMD_DURATION}
    local out
    if (( d >= 3600 )); then
        out=$(printf "%dh%dm" $((d/3600)) $(( (d%3600)/60 )) )
    elif (( d >= 60 )); then
        out=$(printf "%dm%ds" $(( d/60 )) $(( d % 60 )) )
    else
        out=$(printf "%.1fs" "$d" )
    fi
    print -n -- "$out"
}

kotik::padding() {
    local left=${1:-0} right=${2:-0} char=${3:-" "}
    print -n "%${left}<<char%<<"
    print -n "%${right}>>char%>>"
}