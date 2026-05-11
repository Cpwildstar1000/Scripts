### Script cleans up hardries
cls

### Variables
$ComputerName

### Code Block
## System Information
systeminfo
## Gets drive information
gwmi win32_logicaldisk -ComputerName $ComputerName | select DeviceID,@{n='Free Space()GB';e={"{0:n2}" -f ($_.freespace/1GB)}},@{n='Total Space';e={"{0:n2}" -f ($_.size/1GB)}},@{n='Space(%)';e={'{0:p0}' -f (($_.freespace/1GB)/($_.size/1GB))}}

Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table –AutoSize