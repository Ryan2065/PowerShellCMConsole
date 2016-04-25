<#
    .SYNOPSIS
        
 
    .DESCRIPTION
        
   
    .EXAMPLE
        
  
    .NOTES
        AUTHOR: Ryan Ephgrave
        LASTEDIT: 02/22/2016 19:16:40
 
   .LINK
        https://github.com/Ryan2065/PowerShellCMConsole
#>

Import-Module "$PSScriptRoot\UI - XAML Functions.ps1"
$ConsolePath = (Get-Item $PSScriptRoot).Parent.FullName
[xml]$ConnectToServerXAML = Get-Content "$ConsolePath\XAML Library\ConnectToServer.xaml"

# Add assemblies
Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase

# Make window
$ServerConnect = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $ConnectToServerXAML))
$ConnectToServerXAML.SelectNodes("//*[@Name]") | Foreach-Object { Set-Variable -Name (("ServerConnect" + "_" + $_.Name)) -Value $ServerConnect.FindName($_.Name) }
$ClassHashTable = @{
    'ServerName' = 'string';
    'SiteCode' = 'string';
    'UseAltCredentials' = 'bool'
    'SaveAltCredentials' = 'bool'
}
$result = Create-EphingClass -ClassName 'ConnectToServerClass' -ClassHash $ClassHashTable

$ServerConnectDataContext = New-Object -TypeName 'ConnectToServerClass'

Process-Options

try {
    $ServerConnectDataContext.ServerName = $SynchronizedHashTable.OptionsHash["ServerName"]
    $ServerConnectDataContext.SiteCode = $SynchronizedHashTable.OptionsHash["SiteCode"]
    If($SynchronizedHashTable.OptionsHash["AltCreds"] -eq 'True') { $ServerConnectDataContext.UseAltCredentials = $true }
    If($SynchronizedHashTable.OptionsHash["SaveCreds"] -eq 'True') { $ServerConnectDataContext.SaveAltCredentials = $true }
}
catch {  }
$ServerConnect.DataContext = $ServerConnectDataContext

$ServerConnect_Btn_Save.Add_Click({
    $SynchronizedHashTable.OptionsHash["ServerName"] = $ServerConnectDataContext.ServerName
    $SynchronizedHashTable.OptionsHash["SiteCode"] = $ServerConnectDataContext.SiteCode
    if($ServerConnectDataContext.UseAltCredentials -eq $true) { 
        $SynchronizedHashTable.OptionsHash["CMCreds"] = Get-Credential -Message 'Please enter the credentials to connect to the ConfigMgr site server'
        $AltCredsUser = $SynchronizedHashTable.Optionshash["CMCreds"].UserName
    }
    if ($ServerConnectDataContext.SaveAltCredentials -eq $true) {
        . "$ConsolePath\General Functions\General - Credentials.ps1"
        $WinVaultCreds = Get-WinVaultCredentials -UserName $SynchronizedHashTable.Optionshash["CMCreds"].UserName
        if ($WinVaultCreds -ne $null) {
            $Popup = New-Object -ComObject Wscript.Shell
            $Results = $Popup.Popup('Credentials already found in valut for this username. Replace?',0,'Replace?',1)
            If ($Results -eq 1) {
                Remove-WinVaultCredentials -UserName $SynchronizedHashTable.Optionshash["CMCreds"].UserName
                Set-WinVaultCredentials -PSCredential $SynchronizedHashTable.Optionshash["CMCreds"]
            }
        }
        else {
            Set-WinVaultCredentials -PSCredential $SynchronizedHashTable.Optionshash["CMCreds"]
        }
    }
    $ServerName = $ServerConnectDataContext.ServerName
    $SiteCode = $ServerConnectDataContext.SiteCode
    $AltCreds = $ServerConnectDataContext.UseAltCredentials
    $SaveCreds = $ServerConnectDataContext.SaveAltCredentials
    "ServerName=$ServerName" > "$ConsolePath\PoshConsoleSettings.txt"
    "SiteCode=$SiteCode" >> "$ConsolePath\PoshConsoleSettings.txt"
    "AltCreds=$AltCreds" >> "$ConsolePath\PoshConsoleSettings.txt"
    "SaveCreds=$SaveCreds" >> "$ConsolePath\PoshConsoleSettings.txt"
    "AltCredsUser=$AltCredsUser" >> "$ConsolePath\PoshConsoleSettings.txt"
    $null = $ServerConnect.Close()
})
 
$null = $ServerConnect.ShowDialog()