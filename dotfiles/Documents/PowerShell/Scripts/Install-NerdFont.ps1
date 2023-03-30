[CmdletBinding(SupportsShouldProcess)]
param (
	[Parameter(Mandatory)]
	[string]$FontName,
	[string]$DownloadUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/"
)

$TempFile = [System.IO.Path]::GetTempFileName()
$TempDirectory = Join-Path $Env:Temp $(New-Guid)

try {
	Invoke-WebRequest -Uri "$DownloadUrl$FontName.zip" -OutFile $TempFile
	Expand-Archive -LiteralPath $TempFile -DestinationPath $TempDirectory

	$fonts = (New-Object -ComObject shell.application).NameSpace(0x14)
	foreach ($fontFile in (Get-ChildItem $TempDirectory -Recurse -Include "*.ttf", "*.otf")) {
		if ($PSCmdlet.ShouldProcess($fontFile.Name, "Install font")) {
			$fonts.CopyHere($fontFile.FullName)
		}
	}
}
finally {
	Remove-Item $TempFile
	Remove-Item $TempDirectory -Recurse
}
