#!/usr/bin/env zsh
# plugins.d/20-fzf.zsh

if [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
elif [[ -d "$HOME/.fzf" ]]; then
    source "$HOME/.fzf/shell/completion.zsh" 2>/dev/null || true
    source "$HOME/.fzf/shell/key-binding.zsh" 2>/dev/null || true
fi