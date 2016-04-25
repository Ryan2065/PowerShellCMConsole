Function Start-EphingThreading {
    Param (
        $ScriptBlock,
        $RunspaceID
    )
    $ConsolePath = (Get-Item $PSScriptRoot).Parent.FullName
    try {
    $SynchronizedHashTable.Runspaces["PS$RunspaceID"] = [Powershell]::Create().AddScript($Scriptblock).AddArgument($RunspaceID).AddArgument($ConsolePath)
    $SynchronizedHashTable.Runspaces["PS$RunspaceID"].RunspacePool = $SynchronizedHashTable.RunspacePool
    return $SynchronizedHashTable.Runspaces["PS$RunspaceID"].BeginInvoke()
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
	$SessionState.Variables.Add((New-Object -TypeName System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList 'SynchronizedHashTable', $SynchronizedHashTable, ""))
    $SessionState.ImportPSModule("$ConsolePath\UI Code\UI - Log Function.ps1")
    $SynchronizedHashTable.RunspacePool = [RunspaceFactory]::CreateRunspacePool(1, $Threads, $SessionState, $Host)
    $null = $SynchronizedHashTable.RunspacePool.Open()
    $SynchronizedHashTable.Runspaces = @{}
}