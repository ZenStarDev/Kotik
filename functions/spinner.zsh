#!/usr/bin/env zsh
# functions/spinner.zsh

kotik::spinner::frames=( "|" "/" "-" "\\" )

kotik::spinner::show() {
    local i=${1:-0}
    print -n -- "${kotik::spinner::frames[$(( i % 4 ))]}"
}