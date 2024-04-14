<#
.SYNOPSIS
	Updates the environment variables in the current session.

.DESCRIPTION
	This script updates the environment variables in the current session. It merges the user and system environment variables with the current session, overwriting any existing values. The only exception is the `Path` variable, which is merged instead of overwritten, to avoid losing any existing paths. Duplicate paths are removed to prevent clutter.

	This script is useful when you need to update the environment variables after installing a new program or updating an existing one.

.LINK
	Original source: https://stackoverflow.com/a/22670892
#>

function Merge-Path {
	param (
		[Parameter(Mandatory)]
		[string[]]$Paths
	)

	$merged = @()
	foreach ($path in $Paths) {
		$merged += $path -split [IO.Path]::PathSeparator
	}

	($merged | Select-Object -Unique) -join [IO.Path]::PathSeparator
}

function Update-EnvironmentVariable {
	[CmdletBinding(SupportsShouldProcess)]
	param (
		[Parameter(Mandatory)]
		[EnvironmentVariableTarget]$Level
	)

	$envVars = [Environment]::GetEnvironmentVariables($Level).GetEnumerator()

	foreach ($var in $envVars) {
		if ($var.Name -eq 'Path') {
			$var.Value = Merge-Path $(Get-Content Env:$($var.Name)), $($var.Value)
		}

		Set-Content -Path "Env:$($var.Name)" -Value $var.Value
	}
}

Update-EnvironmentVariable ([EnvironmentVariableTarget]::Machine)
Update-EnvironmentVariable ([EnvironmentVariableTarget]::User)
