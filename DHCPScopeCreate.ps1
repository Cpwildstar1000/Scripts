#This file will create a DHCP scope
clear
#sets the name of the scope your creating
$Name=read-host "What is the name of the scope that you want to create?`t"
clear
#sets the starting IP Address that you want to assign
$StartIp=read-host "What is the start ip address?`t"
clear
#sets the ending IP Address that you want to assign
$EndIp=read-host "What is the end ip address?`t"
clear
#sets the subnet of the scope you are creating
$Subnet=read-host "What is the subnet mask you want to assign`t"
clear
#sets the name of the DHCP server that you want to use
$DHCPServerName=read-host "What is the name of the DHCP Server?`t"
clear
add-dhcpserverv4scope -name $Name -StartRange $StartIp -EndRange $EndIp -SubnetMask $Subnet -cn $DHCPServerName
.\DHCPConfig.ps1