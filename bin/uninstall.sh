#!/usr/bin/env bash
set -euo pipefail

KOTIK_TARGET="${KOTIK_TARGET:-$HOME/.kotik}"
ZSHRC="$HOME/.zshrc"
MARKER="# >>> kotik >>>"
MARKER_END="# <<< kotik <<<"

if [[ -f "$ZSHRC" ]]; then
  sed -i.bak "/$MARKER/,/$MARKER_END/d" "$ZSHRC"
  echo "kotik: removed wiring from $ZSHRC (backup at $ZSHRC.bak)"
fi

if [[ -d "$KOTIK_TARGET" ]]; then
  rm -rf "$KOTIK_TARGET"
  echo "kotik: removed $KOTIK_TARGET"
fi

echo "kotik: uninstalled. ~/.kotik.zsh was left in place if it existed."
