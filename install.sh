#!/bin/bash
set -euo pipefail

# ============================================================================
# Dotfiles Installer
# Supports: macOS, Linux
# Usage: ./install.sh [--machine-role local|server] [--dry-run] [--no-color] [--skip-packages] [--no-sudo]
# ============================================================================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false
NO_COLOR=false
SKIP_PACKAGES=false
NO_SUDO=false
MACHINE_ROLE=""
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
ROLE_FILE="$HOME/.config/dotfiles/machine-role"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --machine-role)
            MACHINE_ROLE="${2:-}"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --no-color)
            NO_COLOR=true
            shift
            ;;
        --skip-packages)
            SKIP_PACKAGES=true
            shift
            ;;
        --no-sudo)
            NO_SUDO=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--machine-role local|server] [--dry-run] [--no-color] [--skip-packages] [--no-sudo]"
            echo "  --machine-role  Machine role; defaults to the saved role when available"
            echo "  --dry-run       Show what would be done without making changes"
            echo "  --no-color      Disable colored output"
            echo "  --skip-packages Skip installing system packages"
            echo "  --no-sudo       Skip system packages when sudo is unavailable"
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            echo "Run with --help for usage." >&2
            exit 1
            ;;
    esac
done

if [[ -z "$MACHINE_ROLE" && -r "$ROLE_FILE" ]]; then
    MACHINE_ROLE="$(sed -n '1p' "$ROLE_FILE")"
fi

if [[ -z "$MACHINE_ROLE" ]]; then
    echo "Missing machine role; pass --machine-role [local|server] or create $ROLE_FILE" >&2
    exit 1
fi

case "$MACHINE_ROLE" in
    local|server) ;;
    *)
        echo "Invalid machine role: $MACHINE_ROLE" >&2
        echo "Expected one of: local, server" >&2
        exit 1
        ;;
esac

