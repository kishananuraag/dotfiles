[CmdletBinding()]
param(
    [switch]$SkipPackages,
    [switch]$SkipSymlinks,
    [switch]$SkipFonts,
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
    Write-Host "[+] $Message" -ForegroundColor Green 
}

function Write-Warn { 
    param([string]$Message)
    Write-Host "[!] $Message" -ForegroundColor Yellow 
}

function Write-Fail { 
    param([string]$Message)
    Write-Host "[x] $Message" -ForegroundColor Red 
}

# ============================================================================
# FIX SMART QUOTES IN PS1 FILES
# ============================================================================

Write-Step "Fixing smart quotes in PowerShell scripts..."
Get-ChildItem "$DotfilesRoot\windows" -Filter "*.ps1" -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName -Raw -Encoding UTF8
    $fixed = $content `
        -replace [char]0x201C, '"' `
        -replace [char]0x201D, '"' `
        -replace [char]0x2018, "'" `
        -replace [char]0x2019, "'"
    if ($fixed -ne $content) {
        Set-Content $_.FullName -Value $fixed -Encoding UTF8
        Write-Success "Fixed quotes in $($_.Name)"
    }
}

# ============================================================================
# PREREQUISITE CHECKS
# ============================================================================

Write-Step "Checking prerequisites..."

# Check if winget is installed
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Fail "winget is not installed"
    Write-Host "Please install App Installer from Microsoft Store or update Windows"
    exit 1
}

Write-Success "winget is available"

# Check if running as admin (for informational purposes)
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($isAdmin) {
    Write-Warn "Running as Administrator - Scoop requires a normal user session."
}

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
            winget install --id $pkg.Name --silent --accept-package-agreements --accept-source-agreements 2>&1
            if ($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq -1978335189) {
                Write-Success "$($pkg.DisplayName) installed (or already present)"
            } else {
                Write-Warn "$($pkg.DisplayName) may have failed - check manually"
            }
        }
        catch {
            Write-Warn "Failed to install $($pkg.DisplayName): $_"
        }
    }

    # Install Iosevka font via Scoop
    if (-not $SkipFonts) {
        Write-Step "Installing Iosevka Nerd Font via Scoop..."

        if ($isAdmin) {
            Write-Warn "Running as Administrator - Scoop requires a normal user session."
            Write-Host "    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force" -ForegroundColor White
            Write-Host "    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression" -ForegroundColor White
            Write-Host "    scoop bucket add nerd-fonts" -ForegroundColor White
            Write-Host "    scoop install nerd-fonts/Iosevka-NF" -ForegroundColor White
        } else {
            # Install Scoop if not present
            if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
                Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
                Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
            }

            scoop bucket add nerd-fonts 2>&1 | Out-Null
            scoop install nerd-fonts/Iosevka-NF

            if ($LASTEXITCODE -eq 0) {
                Write-Success "Iosevka NF font installed"
            } else {
                Write-Warn "Font install may have failed - check scoop output above"
            }
        }
    } else {
        Write-Warn "Skipping font installation (--SkipFonts)"
    }

} else {
    Write-Warn "Skipping package installation (--SkipPackages)"
}

# ============================================================================
# CREATE DIRECTORY STRUCTURE
# ============================================================================

Write-Step "Creating directory structure..."

