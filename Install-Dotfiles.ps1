[CmdletBinding()]
param ()

$Verbose = $PSBoundParameters.ContainsKey('Verbose') -and $PSBoundParameters['Verbose']

Write-Information "Installing dotfiles"
Install-Dotfiles (Join-Path $PSScriptRoot dotfiles) -Verbose:$Verbose

Write-Information "Making custom scripts directly executable in the shell"
Add-EnvironmentPath (Join-Path (Split-Path $PROFILE) Scripts) -Verbose:$Verbose

Write-Information "Checking for dev drive and set caches if available"
$devDrive = (Get-Volume | Where-Object { $_.FileSystem -eq "ReFS" })?.DriveLetter
if ($devDrive) {
	Set-DevDriveCache (Get-PSDrive $devDrive).Root -Verbose:$Verbose
}

Write-Information "Installing modules required by profile"
@(
	"posh-git",
	"Terminal-Icons",
	"totkeks.GitManagement",
	"VirtualDesktop",
	"CompletionPredictor"
) | Install-PSResource -WarningAction SilentlyContinue -Verbose:$false
