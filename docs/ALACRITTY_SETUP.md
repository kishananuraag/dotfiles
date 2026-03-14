# Alacritty Terminal Setup for Windows

Complete guide to setting up a modern Windows development environment with Alacritty, PowerShell 7, and Neovim.

This setup is based on [shivajreddy's dotfiles](https://github.com/shivajreddy/dotfiles) with the **Kanagawa Dragon** theme.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Quick Installation](#quick-installation)
- [Manual Installation](#manual-installation)
- [Configuration](#configuration)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Keyboard Shortcuts](#keyboard-shortcuts)

## 🎯 Overview

### What You'll Get

- **Alacritty**: Lightweight, GPU-accelerated terminal emulator
- **PowerShell 7**: Modern PowerShell with enhanced features
- **Starship Prompt**: Beautiful, informative command prompt
- **Iosevka Font**: Programmer's font with ligatures
- **Kanagawa Dragon Theme**: Dark blue/purple color scheme
- **Neovim + LazyVim**: Modern text editor with IDE features
- **Kanata**: Keyboard remapping for ergonomics
- **GlazeWM**: Tiling window manager (optional)
- **Modern CLI Tools**: zoxide, fzf, ripgrep, bat, eza

### Why This Setup?

- **Native Windows**: No WSL overhead, direct Windows integration
- **GPU-Accelerated**: Smooth rendering, even with lots of output
- **Minimal**: Lightweight, fast startup times
- **Beautiful**: Cohesive Kanagawa Dragon theme across all tools
- **Productive**: Vim motions, tiling windows, keyboard-first workflow

## ✅ Prerequisites

1. **Windows 10 or 11**
2. **Administrator privileges**
3. **Git for Windows** (install first if not present)
4. **Internet connection** (for downloading packages)

## 🚀 Quick Installation

### One-Command Setup (Recommended)

Open PowerShell **as Administrator** (Right-click → Run as Administrator):

```powershell
# Clone the repository
git clone https://github.com/kishananuraag/dotfiles.git $env:USERPROFILE\.dotfiles

# Navigate and run installer
cd $env:USERPROFILE\.dotfiles\windows
Set-ExecutionPolicy Bypass -Scope Process -Force
.\install-windows.ps1
```

The script will:
1. ✅ Install Alacritty via winget
2. ✅ Install PowerShell 7
3. ✅ Install Starship prompt
4. ✅ Install Iosevka font
5. ✅ Install Neovim + LazyVim
6. ✅ Install modern CLI tools (zoxide, fzf, ripgrep, bat, eza)
7. ✅ Install GlazeWM tiling window manager
8. ✅ Create symlinks for all configurations
9. ✅ Optionally setup Kanata keyboard remapping

**Installation takes ~10 minutes** depending on internet speed.

### Post-Installation

1. **Launch Alacritty** from Start Menu
2. **Verify PowerShell 7**:
   ```powershell
   $PSVersionTable.PSVersion  # Should show 7.x.x
   ```
3. **Test Starship prompt** - should display colorful prompt
4. **Open Neovim**:
   ```powershell
   nvim
   ```
   LazyVim will auto-install plugins on first launch (takes 2-3 minutes)

## 🔧 Manual Installation

If you prefer manual installation or need to troubleshoot:

### Step 1: Install Packages

```powershell
# Core tools
winget install Alacritty.Alacritty
winget install Microsoft.PowerShell
winget install Starship.Starship
winget install Neovim.Neovim
winget install Git.Git

# CLI enhancements
winget install ajeetdsouza.zoxide     # Smart cd
winget install junegunn.fzf           # Fuzzy finder
winget install BurntSushi.ripgrep.MSVC  # Fast grep
winget install sharkdp.bat            # Better cat
winget install eza-community.eza      # Better ls

# Optional: Window manager
winget install glzr-io.glazewm
```

### Step 2: Install Iosevka Font

1. Download from: https://github.com/be5invis/Iosevka/releases
2. Extract the ZIP file
3. Select all `.ttf` files → Right-click → Install for all users

### Step 3: Setup Configuration Directories

```powershell
# Create config directories
New-Item -Path "$env:USERPROFILE\.config\alacritty" -ItemType Directory -Force
New-Item -Path "$env:USERPROFILE\.config\kanata" -ItemType Directory -Force
New-Item -Path "$env:USERPROFILE\Documents\PowerShell" -ItemType Directory -Force
```

### Step 4: Clone Dotfiles

```powershell
git clone https://github.com/kishananuraag/dotfiles.git $env:USERPROFILE\.dotfiles
```

### Step 5: Create Symbolic Links

Run PowerShell **as Administrator**:

```powershell
cd $env:USERPROFILE\.dotfiles\windows

# Alacritty
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.config\alacritty\alacritty.toml" -Target ".\alacritty\alacritty.toml" -Force
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.config\alacritty\kanagawa_dragon.toml" -Target ".\alacritty\kanagawa_dragon.toml" -Force
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.config\alacritty\font_iosevka.toml" -Target ".\alacritty\font_iosevka.toml" -Force

# PowerShell
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Target ".\PowerShell\profile.ps1" -Force

# Starship
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.config\starship.toml" -Target ".\starship.toml" -Force
```

### Step 6: Install Neovim Configuration

```powershell
# Clone friend's dotfiles for Neovim config
git clone https://github.com/shivajreddy/dotfiles.git $env:TEMP\friend-dotfiles --depth 1

# Backup existing config (if any)
if (Test-Path "$env:LOCALAPPDATA\nvim") {
    Move-Item "$env:LOCALAPPDATA\nvim" "$env:LOCALAPPDATA\nvim.backup"
}

# Copy Neovim config
Copy-Item -Path "$env:TEMP\friend-dotfiles\common\nvim" -Destination "$env:LOCALAPPDATA\nvim" -Recurse

# Cleanup
Remove-Item $env:TEMP\friend-dotfiles -Recurse -Force
```

## ⚙️ Configuration

### Alacritty Configuration

Location: `~/.config/alacritty/alacritty.toml`

Key settings:
```toml
[window]
opacity = 0.95               # Transparency (1.0 = opaque)
padding = { x = 10, y = 10 } # Internal padding

[font]
size = 12.0                  # Font size

[cursor]
style = { shape = "Block" }  # Cursor shape
```

### PowerShell Profile

Location: `~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1`

Includes:
- Git aliases (gst, gco, gp, etc.)
- Navigation shortcuts (docs, downloads)
- Starship prompt initialization
- zoxide integration

### Starship Prompt

Location: `~/.config/starship.toml`

Features:
- **OS icon** - Shows Windows logo
- **Username** - Current user
- **Directory** - Abbreviated path with icons
- **Git status** - Branch and changes
- **Language versions** - Node, Python, Rust, etc.
- **Time** - Current time
- **Kanagawa Dragon colors** - Consistent theme

## 🎨 Customization

### Change Transparency

Edit `~/.config/alacritty/alacritty.toml`:
```toml
[window]
opacity = 1.0  # 1.0 = fully opaque, 0.0 = fully transparent
```

### Adjust Font Size

Edit `~/.config/alacritty/font_iosevka.toml`:
```toml
[font]
size = 14.0  # Increase for larger text
```

### Change Colors

The Kanagawa Dragon theme is in `~/.config/alacritty/kanagawa_dragon.toml`.

To use a different theme:
1. Browse themes at: https://alacritty-themes.netlify.app/
2. Download theme TOML file
3. Update import in `alacritty.toml`:
   ```toml
   import = ["~/.config/alacritty/your-theme.toml"]
   ```

### Add PowerShell Aliases

Edit `~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1`:
```powershell
# Add your custom aliases
function myfunction { Write-Host "Hello!" }
Set-Alias mf myfunction
```

### Customize Starship Prompt

Edit `~/.config/starship.toml`:
```toml
# Disable time module
[time]
disabled = true

# Change directory truncation
[directory]
truncation_length = 5
```

Full docs: https://starship.rs/config/

## 🐛 Troubleshooting

### Alacritty won't start

**Issue**: Error message or window closes immediately

**Solutions**:
1. Check config syntax:
   ```powershell
   alacritty --config-file ~/.config/alacritty/alacritty.toml
   ```
2. Temporarily rename config to test:
   ```powershell
   Rename-Item ~/.config/alacritty/alacritty.toml alacritty.toml.bak
   ```
3. Check logs: `%APPDATA%\alacritty\alacritty.log`

### Font not displaying correctly

**Issue**: Characters look wrong or boxes appear

**Solutions**:
1. Verify font is installed:
   - Open Settings → Personalization → Fonts
   - Search for "Iosevka"
2. Restart Alacritty after font installation
3. Try different font:
   ```toml
   [font.normal]
   family = "Cascadia Code"  # Built-in Windows font
   ```

### PowerShell profile not loading

**Issue**: Aliases don't work, plain prompt

**Solutions**:
1. Check execution policy:
   ```powershell
   Get-ExecutionPolicy
   # Should be RemoteSigned or Unrestricted
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
2. Verify profile location:
   ```powershell
   $PROFILE
   # Should point to Documents\PowerShell\Microsoft.PowerShell_profile.ps1
   Test-Path $PROFILE  # Should return True
   ```
3. Check for errors:
   ```powershell
   . $PROFILE  # Reload profile manually
   ```

### Starship prompt not showing

**Issue**: Plain `PS>` prompt instead of colorful Starship

**Solutions**:
1. Verify Starship is installed:
   ```powershell
   starship --version
   ```
2. Check profile contains:
   ```powershell
   Invoke-Expression (&starship init powershell)
   ```
3. Reload profile:
   ```powershell
   . $PROFILE
   ```

### Neovim plugins won't install

**Issue**: LazyVim shows errors, plugins missing

**Solutions**:
1. Check internet connection
2. Manually trigger update:
   - Open nvim
   - Press `:Lazy sync`
3. Clear cache and retry:
   ```powershell
   Remove-Item $env:LOCALAPPDATA\nvim-data -Recurse -Force
   nvim  # Will reinstall everything
   ```

### Colors look wrong

**Issue**: Theme colors don't match screenshots

**Solutions**:
1. Ensure terminal is using true color:
   ```powershell
   $env:TERM = "xterm-256color"
   ```
2. Check Alacritty config has:
   ```toml
   [env]
   TERM = "xterm-256color"
   ```
3. Verify theme import in `alacritty.toml`

## ⌨️ Keyboard Shortcuts

### Alacritty Default Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl + Shift + C` | Copy |
| `Ctrl + Shift + V` | Paste |
| `Ctrl + Shift + N` | New window |
| `Ctrl + Shift + =` | Increase font size |
| `Ctrl + -` | Decrease font size |
| `Ctrl + 0` | Reset font size |
| `Alt + Enter` | Toggle fullscreen |

### PowerShell Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl + R` | Search command history (with fzf) |
| `Tab` | Autocomplete |
| `Ctrl + Left/Right` | Move by word |
| `Home/End` | Start/end of line |
| `Ctrl + C` | Cancel command |
| `Ctrl + L` | Clear screen |

### Neovim (LazyVim) Shortcuts

| Shortcut | Action |
|----------|--------|
| `Space` | Leader key (wait for menu) |
| `Space + e` | File explorer |
| `Space + f + f` | Find files |
| `Space + /` | Search in files |
| `Space + w` | Window commands |
| `:q` | Quit |
| `:w` | Save |

Full LazyVim docs: https://www.lazyvim.org/keymaps

### Kanata Remappings (if installed)

| Key | Tap | Hold |
|-----|-----|------|
| `Caps Lock` | Escape | Navigation layer |
| `H` (with Caps) | — | Left arrow |
| `J` (with Caps) | — | Down arrow |
| `K` (with Caps) | — | Up arrow |
| `L` (with Caps) | — | Right arrow |

See `windows/kanata/README.md` for customization.

## 📚 Additional Resources

- **Alacritty**: https://alacritty.org/
- **PowerShell 7**: https://learn.microsoft.com/en-us/powershell/
- **Starship**: https://starship.rs/
- **Neovim**: https://neovim.io/
- **LazyVim**: https://www.lazyvim.org/
- **Kanagawa Theme**: https://github.com/rebelot/kanagawa.nvim
- **Friend's Dotfiles**: https://github.com/shivajreddy/dotfiles
- **Iosevka Font**: https://github.com/be5invis/Iosevka

## 🎉 Next Steps

1. **Learn Neovim**: Open `nvim` and type `:Tutor` for interactive tutorial
2. **Try GlazeWM**: Launch from Start Menu for tiling window management
3. **Setup Kanata**: See `windows/kanata/README.md` for keyboard remapping
4. **Explore CLI tools**:
   - `z <partial-path>` - Jump to directories (zoxide)
   - `fzf` - Fuzzy find files
   - `rg <pattern>` - Fast grep (ripgrep)
   - `bat <file>` - View files with syntax highlighting
   - `eza -l` - Beautiful file listing

Enjoy your beautiful, productive Windows development environment! ✨
