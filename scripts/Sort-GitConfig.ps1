<#
.SYNOPSIS
    Sorts the sections in a gitconfig file.

.DESCRIPTION
    This script reads a gitconfig file, sorts the sections, and writes the sorted sections back to the file.

.PARAMETER Path
    The path to the gitconfig file to sort.

.EXAMPLE
    Sort-GitConfig.ps1 -Path "~/.gitconfig"
    This command sorts the sections in the gitconfig file at "~/.gitconfig".
#>

[CmdletBinding()]
param (
	[Parameter(Mandatory)]
	[string]$Path
)

if (-not (Test-Path $Path -PathType Leaf)) {
	Write-Error 'Invalid gitconfig path'
	exit
}

$gitConfig = [System.Collections.SortedList](Get-IniContent $Path)
Out-IniFile -InputObject $gitConfig -FilePath $Path -Pretty -Loose -Force
