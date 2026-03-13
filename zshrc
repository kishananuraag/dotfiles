# Oh My Zsh Configuration
# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Plugins to load
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    node
    npm
    python
)

# Load Oh My Zsh (if installed)
if [ -d "$ZSH" ]; then
    source $ZSH/oh-my-zsh.sh
else
    # Fallback configuration if Oh My Zsh is not installed
    echo "⚠️  Oh My Zsh not found. Run the installation script to set it up."
    
    # Basic prompt
    PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '
    
    # Basic completion
    autoload -Uz compinit
    compinit
    
    # Suggested completions
    zstyle ':completion:*' menu select
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Enable color support
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# Key bindings
bindkey -v  # Vim mode
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# Load dotfiles aliases
[ -f ~/.aliases ] && source ~/.aliases

# Load Docker aliases if they exist
[ -f ~/.dotfiles/docker/aliases.zsh ] && source ~/.dotfiles/docker/aliases.zsh

# Platform-specific configurations
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS specific settings
    [ -f ~/.dotfiles/zsh/macos.zsh ] && source ~/.dotfiles/zsh/macos.zsh
elif grep -qi microsoft /proc/version 2>/dev/null; then
    # WSL specific settings
    [ -f ~/.dotfiles/zsh/wsl.zsh ] && source ~/.dotfiles/zsh/wsl.zsh
fi

# Load local customizations (if they exist)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
