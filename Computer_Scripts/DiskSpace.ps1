cls
$ComputerName = Read-Host 'What is the computer you are connecting to?'
$Credential = Read-Host 'What credentials do you want to use?'
cls
Write-Host '1) GB'
Write-Host '2) MB'
$Size = Read-Host "`nWhat do you want the size to be displayed as?"
if ($Size -eq 1) {
	cls
	Get-WmiObject cim_logicaldisk -ComputerName "$ComputerName" -Credential "$Credential" | Sort-Object deviceid | ft deviceid,@{N='Free Space';E={$_.freespace/1073741824}},@{N='Total Space';E={$_.size/1073741824}}
}
if ($Size -eq 2) {
	cls
	Get-WmiObject cim_logicaldisk -ComputerName "$ComputerName" -Credential "$Credential" | Sort-Object deviceid | ft deviceid,@{N='Free Space';E={$_.freespace/1048576}},@{N='Total Space';E={$_.size/1048576}}
}