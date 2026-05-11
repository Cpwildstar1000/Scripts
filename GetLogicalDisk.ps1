$computer = Read-Host 'What computer are you connecting to?'
$wmi = Get-WmiObject -ComputerName $computer -Class win32_logicaldisk | Select-Object DeviceID
$DriveType = Get-WmiObject -ComputerName $computer -Class win32_logicaldisk | Select-Object DriveType
Get-WmiObject -ComputerName $computer -Class win32_logicaldisk | Where-Object ($DriveType -eq 3) {
	Write-Host $wmi
}
Get-WmiObject -ComputerName $computer -Class win32_logicaldisk | Where-Object ($DriveType -eq 5) {
	Write-Host $wmi
}