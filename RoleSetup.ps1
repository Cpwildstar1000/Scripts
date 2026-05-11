# This is the Role Setup script
clear
$title = "------------`n|Role Setup|`n------------"
write-host " "
write-host "1) Set up Active Directory"
write-host "2) Set up DNS"
write-host "3) Set up DHCP"
write-host "4) Back"
write-host " "
$result=read-host "What do you want to do?"
switch ($result)
    {
		0{.\ADSetup}
		1{.\DNSSetup}
		2{.\DHCPSetup}
		3{.\ServerRoles}
    }
