# Troubleshooting Guide

Common issues and solutions for the dotfiles installation and usage across different platforms.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Git & GitHub Issues](#git--github-issues)  
- [Shell Configuration Issues](#shell-configuration-issues)
- [VS Code Issues](#vs-code-issues)
- [WSL-Specific Issues](#wsl-specific-issues)
- [macOS-Specific Issues](#macos-specific-issues)
- [Docker Issues](#docker-issues)
- [Performance Issues](#performance-issues)
- [Network & Connectivity](#network--connectivity)

## Installation Issues

### Script Won't Execute

**Error:** `Permission denied` when running `./install.sh`

**Solution:**
```bash
# Make script executable
chmod +x ~/.dotfiles/install.sh

# Or run with bash directly
bash ~/.dotfiles/install.sh
```

### Partial Installation

**Error:** Installation stops partway through

**Diagnosis:**
```bash
# Check what failed
cd ~/.dotfiles
bash -x ./install.sh

# Check logs
tail -f /var/log/system.log  # macOS
journalctl -f               # Linux
```

**Solutions:**
```bash
# Clean up and retry
cd ~/.dotfiles
git clean -fd
git reset --hard HEAD
./install.sh

# Or run specific parts
source ~/.dotfiles/install.sh
install_homebrew
install_oh_my_zsh
```

### Symlink Creation Fails

**Error:** `ln: failed to create symbolic link`

**Diagnosis:**
```bash
# Check existing files
ls -la ~/.zshrc ~/.gitconfig ~/.aliases

# Check permissions
ls -la ~/.dotfiles/
```

**Solution:**
```bash
# Backup and remove existing files
mv ~/.zshrc ~/.zshrc.backup
mv ~/.gitconfig ~/.gitconfig.backup
mv ~/.aliases ~/.aliases.backup

# Re-run installation
cd ~/.dotfiles && ./install.sh
```

### Dependencies Missing

**Error:** `command not found: git` or similar

**macOS Solution:**
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Accept license
sudo xcodebuild -license accept
```

**Linux/WSL Solution:**
```bash
# Update package manager and install essentials
sudo apt update
sudo apt install -y git curl wget build-essential

# Or for other distros
sudo yum install git curl wget  # CentOS/RHEL
sudo pacman -S git curl wget    # Arch Linux
```

## Git & GitHub Issues

### Authentication Failures

**Error:** `Permission denied (publickey)` or `Authentication failed`

**For SSH Keys:**
```bash
# Check if SSH key exists
ls -la ~/.ssh/

# Generate new key if needed
ssh-keygen -t ed25519 -C "kishananuraag@gmail.com"

# Add to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Test connection
ssh -T git@github.com
```

**For HTTPS/Token:**
```bash
# Check credential helper
git config --global credential.helper

# Set credential helper
git config --global credential.helper osxkeychain  # macOS
git config --global credential.helper store        # Linux

# Clear stored credentials
git config --global --unset credential.helper
# Then re-authenticate with new token
```

### Wrong Git User Information

**Error:** Commits showing wrong author

**Solution:**
```bash
# Check current config
git config --list | grep user

# Set correct information
git config --global user.name "Kishan"
git config --global user.email "kishananuraag@gmail.com"

# Fix last commit if needed
git commit --amend --reset-author
```

### Remote URL Issues

**Error:** `fatal: remote origin already exists`

**Solution:**
```bash
# Check current remotes
git remote -v

# Update remote URL
git remote set-url origin https://github.com/kishananuraag/dotfiles.git
# Or for SSH:
git remote set-url origin git@github.com:kishananuraag/dotfiles.git

# Or remove and re-add
git remote remove origin
git remote add origin https://github.com/kishananuraag/dotfiles.git
```

## Shell Configuration Issues

### Zsh Not Loading

**Error:** Still using bash instead of zsh

**Solution:**
```bash
# Check current shell
echo $SHELL

# Check available shells
cat /etc/shells

# Change default shell
chsh -s $(which zsh)

# Or set zsh in terminal preferences
# Terminal.app: Preferences > Profiles > Shell > Command: /bin/zsh
```

### Oh My Zsh Issues

**Error:** `command not found: omz`

**Solution:**
```bash
# Check Oh My Zsh installation
ls -la ~/.oh-my-zsh/

# Reinstall if missing
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Or manual installation
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
```

### Plugin Errors

**Error:** `plugin 'xxx' not found`

**Solution:**
```bash
# Install missing plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Or disable problematic plugins temporarily
vim ~/.dotfiles/zshrc
# Comment out plugins that fail
```

### Aliases Not Working

**Error:** `command not found` for custom aliases

**Diagnosis:**
```bash
# Check if aliases file is sourced
grep "aliases" ~/.zshrc

# Check aliases file exists and is readable
ls -la ~/.dotfiles/aliases
cat ~/.dotfiles/aliases
```

**Solution:**
```bash
# Re-source configuration
source ~/.zshrc

# Or manually source aliases
source ~/.dotfiles/aliases

# Check symlink
ls -la ~/.aliases
```

### Slow Shell Startup

**Error:** Terminal takes long time to start

**Diagnosis:**
```bash
# Time the startup
time zsh -i -c exit

# Profile startup (add to .zshrc temporarily)
zmodload zsh/zprof
# ... rest of .zshrc ...
zprof
```

**Solution:**
```bash
# Common culprits and fixes:

# 1. Slow nvm loading
echo 'export NVM_LAZY_LOAD=true' >> ~/.zshrc

# 2. Too many Oh My Zsh plugins
vim ~/.dotfiles/zshrc
# Reduce plugins list

# 3. Network timeouts
# Check for network calls in shell config

# 4. Large history file
echo 'export HISTSIZE=1000' >> ~/.zshrc
echo 'export SAVEHIST=1000' >> ~/.zshrc
```

## VS Code Issues

### Code Command Not Found

**Error:** `command not found: code`

**macOS Solution:**
```bash
# Install code command via VS Code
# 1. Open VS Code
# 2. Cmd+Shift+P
# 3. Type "shell command"
# 4. Select "Install 'code' command in PATH"

# Or add to PATH manually
echo 'export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"' >> ~/.zshrc
```

**WSL Solution:**
```bash
# VS Code should be installed on Windows with WSL extension
# The 'code' command should work automatically in WSL

# If not working, reinstall WSL extension
code --install-extension ms-vscode-remote.remote-wsl
```

**Linux Solution:**
```bash
# Install VS Code via package manager or snap
sudo snap install --classic code

# Or download .deb package
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install code
```

### Extensions Won't Install

**Error:** Extension installation fails

**Solution:**
```bash
# Check VS Code version
code --version

# Try installing extensions manually
code --install-extension catppuccin.catppuccin-vsc

# Check extensions log
# View > Output > Log (Window) > Extension Host

# Clear extension cache
rm -rf ~/.vscode/extensions
# Then reinstall extensions
~/.dotfiles/scripts/install-vscode-extensions.sh
```

### Settings Not Syncing

**Error:** VS Code settings not applied

**Diagnosis:**
```bash
# Check VS Code settings location
# macOS: ~/Library/Application Support/Code/User/
# Linux: ~/.config/Code/User/
# Windows: %APPDATA%\Code\User\

# Check symlinks
ls -la ~/Library/Application\ Support/Code/User/  # macOS
ls -la ~/.config/Code/User/                       # Linux
```

**Solution:**
```bash
# Recreate symlinks
rm ~/Library/Application\ Support/Code/User/settings.json    # macOS
ln -sf ~/.dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json

# Linux
rm ~/.config/Code/User/settings.json
ln -sf ~/.dotfiles/vscode/settings.json ~/.config/Code/User/settings.json
```

### WSL Integration Issues

**Error:** VS Code can't connect to WSL

**Solution:**
```bash
# Install/reinstall WSL extension
code --install-extension ms-vscode-remote.remote-wsl

# Check WSL status
wsl --status

# Restart WSL
wsl --shutdown
wsl

# Open VS Code from WSL
cd ~/
code .
```

## WSL-Specific Issues

### WSL Won't Install

**Error:** WSL installation fails on Windows

**Solution:**
```powershell
# Check Windows version (need 2004+ or Windows 11)
winver

# Enable WSL feature manually
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Restart Windows and retry
wsl --install -d Ubuntu-22.04

# Download WSL kernel update if needed
# https://aka.ms/wsl2kernel
```

### Ubuntu Won't Start

**Error:** `WslRegisterDistribution failed with error: 0x8007019e`

**Solution:**
```powershell
# Enable Virtual Machine Platform
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Restart Windows

# Download and install WSL2 kernel update
# https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi

# Set WSL2 as default
wsl --set-default-version 2
```

### File Permission Issues

**Error:** Permission denied in WSL

**Solution:**
```bash
# Fix common permission issues
sudo chown -R $USER:$USER ~/.dotfiles
sudo chown -R $USER:$USER ~/.oh-my-zsh

# Fix SSH permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
```

### Slow File Operations

**Error:** File operations are very slow

**Solution:**
```bash
# Move files to WSL filesystem (not /mnt/c/)
cp -r /mnt/c/Users/YourName/Projects/myproject ~/Projects/

# Work in WSL filesystem
cd ~/Projects

# Avoid cross-filesystem operations
# Windows Defender exclusions for WSL directories
```

### Network Issues in WSL

**Error:** Can't connect to internet from WSL

**Solution:**
```bash
# Check DNS resolution
nslookup google.com

# Fix DNS if broken
sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
sudo bash -c 'echo "nameserver 8.8.4.4" >> /etc/resolv.conf'

# Or set custom DNS in .wslconfig
# Windows: %USERPROFILE%\.wslconfig
[wsl2]
dns=8.8.8.8
```

## macOS-Specific Issues

### Homebrew Issues

**Error:** `brew: command not found`

**Solution:**
```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add to PATH (for M1/M2 Macs)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
eval "$(/opt/homebrew/bin/brew shellenv)"

# For Intel Macs
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
```

**Error:** Homebrew installation fails

**Solution:**
```bash
# Install Xcode Command Line Tools first
xcode-select --install

# Accept Xcode license
sudo xcodebuild -license accept

# Clear Homebrew cache and retry
rm -rf ~/Library/Caches/Homebrew/
```

### Font Installation Issues

**Error:** Programming fonts not working

**Solution:**
```bash
# Check if fonts are installed
ls -la ~/Library/Fonts/ | grep -i jetbrains

# Reinstall fonts via Homebrew
brew uninstall font-jetbrains-mono font-source-code-pro
brew install font-jetbrains-mono font-source-code-pro

# Or install manually from websites:
# https://www.jetbrains.com/mono/
# https://adobe-fonts.github.io/source-code-pro/
```

### Gatekeeper Issues

**Error:** "Cannot be opened because the developer cannot be verified"

**Solution:**
```bash
# For specific applications (if needed)
sudo xattr -rd com.apple.quarantine /Applications/SomeApp.app

# Or allow in System Preferences
# System Preferences > Security & Privacy > General
# Click "Open Anyway" for blocked app
```

## Docker Issues

### Docker Command Not Found

**Error:** `docker: command not found`

**macOS Solution:**
```bash
# Install Docker Desktop via Homebrew
brew install --cask docker

# Or download from Docker website
# https://docs.docker.com/desktop/mac/install/

# Start Docker Desktop from Applications
```

**WSL Solution:**
```bash
# Option 1: Use Docker Desktop for Windows with WSL integration
# Install Docker Desktop on Windows
# Enable WSL integration in Docker Desktop settings

# Option 2: Install Docker in WSL (without Desktop)
sudo apt update
sudo apt install docker.io
sudo systemctl start docker
sudo usermod -aG docker $USER
newgrp docker
```

### Docker Permission Issues

**Error:** `permission denied while trying to connect to Docker daemon`

**Solution:**
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Apply group membership
newgrp docker

# Or restart terminal/system

# Test Docker access
docker run hello-world
```

### Docker Compose Issues

**Error:** `docker-compose: command not found`

**Solution:**
```bash
# Install via Homebrew
brew install docker-compose

# Or install via pip
pip3 install docker-compose

# Or download binary (Linux)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## Performance Issues

### Slow Terminal Startup

**Diagnosis:**
```bash
# Profile zsh startup
zsh -xvs

# Time specific operations
time source ~/.zshrc
```

**Solutions:**
```bash
# 1. Lazy-load NVM
export NVM_LAZY_LOAD=true

# 2. Reduce Oh My Zsh plugins
# Edit ~/.dotfiles/zshrc, remove unused plugins

# 3. Cache expensive operations
# Use ~/.zshrc.local for machine-specific optimizations

# 4. Disable auto-update checks
export DISABLE_AUTO_UPDATE=true
```

### Slow Git Operations

**Solutions:**
```bash
# Enable Git FSMonitor
git config core.fsmonitor true

# Increase Git buffer sizes
git config http.postBuffer 524288000
git config pack.packSizeLimit 2g

# Use SSH instead of HTTPS for large repos
git remote set-url origin git@github.com:kishananuraag/dotfiles.git
```

### High Memory Usage

**Diagnosis:**
```bash
# Check memory usage
htop
ps aux --sort=-%mem | head

# WSL-specific
# Check Windows Task Manager for "Vmmem"
```

**Solutions:**
```bash
# WSL: Limit memory in .wslconfig
[wsl2]
memory=4GB
swap=1GB

# macOS: Check for runaway processes
# Activity Monitor > CPU/Memory tabs

# General: Clear caches
# Homebrew
brew cleanup

# npm
npm cache clean --force

# Docker
docker system prune -f
```

## Network & Connectivity

### DNS Issues

**Symptoms:** Can't resolve domain names

**Solution:**
```bash
# Test DNS resolution
nslookup google.com

# WSL: Fix DNS
sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'

# macOS: Flush DNS cache
sudo dscacheutil -flushcache

# Check network connectivity
ping -c 4 8.8.8.8
```

### Firewall/Proxy Issues

**Corporate Networks:**
```bash
# Configure Git for proxy
git config --global http.proxy http://proxy.company.com:8080
git config --global https.proxy https://proxy.company.com:8080

# Configure npm for proxy
npm config set proxy http://proxy.company.com:8080
npm config set https-proxy https://proxy.company.com:8080

# Configure Homebrew
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=https://proxy.company.com:8080
```

### SSL Certificate Issues

**Error:** `SSL certificate problem`

**Solution:**
```bash
# Temporary workaround (not recommended for production)
git config --global http.sslverify false

# Better: Update certificates
# macOS
brew install ca-certificates

# Linux
sudo apt update && sudo apt install ca-certificates

# WSL: Copy certificates from Windows
sudo apt install ca-certificates
```

## Getting Help

### Diagnostic Information

When reporting issues, include:

```bash
# System information
uname -a

# Shell information
echo $SHELL
$SHELL --version

# Git information
git --version
git config --list

# VS Code information
code --version

# Homebrew information (macOS)
brew --version
brew doctor

# WSL information (Windows)
wsl --status
wsl -l -v
```

### Reset Everything

**Nuclear option** if nothing works:

```bash
# Backup any local changes first
cd ~/.dotfiles
git stash

# Remove installed configurations
rm ~/.zshrc ~/.gitconfig ~/.aliases

# Remove Oh My Zsh
rm -rf ~/.oh-my-zsh

# Re-clone repository
cd ~
rm -rf ~/.dotfiles
git clone https://github.com/kishananuraag/dotfiles.git ~/.dotfiles

# Fresh installation
cd ~/.dotfiles
./install.sh
```

### Community Support

- **GitHub Issues:** Create an issue with detailed error information
- **Discussions:** Use GitHub Discussions for general questions
- **Documentation:** Check all docs/ files for platform-specific guides

Remember to include error messages, system information, and steps to reproduce when seeking help!