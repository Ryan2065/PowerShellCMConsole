<#
    .SYNOPSIS
        
 
    .DESCRIPTION
        
   
    .EXAMPLE
        
  
    .NOTES
        AUTHOR: 
        LASTEDIT: 02/23/2016 17:22:18
 
   .LINK
        
#>

$Global:SynchrnoizedHashTable = [HashTable]::Synchronized(@{})
$SynchrnoizedHashTable.Host = $Host
$SynchrnoizedHashTable.OptionsHash = @{}
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process

Function Process-Options {
    If(Test-Path "$PSScriptRoot\PoshConsoleSettings.txt") {
        Get-Content "$PSScriptRoot\PoshConsoleSettings.txt" | Foreach-Object {
            $SplitLine = $_.Split("=")
            $SynchrnoizedHashTable.OptionsHash[$SplitLine[0]] = $SplitLine[1]
        }
    }
    else {
        Import-Module "$PSScriptRoot\UI Code\UI - ConnectToServer.ps1"
    }
}

Process-Options

if($SynchrnoizedHashTable.OptionsHash["AltCreds"] -eq 'True') {
    if (![String]::IsNullOrEmpty($SynchrnoizedHashTable.OptionsHash["AltCredsUser"])) { $SynchrnoizedHashTable.OptionsHash["CMCreds"] = Get-Credential -Message 'Please enter the credentials to connect to the ConfigMgr site server' -UserName $SynchrnoizedHashTable.OptionsHash["AltCredsUser"] }
    else { $SynchrnoizedHashTable.OptionsHash["CMCreds"] = Get-Credential -Message 'Please enter the credentials to connect to the ConfigMgr site server' }
    $tempOptionsText = Get-Content "$PSScriptRoot\PoshConsoleSettings.txt"
    Remove-Item "$PSScriptRoot\PoshConsoleSettings.txt" -Force
    $added = $false
    foreach ($line in $tempOptionsText) {
        if($line.ToLower().Contains('altcredsuser')) {
            $NewLine = "AltCredsUser=" + $SynchrnoizedHashTable.OptionsHash["CMCreds"].UserName
            $NewLine >> "$PSScriptRoot\PoshConsoleSettings.txt"
            $added = $true
        }
        else {
            $line >> "$PSScriptRoot\PoshConsoleSettings.txt"
        }
        if ($added -eq $false) {
            $NewLine = "AltCredsUser=" + $SynchrnoizedHashTable.OptionsHash["CMCreds"].UserName
            $NewLine >> "$PSScriptRoot\PoshConsoleSettings.txt"
        }
    }
}

Import-Module "$PSScriptRoot\UI Code\UI - XAML Functions.ps1"
Import-Module "$PSScriptRoot\Worker Functions\Worker - Runspaces.ps1"
Import-Module "$PSScriptRoot\UI Code\UI - Log Function.ps1"

Create-EphingRunspacePool -Threads 20
Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase

[xml]$xaml = Get-Content "$PSScriptRoot\XAML Library\MainWindow.xaml"

#region Classes
$ClassHashTable = @{
    'BoundaryFilterText' = 'string';
    'TabControlSelectedIndex' = 'int';
    'ReleaseNotes' = 'string';
    'ProgressVisibility' = 'object'
    'GridEnabled' = 'bool'
    'LogText' = 'string'
}
$Returned = Create-EphingClass -ClassName 'WindowClass' -ClassHash $ClassHashTable
#endregion

# Make window
$Window = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))
$xaml.SelectNodes("//*[@Name]") | Foreach-Object { Set-Variable -Name (("Window" + "_" + $_.Name)) -Value $Window.FindName($_.Name) }

$SynchrnoizedHashTable.WindowDataContext = New-Object -TypeName WindowClass
$Window.DataContext = $SynchrnoizedHashTable.WindowDataContext
$SynchrnoizedHashTable.WindowDataContext.ProgressVisibility = [System.Windows.Visibility]::Hidden
$SynchrnoizedHashTable.WindowDataContext.GridEnabled = $true
$Window_MI_Connect.Add_Click({
    Import-Module "$PSScriptRoot\UI Code\UI - ConnectToServer.ps1"
})

$Window_MI_Exit.Add_Click({
    Exit
})
  

$Window_Tree_MainMenu.Add_SelectedItemChanged({
    #$SynchrnoizedHashTable.WindowDataContext.TabControlSelectedIndex = $Window_Tree_MainMenu.SelectedItem.Tag
    $Header= $Window_Tree_MainMenu.SelectedItem.Header
    if (Test-Path "$PSScriptRoot\UI Code\UI - $Header.ps1") {
        . "$PSScriptRoot\UI Code\UI - $Header.ps1"
    }
})

$Window_LogText.Add_TextChanged({
    if (!$Window_LogText.IsFocused) {
        $Window_LogText.ScrollToEnd()
    }
})

<#$Window_Txt_BoundaryFilter.Add_KeyDown({
    $args[1].Key.ToString()
})#>
 

$Window.ShowDialog() | Out-Null
