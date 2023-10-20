<#
.SYNOPSIS
	Installs a Nerd Font to the system.

.DESCRIPTION
	This script installs a Nerd Font to the system by downloading the font and installing it to the user's font directory.

.PARAMETER FontName
	The name of the font to install. Check https://github.com/ryanoasis/nerd-fonts/releases for a list of available fonts.

.PARAMETER DownloadUrl
	The URL to download the font from. Defaults to the latest release of the Nerd Fonts repository.

.EXAMPLE
	Install-NerdFont -FontName CascadiaCode
#>

[CmdletBinding(SupportsShouldProcess)]
param (
	[Parameter(Mandatory)]
	[string]$FontName,
	[string]$DownloadUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/"
)

$temp = [System.IO.Path]::GetTempFileName()
$tempDirectory = Join-Path $Env:Temp $(New-Guid)
New-Item -ItemType Directory -Path $tempDirectory | Out-Null

try {
	Invoke-WebRequest -Uri "$DownloadUrl$FontName.tar.xz" -OutFile $temp
	tar xzf $temp -C $tempDirectory

	$fonts = (New-Object -ComObject Shell.Application).NameSpace(0x14)
	foreach ($fontFile in (Get-ChildItem $tempDirectory -Recurse -Include "*.ttf", "*.otf")) {
		if ($PSCmdlet.ShouldProcess($fontFile.Name, "Install font")) {
			Write-Output "Installing $($fontFile.Name)"
			$fonts.CopyHere($fontFile.FullName, 0x14)
		}
	}
}
finally {
	Remove-Item $temp
	Remove-Item $tempDirectory -Recurse
}
