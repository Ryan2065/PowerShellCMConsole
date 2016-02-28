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
            $SynchrnoizedHashTable.WindowDataContext.ProgressVisibility = [System.Windows.Visibility]::Visible
            $SynchrnoizedHashTable.WindowDataContext.GridEnabled = $false
            $BoundaryList = New-Object System.Collections.ObjectModel.ObservableCollection[BoundaryDataGridClass]
            $NameSpace = 'root\sms\site_' + $SynchrnoizedHashTable.OptionsHash["SiteCode"]
            If($SynchrnoizedHashTable.OptionsHash["AltCreds"] -eq 'True') {
                $CIMSession = New-CimSession -Credential $SynchrnoizedHashTable.OptionsHash['CMCreds'] -ComputerName $SynchrnoizedHashTable.OptionsHash['ServerName']
                $Boundaries = Get-CimInstance -Namespace $NameSpace -ClassName 'SMS_Boundary' -CimSession $CIMSession #-ComputerName $SynchrnoizedHashTable.OptionsHash['ServerName']  # -Credential $SynchrnoizedHashTable.OptionsHash['CMCreds']
            }
            else {
                $Boundaries = Get-CimInstance -Namespace $NameSpace -Class 'SMS_Boundary' -ComputerName $SynchrnoizedHashTable.OptionsHash['ServerName']
            }
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
        $SynchrnoizedHashTable.BoundaryGridDataContext.BoundaryList = $BoundaryList
        Log -Message 'Finished getting boundaries!'
        $SynchrnoizedHashTable.WindowDataContext.ProgressVisibility = [System.Windows.Visibility]::Hidden
        $SynchrnoizedHashTable.WindowDataContext.GridEnabled = $true
    }
    try {
        $null = $SynchrnoizedHashTable.BoundaryGridDataContext.BoundaryList.Clear()
    }
    catch{ }
    Start-EphingThreading -ScriptBlock $GatherBoundariesScriptBlock -RunspaceID 'GatherBoundaries'
}

