$Users = Get-ADUser -Filter 'name -like "*"' -SearchBase 'OU=Intl,DC=aims,DC=wisc,DC=edu'
#$Users = Get-ADUser -Filter 'name -like "Test User1"'
foreach ($User in $Users) {
	<#$Username = $User.SamAccountName
	$OldDisplayName = $User.Name
	$DisplayNameSplit = $OldDisplayName -split " "
	$SplitFirst = $DisplayNameSplit[0]
	$SplitLast = $DisplayNameSplit[1]
	$NewDisplayName = "$SplitLast" + ', ' + "$SplitFirst"#>
	
	$Username = $User.SamAccountName
	$OldName = $User.Name
	$UserDN = $User.DistinguishedName
	$FirstName = $User.GivenName
	$LastName = $User.Surname
	$NewName = "$LastName" + ', ' + "$FirstName"
	Write-Host $NewName
	Set-ADUser -Identity "$Username" -DisplayName "$NewName"
	Rename-ADObject -Identity "$UserDN" -NewName "$NewName"
}