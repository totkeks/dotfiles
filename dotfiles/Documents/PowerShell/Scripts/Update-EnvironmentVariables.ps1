# taken from https://stackoverflow.com/a/22670892
foreach ($level in "Machine", "User") {
	[Environment]::GetEnvironmentVariables($level).GetEnumerator() | ForEach-Object {
		# Append new paths and remove duplicates
		if ($_.Name -eq 'Path') {
			$_.Value = ($((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -split ';' | Select-Object -Unique) -join ';'
		}
		$_
	} | Set-Content -Path { "Env:$($_.Name)" }
}
