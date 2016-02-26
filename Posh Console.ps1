<#
    .SYNOPSIS
        
 
    .DESCRIPTION
        
   
    .EXAMPLE
        
  
    .NOTES
        AUTHOR: 
        LASTEDIT: 02/23/2016 17:22:18
 
   .LINK
        
#>


[xml]$xaml = Get-Content "$PSScriptRoot\XAML Library\MainWindow.xaml"
# Add assemblies
Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase

# Make window
$Window = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))
$xaml.SelectNodes("//*[@Name]") | Foreach-Object { Set-Variable -Name (("Window" + "_" + $_.Name)) -Value $Window.FindName($_.Name) }
#region CreateClass
Add-Type -Language CSharp @'

using System.ComponentModel;

public class WindowClass : INotifyPropertyChanged
{
    private string privateBoundaryFilterText;
    public string BoundaryFilterText
    {
        get { return privateBoundaryFilterText; }
        set
        {
            privateBoundaryFilterText = value;
            NotifyPropertyChanged("BoundaryFilterText");
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

 
$Window_MI_Connect.Add_Click({

})
  
$Window_MI_Exit.Add_Click({

})
  
$Window_BoundaryDelete.Add_Click({

})

$Window_Txt_BoundaryFilter.Add_KeyDown({
    $args[1].Key.ToString()
})
 
$Window.ShowDialog() | Out-Null
