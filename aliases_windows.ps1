# Windows PowerShell Aliases

# Directory navigation
function ll { Get-ChildItem -Force }
function la { Get-ChildItem -Force -Hidden }
function l { Get-ChildItem }

# Git shortcuts
function gs { git status }
function ga { git add . }
function gc { git commit -m "$args" }
function gp { git push }
function gl { git log --oneline -10 }

# Development shortcuts
function dev { npm run dev }
function build { npm run build }
function test { npm test }

# Custom prompts
Write-Host "Dotfiles loaded!" -ForegroundColor Green
