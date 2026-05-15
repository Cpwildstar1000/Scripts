# This is a call script
clear
$title="-----------------------------`n|Server Configuration Script|`n-----------------------------"
Write-Host "$title"
Write-Host "`n1) Main Configuration"
Write-Host "2) Network Configuration"
Write-Host "3) Server Roles`n"
$result= Read-Host "What do you want to do?"
Switch ($result)
	{
	1 {.\MainConfig}
	2 {.\Network}
	3 {.\ServerRoles}
	}