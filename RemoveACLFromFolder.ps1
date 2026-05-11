$folder = Read-Host "What folder do you want to remove an account from?"
cls
Get-Acl -Path $folder
Write-Host "`n"
$user = Read-Host "What user do you want to remove?"
$acl = Get-Acl -Path $folder
$ar = New-Object system.Security.Principal.NTAccount("$user")
$acl.PurgeAccessRules($ar)
Set-Acl -Path $folder -AclObject $acl
cls