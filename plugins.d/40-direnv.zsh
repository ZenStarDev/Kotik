#!/usr/bin/env zsh
# plugins.d/40-direnv.zsh

if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)" 2>/dev/null || true
fi