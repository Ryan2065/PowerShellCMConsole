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
 
$ConsolePath = (Get-Item $PSScriptRoot).Parent.FullName
[xml]$ConnectToServerXAML = Get-Content "$ConsolePath\XAML Library\ConnectToServer.xaml"

# Add assemblies
Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase

# Make window
$ServerConnect = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $ConnectToServerXAML))
$ConnectToServerXAML.SelectNodes("//*[@Name]") | Foreach-Object { Set-Variable -Name (("ServerConnect" + "_" + $_.Name)) -Value $ServerConnect.FindName($_.Name) }
#region CreateClass
Add-Type -Language CSharp @'
using System.ComponentModel;
public class ConnectToServerClass : INotifyPropertyChanged
{
    private string privateServerName;
    public string ServerName
    {
        get { return privateServerName; }
        set
        {
            privateServerName = value;
            NotifyPropertyChanged("ServerName");
        }
    }

    private string privateSiteCode;
    public string SiteCode
    {
        get { return privateSiteCode; }
        set
        {
            privateSiteCode = value;
            NotifyPropertyChanged("SiteCode");
        }
    }

    private bool privateIsChecked;
    public bool IsChecked
    {
        get { return privateIsChecked; }
        set
        {
            privateIsChecked = value;
            NotifyPropertyChanged("IsChecked");
        }
    }

    public event PropertyChangedEventHandler PropertyChanged;
    private void NotifyPropertyChanged(string property)
    {
        if(PropertyChanged != null)
        {
            PropertyChanged(this, new PropertyChangedEventArgs(property));
        }
    }
}

'@
#endregion

$ServerConnectDataContext = New-Object -TypeName 'ConnectToServerClass'
try {
    $PoshConsoleSettings = Get-ItemProperty -Path "HKCU:\Software\PoshCMConsole" -ErrorAction SilentlyContinue
    $ServerConnectDataContext.ServerName = $PoshConsoleSettings.ServerName
    $ServerConnectDataContext.SiteCode = $PoshConsoleSettings.SiteCode
    If($PoshConsoleSettings.AltCreds -eq 'True') { $ServerConnectDataContext.IsChecked = $true }
}
catch {  }
$ServerConnect.DataContext = $ServerConnectDataContext

$ServerConnect_Btn_Save.Add_Click({
    $Global:CMSiteServer = $ServerConnectDataContext.ServerName
    $Global:CMSiteCode = $ServerConnectDataContext.SiteCode
    if($ServerConnectDataContext.IsChecked -eq $true) { $Global:CMCreds = Get-Credential -Message 'Please enter the credentials to connect to the ConfigMgr site server' }
    if(!(Test-Path HKCU:\Software\PoshCMConsole)) {
        $null = New-Item -Path HKCU:\Software\PoshCMConsole -Force
    }
    New-ItemProperty -Path HKCU:\Software\PoshCMConsole -Name 'ServerName' -Value $ServerConnectDataContext.ServerName -Force
    New-ItemProperty -Path HKCU:\Software\PoshCMConsole -Name 'SiteCode' -Value $ServerConnectDataContext.SiteCode -Force
    New-ItemProperty -Path HKCU:\Software\PoshCMConsole -Name 'AltCreds' -Value $ServerConnectDataContext.IsChecked -Force
    $null = $ServerConnect.Close()
})
 
$null = $ServerConnect.ShowDialog()