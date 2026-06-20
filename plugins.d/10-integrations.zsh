#!/usr/bin/env zsh
# plugins.d/10-integrations.zsh

kotik::plugin::try_source() {
  local f
  for f in "$@"; do
    [[ -r "$f" ]] && { source "$f"; return 0; }
  done
  return 1
}

kotik::plugin::try_source \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

kotik::plugin::try_source \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
