Function Start-EphingThreading {
    Param (
        $ScriptBlock,
        $RunspaceID
    )
    $ConsolePath = (Get-Item $PSScriptRoot).Parent.FullName
    try {
    $SynchrnoizedHashTable.Runspaces["PS$RunspaceID"] = [Powershell]::Create().AddScript($Scriptblock).AddArgument($RunspaceID).AddArgument($ConsolePath)
    $SynchrnoizedHashTable.Runspaces["PS$RunspaceID"].RunspacePool = $SynchrnoizedHashTable.RunspacePool
    return $SynchrnoizedHashTable.Runspaces["PS$RunspaceID"].BeginInvoke()
    }
    catch {
        $_.Exception.Message >> C:\users\rephgrave.CONCURRENCY\Desktop\test.txt
    }
}

Function Create-EphingRunspacePool {
    Param (
        $Threads
    )
    $ConsolePath = (Get-Item $PSScriptRoot).Parent.FullName
	$SessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
	$SessionState.ApartmentState = "STA"
	$SessionState.Variables.Add((New-Object -TypeName System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList 'SynchrnoizedHashTable', $SynchrnoizedHashTable, ""))
    $SessionState.ImportPSModule("$ConsolePath\UI Code\UI - Log Function.ps1")
    $SynchrnoizedHashTable.RunspacePool = [RunspaceFactory]::CreateRunspacePool(1, $Threads, $SessionState, $Host)
    $null = $SynchrnoizedHashTable.RunspacePool.Open()
    $SynchrnoizedHashTable.Runspaces = @{}
}