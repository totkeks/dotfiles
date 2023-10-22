<#
.SYNOPSIS
	Opens a file or folder from the command line.

.DESCRIPTION
	The 'open' function allows you to quickly open a file or folder from the command line by passing in the path as an argument.

	Defaults to the current directory if no path is provided.

.PARAMETER Path
	The path to the file or folder that you want to open.

.EXAMPLE
	open C:\Users\Username\Documents\example.txt
	This command will open the 'example.txt' file in Notepad.

.EXAMPLE
	open C:\Users\Username\Documents
	This command will open the 'Documents' folder in File Explorer.
#>
Function open {
	param (
		[string]$Path = "."
	)
	Invoke-Item $Path
}
