# Neovim Configuration (LazyVim)

This directory is for your Neovim configuration. We recommend using LazyVim, which is what your friend (shivajreddy) uses.

## Quick Setup

### Option 1: Use Your Friend's Configuration (Recommended)

1. **Clone your friend's dotfiles** to get the complete nvim config:
   ```powershell
   git clone https://github.com/shivajreddy/dotfiles.git $env:TEMP\friend-dotfiles
   ```

2. **Copy the nvim configuration**:
   ```powershell
   Copy-Item -Path "$env:TEMP\friend-dotfiles\common\nvim" -Destination "$env:LOCALAPPDATA\nvim" -Recurse -Force
   ```

3. **Launch Neovim** - LazyVim will automatically install all plugins:
   ```powershell
   nvim
   ```

### Option 2: Fresh LazyVim Installation

If you want to start fresh and customize yourself:

1. **Backup any existing config**:
   ```powershell
   Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak
   Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak
   ```

2. **Clone LazyVim starter**:
   ```powershell
   git clone https://github.com/LazyVim/starter $env:LOCALAPPDATA\nvim
   Remove-Item $env:LOCALAPPDATA\nvim\.git -Recurse -Force
   ```

3. **Launch Neovim**:
   ```powershell
   nvim
   ```

## Configuration Location

- **Config Directory**: `%LOCALAPPDATA%\nvim` (typically `C:\Users\<username>\AppData\Local\nvim`)
- **Data Directory**: `%LOCALAPPDATA%\nvim-data`
- **Friend's Config**: https://github.com/shivajreddy/dotfiles/tree/main/common/nvim

## LazyVim Features

- Modern Neovim configuration framework
- Automatic plugin management with lazy.nvim
- Pre-configured LSP, autocompletion, syntax highlighting
- File explorer, fuzzy finder, git integration
- Highly customizable and extensible

## Customization

After installation, you can customize:
- `lua/config/options.lua` - Neovim options
- `lua/config/keymaps.lua` - Custom keybindings
- `lua/config/lazy.lua` - Plugin manager settings
- `lua/plugins/` - Add or override plugins

## Resources

- **LazyVim Documentation**: https://www.lazyvim.org/
- **Neovim Documentation**: https://neovim.io/doc/
- **Friend's Dotfiles**: https://github.com/shivajreddy/dotfiles
