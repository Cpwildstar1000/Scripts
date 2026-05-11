Function Setup-ActiveDirectory {
<#
	.SYNOPSIS
		Runs the setup process for Active Directory
	.DESCRIPTION
		Runs the process to install Active Directory on a server and get the install information from a text file that will be created on the desktop.
	.PARAMETER
		a
	.EXAMPLE
		a
#>
    ## Creates ADSetupInfo.ini file for user to edit as desired for Active Directory Install
	If (Test-Path -Path "$env:USERPROFILE\Desktop") {
        New-Item -Path "$env:USERPROFILE\Desktop" -Name ADSetupInfo.ini -ItemType File -Force
    }
    '[General]
    CreateDnsDelegation=False
    DatabasePath="C:\Windows\NTDS"
    DomainMode="Win2012"
    DomainName="ADTest"
    DomainNetbiosName="ADTest"
    ForestMode="Win2012"
    InstallDns=True
    LogPath="C:\Windows\NTDS"
    NoRebootOnCompletion=
    SysvolPath="C:\Windows\SYSVOL"
    Force=True
    ' | Out-File "$env:USERPROFILE\Desktop\ASSetupInfo.txt" -Force
    Write-Host "Please edit the ADSetupInfo.txt file on your desktop then hit enter"
    pause

    ## Imports the settings from the ADSetupInfo.ini file
    $settings = ImportSettingsFile "$env:USERPROFILE\Desktop\ADSetupInfo.ini"
    function ImportSettingsFile {
	    param ($file)

	    $ini = @{}
	    switch -regex -file $file
	    {
    		    "^\[(.+)\]$" {
        		    $section = $matches[1]
        		    $ini[$section] = @{}
    		    }
    		    "([A-Za-z0-9#_]+)=(.+)" {
        		    $name,$value = $matches[1..2]
        		    $ini[$section][$name] = $value.Trim()
    		    }
	    }
	    $ini
    }

    ## Establishes variables for the Active Directory Install
    $CreateDnsDelegation = $settings.General.CreateDnsDelegation
    $DatabasePath = $settings.General.DatabasePath
    $DomainMode = $settings.General.DomainMode
    $DomainName = $settings.General.DomainName
    $DomainNetbiosName = $settings.General.DomainNetbiosName
    $ForestMode = $settings.General.ForestMode
    $InstallDns = $settings.General.InstallDns
    $LogPath = $settings.General.LogPath
    $NoRebootOnCompletion = $settings.General.NoRebootOnCompletion
    $SysvolPath = $settings.General.SysvolPath
    $Force = $settings.General.Force

    ## Edits varables for use in the Active Directory Install
    $CreateDnsDelegation = '$' + $CreateDnsDelegation
    $InstallDns = '$' + $InstallDns
    $NoRebootOnCompletion = '$' + $NoRebootOnCompletion
    $Force = '$' + $Force

    ## Import modules needed to run the commands
    Import-Module ADDSDeployment
    
    ## Run the Install commands
    Install-WindowsFeature ADDSForest -CreateDnsDelegation:$CreateDnsDelegation -DatabasePath $DatabasePath -DomainMode $DomainMode -DomainName $DomainName -DomainNetbiosName $DomainNetbiosName -ForestMode $ForestMode -InstallDns:$InstallDns -LogPath $LogPath -NoRebootOnCompletion:$NoRebootOnCompletion -SysvolPath $SysvolPath -Force:$Force
    Install-WindowsFeature RSAT-ADDS
}