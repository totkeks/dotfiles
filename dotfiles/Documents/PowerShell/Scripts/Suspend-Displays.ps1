Add-Type -MemberDefinition @"
[DllImport("user32.dll")]
public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);
"@ -Name "Win32SendMessage" -Namespace Win32Functions -PassThru | Out-Null

# Send the message to turn off all monitors
[Win32Functions.Win32SendMessage]::SendMessage(
	0xffff, # HWND_BROADCAST
	0x0112, # WM_SYSCOMMAND
	0xF170, # SC_MONITORPOWER
	2        # Turn off monitors
)
