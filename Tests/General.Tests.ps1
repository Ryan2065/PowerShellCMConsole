Import-Module Pester

$GeneralFile = ((Get-Item -Path $PSScriptRoot).Parent).FullName + "\General Functions\General.ps1"
. $GeneralFile

Describe 'Process-Options' {
    Context "Should be successful" {
        Mock Get-Item {
            $Returnhash = @{}
            $ReturnHash["Parent"] = @{}
            $ReturnHash.Parent["FullName"] = 'c:\testthis'
            return $Returnhash
        }
        Mock Test-Path { return $true }
        Mock Get-Content {
            $ReturnContent = "ServerName=Lab-CM","SiteCode=PS1","AltCreds=True","AltCredsUser=Home\Administrator"
            return $ReturnContent
        }
        $Global:SynchronizedHashTable = @{}
        It 'Should Fill Hash' {
            Process-Options
            $SynchronizedHashTable.OptionsHash["ServerName"] | Should Be "Lab-CM"
            $SynchronizedHashTable.OptionsHash["SiteCode"] | Should Be "PS1"
            $SynchronizedHashTable.OptionsHash["AltCreds"] | Should Be "True"
            $SynchronizedHashTable.OptionsHash["AltCredsUser"] | Should Be "Home\Administrator"
        }
    }
}