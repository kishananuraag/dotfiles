# macOS Installation Guide

Complete guide for setting up the dotfiles on macOS with automated package management via Homebrew.

## Prerequisites

- **macOS 10.15 (Catalina)** or later
- **Internet connection** for downloading packages
- **Xcode Command Line Tools** (automatically installed)

## Quick Start

### One-Command Installation

```bash
# Clone and install in one command
git clone https://github.com/kishananuraag/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./install.sh
```

### Step-by-Step Installation

```bash
# 1. Clone the repository
git clone https://github.com/kishananuraag/dotfiles.git ~/.dotfiles

# 2. Navigate to dotfiles directory
cd ~/.dotfiles

# 3. Run installation script
./install.sh
```

**Installation time:** 10-15 minutes (depending on internet speed)

## What Gets Installed

### Package Manager

**Homebrew** - The missing package manager for macOS
- Automatically installed if not present
- Used to install all development tools and applications

### Development Tools

**Command Line Tools:**
- Git with enhanced configuration
- Zsh with Oh My Zsh (robbyrussell theme)
- Neovim, Ripgrep (modern search)
- Node.js (latest LTS)
- Python 3.11
- Docker & Docker Compose
- Essential utilities: curl, wget, zlib

**Zsh Enhancements:**
- zsh-autosuggestions (command suggestions)
- zsh-syntax-highlighting (syntax highlighting)

### Applications

**Development:**
- Google Chrome
- Kitty Terminal (GPU-accelerated)

**Media & Productivity:**
- VLC Media Player
- OBS Studio (streaming/recording)
- Multiviewer (multi-camera monitoring)
- Obsidian (note-taking)

**Utilities:**
- Android File Transfer
- iStat Menus (system monitoring)

**Communication:**
- Microsoft Teams
- Discord

### Fonts

**Programming Fonts:**
- JetBrains Mono (with ligatures)
- Source Code Pro

### VS Code Extensions

**Theme & Appearance:**
- Catppuccin theme and icons

**Development:**
- WSL extension (for Windows compatibility)
- Docker extension
- GitLens (enhanced Git integration)
- Prettier (code formatting)
- Python extension

**Database:**
- SQL Server tools
- SQL Database Projects

## Configuration Details

### Shell Configuration

**Zsh Setup:**
- Oh My Zsh framework with robbyrussell theme
- Custom aliases for productivity
- Enhanced history and completion
- Vim key bindings
- Git status in prompt

**Available Aliases:**
```bash
# File operations
ll                # ls -alF
la                # ls -A
l                 # ls -CF

# Git shortcuts
gs                # git status
ga                # git add
gc                # git commit
gp                # git push
gl                # git log

# Development
dev               # npm run dev
build             # npm run build
test              # npm test

# Docker shortcuts
dps               # docker ps
dc                # docker-compose
dcleanup          # cleanup unused containers/images
```

### Git Configuration

**Enhanced Git Setup:**
- User configured as "Kishan" <kishananuraag@gmail.com>
- Useful aliases (st, co, br, ci, lg, undo)
- Global gitignore for common files
- Optimized for rebasing workflow

**Git Aliases:**
```bash
git st            # status
git co            # checkout
git br            # branch
git ci            # commit
git lg            # fancy log with graph
git undo          # reset last commit (soft)
```

### VS Code Integration

**Settings:**
- JetBrains Mono font with ligatures
- Catppuccin Macchiato theme
- Optimized for development workflow
- Integrated terminal uses zsh
- Format on save enabled

**Terminal Integration:**
```bash
code .            # Open current directory
code file.js      # Open specific file
code -n           # New window
```

## Development Environment

### Node.js Development

**NVM (Node Version Manager):**
```bash
# Install latest LTS
nvm install --lts

# Use specific version
nvm use 18

# List installed versions
nvm list
```

**npm Configuration:**
- Automatic init defaults (author, license)
- Performance optimizations

### Python Development

**pyenv (Python Version Manager):**
```bash
# Install Python version
pyenv install 3.11.0

# Set global version
pyenv global 3.11.0

# List available versions
pyenv versions
```

**pip Configuration:**
- Faster downloads and caching
- User-level installations by default

### Docker Development

**Docker Desktop:**
- Installed via Homebrew
- Automatic service management
- Useful aliases for common tasks

**Docker Workflow:**
```bash
# Start containers
dc up

# View running containers
dps

# Clean up
dcleanup

# Execute command in container
dex container_name bash
```

## Directory Structure

### Dotfiles Organization

```
~/.dotfiles/
├── README.md                    # Main documentation
├── install.sh                   # Installation script
├── Brewfile                     # macOS packages
│
├── gitconfig                    # Git configuration
├── gitignore_global             # Global gitignore
├── aliases                      # Shell aliases
├── zshrc                        # Zsh configuration
├── zshenv                       # Environment variables
│
├── vscode/                      # VS Code settings
├── docker/                      # Docker aliases
├── python/                      # Python configuration
├── ssh/                         # SSH templates
├── scripts/                     # Utility scripts
└── docs/                        # Documentation
```

### Home Directory

After installation, your home directory will have:

```
~/
├── .dotfiles/                   # This repository
├── .gitconfig -> .dotfiles/gitconfig
├── .gitignore_global -> .dotfiles/gitignore_global
├── .aliases -> .dotfiles/aliases
├── .zshrc -> .dotfiles/zshrc
├── .zshenv -> .dotfiles/zshenv
├── .oh-my-zsh/                  # Oh My Zsh installation
└── Projects/                    # Recommended for projects
```

