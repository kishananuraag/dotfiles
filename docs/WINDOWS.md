# Windows & WSL Installation Guide

Complete guide for setting up the dotfiles on Windows with WSL (Windows Subsystem for Linux).

## Prerequisites

- **Windows 10 version 2004** (Build 19041) or later, or **Windows 11**
- **Administrator privileges** for initial setup
- **Internet connection** for downloading packages

## Quick Start (Automated)

### Option 1: Automated Bootstrap (Recommended)

The fastest way to get everything set up on a fresh Windows machine:

```powershell
# 1. Download bootstrap script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/kishananuraag/dotfiles/main/bootstrap.ps1" -OutFile "$env:USERPROFILE\Downloads\bootstrap.ps1"

# 2. Open PowerShell as Administrator
# Right-click on PowerShell and select "Run as Administrator"

# 3. Navigate to Downloads and run
cd $env:USERPROFILE\Downloads
Set-ExecutionPolicy Bypass -Scope Process -Force
.\bootstrap.ps1
```

**What the bootstrap script does:**

1. ✅ Checks Windows compatibility
2. ✅ Installs WSL2 with Ubuntu 22.04
3. ✅ Handles Windows restart (if required)
4. ✅ Creates optimal WSL configuration
5. ✅ Installs Windows Terminal (optional)
6. ✅ Sets up dotfiles automatically in WSL
7. ✅ Installs all development tools

**Total time:** 15-20 minutes (including potential restart)

### Option 2: Manual WSL Setup

If you prefer manual control or already have WSL:

#### Step 1: Install WSL

```powershell
# Install WSL2 with Ubuntu 22.04
wsl --install -d Ubuntu-22.04

# Restart if prompted, then continue
```

#### Step 2: Initial Ubuntu Setup

1. Open Ubuntu from Start Menu
2. Create username and password when prompted
3. Update packages:

```bash
sudo apt update && sudo apt upgrade -y
```

#### Step 3: Install Dotfiles

```bash
# Clone dotfiles
git clone https://github.com/kishananuraag/dotfiles.git ~/.dotfiles

# Run installation
cd ~/.dotfiles
./install.sh
```

## What Gets Installed

### Development Environment

**Command Line Tools:**
- Git with enhanced configuration
- Zsh with Oh My Zsh (robbyrussell theme)
- Node.js (via nvm)
- Python 3.11 (via pyenv)
- Docker CLI
- Essential tools: curl, wget, ripgrep, neovim

**Applications** (installed via Homebrew on Linux):
- All development packages from Brewfile.wsl
- Docker and Docker Compose
- Additional CLI utilities

### VS Code Integration

**Automatic Setup:**
- Settings sync (theme, fonts, editor preferences)
- WSL extension (remote development)
- Essential extensions (Docker, GitLens, Prettier, Python)
- WSL as default integrated terminal

**Usage:**
```bash
# Open current directory in VS Code from WSL
code .

# Open specific file
code file.js

# VS Code automatically runs in WSL context
```

## Configuration Details

### WSL Configuration

The installation creates `%USERPROFILE%\.wslconfig`:

```ini
[wsl2]
memory=4GB
processors=2
swap=1GB
localhostForwarding=true

[interop]
enabled=true
appendWindowsPath=true
```

**Benefits:**
- Better memory management
- Faster performance
- Localhost forwarding for web development
- Windows interoperability

### Windows Terminal Setup

**Automatic Configuration:**
- Ubuntu 22.04 as default profile
- Enhanced font rendering (JetBrains Mono)
- Color scheme integration

**Manual Setup** (if Windows Terminal not auto-installed):

1. Install from Microsoft Store: "Windows Terminal"
2. Open Windows Terminal
3. Settings → Default profile → Ubuntu-22.04 (WSL)

### Shell Configuration

**Zsh Features:**
- Oh My Zsh framework with robbyrussell theme
- Auto-suggestions and syntax highlighting
- Git integration with status prompts
- Custom aliases for development workflow
- Docker command shortcuts

**Available Aliases:**
```bash
# File operations
ll, la, l         # Enhanced ls commands

# Git shortcuts  
gs, ga, gc, gp, gl   # status, add, commit, push, log

# Development
dev, build, test     # npm run commands

# Docker
dps, dc, dex         # Docker shortcuts
```

## Development Workflow

### Project Setup

```bash
# Navigate to your project directory
cd /mnt/c/Users/YourName/Projects/MyProject

# Or create projects in WSL filesystem (faster)
mkdir ~/Projects
cd ~/Projects

# Open in VS Code
code .
```

### Git Configuration

**Automatic Setup:**
- User name and email configured
- SSH key template provided
- Enhanced Git aliases and settings

**SSH Setup for GitHub:**
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "kishananuraag@gmail.com"

# Copy public key
cat ~/.ssh/id_ed25519.pub
# Add to GitHub: https://github.com/settings/keys

