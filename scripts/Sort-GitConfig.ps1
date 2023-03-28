[CmdletBinding()]
param (
	[Parameter(Mandatory)]
	[string]$GitConfigPath
)

if (-not (Test-Path $GitConfigPath -PathType Leaf)) {
	Write-Error "Invalid gitconfig path"
	exit
}

$gitConfig = [System.Collections.SortedList](Get-IniContent $GitConfigPath)
Out-IniFile -InputObject $gitConfig -FilePath $GitConfigPath -Pretty -Loose -Force
