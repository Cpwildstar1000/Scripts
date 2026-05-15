# This script will configure your IP Address and subnet mask for an adapter
clear
netsh int ipv4 sh int
#sets the adapter that you want to configure
$adapter=read-host "`nWhat adapter do you want to configure:`t"
clear
#sets the IP Address that you want to assign to the adapter
$address=read-host "What is the IP Address that you want?:`t"
clear
#sets the subnet that you are using for the adapter
$subnet=read-host "What is the subnet mask you want (eg. 255.255.255.0):`t"
netsh int ipv4 set address "$adapter" static $address $subnet
.\Start.ps1