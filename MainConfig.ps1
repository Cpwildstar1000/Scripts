#This is the Main Configuration script
clear
$Drives = (Get-WmiObject win32_volume).Name
$workgorup = (Get-WmiObject win32_computersystem).workgroup
$domain = (Get-WmiObject win32_computersystem).domain
if ($workgroup -eq $null)
	{Write-Host "Domain/Workgroup:`tDomain: $domain"}
else
	{Write-Host "Domain/Workgroup:`tWorkgroup: $workgorup"}
Write-Host "Computer Name:`t`t$env:COMPUTERNAME"
Write-Host "Physical Drives:`t$Drives"