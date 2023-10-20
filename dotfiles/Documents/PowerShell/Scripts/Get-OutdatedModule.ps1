[CmdletBinding(SupportsShouldProcess)]
param ()

$yesToAll = $false
$noToAll = $false

# Check each module for updates
$updates = foreach ($module in Get-InstalledModule) {
	$latestVersion = (Find-Module $module.Name -AllowPrerelease | Select-Object -First 1).Version
	if ($module.Version -lt $latestVersion) {
		[PSCustomObject]@{
			Name = $module.Name
			InstalledVersion = $module.Version
			LatestVersion = $latestVersion
		}
	}
}

# Output the updates in a table
if ($updates) {
	$updates | Format-Table -AutoSize

	foreach ($update in $updates) {
		if ($PSCmdlet.ShouldContinue("Update module $($update.Name) from $($update.InstalledVersion) to $($update.LatestVersion)?", "Update-Module", [ref]$yesToAll, [ref]$noToAll)) {

			Update-Module -Name $update.Name -AllowPrerelease -Force
			Get-InstalledModule -Name $update.Name -AllVersions | Where-Object { $_.Version -lt $update.LatestVersion } | Uninstall-Module -Force
		}
	}
}
else {
	Write-Output "All modules are up to date."
}
