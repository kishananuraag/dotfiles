# Dotfiles Setup Script for Windows (PowerShell)
# Run this on any Windows machine to sync your configs

$DOTFILES_REPO = "https://github.com/kishananuraag/dotfiles.git"
$DOTFILES_DIR = "$env:USERPROFILE\.dotfiles"

# Clone or update dotfiles repo
if (Test-Path $DOTFILES_DIR) {
    Write-Host "Updating dotfiles..."
    Set-Location $DOTFILES_DIR
    git pull
} else {
    Write-Host "Cloning dotfiles..."
    git clone $DOTFILES_REPO $DOTFILES_DIR
}

Set-Location $DOTFILES_DIR
Write-Host "Setting up symlinks..."

# Gitconfig
$gitconfigTarget = "$env:USERPROFILE\.gitconfig"
if (Test-Path $gitconfigTarget) { Remove-Item $gitconfigTarget }
New-Item -ItemType SymbolicLink -Path $gitconfigTarget -Target "$DOTFILES_DIR\gitconfig"

# Shell aliases (add to PowerShell profile)
$profilePath = $PROFILE
$profileDir = Split-Path $profilePath -Parent
if (!(Test-Path $profileDir)) { New-Item -ItemType Directory -Path $profileDir -Force }

$aliasContent = @"
# Load dotfiles aliases
`$dotfilesAliases = `"`$env:USERPROFILE\.dotfiles\aliases_windows.ps1`"
if (Test-Path `$dotfilesAliases) {
    . `$dotfilesAliases
}
"@

if (!(Select-String -Path $profilePath -Pattern "dotfiles aliases" -Quiet)) {
    Add-Content $profilePath $aliasContent
}

Write-Host "Dotfiles synced successfully!"
Write-Host "Restart PowerShell to load aliases."
