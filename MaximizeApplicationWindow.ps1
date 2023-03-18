function Set-WindowStyle {
    param(
        [Parameter()]
        [ValidateSet('MAXIMIZE', 'MINIMIZE', 'RESTORE', 'SHOW', 'HIDE')]
        $Style = 'SHOW',
        [Parameter()]
        $MainWindowHandle = (Get-Process -Id $pid).MainWindowHandle
    )

    $WindowStates = @{
        MAXIMIZE  = 3
        MINIMIZE  = 6
        RESTORE   = 9
        SHOW      = 5
        HIDE      = 0
    }

    Write-Verbose ("Set Window Style {1} on handle {0}" -f $MainWindowHandle, $($WindowStates[$style]))

    $Win32ShowWindowAsync = Add-Type –memberDefinition @"
    [DllImport("user32.dll")]
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
"@ -name "Win32ShowWindowAsync" -namespace Win32Functions –passThru

    $Win32ShowWindowAsync::ShowWindowAsync($MainWindowHandle, $WindowStates[$Style]) | Out-Null
}

(Get-Process -Name notepad).MainWindowHandle | foreach { Set-WindowStyle MAXIMIZE $_ }
