# Open anything from the command line
Function open {
	param (
		[string]$Path = "."
	)
	Invoke-Item $Path
}
