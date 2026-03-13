# Load dotfiles aliases
[ -f ~/.aliases ] && source ~/.aliases

# Path additions
export PATH="$HOME/bin:/usr/local/bin:$PATH"

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

# Completion
autoload -Uz compinit
compinit

# Suggested completions
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Enable vim mode
bindkey -v

# Key bindings
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
