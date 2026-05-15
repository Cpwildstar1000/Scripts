#This script will create a Forward or Reverse lookup zone in DNS
#User decision between Forward or Reverse
clear
$FoR=read-host "Forward or Reverse Lookup zone?(F/R)"
if ($FoR -eq "F")
	{
	clear
	#Sets the name of the forward lookup zone that you want to use
	$name=read-host "What is the name you want to use?"
	clear
	#Sets the scope type of the Forward lookup zone
	$scope=read-host "Do you want to use Custom, Domain, Forest, or Legacy?"
	Add-DnsServerPrimaryZone -Name $name -ReplicationScope $scope
	}
if ($FoR -eq "R")
	{
	clear
	#Sets the Network ID
	$netid=read-host "What is the Network ID?"
	clear
	#Sets the scope type for the Reverse Lookup zone
	$scope=read-host "Do you want to use Custom, Domain, Forest, or Legacy?"
	Add-DnsServerPrimaryZone -NetworkID $netid -ReplicationScope $scope
	}
.\ServerDNSConfig