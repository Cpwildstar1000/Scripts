#This script will create an A record in DNS
#Sets the name of the Record that you want to create
clear
$name=read-host "What do you want to name the A record?"
clear
#Sets the name of the zone that the A record will be put in
$zonename=read-host "What is the name of the zone that you are adding the record to?"
clear
#Sets the IP Address that will be assigned to the A record
$ipaddress=read-host"What is the IP Address that you want to assign?"
Add-DnsServerResourceRecordA -Name $name -ZoneName $zonename -AllowUpdateAny -IPv4Address $ipaddress -TimeToLive $TTL
.\ServerDNSConfig