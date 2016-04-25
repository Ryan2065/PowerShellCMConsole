<#
    .SYNOPSIS
        
 
    .DESCRIPTION
        
   
    .EXAMPLE
        
  
    .NOTES
        AUTHOR: 
        LASTEDIT: 02/27/2016 14:21:10
 
   .LINK
        
#>

Function Gather-Boundaries {
    $GatherBoundariesScriptBlock = {
        try{
            Log -Message "Loading boundaries..."
            $SynchronizedHashTable.WindowDataContext.ProgressVisibility = [System.Windows.Visibility]::Visible
            $SynchronizedHashTable.WindowDataContext.GridEnabled = $false
            $BoundaryList = New-Object System.Collections.ObjectModel.ObservableCollection[BoundaryDataGridClass]
            $NameSpace = 'root\sms\site_' + $SynchronizedHashTable.OptionsHash["SiteCode"]
            if ($SynchronizedHashTable.CIMSession -eq $null) {
                If($SynchronizedHashTable.OptionsHash["AltCreds"] -eq 'True') {
                    $SynchronizedHashTable.CIMSession = New-CimSession -Credential $SynchronizedHashTable.OptionsHash['CMCreds'] -ComputerName $SynchronizedHashTable.OptionsHash['ServerName']
                }
                else {
                    $SynchronizedHashTable.CIMSession = New-CimSession -ComputerName -ComputerName $SynchronizedHashTable.OptionsHash['ServerName']
                }               
            }
            $Boundaries = Get-CimInstance -Namespace $NameSpace -ClassName 'SMS_Boundary' -CimSession $SynchronizedHashTable.CIMSession
            foreach ($Boundary in $Boundaries) {
                $BoundaryItem = New-Object -TypeName BoundaryDataGridClass
                $BoundaryItem.Boundary = $Boundary.Value
                Log -Message ("Found Boundary - " + $BoundaryItem.Boundary)
                $BoundaryItem.CreatedBy = $Boundary.CreatedBy
                Switch ($Boundary.BoundaryType) {
                    0 {
                        $BoundaryItem.Type = 'IP Subnet'
                    }
                    1 {
                        $BoundaryItem.Type = 'Active Directory site'
                    }
                    2 {
                        $BoundaryItem.Type = 'IPv6 Prefix'
                    }
                    3 {
                        $BoundaryItem.Type = 'IP address range'
                    }
                }
                $BoundaryItem.Description = $Boundary.DisplayName
                $BoundaryItem.GroupCount = $Boundary.GroupCount
                $BoundaryItem.ModifiedBy = $Boundary.ModifiedBy
                $BoundaryItem.DateModified = $Boundary.ModifiedOn
                $BoundaryItem.DateCreated = $Boundary.CreatedOn
                $BoundaryList.Add($BoundaryItem)
            }
        }
        catch {
            Log -Message "Error loading boundaries" -ErrorMessage $_.Exception.Message
        }
        $SynchronizedHashTable.BoundaryGridDataContext.BoundaryList = $BoundaryList
        Log -Message 'Finished getting boundaries!'
        $SynchronizedHashTable.WindowDataContext.ProgressVisibility = [System.Windows.Visibility]::Hidden
        $SynchronizedHashTable.WindowDataContext.GridEnabled = $true
    }
    try {
        $null = $SynchronizedHashTable.BoundaryGridDataContext.BoundaryList.Clear()
    }
    catch{ }
    Start-EphingThreading -ScriptBlock $GatherBoundariesScriptBlock -RunspaceID 'GatherBoundaries'
}

