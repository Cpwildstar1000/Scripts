<# 
 .Synopsis
  Modifies the description field for User Accounts in Active Directory

 .Description
  This Script is built to run with Dell Active Administrator 8.0. It will take the user accounts that Active Administrator finds when you run the inactive accounts section and modify the Description fields for the AD Object

 .Parameter ObjName
  User name for the AD Object.

 .Parameter ObjPath
  OU Path for AD Object.

  
#>
function Modify-UserAccountDescription {
param(
	[Parameter(Mandatory=$True)]
    $ObjName,
	
	[Parameter(Mandatory=$True)]
    $ObjPath
    )
	
## Body
#$OUPath = Get-ADUser - | select *,@{l='Parent';e={([adsi]"LDAP://$($_.DistinguishedName)").Parent}}
$OUPath = $ObjPath -replace 'LDAP://', ''
$Description = (Get-ADUser -Identity $ObjName -Properties Description).Description
$NewDescription = "$OUPath" + ' ,' + "$Description"
#Set-ADUser -Identity $ObjName -Description $NewDescription

## Uncomment to test the script
$ObjName | Out-File -LiteralPath C:\Users\ocp\Desktop\UserAccountDescriptionModeifier.txt -Append
$NewDescription | Out-File -LiteralPath C:\users\ocp\Desktop\UserAccountDescriptionModeifier.txt -Append
}