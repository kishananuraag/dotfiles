#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Windows Dotfiles Installation Script - Alacritty Development Environment
.DESCRIPTION
    Automated installation and configuration of Windows-native development environment
    including Alacritty, PowerShell 7, Starship, Neovim, Kanata, and GlazeWM.
    
    Based on shivajreddy's dotfiles configuration with Kanagawa Dragon theme.
.NOTES
    Author: Anurag Kishan
    Requires: Windows 10/11, Administrator privileges
    Theme: Kanagawa Dragon (dark blue/purple)
    Font: Iosevka (programmer font with ligatures)
#>

[CmdletBinding()]
param(
    [switch]$SkipPackages,
    [switch]$SkipSymlinks,
    [switch]$SkipNeovim,
    [switch]$SkipKanata
)

# ============================================================================
# CONFIGURATION
# ============================================================================

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# Paths
$DotfilesRoot = Split-Path -Parent $PSScriptRoot
$WindowsRoot = Join-Path $DotfilesRoot "windows"
$ConfigRoot = Join-Path $env:USERPROFILE ".config"

# Color output
function Write-Step { 
    param([string]$Message)
    Write-Host "`n[*] $Message" -ForegroundColor Cyan 
}

function Write-Success { 
    param([string]$Message)
    Write-Host "[✓] $Message" -ForegroundColor Green 
}

function Write-Warning { 
    param([string]$Message)
    Write-Host "[!] $Message" -ForegroundColor Yellow 
}

function Write-Fail { 
    param([string]$Message)
    Write-Host "[✗] $Message" -ForegroundColor Red 
}

# ============================================================================
# PREREQUISITE CHECKS
# ============================================================================

Write-Step "Checking prerequisites..."

# Check if running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Fail "This script must be run as Administrator"
    Write-Host "Right-click PowerShell and select 'Run as Administrator'"
    exit 1
}

Write-Success "Running as Administrator"

# Check if winget is installed
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Fail "winget is not installed"
    Write-Host "Please install App Installer from Microsoft Store or update Windows"
    exit 1
}

Write-Success "winget is available"

# ============================================================================
# PACKAGE INSTALLATION
# ============================================================================

if (-not $SkipPackages) {
    Write-Step "Installing packages via winget..."

    $packages = @(
        @{ Name = "Alacritty.Alacritty"; DisplayName = "Alacritty Terminal" }
        @{ Name = "Microsoft.PowerShell"; DisplayName = "PowerShell 7" }
        @{ Name = "Starship.Starship"; DisplayName = "Starship Prompt" }
        @{ Name = "Neovim.Neovim"; DisplayName = "Neovim" }
        @{ Name = "Git.Git"; DisplayName = "Git" }
        @{ Name = "ajeetdsouza.zoxide"; DisplayName = "zoxide (smart cd)" }
        @{ Name = "junegunn.fzf"; DisplayName = "fzf (fuzzy finder)" }
        @{ Name = "BurntSushi.ripgrep.MSVC"; DisplayName = "ripgrep (fast grep)" }
        @{ Name = "sharkdp.bat"; DisplayName = "bat (better cat)" }
        @{ Name = "eza-community.eza"; DisplayName = "eza (better ls)" }
        @{ Name = "glzr-io.glazewm"; DisplayName = "GlazeWM (tiling window manager)" }
    )

    foreach ($pkg in $packages) {
        Write-Host "  Installing $($pkg.DisplayName)..." -ForegroundColor Yellow
        try {
            winget install --id $pkg.Name --silent --accept-package-agreements --accept-source-agreements
            Write-Success "$($pkg.DisplayName) installed"
        }
        catch {
            Write-Warning "Failed to install $($pkg.DisplayName): $_"
        }
    }

    # Install Iosevka font
    Write-Step "Installing Iosevka font..."
    
    $fontUrl = "https://github.com/be5invis/Iosevka/releases/download/v32.3.1/PkgTTF-Iosevka-32.3.1.zip"
    $fontZip = Join-Path $env:TEMP "Iosevka.zip"
    $fontExtract = Join-Path $env:TEMP "Iosevka"
    
    try {
        Write-Host "  Downloading Iosevka font..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $fontUrl -OutFile $fontZip -UseBasicParsing
        
        Write-Host "  Extracting fonts..." -ForegroundColor Yellow
        Expand-Archive -Path $fontZip -DestinationPath $fontExtract -Force
        
        Write-Host "  Installing fonts..." -ForegroundColor Yellow
        $fonts = Get-ChildItem -Path $fontExtract -Filter "*.ttf" -Recurse
        $fontsFolder = (New-Object -ComObject Shell.Application).Namespace(0x14)
        
        foreach ($font in $fonts) {
            $fontsFolder.CopyHere($font.FullName)
        }
        
        Write-Success "Iosevka font installed"
        
        # Cleanup
        Remove-Item $fontZip -Force -ErrorAction SilentlyContinue
        Remove-Item $fontExtract -Recurse -Force -ErrorAction SilentlyContinue
    }
    catch {
        Write-Warning "Failed to install Iosevka font: $_"
        Write-Host "  You can manually install from: https://github.com/be5invis/Iosevka/releases"
    }

} else {
    Write-Warning "Skipping package installation (--SkipPackages)"
}

