#!/usr/bin/env zsh
# plugins.d/30-zoxide.zsh

if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)" 2>/dev/null || true
fi