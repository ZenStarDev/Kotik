#!/usr/bin/env bash
# kotik auto-rice - One-click desktop environment setup
set -euo pipefail

DISTRO=$(grep -oP '(?<=^ID=).+' /etc/os-release 2>/dev/null || echo "unknown")

log() { echo -e "\033[36m==>\033[0m $*"; }
err() { echo -e "\033[31mERROR:\033[0m $*" >&2; }

detect_pkg_manager() {
    if command -v apt &>/dev/null; then echo "apt"
    elif command -v pacman &>/dev/null; then echo "pacman"
    elif command -v dnf &>/dev/null; then echo "dnf"
    else echo "unknown"; fi
}

install_packages() {
    local pkgs=("$@")
    case "$(detect_pkg_manager)" in
        apt) sudo apt install -y "${pkgs[@]}" ;;
        pacman) sudo pacman -S --noconfirm "${pkgs[@]}" ;;
        dnf) sudo dnf install -y "${pkgs[@]}" ;;
    esac
}

setup_base() {
    log "Updating system..."
    case "$(detect_pkg_manager)" in
        apt) sudo apt update && sudo apt upgrade -y ;;
        pacman) sudo pacman -Syu --noconfirm ;;
        dnf) sudo dnf upgrade -y ;;
    esac
}

setup_wm() {
    local wm=${1:-i3}
    log "Installing Window Manager ($wm)..."
    case "$(detect_pkg_manager)" in
        apt) install_packages "$wm" i3status dunst rofi nitrogen picom xclip ;;
        pacman) install_packages "$wm" i3status dunst rofi nitrogen picom xclip ;;
    esac
}

setup_waybar() {
    log "Installing Waybar..."
    case "$(detect_pkg_manager)" in
        apt) install_packages waybar swaybg ;;
        pacman) install_packages waybar swaybg ;;
    esac
}

setup_wallpaper() {
    local wallpaper=${1:-"$HOME/.config/kotik/wallpaper.jpg"}
    log "Setting wallpaper..."
    [[ -f "$wallpaper" ]] && {
        if command -v wayfire &>/dev/null; then
            wayfire --set-wallpaper="$wallpaper"
        elif command -v nitrogen &>/dev/null; then
            nitrogen --set-scaled "$wallpaper"
        fi
    } || log "Wallpaper not found: $wallpaper"
}

setup_dotfiles() {
    local dotfiles_dir=${1:-"$HOME/.config/kotik/dotfiles"}
    log "Symlinking dotfiles..."
    [[ -d "$dotfiles_dir" ]] && {
        find "$dotfiles_dir" -mindepth 1 -maxdepth 1 -type f | while read -r f; do
            ln -sf "$f" "$HOME/.config/$(basename "$f")" 2>/dev/null || true
        done
    }
    
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    [[ -d "$script_dir/configs/waybar" ]] && {
        mkdir -p "$HOME/.config/waybar"
        ln -sf "$script_dir/configs/waybar/config" "$HOME/.config/waybar/config" 2>/dev/null || true
        ln -sf "$script_dir/configs/waybar/style.css" "$HOME/.config/waybar/style.css" 2>/dev/null || true
    }
}

main() {
    log "Starting kotik auto-rice..."

    setup_base
    setup_wm i3
    setup_waybar
    setup_wallpaper
    setup_dotfiles

    log "Auto-rice complete! Restart your session."
}

[[ "${KOTIK_DRY_RUN:-0}" == "1" ]] && exec echo "[DRY RUN] Would run auto-rice"
main "$@"