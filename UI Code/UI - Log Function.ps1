Function Log {
    Param (
        $Message,
        $ErrorMessage
    )
    $CurrentTime = (Get-Date).ToLongTimeString()
    $SynchrnoizedHashTable.WindowDataContext.LogText = $SynchrnoizedHashTable.WindowDataContext.LogText + "$CurrentTime - $Message $ErrorMessage`n"
}
