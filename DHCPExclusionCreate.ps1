#This script will set a exclusion range on your DHCP Scopes
clear
#Sets the server name that you want to use
$server=read-host "What is the Server Name?"
clear
Get-DHCPServerv4Scope -ComputerName $server
#Sets the ip for the scope
$ScopeId=read-host "What is the IP of the scope you want to set?"
clear
Get-DHCPServerv4ExclusionRange -ComputerName $server |ft StartRange,EndRange -A
#Sets the ip for the start of the range
$StartRange=read-host "What is the Start IP of the scope?"
clear
Get-DHCPServerv4ExclusionRange -ComputerName $server
#Sets the ip for the end of the range
$EndRange=read-host "What is the End IP of the scope?"
Add-DHCPServerv4ExclusionRange -ScopeId $ScopeId -StartRange $StartRange -EndRange $EndRange
.\DHCPConfig.ps1