$directories = @(
    $ConfigRoot
    (Join-Path $env:APPDATA "alacritty")
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
# WRITE ALACRITTY CONFIG (directly to APPDATA with import)
# ============================================================================

Write-Step "Writing Alacritty config..."

$dotfilesForward = $DotfilesRoot.Replace('\', '/')

$alacrittyConfig = @"
# Alacritty Configuration - Kanagawa Dragon Theme
# Auto-generated by install-windows.ps1

[general]
import = [
    "$dotfilesForward/windows/alacritty/kanagawa_dragon.toml",
]

[font]
normal  = { family = "Iosevka NF", style = "Regular" }
bold    = { family = "Iosevka NF", style = "Bold" }
italic  = { family = "Iosevka NF", style = "Obl" }
size    = 13.0

[window]
opacity        = 0.95
blur           = true
decorations    = "Full"
startup_mode   = "Windowed"
dynamic_title  = true

[window.dimensions]
columns = 200
lines   = 50

[window.padding]
x = 10
y = 10

[scrolling]
history    = 10000
multiplier = 3

[cursor]
style            = { shape = "Block", blinking = "On" }
blink_interval   = 750
unfocused_hollow = true

[selection]
save_to_clipboard = true

[mouse]
hide_when_typing = true

[keyboard]
bindings = [
    { key = "V",     mods = "Control|Shift", action = "Paste" },
    { key = "C",     mods = "Control|Shift", action = "Copy" },
    { key = "Plus",  mods = "Control",       action = "IncreaseFontSize" },
    { key = "Minus", mods = "Control",       action = "DecreaseFontSize" },
    { key = "Key0",  mods = "Control",       action = "ResetFontSize" },
    { key = "N",     mods = "Control|Shift", action = "SpawnNewInstance" },
]

[shell]
program = "pwsh"
args    = ["-NoLogo", "-WorkingDirectory", "~"]
"@

Set-Content "$env:APPDATA\alacritty\alacritty.toml" -Value $alacrittyConfig -Encoding UTF8
Write-Success "Alacritty config written to $env:APPDATA\alacritty\alacritty.toml"

# Migrate deprecated Alacritty syntax
if (Get-Command alacritty -ErrorAction SilentlyContinue) {
    alacritty migrate 2>&1 | Out-Null
    Write-Success "Alacritty config migrated"
} else {
    Write-Warn "Alacritty not found in PATH yet - run 'alacritty migrate' after restarting terminal"
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
            Write-Warn "Target already exists: $Target"
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
    Write-Warn "Skipping symlink creation (--SkipSymlinks)"
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
                Write-Warn "Neovim config already exists"
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
    Write-Warn "Skipping Neovim setup (--SkipNeovim)"
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
    Write-Warn "Skipping Kanata setup (--SkipKanata)"
}

# ============================================================================
# FINAL STEPS
# ============================================================================

Write-Step "Installation complete!"

Write-Host "`n" -NoNewline
Write-Host "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" -ForegroundColor DarkGray
Write-Host "  NEXT STEPS" -ForegroundColor Cyan
Write-Host "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" -ForegroundColor DarkGray

Write-Host "`n1. " -NoNewline -ForegroundColor Yellow
Write-Host "Launch Alacritty" -ForegroundColor White
Write-Host "   Search for 'Alacritty' in Start Menu or run: alacritty"

Write-Host "`n2. " -NoNewline -ForegroundColor Yellow
Write-Host "Configure PowerShell 7 as default (optional)" -ForegroundColor White
Write-Host "   Windows Terminal Settings â†’ Default profile â†’ PowerShell 7"

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
Write-Host "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" -ForegroundColor DarkGray
Write-Host "  DOCUMENTATION" -ForegroundColor Cyan
Write-Host "â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”" -ForegroundColor DarkGray

Write-Host "`nFor detailed guides, see:" -ForegroundColor White
Write-Host "  â€¢ docs/ALACRITTY_SETUP.md - Complete Alacritty setup guide"
Write-Host "  â€¢ docs/WINDOWS.md - Windows-specific documentation"
Write-Host "  â€¢ windows/nvim/README.md - Neovim setup"
Write-Host "  â€¢ windows/kanata/README.md - Kanata keyboard remapping"

Write-Host "`nFriend's dotfiles: " -NoNewline -ForegroundColor White
Write-Host "https://github.com/shivajreddy/dotfiles" -ForegroundColor Blue

Write-Host "`n" -ForegroundColor DarkGray
Write-Success "Happy coding!"

