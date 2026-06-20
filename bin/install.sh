#!/usr/bin/env bash
set -euo pipefail

KOTIK_TARGET="${KOTIK_TARGET:-$HOME/.kotik}"
ZSHRC="$HOME/.zshrc"
MARKER="# >>> kotik >>>"
MARKER_END="# <<< kotik <<<"
REPO="${KOTIK_REPO:-https://github.com/ZenStarDev/Kotik.git}"

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

update() {
    [[ ! -d "$KOTIK_TARGET" ]] && { echo "kotik: not installed"; exit 1; }
    local tmp
    tmp=$(mktemp -d)
    git clone "$REPO" "$tmp" --depth=1 2>/dev/null
    cp -R "$tmp"/{core,segments,themes,functions,plugins.d,bin} "$KOTIK_TARGET"/
    rm -rf "$tmp"
    echo "kotik: updated to latest"
}

uninstall() {
    [[ ! -d "$KOTIK_TARGET" ]] && { echo "kotik: not installed"; exit 1; }
    rm -rf "$KOTIK_TARGET"
    [[ -f "$ZSHRC" ]] && sed -i "/$MARKER/,/$MARKER_END/d" "$ZSHRC"
    [[ -f "$HOME/.kotik.zsh" ]] && rm -f "$HOME/.kotik.zsh"
    echo "kotik: uninstalled"
}

remote_install() {
    local tmp
    tmp=$(mktemp -d)
    git clone "$REPO" "$tmp" --depth=1 2>/dev/null
    KOTIK_SOURCE_DIR="$tmp" bash "$tmp/bin/install.sh" "$@"
    rm -rf "$tmp"
}

splash

if [[ "${KOTIK_UPDATE:-0}" == "1" ]]; then update && exit 0; fi
if [[ "${KOTIK_UNINSTALL:-0}" == "1" ]]; then uninstall && exit 0; fi
if [[ "${KOTIK_REMOTE:-0}" == "1" ]]; then remote_install && exit 0; fi

SRC_DIR="${KOTIK_SOURCE_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

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
