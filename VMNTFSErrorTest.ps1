$VMList = (Get-VM aimswk-*).name
foreach ($VM in $VMList) {
	#$VM = "$VM" + '.aims.wisc.edu'
	$VM
	Get-Service -ComputerName $VM -ServiceName remoteregistry | Start-Service
	#$ErrorLog = Get-EventLog -ComputerName $VM -LogName System -Source NTFS -EntryType Error
	#$ErrorDate = $ErrorLog.Time
	#$Errors = "$VM" + ', ' + "$ErrorDate"
	#Write-Host $Errors
}