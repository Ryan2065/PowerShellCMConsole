<#
    .SYNOPSIS
        
 
    .DESCRIPTION
        
   
    .EXAMPLE
        
  
    .NOTES
        AUTHOR: 
        LASTEDIT: 02/23/2016 17:22:18
 
   .LINK
        
#>

$Global:SynchronizedHashTable = [HashTable]::Synchronized(@{})
$SynchronizedHashTable.Host = $Host
$SynchronizedHashTable.OptionsHash = @{}
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process

. "$PSScriptRoot\General Functions\General.ps1"
. "$PSScriptRoot\UI Code\UI - XAML Functions.ps1"
. "$PSScriptRoot\Worker Functions\Worker - Runspaces.ps1"
. "$PSScriptRoot\UI Code\UI - Log Function.ps1"

Process-Options

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

$SynchronizedHashTable.WindowDataContext = New-Object -TypeName WindowClass
$Window.DataContext = $SynchronizedHashTable.WindowDataContext
$SynchronizedHashTable.WindowDataContext.ProgressVisibility = [System.Windows.Visibility]::Hidden
$SynchronizedHashTable.WindowDataContext.GridEnabled = $true
$Window_MI_Connect.Add_Click({
    Import-Module "$PSScriptRoot\UI Code\UI - ConnectToServer.ps1"
})

$Window_MI_Exit.Add_Click({
    Exit
})
  

$Window_Tree_MainMenu.Add_SelectedItemChanged({
    #$SynchronizedHashTable.WindowDataContext.TabControlSelectedIndex = $Window_Tree_MainMenu.SelectedItem.Tag
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

if (Test-Path "$PSScriptRoot\UI Code\UI - Welcome.ps1") {
    . "$PSScriptRoot\UI Code\UI - Welcome.ps1"
}

<#$Window_Txt_BoundaryFilter.Add_KeyDown({
    $args[1].Key.ToString()
})#>



if($SynchronizedHashTable.OptionsHash["AltCreds"] -eq 'True') {
    If(($Global:SynchronizedHashTable.OptionsHash["SaveCreds"] -eq 'True')) {
        . "$PSScriptRoot\General Functions\General - Credentials.ps1"
        $SynchronizedHashTable.OptionsHash["CMCreds"] = Get-WinVaultCredentials -UserName $SynchronizedHashTable.OptionsHash["AltCredsUser"]
    }
    else {
        if (![String]::IsNullOrEmpty($SynchronizedHashTable.OptionsHash["AltCredsUser"])) { $SynchronizedHashTable.OptionsHash["CMCreds"] = Get-Credential -Message 'Please enter the credentials to connect to the ConfigMgr site server' -UserName $SynchronizedHashTable.OptionsHash["AltCredsUser"] }
        else { $SynchronizedHashTable.OptionsHash["CMCreds"] = Get-Credential -Message 'Please enter the credentials to connect to the ConfigMgr site server' }
        $tempOptionsText = Get-Content "$PSScriptRoot\PoshConsoleSettings.txt"
        Remove-Item "$PSScriptRoot\PoshConsoleSettings.txt" -Force
        $added = $false
        foreach ($line in $tempOptionsText) {
            if($line.ToLower().Contains('altcredsuser')) {
                $NewLine = "AltCredsUser=" + $SynchronizedHashTable.OptionsHash["CMCreds"].UserName
                $NewLine >> "$PSScriptRoot\PoshConsoleSettings.txt"
                $added = $true
            }
            else {
                $line >> "$PSScriptRoot\PoshConsoleSettings.txt"
            }
            if ($added -eq $false) {
                $NewLine = "AltCredsUser=" + $SynchronizedHashTable.OptionsHash["CMCreds"].UserName
                $NewLine >> "$PSScriptRoot\PoshConsoleSettings.txt"
            }
        }
    }
}


$Window.ShowDialog() | Out-Null
