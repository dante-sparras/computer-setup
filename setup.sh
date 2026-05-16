#!/usr/bin/env bash
# =============================================================================
# computer-setup - Universal Environment Setup Script
# =============================================================================
# This script:
#   1. Sets up the base environment based on OS (Linux/WSL/macOS)
#   2. Then applies all dotfiles using Chezmoi
#
# Usage: ./setup.sh
# =============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log()      { echo -e "${BLUE}[INFO]${NC} $1"; }
success()  { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn()     { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()    { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
phase()    { echo -e "\n${CYAN}=== $1 ===${NC}"; }

# =============================================================================
# PHASE 1: OS Detection & Environment Setup
# =============================================================================

detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -qi microsoft /proc/version 2>/dev/null; then
            OS="wsl"
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        OS="unknown"
    fi
    log "Detected operating system: $OS"
}

install_chezmoi() {
    if command -v chezmoi >/dev/null 2>&1; then
        log "Chezmoi already installed ($(chezmoi --version | head -n1))"
        return 0
    fi

    log "Installing Chezmoi..."
    case "$OS" in
        macos)
            if command -v brew >/dev/null 2>&1; then
                brew install chezmoi
            else
                sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b "$HOME/.local/bin"
            fi
            ;;
        linux|wsl)
            if command -v dnf >/dev/null 2>&1; then
                sudo dnf install -y chezmoi
            elif command -v apt >/dev/null 2>&1; then
                sudo apt update -y && sudo apt install -y chezmoi
            elif command -v pacman >/dev/null 2>&1; then
                sudo pacman -S --noconfirm chezmoi
            else
                sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b "$HOME/.local/bin"
            fi
            ;;
    esac

    # Ensure binary is in PATH
    if ! command -v chezmoi >/dev/null 2>&1; then
        export PATH="$HOME/.local/bin:$PATH"
    fi
}

install_cli_tools() {
    log "Installing modern CLI tools (eza, bat, ripgrep, fd, zsh, etc.)..."

    case "$OS" in
        linux|wsl)
            if command -v dnf >/dev/null 2>&1; then
                sudo dnf install -y eza bat ripgrep fd-find zsh zoxide fzf starship
            elif command -v apt >/dev/null 2>&1; then
                sudo apt update -y
                sudo apt install -y eza bat ripgrep fd-find zsh zoxide fzf
                # starship via cargo or direct install
                curl -sS https://starship.rs/install.sh | sh -s -- -y || true
            elif command -v pacman >/dev/null 2>&1; then
                sudo pacman -S --noconfirm eza bat ripgrep fd zsh zoxide fzf starship
            fi
            ;;
        macos)
            if command -v brew >/dev/null 2>&1; then
                brew install eza bat ripgrep fd zsh zoxide fzf starship
            fi
            ;;
    esac
}

setup_wsl_specific() {
    if [[ "$OS" == "wsl" ]]; then
        log "Applying WSL-specific configurations..."
        # Ensure Windows interop works well
        if ! grep -q "interop" /etc/wsl.conf 2>/dev/null; then
            echo -e "[interop]\nappendWindowsPath = true" | sudo tee -a /etc/wsl.conf >/dev/null || true
        fi
    fi
}

setup_shell() {
    if [[ "$SHELL" != *"zsh"* ]]; then
        log "Changing default shell to zsh..."
        if command -v zsh >/dev/null 2>&1; then
            chsh -s "$(command -v zsh)" || warn "Run manually: chsh -s $(which zsh)"
        fi
    else
        log "zsh is already the default shell"
    fi
}

# =============================================================================
# PHASE 2: Apply Dotfiles with Chezmoi
# =============================================================================

apply_dotfiles() {
    phase "Applying dotfiles with Chezmoi"

    local repo="dante-sparras/computer-setup"

    if ! command -v chezmoi >/dev/null 2>&1; then
        error "Chezmoi is not available. Cannot continue."
    fi

    log "Running: chezmoi init --apply $repo"
    chezmoi init --apply "$repo" --force || {
        warn "Chezmoi init failed. You may need to run it manually later."
        return 0
    }

    success "Dotfiles successfully applied!"
}

# =============================================================================
# Main
# =============================================================================

main() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║         computer-setup - Full Environment Bootstrap        ║"
    echo "╚════════════════════════════════════════════════════════════╝"

    phase "Phase 1: Environment Setup (OS-specific)"
    detect_os
    install_chezmoi
    install_cli_tools
    setup_wsl_specific
    setup_shell

    phase "Phase 2: Dotfiles Application"
    apply_dotfiles

    echo
    success "🎉 Complete environment setup finished!"
    echo
    echo "Next steps:"
    echo "  1. Restart your terminal (or run: exec zsh)"
    echo "  2. Run 'chezmoi update' anytime to pull latest changes"
    echo "  3. Edit files in ~/.local/share/chezmoi to customize"
    echo
}

main "$@"