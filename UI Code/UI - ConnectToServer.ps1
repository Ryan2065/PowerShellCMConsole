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
    'IsChecked' = 'bool'
}
$result = Create-EphingClass -ClassName 'ConnectToServerClass' -ClassHash $ClassHashTable

$ServerConnectDataContext = New-Object -TypeName 'ConnectToServerClass'

Process-Options

try {
    $ServerConnectDataContext.ServerName = $Global:OptionsHash["ServerName"]
    $ServerConnectDataContext.SiteCode = $Global:OptionsHash["SiteCode"]
    If($Global:OptionsHash["AltCreds"] -eq 'True') { $ServerConnectDataContext.IsChecked = $true }
}
catch {  }
$ServerConnect.DataContext = $ServerConnectDataContext

$ServerConnect_Btn_Save.Add_Click({
    $Global:OptionsHash["ServerName"] = $ServerConnectDataContext.ServerName
    $Global:OptionsHash["SiteCode"] = $ServerConnectDataContext.SiteCode
    if($ServerConnectDataContext.IsChecked -eq $true) { $Global:OptionsHash["CMCreds"] = Get-Credential -Message 'Please enter the credentials to connect to the ConfigMgr site server' }
    $ServerName = $ServerConnectDataContext.ServerName
    $SiteCode = $ServerConnectDataContext.SiteCode
    $AltCreds = $ServerConnectDataContext.IsChecked
    "ServerName=$ServerName" > "$ConsolePath\PoshConsoleSettings.txt"
    "SiteCode=$SiteCode" >> "$ConsolePath\PoshConsoleSettings.txt"
    "AltCreds=$AltCreds" >> "$ConsolePath\PoshConsoleSettings.txt"
    $null = $ServerConnect.Close()
})
 
$null = $ServerConnect.ShowDialog()