# ============================================================================
# CREATE DIRECTORY STRUCTURE
# ============================================================================

Write-Step "Creating directory structure..."

$directories = @(
    $ConfigRoot
    (Join-Path $ConfigRoot "alacritty")
    (Join-Path $ConfigRoot "kanata")
    (Join-Path $env:USERPROFILE "Documents\PowerShell")
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -Path $dir -ItemType Directory -Force | Out-Null
        Write-Success "Created: $dir"
    } else {
        Write-Host "  Exists: $dir" -ForegroundColor DarkGray
    }
}

# ============================================================================
# CREATE SYMLINKS
# ============================================================================

if (-not $SkipSymlinks) {
    Write-Step "Creating symbolic links..."

    function New-Symlink {
        param(
            [string]$Source,
            [string]$Target
        )
        
        if (Test-Path $Target) {
            Write-Warning "Target already exists: $Target"
            $response = Read-Host "  Overwrite? (y/N)"
            if ($response -ne 'y') {
                Write-Host "  Skipped: $Target" -ForegroundColor DarkGray
                return
            }
            Remove-Item $Target -Recurse -Force
        }
        
        try {
            New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force | Out-Null
            Write-Success "Linked: $Target -> $Source"
        }
        catch {
            Write-Fail "Failed to create symlink: $_"
        }
    }

    # Alacritty configuration
    New-Symlink `
        -Source (Join-Path $WindowsRoot "alacritty\alacritty.toml") `
        -Target (Join-Path $ConfigRoot "alacritty\alacritty.toml")
    
    New-Symlink `
        -Source (Join-Path $WindowsRoot "alacritty\kanagawa_dragon.toml") `
        -Target (Join-Path $ConfigRoot "alacritty\kanagawa_dragon.toml")
    
    New-Symlink `
        -Source (Join-Path $WindowsRoot "alacritty\font_iosevka.toml") `
        -Target (Join-Path $ConfigRoot "alacritty\font_iosevka.toml")

    # PowerShell profile
    New-Symlink `
        -Source (Join-Path $WindowsRoot "PowerShell\profile.ps1") `
        -Target "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

    # Starship configuration
    New-Symlink `
        -Source (Join-Path $WindowsRoot "starship.toml") `
        -Target (Join-Path $ConfigRoot "starship.toml")

    # GlazeWM configuration (if exists)
    $glazeConfig = Join-Path $WindowsRoot "glaze.yaml"
    if (Test-Path $glazeConfig) {
        New-Symlink `
            -Source $glazeConfig `
            -Target (Join-Path $ConfigRoot "glazewm\config.yaml")
    }

    # Kanata configuration
    if (-not $SkipKanata) {
        New-Symlink `
            -Source (Join-Path $WindowsRoot "kanata\kanata-aula-f75.kbd") `
            -Target (Join-Path $ConfigRoot "kanata\kanata-aula-f75.kbd")
    }

} else {
    Write-Warning "Skipping symlink creation (--SkipSymlinks)"
}

# ============================================================================
# NEOVIM SETUP
# ============================================================================

if (-not $SkipNeovim) {
    Write-Step "Setting up Neovim with LazyVim..."

    $nvimConfig = Join-Path $env:LOCALAPPDATA "nvim"
    
    $response = Read-Host "Install LazyVim configuration from friend's dotfiles? (y/N)"
    if ($response -eq 'y') {
        $tempDotfiles = Join-Path $env:TEMP "friend-dotfiles"
        
        try {
            Write-Host "  Cloning friend's dotfiles..." -ForegroundColor Yellow
            git clone https://github.com/shivajreddy/dotfiles.git $tempDotfiles --depth 1
            
            if (Test-Path $nvimConfig) {
                Write-Warning "Neovim config already exists"
                $backup = "${nvimConfig}.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
                Move-Item $nvimConfig $backup
                Write-Success "Backed up to: $backup"
            }
            
            Write-Host "  Copying nvim configuration..." -ForegroundColor Yellow
            Copy-Item -Path (Join-Path $tempDotfiles "common\nvim") -Destination $nvimConfig -Recurse
            
            Write-Success "LazyVim configuration installed"
            Write-Host "  Launch nvim to install plugins automatically"
            
            # Cleanup
            Remove-Item $tempDotfiles -Recurse -Force -ErrorAction SilentlyContinue
        }
        catch {
            Write-Fail "Failed to setup Neovim: $_"
            Write-Host "  See windows/nvim/README.md for manual setup"
        }
    } else {
        Write-Host "  Skipped Neovim setup"
        Write-Host "  See windows/nvim/README.md for setup instructions"
    }
} else {
    Write-Warning "Skipping Neovim setup (--SkipNeovim)"
}

