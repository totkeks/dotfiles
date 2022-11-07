#------------------------------------------------------------------------------
# The Beginning
#------------------------------------------------------------------------------
Import-Module ProfileManagement
Start-LoadingSequence

#------------------------------------------------------------------------------
# Default shell behavior
#------------------------------------------------------------------------------
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Properly handle unicode in terminals
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

# Tell git to not spam stderr with output
$env:GIT_REDIRECT_STDERR = '2>&1'
Import-Module GitManagement

Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardDeleteWord

. powershell/aliases.ps1
. powershell/tab-completion.ps1

#------------------------------------------------------------------------------
# The End
#------------------------------------------------------------------------------
Stop-LoadingSequence

oh-my-posh init pwsh --config ~/.totkeks.omp.toml | Invoke-Expression
