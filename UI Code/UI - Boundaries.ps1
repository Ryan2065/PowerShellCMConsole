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

#Add Boundary UI to WindowGrid
$Snippet = Add-EphingSnippet -Header $Window_Tree_MainMenu.SelectedItem.Header -XAMLControl $Window_RightGrid
$ConsolePath = (Get-Item $PSScriptRoot).Parent.FullName
[xml]$SnippetXaml = Get-Content "$ConsolePath\XAML Library\Snippet - Boundaries.xaml"
$SnippetXaml.SelectNodes("//*[@Name]") | Foreach-Object { Set-Variable -Name (("Window" + "_Boundary_" + $_.Name)) -Value $Snippet.FindName($_.Name) }
$ConsolePath = (Get-Item $PSScriptRoot).Parent.FullName

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
}
Create-EphingClass -ClassName 'BoundaryGridClass' -ClassHash $BoundaryClassHash
$SynchrnoizedHashTable.BoundaryGridDataContext = New-Object 'BoundaryGridClass'
$Snippet.DataContext = $SynchrnoizedHashTable.BoundaryGridDataContext

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
#$Window_Boundary_BoundaryDataGrid = $Snippet.FindName('BoundaryDataGrid')
$Window_Boundary_BoundaryDataGrid.Add_SelectionChanged({
    $SelectedItem = $Window_Boundary_BoundaryDataGrid.SelectedItem
    Log -Message $args[0].GetType()
    $SynchrnoizedHashTable.BoundaryGridDataContext.Name = $args[0].SelectedItem.Boundary

})