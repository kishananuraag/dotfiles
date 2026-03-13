# Cross-Platform Dotfiles

Automated development environment setup for macOS, Linux, WSL, and Windows with one-command installation.

## ✨ Features

- 🚀 **One-command installation** on any platform
- 📦 **Automated package management** via Homebrew (macOS + WSL)
- 🎨 **Zsh with Oh My Zsh** - robbyrussell theme, auto-suggestions, syntax highlighting
- 🐳 **Docker** - Shortcuts and aliases for container management
- 💻 **VS Code** - Synced settings, keybindings, and extensions
- 🔐 **Git & SSH** - Pre-configured with best practices
- 🐍 **Python & Node.js** - Version managers and configs
- 🪟 **Windows** - GlazeWM tiling window manager + PowerShell aliases

## 🎯 What Gets Installed

### macOS (via Brewfile)
- **Dev Tools**: Git, Neovim, Ripgrep, Zsh enhancements, Docker
- **Languages**: Node.js, Python 3.11
- **Fonts**: JetBrains Mono, Source Code Pro
- **Apps**: Chrome, Kitty Terminal, VLC, OBS, Obsidian, Discord, Teams
- **VS Code Extensions**: Catppuccin theme, SQL Server tools, WSL extension, GitLens, Docker

### WSL/Linux
- Essential CLI tools (git, zsh, curl, wget, build-essential)
- Homebrew on Linux (optional)
- Docker
- nvm (Node Version Manager)

### All Platforms
- Oh My Zsh with plugins
- Git configuration with useful aliases
- Shell aliases for productivity
- VS Code settings sync

## 🚀 Quick Start

### Fresh Windows (No WSL)
```powershell
# 1. Download bootstrap script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/kishananuraag/dotfiles/main/bootstrap.ps1" -OutFile "$env:USERPROFILE\Downloads\bootstrap.ps1"

# 2. Run as Administrator
cd $env:USERPROFILE\Downloads
Set-ExecutionPolicy Bypass -Scope Process -Force
.\bootstrap.ps1
```

### macOS or Linux
```bash
git clone https://github.com/kishananuraag/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

### WSL (Already Installed)
```bash
git clone https://github.com/kishananuraag/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## 📚 Documentation

- [Windows/WSL Setup Guide](docs/WINDOWS.md) - Complete Windows installation guide
- [macOS Setup Guide](docs/MACOS.md) - macOS installation and configuration
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and solutions
- [SSH Configuration](ssh/README.md) - SSH key setup and GitHub authentication

## 🛠️ Configuration Files

### Shell & Git
- `aliases` - Shell aliases for productivity
- `zshrc` - Zsh configuration with Oh My Zsh
- `zshenv` - Environment variables and PATH
- `gitconfig` - Git configuration with useful aliases
- `gitignore_global` - Global gitignore patterns

### Package Management
- `Brewfile` - macOS packages and applications
- `Brewfile.wsl` - WSL-specific packages via Homebrew
- `python/pip.conf` - Python pip configuration

### Development Tools
- `vscode/` - VS Code settings, keybindings, and extensions
- `docker/aliases.zsh` - Docker shortcuts and functions
- `ssh/config.example` - SSH configuration template

### Windows Integration
- `bootstrap.ps1` - Automated WSL installation for Windows
- `install.ps1` - Windows PowerShell setup
- `aliases_windows.ps1` - PowerShell aliases
- `glaze.yaml` - GlazeWM tiling window manager config

### Documentation & Scripts
- `docs/` - Platform-specific installation guides
- `scripts/` - Utility scripts for installation and maintenance

## 🔄 Updating

```bash
cd ~/.dotfiles
git pull
./install.sh  # Re-run to apply updates
```

## 🎨 Customization

All configs are modular and easy to customize:

- **Shell aliases**: Edit `aliases` (Unix) or `aliases_windows.ps1` (Windows)
- **Git settings**: Edit `gitconfig`
- **Zsh config**: Edit `zshrc`
- **VS Code**: Edit files in `vscode/`
- **Packages**: Edit `Brewfile` (macOS) or `Brewfile.wsl` (WSL)

Create local overrides for machine-specific settings:
- `.zshrc.local` - Local zsh customizations
- `.gitconfig.local` - Local git settings (user info, etc.)
- `.aliases.local` - Local aliases

## 🏗️ Repository Structure

```
dotfiles/
├── README.md                    # This file
├── install.sh                   # Main installation script
├── bootstrap.ps1                # Windows WSL bootstrap
├── Brewfile                     # macOS packages
├── Brewfile.wsl                 # WSL packages
│
├── aliases                      # Shell aliases
├── gitconfig                    # Git configuration
├── zshrc                        # Zsh configuration
├── zshenv                       # Environment variables
├── gitignore_global             # Global gitignore
│
├── vscode/                      # VS Code configuration
├── docker/                      # Docker aliases
├── python/                      # Python configuration
├── ssh/                         # SSH templates and guide
├── scripts/                     # Utility scripts
├── docs/                        # Documentation
│
├── aliases_windows.ps1          # Windows PowerShell aliases
├── install.ps1                  # Windows installation
└── glaze.yaml                   # Windows tiling manager
```

## 🤝 Contributing

Feel free to fork and customize for your own use! Contributions and suggestions are welcome.

## 📄 License

MIT

---

**Cross-platform development environment that works everywhere.** ✨
