<#Function Reset-FolderPermissions {
param (
	[Parameter(Mandatory=$true,
				Position=0)]
	[string[]]$FolderPath
)#>
$Folder = 'C:\Users\cpulvermacher\Desktop\New Folder'
$OldPermissions = (Get-Acl $Folder).Access.IdentityReference
foreach ($Permission in $OldPermissions) {
	if ($Permission -match 'aims') {
		Write-Host $Permission
		$acl = Get-Acl $Folder
		$ar = New-Object System.Security.Principal.NTAccount("$Permission")
		$acl.PurgeAccessRules($ar)
		Set-Acl -Path $Folder -AclObject $acl
	}
}