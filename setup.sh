#!/usr/bin/env bash
# =============================================================================
# computer-setup - Universal Environment Setup (Linux / WSL / macOS)
# =============================================================================
# This script fully sets up your development environment using Chezmoi.
# Run with: bash setup.sh
# =============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Detect OS and environment
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
    log "Detected OS: $OS"
}

# Install Chezmoi if not present
install_chezmoi() {
    if command -v chezmoi >/dev/null 2>&1; then
        log "Chezmoi already installed: $(chezmoi --version | head -1)"
        return
    fi

    log "Installing Chezmoi..."
    if [[ "$OS" == "macos" ]]; then
        if command -v brew >/dev/null 2>&1; then
            brew install chezmoi
        else
            sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b "$HOME/.local/bin"
        fi
    elif [[ "$OS" == "linux" || "$OS" == "wsl" ]]; then
        # Try package managers
        if command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y chezmoi
        elif command -v apt >/dev/null 2>&1; then
            sudo apt update && sudo apt install -y chezmoi
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -S --noconfirm chezmoi
        else
            sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b "$HOME/.local/bin"
        fi
    fi

    # Ensure chezmoi is in PATH
    if ! command -v chezmoi >/dev/null 2>&1; then
        export PATH="$HOME/.local/bin:$PATH"
    fi

    success "Chezmoi installed successfully"
}

# Install modern CLI tools
install_cli_tools() {
    log "Installing modern CLI tools..."

    case "$OS" in
        linux|wsl)
            if command -v dnf >/dev/null 2>&1; then
                sudo dnf install -y eza bat ripgrep fd-find zsh
            elif command -v apt >/dev/null 2>&1; then
                sudo apt update
                sudo apt install -y eza bat ripgrep fd-find zsh
            elif command -v pacman >/dev/null 2>&1; then
                sudo pacman -S --noconfirm eza bat ripgrep fd zsh
            fi
            ;;
        macos)
            if command -v brew >/dev/null 2>&1; then
                brew install eza bat ripgrep fd zsh
            fi
            ;;
    esac

    success "CLI tools installed (or already present)"
}

# Initialize and apply dotfiles
setup_dotfiles() {
    log "Initializing dotfiles with Chezmoi..."

    local repo="dante-sparras/computer-setup"

    if chezmoi --version >/dev/null 2>&1; then
        chezmoi init --apply "$repo" --force || true
    else
        error "Chezmoi not found in PATH after installation"
    fi

    success "Dotfiles applied successfully!"
}

# Set zsh as default shell (if not already)
setup_shell() {
    if [[ "$SHELL" != *"zsh"* ]]; then
        log "Setting zsh as default shell..."
        if command -v zsh >/dev/null 2>&1; then
            chsh -s "$(command -v zsh)" || warn "Could not change shell automatically. Run: chsh -s $(which zsh)"
        fi
    else
        log "zsh is already your default shell"
    fi
}

# Main execution
main() {
    echo "=========================================="
    echo "   computer-setup - Full Environment Setup"
    echo "=========================================="

    detect_os
    install_chezmoi
    install_cli_tools
    setup_dotfiles
    setup_shell

    echo
    success "🎉 Environment setup complete!"
    echo
    echo "Next steps:"
    echo "  • Restart your terminal or run: exec zsh"
    echo "  • Run 'chezmoi update' to pull future changes"
    echo "  • Edit configs in ~/.local/share/chezmoi"
    echo
}

main "$@"