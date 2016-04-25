<#
    .SYNOPSIS
        
 
    .DESCRIPTION
        
   
    .EXAMPLE
        
  
    .NOTES
        AUTHOR: 
        LASTEDIT: 03/03/2016 20:47:56
 
   .LINK
        
#>

$Snippet = Add-EphingSnippet -Header 'Welcome' -XAMLControl $Window_RightGrid
$ConsolePath = (Get-Item $PSScriptRoot).Parent.FullName
[xml]$SnippetXaml = Get-Content "$ConsolePath\XAML Library\Snippet - Welcome.xaml"
$SnippetXaml.SelectNodes("//*[@Name]") | Foreach-Object { Set-Variable -Name (("Window" + "_Welcome_" + $_.Name)) -Value $Snippet.FindName($_.Name) }

$WelcomeClassHash = @{
    'ReleaseNotes' = 'string';
}

Create-EphingClass -ClassName 'WelcomeGridClass' -ClassHash $WelcomeClassHash

$SynchronizedHashTable.WelcomeGridDataContext = New-Object 'WelcomeGridClass'
$Snippet.DataContext = $SynchronizedHashTable.WelcomeGridDataContext

$ReleaseNotesText = New-Object System.IO.StreamReader -ArgumentList "$ConsolePath\ReleaseNotes.txt"


$SynchronizedHashTable.WelcomeGridDataContext.ReleaseNotes = $ReleaseNotesText.ReadToEnd()
$ReleaseNotesText.Close()