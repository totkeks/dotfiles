[CmdletBinding(SupportsShouldProcess)]
param ()

$yesToAll = $false
$noToAll = $false

function FindAvailableUpdates {
	$installedModules = Get-InstalledPSResource |
		Group-Object -Property Name |
		ForEach-Object { [PSCustomObject]@{
				Name = $_.Name
				Versions = @($_.Group.Version)
			} }

	foreach ($module in $installedModules) {
		$latestVersion = (Find-PSResource $module.Name -Prerelease |
				Sort-Object -Property Version -Descending |
				Select-Object -First 1).Version

		if ($module.Versions -notcontains $latestVersion) {
			[PSCustomObject]@{
				Name = $module.Name
				InstalledVersions = $module.Versions
				LatestVersion = $latestVersion
			}
		}
	}
}

function UpdateOutdatedModules {
	if ($availableUpdates = FindAvailableUpdates) {
		Write-Output 'Available updates:'
		$availableUpdates | Format-Table -AutoSize

		foreach ($module in $availableUpdates) {
			if ($PSCmdlet.ShouldContinue("Update module $($module.Name) from $($module.InstalledVersions) to $($module.LatestVersion)?", 'Update-PSResource', [ref]$yesToAll, [ref]$noToAll)) {
				Update-PSResource -Name $module.Name -Prerelease
			}
		}
	}
	else {
		Write-Output 'All installed modules are up to date.'
	}
}

function FindOlderVersions {
	$installedModules = Get-InstalledPSResource |
		Group-Object -Property Name |
		ForEach-Object { [PSCustomObject]@{
				Name = $_.Name
				Versions = @($_.Group.Version | Sort-Object -Descending)
			} }

	foreach ($module in $installedModules) {
		if ($module.Versions.Count -gt 1) {
			[PSCustomObject]@{
				Name = $module.Name
				LatestVersion = $module.Versions[0]
				OldVersions = @($module.Versions | Select-Object -Skip 1)
			}
		}
	}
}

function RemoveOlderVersions {
	if ($olderVersions = FindOlderVersions) {
		Write-Output 'Older versions:'
		$olderVersions | Format-Table -AutoSize

		foreach ($module in $olderVersions) {
			foreach ($version in $module.OldVersions) {
				if ($PSCmdlet.ShouldContinue("Remove version $($version) of module $($module.Name)?", 'Uninstall-PSResource', [ref]$yesToAll, [ref]$noToAll)) {
					Uninstall-PSResource -Name $module.Name -Version $version
				}
			}
		}
	}
	else {
		Write-Output 'No older versions of installed modules found.'
	}
}

UpdateOutdatedModules
RemoveOlderVersions
