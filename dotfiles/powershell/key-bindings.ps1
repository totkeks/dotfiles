using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardWord
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete

# F1 for help on the command line
Set-PSReadLineKeyHandler `
	-Chord F1 `
	-BriefDescription CommandHelp `
	-LongDescription "Open the help window for the current command" `
	-ScriptBlock {

	$ast = $null
	$tokens = $null
	$errors = $null
	$cursor = $null
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

	$commandAst = $ast.FindAll( {
			$node = $args[0]
			$node -is [CommandAst] -and
			$node.Extent.StartOffset -le $cursor -and
			$node.Extent.EndOffset -ge $cursor
		}, $true) | Select-Object -Last 1

	if ($commandAst -ne $null) {
		$commandName = $commandAst.GetCommandName()
		if ($commandName -ne $null) {
			$command = $ExecutionContext.InvokeCommand.GetCommand($commandName, 'All')
			if ($command -is [AliasInfo]) {
				$commandName = $command.ResolvedCommandName
			}

			if ($commandName -ne $null) {
				Get-Help $commandName -ShowWindow
			}
		}
	}
}
