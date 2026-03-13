#!/bin/bash
# Enhanced Dotfiles Setup Script
# Works on: macOS, Linux, WSL (Ubuntu on Windows)
# Features: Homebrew, Oh My Zsh, VS Code extensions, Docker aliases
# Usage: curl -sL https://raw.githubusercontent.com/kishananuraag/dotfiles/main/install.sh | bash

set -e

DOTFILES_REPO="https://github.com/kishananuraag/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo_status() { echo -e "${GREEN}[✓] $1${NC}"; }
echo_warn() { echo -e "${YELLOW}[!] $1${NC}"; }
echo_error() { echo -e "${RED}[✗] $1${NC}"; }
echo_info() { echo -e "${BLUE}[ℹ] $1${NC}"; }

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

# Install Homebrew
install_homebrew() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo_info "Checking Homebrew installation..."
        if ! command -v brew &>/dev/null; then
            echo_status "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            echo_status "Homebrew already installed"
        fi
    elif [ "$(detect_os)" = "wsl" ] || [ "$(detect_os)" = "linux" ]; then
        echo_info "Checking Homebrew on Linux..."
        if ! command -v brew &>/dev/null; then
            echo_status "Installing Homebrew on Linux..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        else
            echo_status "Homebrew already installed"
        fi
    fi
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo_status "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        
        # Install plugins
        echo_status "Installing zsh-autosuggestions plugin..."
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null || true
        
        echo_status "Installing zsh-syntax-highlighting plugin..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null || true
    else
        echo_status "Oh My Zsh already installed"
    fi
}

