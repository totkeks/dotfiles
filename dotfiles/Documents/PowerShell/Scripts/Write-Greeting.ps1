$username = $IsWindows ? (Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData\" | Get-ItemProperty | Where-Object { $_.psobject.Properties["LoggedOnUser"] -Like "*$($env:USERNAME)" } | Select-Object -First 1 -ExpandProperty LoggedOnDisplayName) : $env:USERNAME
$computername = $env:COMPUTERNAME
$os = $PSVersionTable.OS
$psversion = $PSVersionTable.PSVersion

Write-Output "Hello $($PSStyle.Foreground.Blue)$username$($PSStyle.Reset), welcome to $($PSStyle.Foreground.Blue)$computername$($PSStyle.Reset)!"
Write-Output "You are running $($PSStyle.Foreground.Yellow)PowerShell $psversion$($PSStyle.Reset) on $($PSStyle.Foreground.Yellow)$os$($PSStyle.Reset).`n"
