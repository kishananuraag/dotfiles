# Load nvm (Node Version Manager)
# This runs before .zshrc for early availability

export NVM_DIR="$HOME/.nvm"

# Load nvm if it exists
if [ -d "$NVM_DIR" ]; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Default editor
export EDITOR="vim"
export VISUAL="vim"

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Path additions
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# History
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
