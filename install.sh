#!/bin/bash
# Dotfiles Setup Script
# Run this on any machine to sync your configs

DOTFILES_REPO="https://github.com/yourusername/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

# Clone or update dotfiles repo
if [ -d "$DOTFILES_DIR" ]; then
    echo "Updating dotfiles..."
    cd "$DOTFILES_DIR" && git pull
else
    echo "Cloning dotfiles..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# Create symlinks
echo "Setting up symlinks..."

# Gitconfig
ln -sf "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"

# Shell aliases
ln -sf "$DOTFILES_DIR/aliases" "$HOME/.aliases"

# Shell RC file
if [ -n "$ZSH_VERSION" ]; then
    if ! grep -q ".aliases" "$HOME/.zshrc" 2>/dev/null; then
        echo "" >> "$HOME/.zshrc"
        echo "# Load dotfiles aliases" >> "$HOME/.zshrc"
        echo "[ -f ~/.aliases ] && source ~/.aliases" >> "$HOME/.zshrc"
    fi
elif [ -n "$BASH_VERSION" ]; then
    if ! grep -q ".aliases" "$HOME/.bashrc" 2>/dev/null; then
        echo "" >> "$HOME/.bashrc"
        echo "# Load dotfiles aliases" >> "$HOME/.bashrc"
        echo "[ -f ~/.aliases ] && source ~/.aliases" >> "$HOME/.bashrc"
    fi
fi

echo "Dotfiles synced successfully!"
echo "Source ~/.aliases to load aliases, or restart your shell."
