<#
.SYNOPSIS
	Retrieves information about connected devices.

.DESCRIPTION
	This script retrieves information about connected devices that belong to specific PNP classes and are currently present. It formats the output as a table with specific columns.

.LINK
	Original source: https://stackoverflow.com/a/76259155/6374587
#>

function Get-DeviceInformation {
	param (
		[Parameter(Mandatory)]
		[string[]]$PNPClasses
	)

	Get-PnpDevice |
		Where-Object { $_.PNPClass -in $PNPClasses } |
		Where-Object { $_.Present -in "True" } |
		Select-Object Name, Description, Manufacturer, PNPClass, Service, Present, Status, DeviceID |
		Sort-Object Name
}

function Format-DeviceInformation {
	param (
		[Parameter(Mandatory)]
		[PSObject]$Devices
	)

	$Devices |
		Format-Table Description, Manufacturer, PNPClass, Service,
		@{Label = "COM port"; Expression = { ($_.Name -Match "\((COM\d{1,2})\)" | Out-Null && $Matches[1]) } },
		@{Label = "VID:PID"; Expression = { ($_.DeviceID -Match "USB\\VID_([0-9a-fA-F]{4})\&PID_([0-9a-fA-F]{4})" | Out-Null && ('{0}{1}{2}' -f ${Matches}[1], ":", ${Matches}[2]).ToLower() ) } },
		Present, Status
}

$Devices = Get-DeviceInformation "WPD", "AndroidUsbDeviceClass", "Modem", "Ports"
if ($Devices) {
	Format-DeviceInformation $Devices
}
else {
	Write-Output "No devices found."
}
