Function Log {
    Param (
        $Message,
        $ErrorMessage,
        $ExceptionObject
    )
    if ($ExceptionObject -ne $null) { $ErrorMessage = $ExceptionObject.Exception.Message }
    $CurrentTime = (Get-Date).ToLongTimeString()
    $SynchronizedHashTable.WindowDataContext.LogText = $SynchronizedHashTable.WindowDataContext.LogText + "$CurrentTime - $Message $ErrorMessage`n"
}
