using namespace System.Diagnostics.CodeAnalysis
using namespace System.Management.Automation

[SuppressMessageAttribute('PSReviewUnusedParameter', 'wordToComplete')]
param()

Import-Module CompletionPredictor
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView

# .NET CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
	param($wordToComplete, $commandAst,	$cursorPosition)

	dotnet complete --position $cursorPosition "$commandAst" | ForEach-Object {
		[CompletionResult]::new($_, $_, 'ParameterValue', $_)
	}
}

# Windows Package Manager
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
	param($wordToComplete, $commandAst, $cursorPosition)

	winget complete --word "$wordToComplete" --commandline "$commandAst" --position $cursorPosition | ForEach-Object {
		[CompletionResult]::new($_, $_, 'ParameterValue', $_)
	}
}

# Lazy-load additional completions that require external tools
Register-EngineEvent -SourceIdentifier PowerShell.OnIdle -Action {
	# Git (TODO reduce to just completions, without the prompt features)
	Import-Module posh-git

	# Oh My Posh
	oh-my-posh completion powershell | Out-String | Invoke-Expression

	# GitHub CLI
	gh completion -s powershell | Out-String | Invoke-Expression

	# Podman, with workaround for https://github.com/containers/podman/issues/15527
	(podman completion powershell | Out-String) -replace "podman.exe", "podman" | Invoke-Expression

	# Volta
	volta completions powershell | Out-String | Invoke-Expression

	# Unregister the event after the completions have been loaded
	Unregister-Event -SourceIdentifier PowerShell.OnIdle
} | Out-Null
