$Groups = Get-ADGroup -Properties * -Filter * -SearchBase "OU=Users,DC=AIMS,DC=WISC,DC=EDU"
Foreach($G In $Groups)
{
	Write-Host $G.Name
	Write-Host "-------------"
	$G.Members
}