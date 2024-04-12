using namespace Microsoft.PowerShell
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Chord UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardWord
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete

Set-PSReadLineKeyHandler `
	-Chord 'Alt+(' `
	-BriefDescription ParenthesizeSelection `
	-LongDescription "Put parenthesis around the selection or entire line and move the cursor to after the closing parenthesis" `
	-ScriptBlock {

	$selectionStart = $null
	$selectionLength = $null
	[PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

	$line = $null
	$cursor = $null
	[PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
	if ($selectionStart -ne -1) {
		[PSConsoleReadLine]::Replace($selectionStart, $selectionLength, '(' + $line.SubString($selectionStart, $selectionLength) + ')')
		[PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
	}
	else {
		[PSConsoleReadLine]::Replace(0, $line.Length, '(' + $line + ')')
		[PSConsoleReadLine]::EndOfLine()
	}
}

Set-PSReadLineKeyHandler `
	-Chord Alt+w `
	-BriefDescription SaveInHistory `
	-LongDescription "Save current line in history but do not execute" `
	-ScriptBlock {

	$line = $null
	$cursor = $null
	[PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
	[PSConsoleReadLine]::AddToHistory($line)
	[PSConsoleReadLine]::RevertLine()
}

Set-PSReadLineKeyHandler `
	-Chord "Alt+'" `
	-BriefDescription ToggleQuoteArgument `
	-LongDescription "Toggle quotes on the argument under the cursor" `
	-ScriptBlock {

	$ast = $null
	$tokens = $null
	$errors = $null
	$cursor = $null
	[PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

	$tokenToChange = $null
	foreach ($token in $tokens) {
		$extent = $token.Extent
		if ($extent.StartOffset -le $cursor -and $extent.EndOffset -ge $cursor) {
			$tokenToChange = $token

			# If the cursor is at the end (it's really 1 past the end) of the previous token,
			# we only want to change the previous token if there is no token under the cursor
			if ($extent.EndOffset -eq $cursor -and $foreach.MoveNext()) {
				$nextToken = $foreach.Current
				if ($nextToken.Extent.StartOffset -eq $cursor) {
					$tokenToChange = $nextToken
				}
			}
			break
		}
	}

	if ($tokenToChange -ne $null) {
		$extent = $tokenToChange.Extent
		$tokenText = $extent.Text
		if ($tokenText[0] -eq '"' -and $tokenText[-1] -eq '"') {
			# Switch to no quotes
			$replacement = $tokenText.Substring(1, $tokenText.Length - 2)
		}
		elseif ($tokenText[0] -eq "'" -and $tokenText[-1] -eq "'") {
			# Switch to double quotes
			$replacement = '"' + $tokenText.Substring(1, $tokenText.Length - 2) + '"'
		}
		else {
			# Add single quotes
			$replacement = "'" + $tokenText + "'"
		}

		[PSConsoleReadLine]::Replace(
			$extent.StartOffset,
			$tokenText.Length,
			$replacement)
	}
}