# ============================================================================
# KANATA SETUP
# ============================================================================

if (-not $SkipKanata) {
    Write-Step "Setting up Kanata keyboard remapper..."

    $response = Read-Host "Download and configure Kanata? (y/N)"
    if ($response -eq 'y') {
        $kanataDir = Join-Path $env:USERPROFILE "Tools\Kanata"
        $kanataExe = Join-Path $kanataDir "kanata.exe"
        
        try {
            # Create directory
            if (-not (Test-Path $kanataDir)) {
                New-Item -Path $kanataDir -ItemType Directory -Force | Out-Null
            }
            
            Write-Host "  Downloading Kanata..." -ForegroundColor Yellow
            $kanataUrl = "https://github.com/jtroo/kanata/releases/latest/download/kanata_wintercept.exe"
            Invoke-WebRequest -Uri $kanataUrl -OutFile $kanataExe -UseBasicParsing
            
            Write-Success "Kanata downloaded to: $kanataExe"
            
            # Create startup shortcut
            Write-Host "  Creating startup shortcut..." -ForegroundColor Yellow
            $shell = New-Object -ComObject WScript.Shell
            $shortcut = $shell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Kanata.lnk")
            $shortcut.TargetPath = $kanataExe
            $shortcut.Arguments = "--cfg `"$ConfigRoot\kanata\kanata-aula-f75.kbd`""
            $shortcut.WorkingDirectory = $kanataDir
            $shortcut.WindowStyle = 7  # Minimized
            $shortcut.Save()
            
            Write-Success "Kanata will start automatically on login"
            Write-Host "  Config: $ConfigRoot\kanata\kanata-aula-f75.kbd"
        }
        catch {
            Write-Fail "Failed to setup Kanata: $_"
            Write-Host "  See windows/kanata/README.md for manual setup"
        }
    } else {
        Write-Host "  Skipped Kanata setup"
    }
} else {
    Write-Warning "Skipping Kanata setup (--SkipKanata)"
}

# ============================================================================
# FINAL STEPS
# ============================================================================

Write-Step "Installation complete!"

Write-Host "`n" -NoNewline
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  NEXT STEPS" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

Write-Host "`n1. " -NoNewline -ForegroundColor Yellow
Write-Host "Launch Alacritty" -ForegroundColor White
Write-Host "   Search for 'Alacritty' in Start Menu or run: alacritty"

Write-Host "`n2. " -NoNewline -ForegroundColor Yellow
Write-Host "Configure PowerShell 7 as default (optional)" -ForegroundColor White
Write-Host "   Windows Terminal Settings → Default profile → PowerShell 7"

Write-Host "`n3. " -NoNewline -ForegroundColor Yellow
Write-Host "Test Neovim" -ForegroundColor White
Write-Host "   Run: nvim"
Write-Host "   LazyVim will automatically install plugins on first launch"

Write-Host "`n4. " -NoNewline -ForegroundColor Yellow
Write-Host "Start Kanata (if installed)" -ForegroundColor White
Write-Host "   Run: ~\Tools\Kanata\kanata.exe --cfg ~/.config/kanata/kanata-aula-f75.kbd"
Write-Host "   Or restart Windows (auto-start enabled)"

Write-Host "`n5. " -NoNewline -ForegroundColor Yellow
Write-Host "Start GlazeWM (optional)" -ForegroundColor White
Write-Host "   Search for 'GlazeWM' in Start Menu"
Write-Host "   Tiling window manager for better workspace management"

Write-Host "`n6. " -NoNewline -ForegroundColor Yellow
Write-Host "Customize!" -ForegroundColor White
Write-Host "   Alacritty: ~/.config/alacritty/alacritty.toml"
Write-Host "   PowerShell: ~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
Write-Host "   Starship: ~/.config/starship.toml"
Write-Host "   Kanata: ~/.config/kanata/kanata-aula-f75.kbd"

Write-Host "`n" -NoNewline
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Host "  DOCUMENTATION" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

Write-Host "`nFor detailed guides, see:" -ForegroundColor White
Write-Host "  • docs/ALACRITTY_SETUP.md - Complete Alacritty setup guide"
Write-Host "  • docs/WINDOWS.md - Windows-specific documentation"
Write-Host "  • windows/nvim/README.md - Neovim setup"
Write-Host "  • windows/kanata/README.md - Kanata keyboard remapping"

Write-Host "`nFriend's dotfiles: " -NoNewline -ForegroundColor White
Write-Host "https://github.com/shivajreddy/dotfiles" -ForegroundColor Blue

Write-Host "`n" -ForegroundColor DarkGray
Write-Success "Happy coding!"
