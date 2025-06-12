#cls
#$AIMSCredentials = Read-Host 'What are your AIMS credentials?'
#$FPMCredentials = Read-Host 'What are your FPM credentials?'
cls
$i = 0
$DateTime = Get-Date -Format "MM-dd-yyyy-HHmmss"

while ($i -eq 0) {
	cls
	$computers = Get-Content C:\Users\cpulvermacher\Desktop\DiskMonitoring\Computers.txt
	Foreach ($computer in $computers) {
		$disks = Get-WmiObject -ComputerName $computer -Class win32_LogicalDisk -Filter "DriveType = 3"
		$computer = $computer.toupper()
		Foreach ($disk in $disks) {
			#Gets drive information
			$deviceid = $disk.DeviceID
			if ($deviceid -eq 'C:') {
				$volumename = $disk.VolumeName
				$size = $disk.Size
				$freespace = $disk.FreeSpace
				$persentFree = [Math]::Round(($freespace / $size) * 100)
				$freespaceMB = [Math]::Round($freespace / 1048576)
				$sizeMB = [Math]::Round($size / 1048576)
				
				# Gets RAN information
				$RAM = Get-WmiObject -ComputerName $computer -Class win32_OperatingSystem
				$RAMTotal = $RAM.TotalVisibleMemorySize
				$RAMAvalible = $RAM.FreePhysicalMemory
				$RAMPercent = [Math]::Round(($RAMAvalible / $RAMTotal) * 100)
				
				# Gets CPU percent usage information
				$CPU = Get-WmiObject -ComputerName $computer -Class win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average
				$CPUPercent = [Math]::Round($CPU)
			
				#Outputs data to console
				if ($freespaceMB -lt 1000 -or $RAMPercent -ge 90 -or $CPUPercent -ge 90) {
					Write-Host "$computer" `n 'DeviceID' `t 'Free' `t 'Total' `t 'Disk Percent' `t 'RAM Percent' `t 'CPU Percent' `n "$deviceid" `t`t "$freespaceMB" `t "$sizeMB" `t "$persentFree%" `t`t "$RAMPercent%" `t`t "$CPUPercent%" `n -foregroundcolor red
				}
				
				elseif ($RAMPercent -ge 70 -or $CPUPercent -ge 70) {
					Write-Host "$computer" `n 'DeviceID' `t 'Free' `t 'Total' `t 'Disk Percent' `t 'RAM Percent' `t 'CPU Percent' `n "$deviceid" `t`t "$freespaceMB" `t "$sizeMB" `t "$persentFree%" `t`t "$RAMPercent%" `t`t "$CPUPercent%" `n -foregroundcolor yellow
				}
				
				else {
					Write-Host "$computer" `n 'DeviceID' `t 'Free' `t 'Total' `t 'Disk Percent' `t 'RAM Percent' `t 'CPU Percent' `n "$deviceid" `t`t "$freespaceMB" `t "$sizeMB" `t "$persentFree%" `t`t "$RAMPercent%" `t`t "$CPUPercent%" `n
				}
			}
		}
	}
	Start-Sleep -s 300
}