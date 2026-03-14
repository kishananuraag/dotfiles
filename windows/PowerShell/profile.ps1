# PowerShell Profile for Windows
# Based on shivajreddy's configuration

# Turn off the update powershell statement when opening powershell
$env:POWERSHELL_UPDATECHECK = 'Off'

# #### STARSHIP PROMPT ####
# Location of starship configuration
$Env:STARSHIP_CONFIG = "$HOME\.dotfiles\windows\starship.toml"
Invoke-Expression (&starship init powershell)

# #### ALIASES ####
Set-Alias -Name vi -Value nvim
Set-Alias -Name vim -Value nvim
Set-Alias -Name c -Value cls

# Git aliases
function gs { git status }
function ga { git add $args }
function gc { git commit -m $args }
function gp { git push }
function gl { git log --oneline --graph --decorate --all }

# Navigation
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function dots { Set-Location ~\.dotfiles }

# Utilities
function which { where.exe $args }

# Update all Windows apps
Function wu {
    winget upgrade --all --include-unknown
}

# Python aliases
Set-Alias -Name python -Value py
Set-Alias -Name python3 -Value py

# Better ls with eza (if installed)
# If eza not installed, falls back to normal ls
if (Get-Command eza -ErrorAction SilentlyContinue) {
    Function ls {
        eza --icons -l $args
    }
    Function ll {
        eza --icons -l -T -L=1 $args
    }
    Set-Alias l ll
}

# #### MISC SETTINGS ####
# When using dir, hide the ugly text background color
$PSStyle.FileInfo.Directory = ""

# Allow Ctrl+D to exit, instead of typing as ^D
Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

# #### WELCOME MESSAGE ####
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "  ║        Windows PowerShell 7              ║" -ForegroundColor Blue
Write-Host "  ║        Dotfiles Loaded Successfully      ║" -ForegroundColor Green
Write-Host "  ╚══════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""