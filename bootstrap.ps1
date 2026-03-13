# Enhanced Bootstrap Script for Fresh Windows Setup
# Automatically installs WSL2, Ubuntu, and configures dotfiles

param(
    [switch]$Force
)

# Colors for output
$Green = "`e[32m"
$Yellow = "`e[33m"
$Red = "`e[31m"
$Blue = "`e[34m"
$Reset = "`e[0m"

function Write-ColorOutput {
    param($Message, $Color = $Reset)
    Write-Host "$Color$Message$Reset"
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-WSLInstalled {
    try {
        $wslOutput = wsl --list 2>$null
        return $LASTEXITCODE -eq 0
    } catch {
        return $false
    }
}

function Test-WindowsVersion {
    $version = [System.Environment]::OSVersion.Version
    # Windows 10 v2004 (build 19041) or Windows 11 required for WSL2
    return $version.Build -ge 19041
}

function Install-WSL {
    Write-ColorOutput "Installing WSL2 with Ubuntu 22.04..." $Blue
    
    try {
        # Install WSL with Ubuntu 22.04
        wsl --install -d Ubuntu-22.04
        
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "✅ WSL2 installation initiated successfully!" $Green
            return $true
        } else {
            Write-ColorOutput "❌ WSL installation failed with exit code: $LASTEXITCODE" $Red
            return $false
        }
    } catch {
        Write-ColorOutput "❌ Error during WSL installation: $_" $Red
        return $false
    }
}

function Test-RestartRequired {
    # Check if a restart is pending
    $restartRequired = $false
    
    # Check Windows Update reboot flag
    if (Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue) {
        $restartRequired = $true
    }
    
    # Check pending file rename operations
    if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -ErrorAction SilentlyContinue) {
        $restartRequired = $true
    }
    
    return $restartRequired
}

function Install-WindowsTerminal {
    Write-ColorOutput "Checking Windows Terminal..." $Blue
    
    try {
        $terminal = Get-AppxPackage -Name Microsoft.WindowsTerminal -ErrorAction SilentlyContinue
        if (-not $terminal) {
            Write-ColorOutput "Installing Windows Terminal via winget..." $Yellow
            winget install --id Microsoft.WindowsTerminal -e --source winget --accept-package-agreements --accept-source-agreements
            
            if ($LASTEXITCODE -eq 0) {
                Write-ColorOutput "✅ Windows Terminal installed successfully!" $Green
            } else {
                Write-ColorOutput "⚠️  Windows Terminal installation failed, but continuing..." $Yellow
            }
        } else {
            Write-ColorOutput "✅ Windows Terminal already installed" $Green
        }
    } catch {
        Write-ColorOutput "⚠️  Could not install Windows Terminal: $_" $Yellow
    }
}

function Create-WSLConfig {
    $wslConfigPath = "$env:USERPROFILE\.wslconfig"
    
    if (-not (Test-Path $wslConfigPath)) {
        Write-ColorOutput "Creating .wslconfig for optimal performance..." $Blue
        
        $wslConfigContent = @"
[wsl2]
memory=4GB
processors=2
swap=1GB
localhostForwarding=true

[interop]
enabled=true
appendWindowsPath=true
"@
        
        Set-Content -Path $wslConfigPath -Value $wslConfigContent -Encoding UTF8
        Write-ColorOutput "✅ .wslconfig created at $wslConfigPath" $Green
    } else {
        Write-ColorOutput "✅ .wslconfig already exists" $Green
    }
}

function Install-DotfilesInWSL {
    Write-ColorOutput "Setting up dotfiles in WSL..." $Blue
    
    $wslCommands = @(
        "cd ~",
        "sudo apt update && sudo apt install -y git curl wget",
        "git clone https://github.com/kishananuraag/dotfiles.git ~/.dotfiles || (cd ~/.dotfiles && git pull)",
        "cd ~/.dotfiles",
        "chmod +x install.sh",
        "./install.sh"
    )
    
    $commandString = $wslCommands -join " && "
    
    try {
        wsl -d Ubuntu-22.04 -- bash -c $commandString
        
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "✅ Dotfiles setup completed successfully!" $Green
            return $true
        } else {
            Write-ColorOutput "❌ Dotfiles setup failed with exit code: $LASTEXITCODE" $Red
            return $false
        }
    } catch {
        Write-ColorOutput "❌ Error during dotfiles setup: $_" $Red
        return $false
    }
}

# Main execution
Clear-Host
Write-ColorOutput @"
╔══════════════════════════════════════════════════════════════════╗
║                    Windows Dotfiles Bootstrap                   ║
║              Automated WSL2 + Ubuntu + Dotfiles Setup           ║
╚══════════════════════════════════════════════════════════════════╝
"@ $Blue

