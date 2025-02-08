using namespace System.Diagnostics.CodeAnalysis
using namespace System.Management.Automation

[SuppressMessageAttribute('PSReviewUnusedParameter', 'wordToComplete')]
param()

Import-Module CompletionPredictor
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView

$Flags = [System.Reflection.BindingFlags]'Instance, NonPublic'
$Context = $ExecutionContext.GetType().GetField('_context', $Flags).GetValue($ExecutionContext)
$NativeProp = $Context.GetType().GetProperty('NativeArgumentCompleters', $Flags)

function Register-LazyCompleter($CommandName, $CompletionScript) {
	$Context = $script:Context
	$NativeProp = $script:NativeProp

	Register-ArgumentCompleter -CommandName $CommandName -ScriptBlock {
		try {
			. $CompletionScript
		}
		catch {
			throw "Failed to run the autocompleter for '$CommandName'"
		}
		$Completer = $NativeProp.GetValue($Context)[$CommandName]
		return & $Completer @Args
	}.GetNewClosure()
}

Register-LazyCompleter dotnet {
	Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
		param($wordToComplete, $commandAst,	$cursorPosition)

		dotnet complete --position $cursorPosition "$commandAst" | ForEach-Object {
			[CompletionResult]::new($_, $_, 'ParameterValue', $_)
		}
	}
}

Register-LazyCompleter gh {
	gh completion -s powershell | Out-String | Invoke-Expression
}

Register-LazyCompleter git {
	Import-Module posh-git
}

Register-LazyCompleter oh-my-posh {
	oh-my-posh completion powershell | Out-String | Invoke-Expression
}

Register-LazyCompleter podman {
	# Podman, with workaround for https://github.com/containers/podman/issues/15527
	(podman completion powershell | Out-String) -replace 'podman.exe', 'podman' | Invoke-Expression
}

Register-LazyCompleter uv {
	uv generate-shell-completion powershell | Out-String | Invoke-Expression
}

Register-LazyCompleter volta {
	volta completions powershell | Out-String | Invoke-Expression
}

Register-LazyCompleter winget {
	Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
		param($wordToComplete, $commandAst, $cursorPosition)

		winget complete --word "$wordToComplete" --commandline "$commandAst" --position $cursorPosition | ForEach-Object {
			[CompletionResult]::new($_, $_, 'ParameterValue', $_)
		}
	}
}
