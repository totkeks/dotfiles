# ask for data for certain files
# email for git, npm login?, project directory, editor for git
[CmdletBinding(SupportsShouldProcess)]
param ()

$yesToAll = $false
$noToAll = $false

$dotfiles = "dotfiles"
$basePath = [System.IO.Path]::Combine($PSScriptRoot, $dotfiles)
$files = Get-ChildItem -Recurse -File $dotfiles

foreach ($file in $files) {
	$relativePath = [System.IO.Path]::GetRelativePath($basePath, $file.FullName)
	$targetPath = [System.IO.Path]::Combine($HOME, $relativePath)

	if ((Test-Path $targetPath) -and -not ($PSCmdlet.ShouldContinue($targetPath, "Replace existing file?", [ref]$yesToAll, [ref]$noToAll))) {
		continue
	}

	Write-Output "Copying $relativePath to $targetPath"
	Copy-Item $file.FullName $targetPath
}
