# ============================================================================
# Dotfiles Installer - Shared Functions
# Sourced by install.sh
# ============================================================================

# ============================================================================
# Logging functions
# ============================================================================
log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1" >&2; }
log_step()    { echo -e "\n${BOLD}${CYAN}==> $1${NC}"; }
log_dry()     { echo -e "${DIM}[DRY-RUN] Would: $1${NC}"; }

# ============================================================================
# Utility functions
# ============================================================================
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)  echo "linux" ;;
        *)       echo "unknown" ;;
    esac
}

command_exists() {
    command -v "$1" &>/dev/null
}

backup_if_exists() {
    local target="$1"
    if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            log_dry "backup $target to $BACKUP_DIR"
        else
            mkdir -p "$BACKUP_DIR"
            cp -r "$target" "$BACKUP_DIR/"
            log_warn "Backed up existing $target"
        fi
    fi
}

safe_link() {
    local src="$1"
    local dest="$2"
    local name="${3:-$(basename "$dest")}"

    if [[ ! -f "$src" ]] && [[ ! -d "$src" ]]; then
        log_warn "Source not found: $src (skipping $name)"
        return 1
    fi

    backup_if_exists "$dest"

    if [[ "$DRY_RUN" == true ]]; then
        log_dry "link $src -> $dest"
    else
        mkdir -p "$(dirname "$dest")"
        ln -sf "$src" "$dest"
        log_success "Linked $name"
    fi
}

safe_clone() {
    local repo="$1"
    local dest="$2"
    local name="${3:-$(basename "$dest")}"

    if [[ -d "$dest" ]]; then
        log_info "$name already installed"
        return 0
    fi

    if ! command_exists git; then
        log_error "git not found, cannot clone $name"
        return 1
    fi

    if [[ "$DRY_RUN" == true ]]; then
        log_dry "clone $repo -> $dest"
    else
        if git clone --depth 1 "$repo" "$dest" &>/dev/null; then
            log_success "Cloned $name"
        else
            log_error "Failed to clone $name"
            return 1
        fi
    fi
}

safe_download() {
    local url="$1"
    local dest="$2"
    local name="${3:-$(basename "$dest")}"

    if [[ -f "$dest" ]]; then
        log_info "$name already installed"
        return 0
    fi

    if [[ "$DRY_RUN" == true ]]; then
        log_dry "download $url -> $dest"
        return 0
    fi

    mkdir -p "$(dirname "$dest")"

    if command_exists curl; then
        if curl -fsSL "$url" -o "$dest" 2>/dev/null; then
            log_success "Downloaded $name"
        else
            log_error "Failed to download $name"
            return 1
        fi
    elif command_exists wget; then
        if wget -q "$url" -O "$dest" 2>/dev/null; then
            log_success "Downloaded $name"
        else
            log_error "Failed to download $name"
            return 1
        fi
    else
        log_error "Neither curl nor wget found, cannot download $name"
        return 1
    fi
}

# ============================================================================
# Package installation
# ============================================================================
detect_package_manager() {
    local os="$1"
    if [[ "$os" == "macos" ]]; then
        if command_exists brew; then
            echo "brew"
        else
            echo "none"
        fi
    elif [[ "$os" == "linux" ]]; then
        if command_exists apt-get; then
            echo "apt"
        elif command_exists dnf; then
            echo "dnf"
        elif command_exists pacman; then
            echo "pacman"
        else
            echo "none"
        fi
    else
        echo "none"
    fi
}

install_package() {
    local pkg="$1"
    local pm="$2"

    if command_exists "$pkg"; then
        log_info "$pkg already installed"
        return 0
    fi

    if [[ "$pm" == "none" ]]; then
        log_warn "No package manager found, cannot install $pkg"
        return 1
    fi

    if [[ "$DRY_RUN" == true ]]; then
        log_dry "install $pkg via $pm"
        return 0
    fi

    log_info "Installing $pkg..."
    case "$pm" in
        brew)
            if brew install "$pkg" &>/dev/null; then
                log_success "Installed $pkg"
            else
                log_error "Failed to install $pkg"
                return 1
            fi
            ;;
        apt)
            if sudo apt-get install -y "$pkg" &>/dev/null; then
                log_success "Installed $pkg"
            else
                log_error "Failed to install $pkg"
                return 1
            fi
            ;;
        dnf)
            if sudo dnf install -y "$pkg" &>/dev/null; then
                log_success "Installed $pkg"
            else
                log_error "Failed to install $pkg"
                return 1
            fi
            ;;
        pacman)
            if sudo pacman -S --noconfirm "$pkg" &>/dev/null; then
                log_success "Installed $pkg"
            else
                log_error "Failed to install $pkg"
                return 1
            fi
            ;;
    esac
}

install_packages() {
    local os="$1"
    local pm=$(detect_package_manager "$os")

    log_step "Installing dependencies"

    if [[ "$pm" == "none" ]]; then
        if [[ "$os" == "macos" ]]; then
            log_warn "Homebrew not found. Install it from https://brew.sh"
        else
            log_warn "No supported package manager found (apt, dnf, pacman)"
        fi
        log_warn "Skipping package installation"
        return 1
    fi

    log_info "Using package manager: $pm"

    # Core packages
    install_package "git" "$pm"
    install_package "vim" "$pm"
    install_package "tmux" "$pm"
    install_package "fish" "$pm"
    install_package "alacritty" "$pm"
}
