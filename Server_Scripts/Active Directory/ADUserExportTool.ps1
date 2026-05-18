$SearchBase = Read-host "What OU do you want to search? (eg. 'ou=Users,dc=contoso,dc=com')"
$users = Get-ADUser -Filter * -Properties * -SearchBase $SearchBase
foreach ($user in $users)
{
	$DesktopPath = [System.Environment]::GetFolderPath("Desktop")
    (Get-ADUser -Identity $user -Properties MemberOf).MemberOf -replace '^CN=([^,]+),OU=.+$','$1' | Out-File $DesktopPath\users.txt
    }