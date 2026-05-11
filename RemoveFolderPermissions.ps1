Function Reset-FolderPermissions {
param (
	[Parameter(Mandatory=$true,
				Position=0)]
	[string[]]$FolderPath
)

$OldPermissions = (Get-Acl $FolderPath).Access.IdentityReference
foreach ($Permission in $OldPermissions) {
	if ($Permission -match 'aims') {
		Write-Host $Permission
	}
}