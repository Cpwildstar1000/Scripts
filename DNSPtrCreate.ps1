#This script will create a Ptr record
clear
#Sets the name of the Ptr record
$name=read-host "What is the name of the Ptr record that you want to add?"
clear
#Sets the zone name of the Ptr record
$zonename=read-host "What is the reverse lookup name you want to use?(example 1.2.3.in-addr-arpa)"
clear
#Sets the name of the A record that you want to connect the Ptr record to
$ptrdomainname=read-host "What is the name of the A Record your connecting it to?(example host17.domain.local)"
Add-DnsServerResourceRecordPtr -Name $name -ZoneName $zonename -AllowUpdateAny -TimeToLive $TTL -PtrDomainName $ptrdomainname
.\ServerDNSConfig