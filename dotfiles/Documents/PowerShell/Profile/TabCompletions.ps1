using namespace System.Diagnostics.CodeAnalysis
using namespace System.Management.Automation

[SuppressMessageAttribute('PSReviewUnusedParameter', 'wordToComplete')]
param()

Import-Module CompletionPredictor
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView

Import-Module posh-git

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

# Oh My Posh
oh-my-posh completion powershell | Out-String | Invoke-Expression

# GitHub CLI
gh completion -s powershell | Out-String | Invoke-Expression

# Podman, with workaround for https://github.com/containers/podman/issues/15527
(podman completion powershell | Out-String) -replace "podman.exe", "podman" | Invoke-Expression

# Volta
volta completions powershell | Out-String | Invoke-Expression