# Test connection
ssh -T git@github.com
```

### Docker Usage

```bash
# Docker is automatically configured
docker --version
docker-compose --version

# Use helpful aliases
dps              # List containers
dc up            # Docker compose up
dcleanup         # Clean unused containers/images
```

## File System Organization

### Recommended Structure

```
C:\Users\YourName\
├── Projects\              # Windows projects (if needed)
└── .dotfiles\             # This repository

/home/yourusername/
├── .dotfiles\             # Dotfiles repository
├── Projects\              # WSL projects (recommended)
├── .config\               # Configuration files
└── .local\                # Local applications and data
```

**Performance Tip:** Keep active projects in WSL filesystem (`~/Projects`) for better performance.

### File System Access

**From WSL to Windows:**
```bash
cd /mnt/c/Users/YourName    # Access Windows files
code /mnt/c/path/to/file    # Edit Windows files in VS Code
```

**From Windows to WSL:**
- File Explorer: `\\wsl$\Ubuntu-22.04\home\yourusername`
- VS Code: Use WSL extension for remote development

## Troubleshooting

### Common Issues

**1. WSL Installation Fails**

```powershell
# Check Windows version
winver

# Enable required Windows features manually
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Restart and retry WSL installation
```

**2. Ubuntu Won't Start**

```powershell
# Check WSL status
wsl --status

# Restart WSL service
wsl --shutdown
wsl

# If still failing, reinstall Ubuntu
wsl --unregister Ubuntu-22.04
wsl --install -d Ubuntu-22.04
```

**3. VS Code Can't Connect to WSL**

```bash
# Install WSL extension in VS Code
code --install-extension ms-vscode-remote.remote-wsl

# Restart VS Code and try again
```

**4. Docker Issues in WSL**

```bash
# Check if Docker service is running (on Windows)
# WSL uses Docker Desktop for Windows

# If using Docker in WSL without Desktop:
sudo service docker start

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

**5. Slow File Operations**

- **Problem:** Files on Windows filesystem (`/mnt/c/`) are slow
- **Solution:** Move projects to WSL filesystem (`~/Projects`)

```bash
# Move project to WSL filesystem
cp -r /mnt/c/Users/YourName/Projects/myproject ~/Projects/
cd ~/Projects/myproject
```

**6. Permission Issues**

```bash
# Fix common permission problems
sudo chown -R $USER:$USER ~/.dotfiles
chmod 755 ~/.dotfiles/scripts/*.sh
```

**7. Network Issues in WSL**

```bash
# Reset network configuration
sudo rm /etc/resolv.conf
sudo rm /etc/wsl.conf
wsl --shutdown
# Restart WSL
```

### Advanced Troubleshooting

**Check WSL Version:**
```bash
wsl -l -v
# Should show VERSION 2
```

**WSL Logs:**
```bash
# View WSL logs
dmesg | grep -i error

# Windows Event Viewer:
# Windows Logs > Application > Filter by "WSL"
```

**Reset WSL if Needed:**
```powershell
# Nuclear option - completely reset WSL
wsl --shutdown
wsl --unregister Ubuntu-22.04
wsl --install -d Ubuntu-22.04
# Then re-run dotfiles installation
```

## Performance Tips

### Optimization

1. **Store Projects in WSL:** Use `~/Projects` instead of `/mnt/c/`
2. **Exclude from Windows Defender:** Add WSL directories to exclusions
3. **Use WSL 2:** Ensure you're using WSL 2 (not WSL 1)
4. **Allocate Adequate Memory:** Adjust `.wslconfig` as needed

### Memory Management

**Monitor Usage:**
```bash
# WSL memory usage
htop

# Windows Task Manager shows WSL memory under "Vmmem"
```

**Optimize .wslconfig:**
```ini
[wsl2]
memory=6GB                    # Increase if you have >8GB RAM
processors=4                  # Use more CPU cores
swap=2GB                      # Increase swap
localhostForwarding=true
```

## Additional Resources

- [Microsoft WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [VS Code WSL Guide](https://code.visualstudio.com/docs/remote/wsl)
- [Windows Terminal Documentation](https://docs.microsoft.com/en-us/windows/terminal/)
- [Docker Desktop for Windows](https://docs.docker.com/desktop/windows/)

## Support

If you encounter issues not covered here:

1. Check [Troubleshooting Guide](TROUBLESHOOTING.md)
2. Review WSL logs and error messages
3. Search existing GitHub issues
4. Create a new issue with detailed error information

## Next Steps

After successful installation:

1. **Explore the shell:** Try the aliases and functions
2. **Set up SSH keys:** Follow the [SSH Guide](../ssh/README.md)
3. **Create your first project:** Use the development workflow
4. **Customize:** Edit configs to match your preferences
5. **Update regularly:** `cd ~/.dotfiles && git pull && ./install.sh`