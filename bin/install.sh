#!/usr/bin/env bash
set -euo pipefail

KOTIK_TARGET="${KOTIK_TARGET:-$HOME/.kotik}"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ZSHRC="$HOME/.zshrc"
MARKER="# >>> kotik >>>"
MARKER_END="# <<< kotik <<<"

splash() {
    clear
    cat <<'EOF'

░██     ░██               ░██    ░██░██       
░██    ░██                ░██       ░██       
░██   ░██    ░███████  ░████████ ░██░██    ░██
░███████    ░██    ░██    ░██    ░██░██   ░██ 
░██   ░██   ░██    ░██    ░██    ░██░███████  
░██    ░██  ░██    ░██    ░██    ░██░██   ░██ 
░██     ░██  ░███████      ░████ ░██░██    ░██

EOF
    echo -e "\033[36mModular zsh prompt framework\033[0m"
    echo ""
}

splash

if [[ -d "$KOTIK_TARGET" ]]; then
    echo "kotik: $KOTIK_TARGET already exists, syncing files"
    rm -rf "$KOTIK_TARGET"
fi

mkdir -p "$KOTIK_TARGET"
cp -R "$SRC_DIR"/{core,segments,themes,functions,plugins.d,bin} "$KOTIK_TARGET"/
mkdir -p "$KOTIK_TARGET/cache"
cp "$SRC_DIR/kotik.zsh" "$KOTIK_TARGET/kotik.zsh"

if [[ ! -f "$HOME/.kotik.zsh" ]]; then
    cp "$SRC_DIR/kotik.conf.example.zsh" "$HOME/.kotik.zsh"
    echo "kotik: wrote default config to ~/.kotik.zsh"
fi

if [[ -f "$ZSHRC" ]] && grep -qF "$MARKER" "$ZSHRC"; then
    echo "kotik: .zshrc already wired, skipping"
else
    {
        echo ""
        echo "$MARKER"
        echo "export KOTIK_HOME=\"\$KOTIK_TARGET\""
        echo "source \"\$KOTIK_HOME/kotik.zsh\""
        echo "$MARKER_END"
    } >> "$ZSHRC"
    echo "kotik: wired into $ZSHRC"
fi

echo ""
echo -e "\033[32mInstallation complete!\033[0m"
echo "kotik: installed to $KOTIK_TARGET"
echo "kotik: edit ~/.kotik.zsh to customize, then reload your shell"
