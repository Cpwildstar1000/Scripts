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
param(
	[Parameter(Mandatory=$True)]
    $ObjName,
	
	[Parameter(Mandatory=$True)]
    $ObjPath
    )
	
## Body
#$OUPath = Get-ADUser - | select *,@{l='Parent';e={([adsi]"LDAP://$($_.DistinguishedName)").Parent}}
Import-Module ActiveDirectory
$ObjPath = (Get-ADUser -Identity "$ObjName" | Select *,@{l='Parent';e={([adsi]"LDAP://$($_.DistinguishedName)").Parent}}).Parent
$OUPath = $ObjPath -replace 'LDAP://', ''
$Description = (Get-ADUser -Identity "$ObjName" -Properties Description).Description
$NewDescription = "$OUPath" + ' ,' + "$Description"
#Set-ADUser -Identity $ObjName -Description $NewDescription

## Uncomment to test the script
$ObjName | Out-File -LiteralPath C:\Users\ocp\Desktop\UserAccountDescriptionModeifier.txt -Append
$NewDescription | Out-File -LiteralPath C:\users\ocp\Desktop\UserAccountDescriptionModeifier.txt -Append

$Company = (Get-ADUser -Identity "$ObjName" -Properties Company).Company
Switch ($Company) {
	AIMS {
		Administration {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\E$\AIMS\$ObjName" -Description "\\aims-fs-02.aims.wisc.edu\InactiveUserHomeInactiveUserHome" -Recurse -Force}
		Applications {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\E$\AIMS\$ObjName" -Description "\\aims-fs-02.aims.wisc.edu\InactiveUserHomeInactiveUserHome" -Recurse -Force}
		Operations and Support Services {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\E$\AIMS\$ObjName" -Description "\\aims-fs-02.aims.wisc.edu\InactiveUserHomeInactiveUserHome" -Recurse -Force}
	}
	BusSvc {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\G$\BusSvc\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
	CEE {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\E$\CEE\$ObjName" -Description "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
	CQPI {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\E$\CQPI\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
	DCS {
		ACSSS {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\G$\DCS\ACSSS\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		Administration {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\G$\DCS\Administration\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		IMC {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\G$\DCS\IMC\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		LAAS {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\G$\DCS\LAAS\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
	}
	ECE {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\G$\ECE\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
	FPM {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\G$\FPM\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
	INTL {
		MidEast {Move-Item -Path "\\aims.drive.wisc.edu\INTLDiv\Home\MidEast\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		SoAsia {Move-Item -Path "\\aims.drive.wisc.edu\INTLDiv\Home\SoAsia\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		SoEastAsia {Move-Item -Path "\\aims.drive.wisc.edu\INTLDiv\Home\SoEastAsia\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		ISMajor {Move-Item -Path "\\aims.drive.wisc.edu\INTLDiv\Home\ISMajor\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		Africa {Move-Item -Path "\\aims.drive.wisc.edu\INTLDiv\Home\Africa\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		Wage {Move-Item -Path "\\aims.drive.wisc.edu\INTLDiv\Home\WAGE\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		CREECA {Move-Item -Path "\\aims.drive.wisc.edu\INTLDiv\Home\CREECA\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		European {Move-Item -Path "\\aims.drive.wisc.edu\INTLDiv\Home\European\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		GlobalHealth {Move-Item -Path "\\aims.drive.wisc.edu\INTLDiv\Home\GlobalHealth\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		IAP {Move-Item -Path "\\aims.drive.wisc.edu\INTLDiv\Home\IAP\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		DevStudies {Move-Item -Path "\\aims.drive.wisc.edu\INTLDiv\Home\DevStudies\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		LACIS {Move-Item -Path "\\aims.drive.wisc.edu\INTLDiv\Home\LACIS\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		Deans {Move-Item -Path "\\aims.drive.wisc.edu\INTLDiv\Home\Deans\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		EastAsia {Move-Item -Path "\\aims.drive.wisc.edu\INTLDiv\Home\EastAsia\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		IRIS {Move-Item -Path "\\aims.drive.wisc.edu\INTLDiv\Home\IRIS\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
	}
	OCR {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\E$\OCR\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
	OHR {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\G$\OHR\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
	PopHealth {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\E$\PopHealth\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
	RecSports {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\G$\RecSports\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
	UWEBC {
		Staff {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\G$\UWEBC\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		Students {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\G$\UWEBC\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
	}
	VCFA {
		ALS {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\G$\VCFA\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
		BPA {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\G$\VCFA\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
	}
	VCOC {Move-Item -Path "\\aims-fs-03.aims.wisc.edu\G$\VCOC\$ObjName" -Destination "\\aims-fs-02.aims.wisc.edu\InactiveUserHome" -Recurse -Force}
}