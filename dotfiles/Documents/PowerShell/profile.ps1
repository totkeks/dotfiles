# Set default shell behavior
$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
Set-StrictMode -Version Latest

# Properly handle unicode in terminals
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

# Stop git from using stderr for output
$env:GIT_REDIRECT_STDERR = '2>&1'

Import-Module totkeks.GitManagement
Set-GitBaseDirectory "<<gitBaseDirectory>>"
Import-Module Terminal-Icons

# Load submodules
Get-ChildItem (Join-Path $PSScriptRoot Profile) *.ps1 | ForEach-Object { . $_.FullName }

Write-Greeting

# Setup prompt
$env:GitBaseDirectory = Get-GitBaseDirectory
oh-my-posh init pwsh --config ~/.totkeks.omp.toml | Invoke-Expression
