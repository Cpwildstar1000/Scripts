<#	
	.NOTES
	===========================================================================
	 Edited:
		CJ Pulvermacher	6/12/2018
	===========================================================================
	.DESCRIPTION
		Gets Users in Active Directory with Inheritance Disabled and create a CSV
#>

$Users = @()
$UserStatuses = @()

"Reading OU List ..."
$Users = Get-ADOrganizationalUnit -Filter * -Properties * | sort canonicalname | select distinguishedname, canonicalname

"Reading Container List ..."
$Users += Get-ADObject -SearchBase "ou=user accounts,ou=managed users,dc=uhs,dc=wisc,dc=edu" -SearchScope OneLevel -LDAPFilter '(objectClass=User)' -Properties * | sort canonicalname | select distinguishedname, canonicalname
#$Containers += Get-ADObject -SearchBase (Get-ADDomain).distinguishedname -SearchScope OneLevel -LDAPFilter '(objectClass=user)' -Properties * | sort canonicalname | select distinguishedname, canonicalname

foreach ($Usr in $Users)
{
	"Evaluating - " + $Usr.distinguishedname + " ..."
	
	$UserStatuses += Get-ADUser -Filter * -SearchBase $Usr.distinguishedname -SearchScope OneLevel -Properties * | where { ($_.nTSecurityDescriptor.AreAccessRulesProtected -eq $true) -and ($_.enabled -eq $true) } | select @{ n = 'OU'; e = { $Usr.distinguishedname } }, displayname, userprincipalname, samAccountName, @{ n = 'Inheritance Broken'; e = { $_.nTSecurityDescriptor.AreAccessRulesProtected } }
}

$UserStatuses | export-csv -path UsersWithInheritanceBroken.csv
