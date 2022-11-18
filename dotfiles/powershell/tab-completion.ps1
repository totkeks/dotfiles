using namespace System.Diagnostics.CodeAnalysis
using namespace System.Management.Automation

[SuppressMessageAttribute('PSReviewUnusedParameter', 'wordToComplete')]
param()

Set-PSReadLineOption -PredictionViewStyle ListView

Import-Module posh-git
# Import-Module NPMTabCompletion
# Import-Module DockerCompletion
# Import-Module DockerComposeCompletion

# .NET CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
	param($wordToComplete, $commandAst,	$cursorPosition)

	dotnet complete --position $cursorPosition "$commandAst" | ForEach-Object {
		[CompletionResult]::new($_, $_, 'ParameterValue', $_)
	}
}

# winget
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
	param($wordToComplete, $commandAst, $cursorPosition)

	winget complete --word "$wordToComplete" --commandline "$commandAst" --position $cursorPosition | ForEach-Object {
		[CompletionResult]::new($_, $_, 'ParameterValue', $_)
	}
}

# Oh My Posh
oh-my-posh completion powershell | Out-String | Invoke-Expression
