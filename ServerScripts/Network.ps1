# This is the Network configuration script
clear
$netInfo=(Get-NetIPConfiguration -InterfaceAlias 10.10.2.0)
$title = "-----------------------`n|Network Configuration|`n-----------------------"
write-host " "
write-host"$netInfo"
write-host "1) Configure IP address"
write-host "2) Configure DNS Server"
write-host "3) Back"
write-host " "
$result=read-host "What do you want to configure?"
switch ($result)
    {
		0{.\IPconfig}
		1{.\DNSconfig}
		2{.\Start}
    }
