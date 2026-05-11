#This script will install Active Directory
clear
$name=read-host "What is the name of the your domain?:`t"
$netbiosname=read-host "What is the netbios name you want to asign?:`t"
clear
Install-WindowsFeature AD-Domain-Services
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "Win2012" `
-DomainName "$name" `
-DomainNetbiosName "CPULVERMACHER" `
-ForestMode "Win2012" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
Install-WindowsFeature RSAT-ADDS
.\RoleSetup
