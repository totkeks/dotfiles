Register-EngineEvent -SourceIdentifier PowerShell.OnIdle -Action {
	Import-Module Terminal-Icons

	# Unregister the event after the completions have been loaded
	Unregister-Event -SourceIdentifier PowerShell.OnIdle
} | Out-Null
