Import-Module ProfileManagement
Start-LoadingSequence

# Default shell behavior
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Properly handle unicode in terminals
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

# Stop git from using stderr for output
$env:GIT_REDIRECT_STDERR = '2>&1'
Import-Module GitManagement

# Load submodules
Set-Aliases
Set-KeyBindings
Set-TabCompletions
Set-SolarizedDarkColorTheme

Stop-LoadingSequence

# Setup prompt
oh-my-posh init pwsh --config ~/.totkeks.omp.toml | Invoke-Expression
