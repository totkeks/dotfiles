# taken from https://stackoverflow.com/a/76259155/6374587
$devices = Get-PnpDevice |
	Where-Object { $_.PNPClass -in "WPD", "AndroidUsbDeviceClass", "Modem", "Ports" } |
	Where-Object { $_.Present -in "True" } |
	Select-Object Name, Description, Manufacturer, PNPClass, Service, Present, Status, DeviceID |
	Sort-Object Name

$devices |
	Format-Table Description, Manufacturer, PNPClass, Service,
	@{Label = "COM port"; Expression = { ($_.Name -Match "\((COM\d{1,2})\)" | Out-Null && $Matches[1]) } },
	@{Label = "VID:PID"; Expression = { ($_.DeviceID -Match "USB\\VID_([0-9a-fA-F]{4})\&PID_([0-9a-fA-F]{4})" | Out-Null && ('{0}{1}{2}' -f ${Matches}[1], ":", ${Matches}[2]).ToLower() ) } },
	Present, Status
