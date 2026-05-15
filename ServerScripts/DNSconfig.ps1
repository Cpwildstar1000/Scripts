# This script will configure your DNS address for an adapter
clear
netsh int ipv4 sh int
#Sets the adapter that you want to use
$adapter=read-host "`nWhat adapter do you want to configure:`t"
clear
#Sets the DNS Adress that you want to apply
$dns=read-host "What is the DNS address that you want to assign?:`t"
netsh int ipv4 set dns "$adapter" static $dns
.\Start.ps1