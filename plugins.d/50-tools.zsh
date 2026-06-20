#!/usr/bin/env zsh
# plugins.d/50-tools.zsh

if command -v bat &>/dev/null; then
    alias cat="bat --style=plain"
fi

if command -v exa &>/dev/null; then
    alias ls="exa --icons"
    alias ll="exa -lah --icons"
fi

if command -v rg &>/dev/null; then
    alias grep="rg"
fi

if command -v thefuck &>/dev/null; then
    eval "$(thefuck --alias)" 2>/dev/null || true
fi