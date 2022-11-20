[CmdletBinding(SupportsShouldProcess)]
param ()

$yesToAll = $false
$noToAll = $false

$dotfiles = "dotfiles"
$configPath = "$HOME/.config/dotfiles.json"
$pattern = [Regex]"<<(?<variable>\w+)>>"
$basePath = [System.IO.Path]::Combine($PSScriptRoot, $dotfiles)
$files = Get-ChildItem -Recurse -File $dotfiles

# Make sure the config file already exists
if (-not (Test-Path $configPath)) {
	New-Item $configPath -ItemType File -Value "{}" -Force
}

$config = Get-Content $configPath | ConvertFrom-Json

foreach ($file in $files) {
	$relativePath = [System.IO.Path]::GetRelativePath($basePath, $file.FullName)
	$targetPath = [System.IO.Path]::Combine($HOME, $relativePath)

	if ((Test-Path $targetPath) -and -not ($PSCmdlet.ShouldContinue($targetPath, "Replace existing file?", [ref]$yesToAll, [ref]$noToAll))) {
		continue
	}

	$content = Get-Content $file.FullName -Raw
	$allMatches = $pattern.Matches($content)

	if ($null -ne $allMatches) {
		foreach ($match in $allMatches) {
			$varName = $match.Groups["variable"].Value
			$varValue = $config.PSObject.Properties[$varName]?.Value

			if ($null -eq $varValue) {
				$varValue = Read-Host "Please enter value for '$varName'"
				$config | Add-Member -MemberType NoteProperty -Name $varName -Value $varValue
			}

			Write-Output "Replacing '$varName' with '$varValue"
			$content = ([Regex]"<<$varName>>").Replace($content, $varValue, 1)
		}
	}

	Write-Output "Saving $relativePath to $targetPath"
	New-Item $targetPath -ItemType File -Value $content -Force | Out-Null
}

Set-Content $configPath ($config | ConvertTo-Json)
