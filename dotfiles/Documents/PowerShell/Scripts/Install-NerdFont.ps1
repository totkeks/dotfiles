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