# Run Brewfile
run_brewfile() {
    if command -v brew &>/dev/null; then
        echo_status "Installing packages from Brewfile..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew bundle --file="$DOTFILES_DIR/Brewfile"
        else
            # WSL - use Brewfile.wsl if it exists
            if [ -f "$DOTFILES_DIR/Brewfile.wsl" ]; then
                brew bundle --file="$DOTFILES_DIR/Brewfile.wsl"
            fi
        fi
    else
        echo_warn "Homebrew not found, skipping package installation"
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

# Install VS Code Extensions
install_vscode_extensions() {
    if command -v code &>/dev/null; then
        echo_status "Installing VS Code extensions..."
        if [ -f "$DOTFILES_DIR/scripts/install-vscode-extensions.sh" ]; then
            bash "$DOTFILES_DIR/scripts/install-vscode-extensions.sh"
        fi
    else
        echo_warn "VS Code not found, skipping extension installation"
        echo_info "Install VS Code and run: $DOTFILES_DIR/scripts/install-vscode-extensions.sh"
    fi
}

# Create symlinks
setup_symlinks() {
    echo_status "Setting up symlinks..."

    # Backup existing files
    backup_if_exists() {
        if [ -e "$1" ] && [ ! -L "$1" ]; then
            echo_info "Backing up existing $1 to $1.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
        fi
    }

    # Git configuration
    backup_if_exists "$HOME/.gitconfig"
    ln -sf "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"

    backup_if_exists "$HOME/.gitignore_global"
    ln -sf "$DOTFILES_DIR/gitignore_global" "$HOME/.gitignore_global"

    # Shell configuration
    backup_if_exists "$HOME/.aliases"
    ln -sf "$DOTFILES_DIR/aliases" "$HOME/.aliases"

    backup_if_exists "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"

    backup_if_exists "$HOME/.zshenv"
    ln -sf "$DOTFILES_DIR/zshenv" "$HOME/.zshenv"

    echo_status "Core symlinks created!"
}

# Create additional symlinks
setup_additional_symlinks() {
    echo_status "Setting up additional configuration symlinks..."
    
    # VS Code settings (platform-specific paths)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        VSCODE_DIR="$HOME/Library/Application Support/Code/User"
    else
        VSCODE_DIR="$HOME/.config/Code/User"
    fi
    
    if [ -d "$VSCODE_DIR" ]; then
        mkdir -p "$VSCODE_DIR"
        ln -sf "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_DIR/settings.json"
        ln -sf "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_DIR/keybindings.json"
        echo_status "VS Code settings linked"
    fi
    
    # Python pip config
    mkdir -p "$HOME/.config/pip"
    ln -sf "$DOTFILES_DIR/python/pip.conf" "$HOME/.config/pip/pip.conf"
    echo_status "Python pip config linked"
    
    # SSH config (only if user doesn't have one)
    if [ ! -f "$HOME/.ssh/config" ]; then
        mkdir -p "$HOME/.ssh"
        cp "$DOTFILES_DIR/ssh/config.example" "$HOME/.ssh/config"
        chmod 600 "$HOME/.ssh/config"
        echo_warn "SSH config created from template - customize as needed"
    fi
}

# Configure shell
configure_shell() {
    OS=$(detect_os)

    # Set zsh as default shell (if not already)
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo_status "Setting zsh as default shell..."
        if [ "$OS" = "wsl" ] || [ "$OS" = "linux" ]; then
            chsh -s $(which zsh)
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            chsh -s $(which zsh)
        fi
        echo_warn "You may need to restart your terminal for shell change to take effect"
    else
        echo_status "Zsh is already the default shell"
    fi
}

# Main installation function
main() {
    OS=$(detect_os)
    
    echo_info "╔══════════════════════════════════════════════════════════════════╗"
    echo_info "║                     Dotfiles Installation                       ║"
    echo_info "║              Cross-platform development environment             ║"
    echo_info "╚══════════════════════════════════════════════════════════════════╝"
    echo ""
    echo_status "Detected OS: $OS"

    # Core setup
    sync_dotfiles
    setup_symlinks
    
    # Install package managers and tools
    install_homebrew
    install_oh_my_zsh
    
    # Platform-specific setup
    if [ "$OS" = "wsl" ] || [ "$OS" = "linux" ]; then
        install_wsl_deps
    fi
    
    # Install packages via Homebrew
    run_brewfile
    
    # Node.js setup
    install_nvm
    
    # Additional configurations
    setup_additional_symlinks
    
    # Configure shell
    configure_shell
    
    # Install VS Code extensions
    install_vscode_extensions

    echo ""
    echo_status "╔══════════════════════════════════════════════════════════════════╗"
    echo_status "║                    🎉 INSTALLATION COMPLETE! 🎉                 ║"
    echo_status "╚══════════════════════════════════════════════════════════════════╝"
    echo ""
    echo_info "What was installed:"
    echo "  ✅ Shell: Zsh + Oh My Zsh (robbyrussell theme)"
    echo "  ✅ Package Manager: Homebrew"
    if [[ "$OS" == "macos" ]]; then
        echo "  ✅ Applications: Chrome, Kitty, VLC, OBS, Obsidian, Discord, etc."
        echo "  ✅ Fonts: JetBrains Mono, Source Code Pro"
    fi
    echo "  ✅ Development: Git, Node.js, Python, Docker"
    echo "  ✅ VS Code: Settings, extensions, WSL integration"
    echo "  ✅ Configurations: Git, SSH templates, Docker aliases"
    echo ""
    echo_info "Next steps:"
    echo "  1. Restart your terminal"
    echo "  2. Try: code . (VS Code), dps (Docker), gs (Git status)"
    if [ "$OS" = "wsl" ]; then
        echo "  3. For Windows Terminal, set Ubuntu as default profile"
        echo "  4. For GlazeWM (tiling): Copy ~/.dotfiles/glaze.yaml to Windows"
    fi
    echo ""
    echo_info "Documentation:"
    echo "  📚 Full guides: ~/.dotfiles/docs/"
    echo "  🔧 SSH setup: ~/.dotfiles/ssh/README.md"
    echo "  🐞 Issues: ~/.dotfiles/docs/TROUBLESHOOTING.md"
    echo ""
    echo_status "Happy coding! 🚀"
}

main "$@"
