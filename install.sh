#!/bin/bash
set -euo pipefail

# ============================================================================
# Dotfiles Installer
# Supports: macOS, Linux
# Usage: ./install.sh [--dry-run] [--no-color] [--skip-packages]
# ============================================================================

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false
NO_COLOR=false
SKIP_PACKAGES=false
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Parse arguments
for arg in "$@"; do
    case $arg in
        --dry-run) DRY_RUN=true ;;
        --no-color) NO_COLOR=true ;;
        --skip-packages) SKIP_PACKAGES=true ;;
        --help|-h)
            echo "Usage: $0 [--dry-run] [--no-color] [--skip-packages]"
            echo "  --dry-run       Show what would be done without making changes"
            echo "  --no-color      Disable colored output"
            echo "  --skip-packages Skip installing system packages"
            exit 0
            ;;
    esac
done

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
    [[ "$DRY_RUN" == true ]] && echo -e "${YELLOW}(DRY RUN MODE)${NC}"
    [[ "$SKIP_PACKAGES" == true ]] && echo -e "${DIM}(skipping packages)${NC}"
    echo

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

    # --- Fish ---
    log_step "Configuring fish"
    safe_link "$PROJECT_DIR/fish/config.fish" "$HOME/.config/fish/config.fish" "fish/config.fish"
    safe_link "$PROJECT_DIR/fish/functions/fish_mode_prompt.fish" "$HOME/.config/fish/functions/fish_mode_prompt.fish" "fish_mode_prompt.fish"
    safe_link "$PROJECT_DIR/fish/functions/fish_prompt.fish" "$HOME/.config/fish/functions/fish_prompt.fish" "fish_prompt.fish"

    # --- i3 (Linux only) ---
    log_step "Configuring i3"
    if [[ "$os" == "linux" ]]; then
        safe_link "$PROJECT_DIR/i3config" "$HOME/.config/i3/config" "i3config"
    else
        log_info "Skipping i3 (not on Linux)"
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
