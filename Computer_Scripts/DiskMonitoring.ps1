# Get directory lists
$userid = Get-WmiObject win32_computersystem | Select-Object -ExpandProperty username
$objUser = New-Object System.Security.Principal.NTAccount("$userid")
$UserSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier]).Value 
# Get the environment variables needed.
$UserProfile = (Get-ItemProperty "Registry::\HKEY_USERS\$UserSID\Volatile Environment").UserProfile
try {$OneDrivePath = (Get-ItemProperty "Registry::\HKEY_USERS\$UserSID\Environment").OneDriveCommercial}
catch {$OneDrivePath = "None"}

if ($OneDrivePath -eq "None") {
	if (!(Test-Path "$UserProfile\Desktop\DiskMonitoring\Computers.txt")) {
		$MonitoringPath = "$UserProfile\Desktop\DiskMonitoring"
		New-Item -Path "$UserProfile\Desktop\DiskMonitoring\" -Name "Computers.txt" -ItemType File
		Write-Host "Please add computers to $UserProfile\Desktop\DiskMonitoring\Computers.txt and press enter."
		Pause
	}
}
else {
	if (!(Test-Path "$OneDrivePath\Desktop\DiskMonitoring\Computers.txt")) {
		$MonitoringPath = "$OneDrivePath\Desktop\DiskMonitoring"
		New-Item -Path "$OneDrivePath\Desktop\DiskMonitoring\" -Name "Computers.txt" -ItemType File
		Write-Host "Please add computers to $OneDrivePath\Desktop\DiskMonitoring\Computers.txt and press enter."
		Pause
	}
}

$i = 0
$DateTime = Get-Date -Format "MM-dd-yyyy-HHmmss"

while ($i -eq 0) {
	$computers = Get-Content $MonitoringPath\Desktop\DiskMonitoring\Computers.txt
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