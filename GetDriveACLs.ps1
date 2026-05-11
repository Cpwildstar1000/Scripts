Write-Host 'Gathering Folder List'
$Folders = gci C:\ -Recurse
foreach ($Folder in $Folders) {
	Write-Host 'Running'
	$Folder | Out-File C:\Temp\FolderAccess.txt -append
	$ACL = Get-Acl $Folder | Select -ExpandProperty access
	$ACL | Out-File C:\Temp\FolderAccess.txt -append
	$BlankLine = "`n"
	$BlankLine | Out-File C:\Temp\FolderAccess.txt -append
}