# ============================================================================
# Colors and formatting
# ============================================================================
if [[ "$NO_COLOR" == false ]] && [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    BOLD='\033[1m'
    DIM='\033[2m'
    NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' BLUE='' CYAN='' BOLD='' DIM='' NC=''
fi

# ============================================================================
# Load functions
# ============================================================================
source "$PROJECT_DIR/lib/functions.sh"

# ============================================================================
# Main installation
# ============================================================================
main() {
    local os=$(detect_os)

    echo -e "\n${BOLD}╔════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║        Dotfiles Installation           ║${NC}"
    echo -e "${BOLD}╚════════════════════════════════════════╝${NC}"
    echo -e "${DIM}OS: $os | Dir: $PROJECT_DIR${NC}"
    echo -e "${DIM}Role: $MACHINE_ROLE${NC}"
    [[ "$DRY_RUN" == true ]] && echo -e "${YELLOW}(DRY RUN MODE)${NC}"
    [[ "$SKIP_PACKAGES" == true ]] && echo -e "${DIM}(skipping packages)${NC}"
    [[ "$NO_SUDO" == true ]] && echo -e "${YELLOW}(no sudo: skipping system packages)${NC}"
    echo

    if [[ "$NO_SUDO" == true ]]; then
        echo -e "${YELLOW}No sudo mode enabled. If you do not have sudo, run this script with --no-sudo.${NC}"
        echo
    fi

    log_step "Recording machine role: $MACHINE_ROLE"
    if [[ "$DRY_RUN" == false ]]; then
        mkdir -p "$HOME/.config/dotfiles"
        printf '%s\n' "$MACHINE_ROLE" > "$HOME/.config/dotfiles/machine-role"
    fi

    # --- Install packages ---
    if [[ "$SKIP_PACKAGES" == false ]]; then
        install_packages "$os"
    fi

    # --- Tmux ---
    log_step "Configuring tmux"
    safe_link "$PROJECT_DIR/tmux.conf" "$HOME/.tmux.conf" "tmux.conf"
    safe_clone "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm" "tpm (tmux plugin manager)"

    # --- Alacritty ---
    log_step "Configuring alacritty"
    safe_link "$PROJECT_DIR/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml" "alacritty.toml"

    # --- Vim ---
    log_step "Configuring vim"
    safe_link "$PROJECT_DIR/vimrc" "$HOME/.vimrc" "vimrc"
    safe_link "$PROJECT_DIR/ideavimrc" "$HOME/.ideavimrc" "ideavimrc"
    safe_download \
        "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" \
        "$HOME/.vim/autoload/plug.vim" \
        "vim-plug"

    # --- IPython / ptipython ---
    log_step "Configuring ipython"
    safe_link \
        "$PROJECT_DIR/ipython/profile_default/ipython_config.py" \
        "$HOME/.ipython/profile_default/ipython_config.py" \
        "ipython config"
    safe_link \
        "$PROJECT_DIR/ipython/profile_default/startup/00-autoreload.py" \
        "$HOME/.ipython/profile_default/startup/00-autoreload.py" \
        "ipython autoreload"

    # --- ptpython / ptipython ---
    log_step "Configuring ptpython"
    safe_link \
        "$PROJECT_DIR/ptpython/config.py" \
        "$HOME/.config/ptpython/config.py" \
        "ptpython config"

    # --- Fish ---
    log_step "Configuring fish"
    safe_link "$PROJECT_DIR/fish/config.fish" "$HOME/.config/fish/config.fish" "fish/config.fish"
    safe_link "$PROJECT_DIR/fish/functions/fish_mode_prompt.fish" "$HOME/.config/fish/functions/fish_mode_prompt.fish" "fish_mode_prompt.fish"
    safe_link "$PROJECT_DIR/fish/functions/fish_prompt.fish" "$HOME/.config/fish/functions/fish_prompt.fish" "fish_prompt.fish"

    # --- i3 (Linux only) ---
    log_step "Configuring i3"
    if [[ "$os" == "linux" ]] && [[ "$MACHINE_ROLE" == local ]]; then
        safe_link "$PROJECT_DIR/i3config" "$HOME/.config/i3/config" "i3config"
        safe_link "$PROJECT_DIR/i3status/config" "$HOME/.config/i3status/config" "i3status config"
        safe_link "$PROJECT_DIR/Xkbmap" "$HOME/.Xkbmap" "Xkbmap"
        if [[ "$DRY_RUN" == true ]]; then
            log_dry "apply Xkbmap with setxkbmap"
        elif command -v setxkbmap >/dev/null 2>&1 && [[ -n "${DISPLAY:-}" ]]; then
            if xargs setxkbmap < "$HOME/.Xkbmap"; then
                log_info "Applied Xkbmap"
            else
                log_warn "Failed to apply Xkbmap"
            fi
        else
            log_warn "Skipping Xkbmap apply (setxkbmap or DISPLAY unavailable)"
        fi
        safe_link "$PROJECT_DIR/autorandr/settings.ini" "$HOME/.config/autorandr/settings.ini" "autorandr settings"
    else
        if [[ "$MACHINE_ROLE" == server ]]; then
            if [[ "$DRY_RUN" == true ]]; then
                log_dry "remove $HOME/.config/i3/config"
                log_dry "remove $HOME/.config/i3status/config"
            else
                rm -f "$HOME/.config/i3/config" "$HOME/.config/i3status/config"
            fi
            log_info "Skipping i3 (server role)"
        else
            log_info "Skipping i3 (not on Linux)"
        fi
    fi

    # --- Done ---
    echo -e "\n${BOLD}${GREEN}✔ Installation complete!${NC}\n"

    if [[ "$DRY_RUN" == false ]]; then
        echo -e "${BOLD}Next steps:${NC}"
        echo -e "  ${CYAN}1.${NC} Reload your shell or run: ${DIM}source ~/.config/fish/config.fish${NC}"
        echo -e "  ${CYAN}2.${NC} In tmux, press ${DIM}prefix + I${NC} to install plugins"
        echo -e "  ${CYAN}3.${NC} In vim, run ${DIM}:PlugInstall${NC} to install plugins"
        if [[ -d "$BACKUP_DIR" ]]; then
            echo -e "\n${YELLOW}Backups saved to: $BACKUP_DIR${NC}"
        fi
    fi
}

# ============================================================================
# Run
# ============================================================================
main "$@"
