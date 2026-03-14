# Cross-Platform Dotfiles

Automated development environment setup for macOS, Linux, and Windows with one-command installation.

## ✨ Features

- 🚀 **One-command installation** on any platform
- 📦 **Automated package management** via Homebrew (macOS) / winget (Windows)
- 🎨 **Zsh with Oh My Zsh** (macOS/Linux) - robbyrussell theme, auto-suggestions, syntax highlighting
- ⚡ **PowerShell 7 + Starship** (Windows) - Modern prompt with Kanagawa Dragon theme
- 🖥️ **Alacritty Terminal** (Windows) - GPU-accelerated, Iosevka font, Kanagawa theme
- 📝 **Neovim + LazyVim** - Modern text editor with LSP, completion, and plugins
- ⌨️ **Kanata Keyboard Remapping** (Windows) - Ergonomic keyboard customization
- 🐳 **Docker** - Shortcuts and aliases for container management
- 💻 **VS Code** - Synced settings, keybindings, and extensions
- 🔐 **Git & SSH** - Pre-configured with best practices
- 🐍 **Python & Node.js** - Version managers and configs
- 🪟 **GlazeWM** (Windows) - Tiling window manager for productivity

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

### Windows (Alacritty + Native PowerShell)
```powershell
# Run as Administrator (Right-click PowerShell → Run as Administrator)

# 1. Clone the repository
git clone https://github.com/kishananuraag/dotfiles.git $env:USERPROFILE\.dotfiles

# 2. Run the installation script
cd $env:USERPROFILE\.dotfiles\windows
Set-ExecutionPolicy Bypass -Scope Process -Force
.\install-windows.ps1
```

**What gets installed:**
- Alacritty terminal with Kanagawa Dragon theme
- PowerShell 7 + Starship prompt
- Neovim with LazyVim configuration
- Iosevka font (programmer font with ligatures)
- Kanata keyboard remapper (optional)
- GlazeWM tiling window manager
- Modern CLI tools: zoxide, fzf, ripgrep, bat, eza

See [docs/ALACRITTY_SETUP.md](docs/ALACRITTY_SETUP.md) for detailed setup guide.

### macOS or Linux
```bash
git clone https://github.com/kishananuraag/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## 📚 Documentation

- [Alacritty Setup (Windows)](docs/ALACRITTY_SETUP.md) - Complete Alacritty + PowerShell setup
- [Windows Guide](docs/WINDOWS.md) - Windows-specific configuration
- [macOS Setup Guide](docs/MACOS.md) - macOS installation and configuration
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and solutions
- [SSH Configuration](ssh/README.md) - SSH key setup and GitHub authentication
- [Neovim Setup](windows/nvim/README.md) - LazyVim installation and usage
- [Kanata Keyboard Remapping](windows/kanata/README.md) - Keyboard customization guide

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

### Windows Configuration
- `windows/install-windows.ps1` - One-command Windows setup script
- `windows/alacritty/` - Alacritty terminal configuration with Kanagawa theme
- `windows/PowerShell/` - PowerShell 7 profile with aliases and customizations
- `windows/starship.toml` - Starship prompt configuration (Kanagawa Dragon theme)
- `windows/nvim/` - Neovim LazyVim setup guide
- `windows/kanata/` - Kanata keyboard remapping (AULA F75 config)
- `windows/glaze.yaml` - GlazeWM tiling window manager config

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
├── install.sh                   # macOS/Linux installation script
├── Brewfile                     # macOS packages
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
└── windows/                     # Windows-specific configurations
    ├── install-windows.ps1      # Windows installation script
    ├── alacritty/               # Alacritty terminal config (Kanagawa theme)
    ├── PowerShell/              # PowerShell 7 profile + aliases
    ├── starship.toml            # Starship prompt (Kanagawa Dragon)
    ├── nvim/                    # Neovim LazyVim setup guide
    ├── kanata/                  # Keyboard remapping (AULA F75)
    └── glaze.yaml               # GlazeWM tiling window manager
```

## 🤝 Contributing

Feel free to fork and customize for your own use! Contributions and suggestions are welcome.

## 📄 License

MIT

---

**Cross-platform development environment that works everywhere.** ✨
