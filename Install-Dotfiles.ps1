[CmdletBinding(SupportsShouldProcess)]
param ()

$yesToAll = $false
$noToAll = $false

$dotfiles = "dotfiles"
$configPath = "$HOME/.config/dotfiles.json"
$variablePattern = [Regex]"<<(?<variable>\w+)>>"
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
	$allMatches = $variablePattern.Matches($content)

	if ($null -ne $allMatches) {
		foreach ($match in $allMatches) {
			$varName = $match.Groups["variable"].Value
			$varValue = $config.PSObject.Properties[$varName]?.Value

			if ($null -eq $varValue) {
				$varValue = Read-Host "Please enter value for '$varName'"
				$config | Add-Member -MemberType NoteProperty -Name $varName -Value $varValue
			}

			Write-Output "Replacing '$varName' with '$varValue'"
			$content = ([Regex]"<<$varName>>").Replace($content, $varValue, 1)
		}
	}

	Write-Output "Saving $relativePath to $targetPath"
	New-Item $targetPath -ItemType File -Value $content -Force | Out-Null
}

Set-Content $configPath ($config | ConvertTo-Json)

# Add scripts folder to PATH (if not present) and refresh
$PATH = [Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)
$scriptsPath = "$(Split-Path $profile)\Scripts"
if ( $PATH -notlike "*" + $scriptsPath + "*" ) {
	[Environment]::SetEnvironmentVariable("PATH", "$PATH;$scriptsPath", [System.EnvironmentVariableTarget]::User)
	[Environment]::SetEnvironmentVariable("PATH", "$PATH;$scriptsPath", [System.EnvironmentVariableTarget]::Process)
}

# Configure dev drive caches
$devDrive = (Get-Volume | Where-Object { $_.FileSystem -eq "ReFS" })?.DriveLetter
if ($devDrive) {
	Write-Output "Configuring dev drive caches"
	[Environment]::SetEnvironmentVariable("npm_config_cache", "${devDrive}:\packages\npm", [System.EnvironmentVariableTarget]::User)
	[Environment]::SetEnvironmentVariable("NUGET_PACKAGES", "${devDrive}:\packages\nuget", [System.EnvironmentVariableTarget]::User)
	[Environment]::SetEnvironmentVariable("VCPKG_DEFAULT_BINARY_CACHE", "${devDrive}:\packages\vcpkg", [System.EnvironmentVariableTarget]::User)
	[Environment]::SetEnvironmentVariable("PIP_CACHE_DIR", "${devDrive}:\packages\pip", [System.EnvironmentVariableTarget]::User)
	[Environment]::SetEnvironmentVariable("CARGO_HOME", "${devDrive}:\packages\cargo", [System.EnvironmentVariableTarget]::User)
	[Environment]::SetEnvironmentVariable("MAVEN_OPTS", "-Dmaven.repo.local=${devDrive}:\packages\maven", [System.EnvironmentVariableTarget]::User)
}

# Install required modules
$modules = @(
	"posh-git",
	"Terminal-Icons",
	"totkeks.GitManagement",
	"VirtualDesktop",
	"CompletionPredictor"
)

foreach ($module in $modules) {
	if (-not (Get-InstalledPSResource $module)) {
		Write-Output "Installing module $module"
		Install-PSResource $module -Scope CurrentUser -Force
	}
}
