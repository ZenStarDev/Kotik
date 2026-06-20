#!/usr/bin/env zsh
# functions/util.zsh

kotik::util::file_exists() {
    [[ -f "$1" ]]
}

kotik::util::dir_exists() {
    [[ -d "$1" ]]
}

kotik::util::command_exists() {
    command -v "$1" &>/dev/null
}

kotik::util::git_dirty() {
    git status --porcelain &>/dev/null
}

kotik::util::in_git_repo() {
    git rev-parse --git-dir &>/dev/null 2>&1
}