# Check if running as administrator
if (-not (Test-Administrator)) {
    Write-ColorOutput "❌ This script must be run as Administrator!" $Red
    Write-ColorOutput "Right-click PowerShell and select 'Run as Administrator'" $Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Check Windows version
if (-not (Test-WindowsVersion)) {
    Write-ColorOutput "❌ Windows 10 v2004+ or Windows 11 is required for WSL2!" $Red
    Write-ColorOutput "Please update Windows and try again." $Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-ColorOutput "✅ Running as Administrator" $Green
Write-ColorOutput "✅ Windows version is compatible" $Green

# Check if WSL is already installed
if (Test-WSLInstalled) {
    Write-ColorOutput "✅ WSL is already installed" $Green
    
    # Check if Ubuntu is available
    $ubuntuInstalled = wsl --list --quiet | Select-String "Ubuntu-22.04"
    
    if ($ubuntuInstalled) {
        Write-ColorOutput "✅ Ubuntu 22.04 is available" $Green
        
        # Setup dotfiles in existing WSL
        Create-WSLConfig
        Install-WindowsTerminal
        
        Write-ColorOutput "Setting up dotfiles in existing WSL..." $Blue
        if (Install-DotfilesInWSL) {
            Write-ColorOutput @"

╔══════════════════════════════════════════════════════════════════╗
║                        🎉 SETUP COMPLETE! 🎉                     ║
╠══════════════════════════════════════════════════════════════════╣
║  Your dotfiles have been successfully configured in WSL!        ║
║                                                                  ║
║  Next steps:                                                     ║
║  1. Open Ubuntu from Start Menu or Windows Terminal             ║
║  2. Everything is configured and ready to use!                  ║
║  3. Try: 'code .' to open VS Code from WSL                      ║
║                                                                  ║
║  Documentation: ~/.dotfiles/docs/WINDOWS.md                     ║
╚══════════════════════════════════════════════════════════════════╝
"@ $Green
        }
    } else {
        Write-ColorOutput "⚠️  WSL is installed but Ubuntu 22.04 is not available" $Yellow
        Write-ColorOutput "Installing Ubuntu 22.04..." $Blue
        wsl --install -d Ubuntu-22.04
    }
} else {
    # Fresh WSL installation
    Write-ColorOutput "Installing WSL2 and Ubuntu 22.04..." $Blue
    
    if (Install-WSL) {
        Create-WSLConfig
        Install-WindowsTerminal
        
        # Check if restart is required
        if (Test-RestartRequired) {
            Write-ColorOutput @"

╔══════════════════════════════════════════════════════════════════╗
║                     ⚠️  RESTART REQUIRED ⚠️                      ║
╠══════════════════════════════════════════════════════════════════╣
║  WSL2 installation requires a system restart.                   ║
║                                                                  ║
║  After restart:                                                  ║
║  1. Run this script again: .\bootstrap.ps1                      ║
║  2. Complete the Ubuntu setup (username/password)               ║
║  3. Dotfiles will be configured automatically                   ║
╚══════════════════════════════════════════════════════════════════╝
"@ $Yellow
            
            $restart = Read-Host "Restart now? (y/N)"
            if ($restart -eq 'y' -or $restart -eq 'Y') {
                Restart-Computer -Force
            }
        } else {
            Write-ColorOutput "✅ No restart required, continuing setup..." $Green
            Start-Sleep -Seconds 3
            
            # Wait for WSL to be ready and then setup dotfiles
            Write-ColorOutput "Waiting for WSL to initialize..." $Blue
            Start-Sleep -Seconds 10
            
            if (Install-DotfilesInWSL) {
                Write-ColorOutput @"

╔══════════════════════════════════════════════════════════════════╗
║                        🎉 SETUP COMPLETE! 🎉                     ║
╠══════════════════════════════════════════════════════════════════╣
║  Windows WSL2 + Ubuntu + Dotfiles installation successful!      ║
║                                                                  ║
║  Next steps:                                                     ║
║  1. Open Ubuntu from Start Menu or Windows Terminal             ║
║  2. Set up your Ubuntu username and password (first time)       ║
║  3. Everything else is already configured!                      ║
║                                                                  ║
║  Try these commands in Ubuntu:                                   ║
║  - 'code .' (opens VS Code from WSL)                            ║
║  - 'docker --version' (Docker CLI)                              ║
║  - 'node --version' (Node.js)                                   ║
║                                                                  ║
║  Documentation: ~/.dotfiles/docs/WINDOWS.md                     ║
╚══════════════════════════════════════════════════════════════════╝
"@ $Green
            }
        }
    }
}

Write-ColorOutput "`nBootstrap script completed." $Blue
Read-Host "Press Enter to exit"