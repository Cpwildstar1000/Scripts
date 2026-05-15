#################
# Things to add #
#################
# Error logging


# Create and write to file on computer to store the update log
$LogFileLocation = "C:\"
$LogFileName = "HPUpdateLog"
$Date = Get-Date -Format "MMddyy"
$LogFileFormatType = ".txt"
$LogFileFullName = "$LogFileName" + "$Date" + "$LogFileFormatType"
$script:LogFile = "$LogFileLocation" + "$LogFileFullName"

if (!(Test-Path "$LogFile")) {
    New-Item -Path "$LogFileLocation" -Name "$LogFileFullName" -ItemType File
}

# Get computer name and IP address
$ComputerName = Read-Host "Enter the computer name to update"
$FullComputerName = (Resolve-DnsName $ComputerName).Name
$ComputerIP = (Resolve-DnsName $ComputerName).IPAddress
$DNSComputerName = (Resolve-DnsName $ComputerIP).NameHost

# Run gpupdate on computer
if ($DNSComputerName -eq $FullComputerName) {
    # Test if computer is responding
    $Online = 0
    if (Test-Connection $FullComputerName -Count 1 -Quiet) {
        $Online = 1
        Write-Host "Computer is ONLINE" | Out-File $LogFile -Append
    }
    else {Write-Host "Computer $FullComputerName is offline. Please check computer and try again"}
    
    # Continue if computer is online
    if ($Online -eq "1") {
        # Update remote computer
        try {
            Write-Host "Updating remote computer: $FullComputerName" -ForegroundColor Green
            Invoke-Command -ComputerName $FullComputerName -ScriptBlock {
                ############
                # gpupdate #
                ############
                # Get last gpupdate time before update and display it
                $LastUpdate = [datetime]::FromFileTime(([Int64] ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeHi) -shl 32) -bor ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeLo))
                $LastGPUpdate = Write-Host "Last gpupdate time: $LastUpdate" -ForegroundColor Yellow
                $LastGPUpdate | Out-File $LogFile -Append
                $LastGPUpdate
                # Update the computer (this is a placeholder, replace with actual update commands)
                $RunningGPUpdate = Write-Host "Running updates on $env:COMPUTERNAME" -ForegroundColor Cyan
                $RunningGPUpdate | Out-File $LogFile -Append
                $RunningGPUpdate
                # Example: Install-WindowsUpdate -AcceptAll -AutoReboot
                gpupdate /force
                # Get recent update time and display it
                $CurrentUpdate = [datetime]::FromFileTime(([Int64] ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeHi) -shl 32) -bor ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeLo))
                $CurrentGPUpdate = Write-Host "Current gpupdate time: $CurrentUpdate" -ForegroundColor Yellow
                $CurrentGPUpdate | Out-File $LogFile -Append
                $CurrentGPUpdate
            }
            #################
            # Driver Update #
            #################
            # Confirm connection to driver folder
            if (Test-Path "\\mad-wsitbob\C$") {
                # Get current driver versions and output them to the log file
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_BIOS | Select-Object SMBIOSBIOSVersion} | Out-File $LogFile -Append
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Wireless Bluetooth (R)'"} | Out-File $LogFile -Append
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Management Engine WMI Provider'"} | Out-File $LogFile -Append
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Ethernet Connection (11) I219-LM'"} | Out-File $LogFile -Append
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Wi-Fi 6 AX201 160MHz'"} | Out-File $LogFile -Append
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) UHD Graphics 630'"} | Out-File $LogFile -Append
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Realtek High Definition Audio'"} | Out-File $LogFile -Append

                # Run installers on remote computer
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& '\\MAD-WSITBOB\C$\Shares\Shared\Drivers\HP\HP 600 G6 Mini\INTEL BLUETOOTH.exe' /s}
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& '\\MAD-WSITBOB\C$\Shares\Shared\Drivers\HP\HP 600 G6 Mini\INTEL MGMT DRIVERS.exe' /s}
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& '\\MAD-WSITBOB\C$\Shares\Shared\Drivers\HP\HP 600 G6 Mini\INTEL NIC DRIVER.exe' /s}
                Start-Sleep -Seconds 30
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& '\\MAD-WSITBOB\C$\Shares\Shared\Drivers\HP\HP 600 G6 Mini\INTEL THUNDERBOLT DRIVER.exe' /s}
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& '\\MAD-WSITBOB\C$\Shares\Shared\Drivers\HP\HP 600 G6 Mini\INTEL VIDEO AND CONTROL PANEL.exe' /s}
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& '\\MAD-WSITBOB\C$\Shares\Shared\Drivers\HP\HP 600 G6 Mini\REALTEK AUDIO DRIVER.exe' /s}
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& '\\MAD-WSITBOB\C$\Shares\Shared\Drivers\HP\HP 600 G6 Mini\WIRELESS LAN DRIVERS.exe' /s}
                Start-Sleep -Seconds 30
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& '\\MAD-WSITBOB\C$\Shares\Shared\Drivers\HP\HP 600 G6 Mini\INTEL BLUETOOTH.exe' /s}
                
                # Check current BIOS version and install 
                $BIOSCommandOutput = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_BIOS | Select-Object SMBIOSBIOSVersion}
                $CurrentBIOSVerion =  (($BIOSCommandOutput) -split "0")[1]
                if ($CurrentBIOSVerion -lt '2.24.') {
                    Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& '\\MAD-WSITBOB\C$\Shares\Shared\Drivers\HP\HP 600 G6 Mini\BIOS HP S22 Ver.02.24.00 Rev.A, 12-8-2025 sp166136.exe' /s}
                }
                # Wait while installing wireless driver to continue until computer is responding again
                While (!(Test-Connection $FullComputerName)) {Write-Host "Waiting for computer to start connect. If waiting for long period, check computer."}
                # Confirm driver installs are matching versions
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_BIOS | Select-Object SMBIOSBIOSVersion} | Out-File $LogFile -Append
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Wireless Bluetooth (R)'"} | Out-File $LogFile -Append
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Management Engine WMI Provider'"} | Out-File $LogFile -Append
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Ethernet Connection (11) I219-LM'"} | Out-File $LogFile -Append
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Wi-Fi 6 AX201 160MHz'"} | Out-File $LogFile  -Append
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) UHD Graphics 630'"} | Out-File $LogFile -Append
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Realtek High Definition Audio'"} | Out-File $LogFile -Append
            }
        $Success = Write-Host "Update completed successfully on $FullComputerName" -ForegroundColor Green
        $Success | Out-File $LogFile -Append
        $Success
        }
        catch {
            $Failure = Write-Host "An error occurred while updating $FullComputerName : $_" -ForegroundColor Red
            $Failure | Out-File $LogFile -Append
            $Failure
        }   
    }
}
else {
    $DNSFailure = Write-Host "Computer DNS records do not match" -ForegroundColor Red
    $DNSFailure | Out-File $LogFile -Append
    $DNSFailure
}
