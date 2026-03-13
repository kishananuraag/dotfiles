# Dotfiles

Your synced configuration files.

## Files

- `aliases` - Shell aliases
- `gitconfig` - Git configuration
- `zshrc` - Zsh configuration
- `install.sh` - Setup script

## Usage

1. Push this folder to a GitHub repo
2. On any new machine, run:
   ```bash
   curl -sL https://raw.githubusercontent.com/yourusername/dotfiles/main/install.sh | bash
   ```

## Manual Setup

```bash
# Clone repo
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles

# Link configs
ln -sf ~/.dotfiles/gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/aliases ~/.aliases
ln -sf ~/.dotfiles/zshrc ~/.zshrc

# Load aliases
source ~/.aliases
```
