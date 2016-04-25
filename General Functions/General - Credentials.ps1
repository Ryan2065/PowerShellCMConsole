Function Get-WinVaultCredentials {
<#
    .SYNOPSIS
        Used to get windows credentials from the password vault in Windows 8 and above
 
    .DESCRIPTION
        
   
    .EXAMPLE
        
  
    .NOTES
        AUTHOR: 
        LASTEDIT: 03/09/2016
 
   .LINK
        Used many examples from https://github.com/randorfer/ScorchDev
#>
 
    Param (
        $UserName
    )
    [void][Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime]
    try {
        Log "Getting credential of username $UserName"
        $PasswordVault = New-Object -TypeName Windows.Security.Credentials.PasswordVault
        $PasswordVault.FindAllByUserName($UserName) | ForEach-Object {
            $_.RetrievePassword()
            Log -Message 'Returning credential!'
            New-Object -TypeName pscredential -ArgumentList $_.UserName, (ConvertTo-SecureString -String $_.Password -AsPlainText -Force)
        }

    }
    catch {
        Log -Message 'Error getting credential' -ExceptionObject $_
    }
}

Function Set-WinVaultCredentials {
    <#
    .SYNOPSIS
        
 
    .DESCRIPTION
        
   
    .EXAMPLE
        
  
    .NOTES
        AUTHOR: 
        LASTEDIT: 03/09/2016 16:45:24
 
   .LINK
        
#>
    Param(
        $PSCredential
    )
    try {
        $UserName = $PSCredential.UserName
        Log -Message "Setting vault credentials of user $UserName"
        [void][Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime]
        $PasswordVault = New-Object Windows.Security.Credentials.PasswordVault
        $VaultCredential = New-Object -TypeName Windows.Security.Credentials.PasswordCredential
        $VaultCredential.UserName = $PSCredential.UserName
        $VaultCredential.Resource = ([guid]::NewGuid()).Guid
        $VaultCredential.Password = $PSCredential.GetNetworkCredential().Password
        $PasswordVault.Add($VaultCredential)
        Log -Message "Successfully set credentials!"
    }
    catch {
        Log 'Error setting credential' -ExceptionObject $_
        
    }
}

Function Remove-WinVaultCredentials {
    Param (
        $UserName
    )
    [void][Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime]
    try {
        $PasswordVault = New-Object -TypeName Windows.Security.Credentials.PasswordVault
        $PasswordVault.FindAllByUserName($UserName) | ForEach-Object {
            $PasswordVault.Remove($_)
        }
    }
    catch {
        
    }    
}

