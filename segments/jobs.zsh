#!/usr/bin/env zsh
# segments/jobs.zsh

kotik::segment::jobs() {
    local -i job_count=0
    job_count=$(jobs -l 2>/dev/null | wc -l)
    (( job_count == 0 )) && return

    local icon=""
    [[ "${KOTIK_OPT[nerd_fonts]}" == 1 ]] && icon=" "

    print -n "$(kotik::fg yellow)${icon}${job_count}$(kotik::reset)"
}

kotik::segment::register jobs kotik::segment::jobs