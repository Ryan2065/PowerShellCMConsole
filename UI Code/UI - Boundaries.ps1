<#
    .SYNOPSIS
        Boundary UI Code
 
    .DESCRIPTION
        
   
    .EXAMPLE
        
  
    .NOTES
        AUTHOR: 
        LASTEDIT: 02/27/2016 13:42:46
 
   .LINK
        
#>
(Get-PSCallStack)[0].Command
#Add Boundary UI to WindowGrid
$Snippet = Add-EphingSnippet -Header $Window_Tree_MainMenu.SelectedItem.Header -XAMLControl $Window_RightGrid
$ConsolePath = (Get-Item $PSScriptRoot).Parent.FullName
[xml]$SnippetXaml = Get-Content "$ConsolePath\XAML Library\Snippet - Boundaries.xaml"
$SnippetXaml.SelectNodes("//*[@Name]") | Foreach-Object { Set-Variable -Name (("Window" + "_Boundary_" + $_.Name)) -Value $Snippet.FindName($_.Name) }

#Create Class for main boundary grid
$BoundaryClassHash = @{
    'Filter' = 'string';
    'BoundaryList' = 'object';
    'Name' = 'string';
    'Description' = 'string';
    'TypeLabel1' = 'string';
    'ADSite' = 'string';
    'TypeText1' = 'string';
    'EndIPAddress' = 'string';
    'SiteSystemItemSource' = 'object';
    'BoundaryGroupItemSource' = 'object';
    'ComboType' = 'string';
    'TypeLabel1Visibility' = 'object';
    'ADSiteBrowseVisibility' = 'object';
    'TypeText1Visibility' = 'object';
    'LabelEndIPVisibility' = 'object';
    'TextEndIPVisibility' = 'object';
}
Create-EphingClass -ClassName 'BoundaryGridClass' -ClassHash $BoundaryClassHash
$SynchronizedHashTable.BoundaryGridDataContext = New-Object 'BoundaryGridClass'
$Snippet.DataContext = $SynchronizedHashTable.BoundaryGridDataContext

#create class for the datagrid
$BoundaryDataGridClassHash = @{
    'Boundary' = 'string';
    'Type' = 'string';
    'Description' = 'string';
    'GroupCount' = 'int';
    'DateCreated' = 'System.DateTime'
    'CreatedBy' = 'string';
    'DateModified' = 'System.DateTime'
    'ModifiedBy' = 'string';
}
Create-EphingClass -ClassName 'BoundaryDataGridClass' -ClassHash $BoundaryDataGridClassHash

. "$ConsolePath\Worker Functions\Worker - Boundaries.ps1"
Gather-Boundaries

$Window_Boundary_BoundaryDataGrid.Add_SelectionChanged({
    $SelectedItem = $Window_Boundary_BoundaryDataGrid.SelectedItem
    
    $SynchronizedHashTable.BoundaryGridDataContext.Name = $args[0].SelectedItem.Boundary
    $SynchronizedHashTable.BoundaryGridDataContext.Description = $args[0].SelectedItem.Description
    $SynchronizedHashTable.BoundaryGridDataContext.ComboType = $args[0].SelectedItem.Type
    Switch ($SynchronizedHashTable.BoundaryGridDataContext.ComboType) {
        'IP subnet' {
            $SynchronizedHashTable.BoundaryGridDataContext.TypeLabel1 = 'Subnet ID:'
            $SynchronizedHashTable.BoundaryGridDataContext.TypeText1 = $args[0].SelectedItem.Boundary
            $SynchronizedHashTable.BoundaryGridDataContext.TypeLabel1Visibility = [System.Windows.Visibility]::Visible
            $SynchronizedHashTable.BoundaryGridDataContext.ADSiteBrowseVisibility = [System.Windows.Visibility]::Hidden
            $SynchronizedHashTable.BoundaryGridDataContext.TypeText1Visibility = [System.Windows.Visibility]::Visible
            $SynchronizedHashTable.BoundaryGridDataContext.LabelEndIPVisibility = [System.Windows.Visibility]::Hidden
            $SynchronizedHashTable.BoundaryGridDataContext.TextEndIPVisibility = [System.Windows.Visibility]::Hidden
        }
        'Active Directory site' {
            $SynchronizedHashTable.BoundaryGridDataContext.TypeLabel1 = 'Active Directory Site Name:'
            $SynchronizedHashTable.BoundaryGridDataContext.ADSite = $args[0].SelectedItem.Boundary
            $SynchronizedHashTable.BoundaryGridDataContext.TypeLabel1Visibility = [System.Windows.Visibility]::Visible
            $SynchronizedHashTable.BoundaryGridDataContext.ADSiteBrowseVisibility = [System.Windows.Visibility]::Visible
            $SynchronizedHashTable.BoundaryGridDataContext.TypeText1Visibility = [System.Windows.Visibility]::Hidden
            $SynchronizedHashTable.BoundaryGridDataContext.LabelEndIPVisibility = [System.Windows.Visibility]::Hidden
            $SynchronizedHashTable.BoundaryGridDataContext.TextEndIPVisibility = [System.Windows.Visibility]::Hidden
        }
        'IPv6 prefix' {
            $SynchronizedHashTable.BoundaryGridDataContext.TypeLabel1 = 'Prefix:'
            $SynchronizedHashTable.BoundaryGridDataContext.TypeText1 = $args[0].SelectedItem.Boundary
            $SynchronizedHashTable.BoundaryGridDataContext.TypeLabel1Visibility = [System.Windows.Visibility]::Visible
            $SynchronizedHashTable.BoundaryGridDataContext.ADSiteBrowseVisibility = [System.Windows.Visibility]::Hidden
            $SynchronizedHashTable.BoundaryGridDataContext.TypeText1Visibility = [System.Windows.Visibility]::Visible
            $SynchronizedHashTable.BoundaryGridDataContext.LabelEndIPVisibility = [System.Windows.Visibility]::Hidden
            $SynchronizedHashTable.BoundaryGridDataContext.TextEndIPVisibility = [System.Windows.Visibility]::Hidden
        }
        'IP address range' {
            $SynchronizedHashTable.BoundaryGridDataContext.TypeLabel1 = 'Starting IP Address:'
            $IPRange = ($args[0].SelectedItem.Boundary).Split('-')
            $SynchronizedHashTable.BoundaryGridDataContext.TypeText1 = $IPRange[0]
            $SynchronizedHashTable.BoundaryGridDataContext.EndIPAddress = $IPRange[1]
            $SynchronizedHashTable.BoundaryGridDataContext.TypeLabel1Visibility = [System.Windows.Visibility]::Visible
            $SynchronizedHashTable.BoundaryGridDataContext.ADSiteBrowseVisibility = [System.Windows.Visibility]::Hidden
            $SynchronizedHashTable.BoundaryGridDataContext.TypeText1Visibility = [System.Windows.Visibility]::Visible
            $SynchronizedHashTable.BoundaryGridDataContext.LabelEndIPVisibility = [System.Windows.Visibility]::Visible
            $SynchronizedHashTable.BoundaryGridDataContext.TextEndIPVisibility = [System.Windows.Visibility]::Visible
        }
    }
})