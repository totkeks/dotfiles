$username = $IsWindows ? ([wmi] "win32_userAccount.Domain='$env:USERDOMAIN',Name='$env:USERNAME'").FullName : $env:USERNAME
$computername = hostname
$os = $PSVersionTable.OS
$psversion = $PSVersionTable.PSVersion

Write-Output "Hello $($PSStyle.Foreground.Blue)$username$($PSStyle.Reset), welcome to $($PSStyle.Foreground.Blue)$computername$($PSStyle.Reset)!"
Write-Output "You are running $($PSStyle.Foreground.Yellow)PowerShell $psversion$($PSStyle.Reset) on $($PSStyle.Foreground.Yellow)$os$($PSStyle.Reset).`n"
