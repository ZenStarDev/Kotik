#!/usr/bin/env zsh
# functions/icons.zsh

kotik::icons() {
    [[ "${KOTIK_OPT[nerd_fonts]}" != 1 ]] && return
    print -n "$1"
}

kotik::icon::dir()    { kotik::icons " " }
kotik::icon::git()    { kotik::icons " " }
kotik::icon::python() { kotik::icons " " }
kotik::icon::node()   { kotik::icons " " }
kotik::icon::jobs()   { kotik::icons " " }