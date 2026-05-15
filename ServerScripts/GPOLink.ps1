#This script links a GPO to an OU
clear
#Tells the script what you policy you want to link
$name=read-host "What is the name of the policy that you want to link?`t"
clear
#Tells the script where you want the GPO to be linked
$path=read-host "What is the path that you want the GPO to be linked to?`t"
clear
#Tells the script what order you want the GPO to be applyed
$order=read-host "What is the order you want it in?`t"
clear
#Tells the script whether you want the policy to be enforced
$enforced=read-host "Do you want the policy to be enforced?`t"
clear
#Tells the script whether you want the link to be enabled
$linkenabled=read-host "Do you want the Link to be enabled?`t"
clear
New-GPLink -Name $name -Target $path -Order $order -LinkEnabled $linkenabled -Enforced $enforced
.\ServerGPConfig.ps1