$SourceFilePath = (Get-Command wt).Source
$StartupFolder = [Environment]::GetFolderPath([Environment+SpecialFolder]::Startup)
$ShortcutPath = Join-Path -Path $StartupFolder "Windows Terminal Quake Mode.lnk"

$WScriptObj = New-Object -ComObject "WScript.Shell"
$shortcut = $WscriptObj.CreateShortcut($ShortcutPath)
$shortcut.TargetPath = $SourceFilePath
$shortcut.WorkingDirectory = Split-Path -Parent $SourceFilePath
$shortcut.Arguments = "-w _quake"
$shortcut.Save()