## Customization

### Personal Modifications

**Git Configuration:**
```bash
# Edit personal Git settings
vim ~/.dotfiles/git/gitconfig.local.example
cp ~/.dotfiles/git/gitconfig.local.example ~/.gitconfig.local
```

**Shell Aliases:**
```bash
# Add personal aliases
vim ~/.dotfiles/aliases

# Or create local overrides
vim ~/.aliases.local
```

**Zsh Configuration:**
```bash
# Customize zsh settings
vim ~/.dotfiles/zshrc

# Or add local customizations
vim ~/.zshrc.local
```

### VS Code Settings

**Modify Settings:**
```bash
vim ~/.dotfiles/vscode/settings.json
```

**Add Extensions:**
```bash
# Add to extensions list
echo "extension.name" >> ~/.dotfiles/vscode/extensions.txt

# Reinstall extensions
~/.dotfiles/scripts/install-vscode-extensions.sh
```

### Application Changes

**Modify Brewfile:**
```bash
# Edit package list
vim ~/.dotfiles/Brewfile

# Install new packages
brew bundle --file ~/.dotfiles/Brewfile
```

## Maintenance

### Updating Dotfiles

```bash
# Update repository
cd ~/.dotfiles
git pull

# Re-run installation to apply updates
./install.sh
```

### Updating Packages

```bash
# Update Homebrew and packages
brew update && brew upgrade

# Update npm packages
npm update -g

# Update Oh My Zsh
omz update
```

### Backup Before Changes

```bash
# Create backup of current configs
cp ~/.zshrc ~/.zshrc.backup
cp ~/.gitconfig ~/.gitconfig.backup

# Or commit local changes
cd ~/.dotfiles
git add .
git commit -m "Local customizations"
```

## Troubleshooting

### Common Issues

**1. Homebrew Installation Fails**

```bash
# Check Xcode Command Line Tools
xcode-select --install

# Manual Homebrew installation
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**2. Zsh Not Default Shell**

```bash
# Change default shell to zsh
chsh -s $(which zsh)

# Restart terminal
```

**3. VS Code Command Not Found**

```bash
# Install VS Code command line tools
# 1. Open VS Code
# 2. Cmd+Shift+P
# 3. Type "shell command"
# 4. Select "Install 'code' command in PATH"
```

**4. Git SSH Issues**

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "kishananuraag@gmail.com"

# Add to ssh-agent
ssh-add ~/.ssh/id_ed25519

# Add public key to GitHub
cat ~/.ssh/id_ed25519.pub
```

**5. Permission Errors**

```bash
# Fix dotfiles permissions
chmod -R 755 ~/.dotfiles
chmod +x ~/.dotfiles/install.sh
chmod +x ~/.dotfiles/scripts/*.sh
```

**6. Symlink Issues**

```bash
# Remove broken symlinks
find ~ -type l ! -exec test -e {} \; -delete

# Re-run installation
cd ~/.dotfiles && ./install.sh
```

### Advanced Troubleshooting

**Check Installation Log:**
```bash
# Run installation with verbose output
cd ~/.dotfiles
bash -x ./install.sh
```

**Verify Symlinks:**
```bash
# List all symlinks pointing to dotfiles
ls -la ~ | grep "\.dotfiles"
```

**Reset Configuration:**
```bash
# Back up current config
mv ~/.zshrc ~/.zshrc.old
mv ~/.gitconfig ~/.gitconfig.old

# Re-run installation
cd ~/.dotfiles && ./install.sh
```

## Performance Optimization

### Zsh Performance

**Check Startup Time:**
```bash
# Time zsh startup
time zsh -i -c exit
```

**Optimize if Slow:**
```bash
# Disable slow plugins temporarily
vim ~/.dotfiles/zshrc

# Profile zsh startup
zsh -xvs
```

### Homebrew Optimization

**Speed Up Installation:**
```bash
# Use multiple cores
echo 'export HOMEBREW_MAKE_JOBS=4' >> ~/.zshrc

# Skip unnecessary downloads
echo 'export HOMEBREW_NO_AUTO_UPDATE=1' >> ~/.zshrc
```

## Additional Resources

- [Homebrew Documentation](https://docs.brew.sh/)
- [Oh My Zsh Documentation](https://ohmyz.sh/)
- [VS Code macOS Setup](https://code.visualstudio.com/docs/setup/mac)
- [macOS Terminal Tips](https://support.apple.com/guide/terminal/)

## Next Steps

After successful installation:

1. **Restart Terminal:** Launch a new terminal session
2. **Verify Installation:** Test aliases and commands
3. **Set up SSH:** Follow the [SSH Guide](../ssh/README.md)
4. **Customize:** Modify configs to match your preferences
5. **Create Projects:** Use `~/Projects` for development work
6. **Regular Updates:** Keep dotfiles and packages updated

## Integration with Other Platforms

This dotfiles setup is designed to work seamlessly with:

- **WSL:** Same configs work in Windows Subsystem for Linux
- **Linux:** Most configs are compatible with Linux distributions
- **Remote Servers:** Can be deployed via SSH for consistent environment

See [Windows Guide](WINDOWS.md) for WSL-specific instructions.