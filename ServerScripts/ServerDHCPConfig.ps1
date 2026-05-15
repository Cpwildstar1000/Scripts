# This is the call script for DHCP
clear
$title = "--------------------|DHCP Configuration|--------------------"
write-host " "
write-host "1)Create a DHCP Scope"
write-host "2)Create a DHCP Exclusion"
write-host "3) Back"
write-host " "
$result=read-host "What do you want to do?"
switch ($result)
    {
		0{.\DHCPScopeCreate.ps1}
		1{.\DHCPExclusionCreate.ps1}
		2{.\RoleConfig.ps1}
	}