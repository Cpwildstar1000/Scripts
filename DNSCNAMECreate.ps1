#This script will create a CNAME record
clear
#Sets the Alias
$name=read-host "What is the alias you want to assign?"
clear
#Sets the Host that is getting the Alias name
$alias=read-host "What is the host that you want to apply the alias to?(example srv1.lab.domain.local)"
Add-DnsServerResourceRecordCName -Name $name -HostNameAlias $alias -ZoneName $zonename
.\ServerDNSConfig