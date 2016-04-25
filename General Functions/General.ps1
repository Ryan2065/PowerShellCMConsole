Function Process-Options {
    try {
        $SynchronizedHashTable["OptionsHash"] = @{}
        $ConsolePath = (Get-Item $PSScriptRoot).Parent.FullName
        If(Test-Path "$ConsolePath\PoshConsoleSettings.txt") {
            $ConsoleSettingContent = Get-Content "$ConsolePath\PoshConsoleSettings.txt"
            Foreach ($Line in $ConsoleSettingContent) {
                $SplitLine = $Line.Split("=")
                $SynchronizedHashTable.OptionsHash[$SplitLine[0]] = $SplitLine[1]
            }
        }
        else {
            . "$ConsolePath\UI Code\UI - ConnectToServer.ps1"
        }
    }
    catch {
        $ConsolePath = (Get-Item $PSScriptRoot).Parent.FullName
        . "$ConsolePath\UI Code\UI - ConnectToServer.ps1"
    }
}
