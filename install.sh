#!/bin/bash
# Dotfiles Setup Script
# Works on: Mac, Linux, WSL (Ubuntu on Windows)
# Usage: curl -sL https://raw.githubusercontent.com/kishananuraag/dotfiles/main/install.sh | bash

set -e

DOTFILES_REPO="https://github.com/kishananuraag/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo_status() { echo -e "${GREEN}[*] $1${NC}"; }
echo_warn() { echo -e "${YELLOW}[!] $1${NC}"; }
echo_error() { echo -e "${RED}[x] $1${NC}"; }

# Detect OS
detect_os() {
    if [ -n "$WSL_DISTRO_NAME" ]; then
        echo "wsl"
    elif [ "$(uname -s)" = "Darwin" ]; then
        echo "macos"
    elif [ "$(uname -s)" = "Linux" ]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

# Install dependencies for WSL
install_wsl_deps() {
    echo_status "Installing dependencies for WSL..."
    sudo apt update
    sudo apt install -y zsh git curl wget build-essential
    echo_status "Dependencies installed!"
}

# Install nvm
install_nvm() {
    if [ ! -d "$HOME/.nvm" ]; then
        echo_status "Installing nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        echo_status "nvm installed! Run: source ~/.zshrc && nvm install --lts"
    else
        echo_warn "nvm already installed"
    fi
}

# Clone or update dotfiles
sync_dotfiles() {
    if [ -d "$DOTFILES_DIR" ]; then
        echo_status "Updating dotfiles..."
        cd "$DOTFILES_DIR" && git pull
    else
        echo_status "Cloning dotfiles..."
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi
}

# Create symlinks
setup_symlinks() {
    echo_status "Setting up symlinks..."

    # Gitconfig
    ln -sf "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"

    # Shell aliases
    ln -sf "$DOTFILES_DIR/aliases" "$HOME/.aliases"

    # zsh config
    ln -sf "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/zshenv" "$HOME/.zshenv"

    # gitignore
    ln -sf "$DOTFILES_DIR/gitignore_global" "$HOME/.gitignore_global"

    echo_status "Symlinks created!"
}

# Configure shell
configure_shell() {
    OS=$(detect_os)

    if [ "$OS" = "wsl" ]; then
        # Set zsh as default shell
        if [ "$SHELL" != "/bin/zsh" ]; then
            echo_status "Setting zsh as default shell..."
            chsh -s /bin/zsh
        fi
    fi

    # Add aliases to shell RC if not present
    if [ -n "$ZSH_VERSION" ]; then
        if ! grep -q "dotfiles aliases" "$HOME/.zshrc" 2>/dev/null; then
            echo "" >> "$HOME/.zshrc"
            echo "# Load dotfiles aliases" >> "$HOME/.zshrc"
            echo "[ -f ~/.aliases ] && source ~/.aliases" >> "$HOME/.zshrc"
        fi
    elif [ -n "$BASH_VERSION" ]; then
        if ! grep -q "dotfiles aliases" "$HOME/.bashrc" 2>/dev/null; then
            echo "" >> "$HOME/.bashrc"
            echo "# Load dotfiles aliases" >> "$HOME/.bashrc"
            echo "[ -f ~/.aliases ] && source ~/.aliases" >> "$HOME/.bashrc"
        fi
    fi
}

# Main
main() {
    OS=$(detect_os)
    echo_status "Detected OS: $OS"

    sync_dotfiles
    setup_symlinks
    configure_shell

    if [ "$OS" = "wsl" ]; then
        install_wsl_deps
        install_nvm
    fi

    echo ""
    echo_status "========================================="
    echo_status "  Dotfiles setup complete!"
    echo_status "========================================="
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal"
    echo "  2. Run: source ~/.zshrc"
    echo ""
    if [ "$OS" = "wsl" ]; then
        echo "For GlazeWM (tiling):"
        echo "  1. Download from https://glazewm.com/"
        echo "  2. Copy ~/.dotfiles/glaze.yaml to %APPDATA%\\glazewm\\config.yaml"
        echo ""
    fi
}

main "$@"
