## This script modifys the Description attribute for user accounts
## This script is ment to be run by another program

## Variables

$ObjName = 
$ObjPath = 

## Body
#$OUPath = Get-ADUser - | select *,@{l='Parent';e={([adsi]"LDAP://$($_.DistinguishedName)").Parent}}
$OUPath = $OUPath -replace 'LDAP://', ''
$Description = (Get-ADUser _ -Properties Description).Description
$NewDescription = "$OUPath" + ' ,' + "$Description"
#Set-ADUser -Description $NewDescription

## Uncomment to test the script
$NewDescription | Out-File -LiteralPath C:\Users\ocp\Desktop\UserAccountDescriptionModeifier.txt -Append