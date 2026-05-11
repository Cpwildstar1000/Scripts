# This is the Role Configuration script
clear
$title = "--------------------`n|Role Configuration|`n--------------------"
write-host " "
write-host "1) Configure Active Directory"
write-host "2) Configure DNS"
write-host "3) Configure DHCP"
write-host "4) Configure Group Policy"
write-host "5) Back"
Write-Host " "
$result=read-host "What do you want to configure?"
switch ($result)
    {
		0{.\ServerADConfig}
		1{.\ServerDNSConfig}
		2{.\ServerDHCPConfig}
		3{.\ServerGPConfig}
		4{.\ServerRoles}
    }
