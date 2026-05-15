#This script will create an OU
clear
#Tells the script what you want to call the OU
$OUName=read-host "What is the OUs Name?:`t"
clear
Get-ADOrganizationalUnit -Filter 'Name -like "*"' | FT Name, DistinguishedName -A 
#Tells the script where to put the OU
$OUPath=read-host "What is the path of the OU?:`t"
New-ADOrganizationalUnit -name "$OUName" -Path "$OUPath"
.\ServerADConfig