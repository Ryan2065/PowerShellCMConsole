Function Create-EphingClass {
    Param (
        $ClassName,
        $ClassHash
    )

    $Class = @"
using System.ComponentModel;
using System.Windows;
public class $ClassName : INotifyPropertyChanged
{

"@
    Foreach ($Key in $ClassHash.Keys) {
        $ClassType = $ClassHash[$Key]
        $Class = $Class + @"
        private $ClassType private$Key;
        public $ClassType $key
        {
            get { return private$Key; }
            set
            {
                private$Key = value;
                NotifyPropertyChanged("$Key");
            }
        }
"@
    }
$Class = $Class + @"

    public event PropertyChangedEventHandler PropertyChanged;
    private void NotifyPropertyChanged(string property)
    {
        if(PropertyChanged != null)
        {
            PropertyChanged(this, new PropertyChangedEventArgs(property));
        }
    }
}
"@
    try {
        $null = Add-Type -Language CSharp $Class -ErrorAction SilentlyContinue
        
    }
    catch {
        
    }
}

Function Add-EphingSnippet {
    Param (
        [string]$Header,
        $XAMLControl
    )
    [xml]$SnippetXaml = ''
    $Continue = $false
    $ConsolePath = (Get-Item $PSScriptRoot).Parent.FullName
    If (Test-Path "$ConsolePath\XAML Library\Snippet - $Header.xaml") {
        [xml]$SnippetXaml = Get-Content "$ConsolePath\XAML Library\Snippet - $Header.xaml"
        $Continue = $true
    }
    if ($Continue) {
        $XAMLControl.Children.Clear()
        $Snippet = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $SnippetXaml))
        $null = $XAMLControl.Children.Add($Snippet)
    }
    return $Snippet
}
