[CmdletBinding(SupportsShouldProcess)]
param (
	[Parameter(Mandatory)]
	[string]$FontName,
	[string]$DownloadUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/"
)

$TempFile = [System.IO.Path]::GetTempFileName()
$TempDirectory = Join-Path $Env:Temp $(New-Guid)
Invoke-WebRequest -Uri "$DownloadUrl$FontName.zip" -OutFile $TempFile
Expand-Archive -LiteralPath $TempFile -DestinationPath $TempDirectory

$fonts = $null
foreach ($fontFile in (Get-ChildItem $TempDirectory -Recurse -Include "*.ttf", "*.otf")) {
	if ($PSCmdlet.ShouldProcess($fontFile.Name, "Install Font")) {
		if (!$fonts) {
			$shellApp = New-Object -ComObject shell.application
			$fonts = $shellApp.NameSpace(0x14)
		}
		$fonts.CopyHere($fontFile.FullName)
	}
}

Remove-Item $TempFile
Remove-Item $TempDirectory -Recurse
