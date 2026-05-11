##############################
##   User Creation Script   ##
##############################
## CJ Pulvermacher 6/16/2016
##
##
## This script will Create a AD User and a Home drive for that user

#cls

Function UserCreate {
## Get Copy User information
$RequestingUser = Read-Host 'What user do you want to copy? (Last, First)'
$RequestingUserInfo = Get-ADUser -Filter "Name -like '$RequestingUser'"
Write-Host ''
$RequestingUserInfo
Write-Host 'If the users info didnt appear then press ctrl+c' -ForegroundColor Yellow
Write-Host ''

## User Creation Variables
$FirstName = Read-Host 'What is the first name of the person?'
$LastName = Read-Host 'What is the last name of the person?'
$UserName = Read-Host 'What is the username that you want to assign?'
$Name = "$LastName" + ', ' + "$FirstName"
$Password = Read-Host 'What is the password you want to assign?'
$Script = Read-Host 'What is the script you want to assign?'
$Company = Read-Host 'What is the users company?'
$Path = Read-Host 'Where should the user be created?'
$UserAccount = "$UserName" + '@aims.wisc.edu'

## User Creation commands
$AccountTest = (Get-ADUser -Identity $UserName -ErrorAcrion SilentlyContinue)
if (!$AccountTest -and $AccountTest -ne "$UserName") {Write-Host 'Account Doesnt Exist'}
elseif ($AccountTest -eq "$UserName") {Write-Host 'Account Already exists'}
<#New-ADUser -Name $Name -AccountPassword (ConvertTo-SecureString "$Password" -AsPlainText -Force) -Company $Company -DisplayName $Name -Enabled $true -GivenName $FirstName -Path $Path -SamAccountName $UserName -ScriptPath $Script -Surname $LastName -UserPrincipalName $UserAccount

## Home drive Creation variables
switch ($Company) {
	AIMS {$Comp = "\\aims-fs-03.aims.wisc.edu\E$\AIMS\$UserName"}
	BusSvc {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\BusSvc\$UserName"}
	CEE {$Comp = "\\aims-fs-03.aims.wisc.edu\E$\CEE\$UserName"}
	CQPI {$Comp = "\\aims-fs-03.aims.wisc.edu\E$\CQPI\$UserName"}
	DCS {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\DCS\$UserName"}
	ECE {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\ECE\$UserName"}
	FPM {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\FPM\$UserName"}
	OCR {$Comp = "\\aims-fs-03.aims.wisc.edu\E$\OCR\$UserName"}
	OHR {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\OHR\$UserName"}
	PopHealth {$Comp = "\\aims-fs-03.aims.wisc.edu\E$\PopHealth\$UserName"}
	RecSports {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\RecSports\$UserName"}
	UWEBC {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\UWEBC\$UserName"}
	VCFA {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\VCFA\$UserName"}
	VCOC {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\VCOC\$UserName"}
	Test {$Comp = "C:\temp\$UserName"}
	}
#$Path = Read-Host "Folder Path"

## Home drive Creation commands
$Permissions = 0
if (!(Test-Path $Comp))
    {New-Item -ItemType Directory -Path $Comp}
while ($Permissions -le 3) {
	$Permissions
	if ($Permissions -eq 0) {
		$Acl = Get-Acl $Comp
		$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule ("SYSTEM", "FullControl", "Allow")
		$Acl.SetAccessRule($Ar)
		$Acl.SetAccessRuleProtection($true,$false)
		Set-Acl $Comp $Acl
	}
	elseif ($Permissions -eq 1) {
		$Acl = Get-Acl $Comp
		$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule ("Domain Admins", "FullControl", "Allow")
		$Acl.SetAccessRule($Ar)
		$Acl.SetAccessRuleProtection($true,$false)
		Set-Acl $Comp $Acl
	}
	elseif ($Permissions -eq 2) {
		$Acl = Get-Acl $Comp
		$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule ("Administrators", "FullControl", "Allow")
		$Acl.SetAccessRule($Ar)
		$Acl.SetAccessRuleProtection($true,$false)
		Set-Acl $Comp $Acl
	}
	elseif ($Permissions -eq 3) {
		$Acl = Get-Acl $Comp
		$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule ("$UserName", "FullControl", "Allow")
		$Acl.SetAccessRule($Ar)
		$Acl.SetAccessRuleProtection($true,$false)
		Set-Acl $Comp $Acl
	}
	$Permissions = $Permissions + 1
}#>
}

Function UserCopy {
## Get Copy User information
$CopyUser = Read-Host 'What user do you want to copy? (Last, First)'
$CopyUserInfo = Get-ADUser -Filter "Name -like '$CopyUser'"
Write-Host ''
$CopyUserInfo
Write-Host 'If the users info didnt appear then press ctrl+c' -ForegroundColor Yellow
Write-Host ''

## User Creation Variables
$FirstName = Read-Host 'What is the first name of the person?'
$LastName = Read-Host 'What is the last name of the person?'
$UserName = Read-Host 'What is the username that you want to assign?'
$Name = "$LastName" + ', ' + "$FirstName"
$Password = Read-Host 'What is the password you want to assign?'
$Script = Read-Host 'What is the script you want to assign?'
$Company = Read-Host 'What is the users company?'
$Path = Read-Host 'Where should the user be created?'
$UserAccount = "$UserName" + '@aims.wisc.edu'

## User Creation commands
#New-ADUser -Name "$Name" -GivenName "FirstName" -Surname "LastName" -DisplayName "$Name" -SamAccountName "$UserName" -ScriptPath "$Script" -AccountPassword (convertto-securestring "$Password" -asplaintext -force) -Path "$Path" -Enabled $true
New-ADUser -Name $Name -AccountPassword (ConvertTo-SecureString "$Password" -AsPlainText -Force) -Company $Company -DisplayName $Name -Enabled $true -GivenName $FirstName -Path $Path -SamAccountName $UserName -ScriptPath $Script -Surname $LastName -UserPrincipalName $UserAccount

## Add New user to the groups
$CopyUserPath = $CopyUserInfo.DistinguishedName
$CopyUserGroups = (Get-ADPrincipalGroupMembership $CopyUserPath).name
ForEach ($Group in $CopyUserGroups) {
	Add-ADGroupMember -Identity $Group -Members $UserName
}

## Home drive Creation variables
switch ($Company) {
	AIMS {$Comp = "\\aims-fs-03.aims.wisc.edu\E$\AIMS\$UserName"}
	BusSvc {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\BusSvc\$UserName"}
	CEE {$Comp = "\\aims-fs-03.aims.wisc.edu\E$\CEE\$UserName"}
	CQPI {$Comp = "\\aims-fs-03.aims.wisc.edu\E$\CQPI\$UserName"}
	DCS {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\DCS\$UserName"}
	ECE {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\ECE\$UserName"}
	FPM {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\FPM\$UserName"}
	OCR {$Comp = "\\aims-fs-03.aims.wisc.edu\E$\OCR\$UserName"}
	OHR {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\OHR\$UserName"}
	PopHealth {$Comp = "\\aims-fs-03.aims.wisc.edu\E$\PopHealth\$UserName"}
	RecSports {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\RecSports\$UserName"}
	UWEBC {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\UWEBC\$UserName"}
	VCFA {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\VCFA\$UserName"}
	VCOC {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\VCOC\$UserName"}
	Test {$Comp = "C:\temp\$UserName"}
}
#$Path = Read-Host "Folder Path"

## Home drive Creation commands
$Permissions = 0
if (!(Test-Path $Comp))
    {New-Item -ItemType Directory -Path $Comp}
while ($Permissions -le 3) {
	$Permissions
	if ($Permissions -eq 0) {
		$Acl = Get-Acl $Comp
		$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule ("SYSTEM", "FullControl", "Allow")
		$Acl.SetAccessRule($Ar)
		$Acl.SetAccessRuleProtection($true,$false)
		Set-Acl $Comp $Acl
	}
	elseif ($Permissions -eq 1) {
		$Acl = Get-Acl $Comp
		$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule ("Domain Admins", "FullControl", "Allow")
		$Acl.SetAccessRule($Ar)
		$Acl.SetAccessRuleProtection($true,$false)
		Set-Acl $Comp $Acl
	}
	elseif ($Permissions -eq 2) {
		$Acl = Get-Acl $Comp
		$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule ("Administrators", "FullControl", "Allow")
		$Acl.SetAccessRule($Ar)
		$Acl.SetAccessRuleProtection($true,$false)
		Set-Acl $Comp $Acl
	}
	elseif ($Permissions -eq 3) {
		$Acl = Get-Acl $Comp
		$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule ("$UserName", "FullControl", "Allow")
		$Acl.SetAccessRule($Ar)
		$Acl.SetAccessRuleProtection($true,$false)
		Set-Acl $Comp $Acl
	}
	$Permissions = $Permissions + 1
}
}


## USer Choice Section
$Choice = Read-Host '[1] Create User, [2] Copy User'
if ($Choice -eq "1") {. UserCreate}
	elseif ($Choice -eq "2")  {. UserCopy}