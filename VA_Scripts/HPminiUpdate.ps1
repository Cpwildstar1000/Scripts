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
$LogFile = "$LogFileLocation" + "$LogFileFullName"

if (!(Test-Path "$LogFile")) {
    New-Item -Path "$LogFileLocation" -Name "$LogFileFullName" -ItemType File
    $FileCreation = "Created log file: $LogFile" | Tee-Object $LogFile -Append
    Write-Host $FileCreation
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
        "Computer is ONLINE" | Tee-Object $LogFile -Append | Write-Host
    }
    else {"Computer $FullComputerName is offline. Please check computer and try again" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Red}
    
    # Continue if computer is online
    if ($Online -eq "1") {
        # Update remote computer
        try {
            "Updating remote computer: $FullComputerName" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
            Invoke-Command -ComputerName $FullComputerName -ScriptBlock {
                ############
                # gpupdate #
                ############
                # Get last gpupdate time before update and display it
                $LastUpdate = [datetime]::FromFileTime(([Int64] ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeHi) -shl 32) -bor ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeLo))
                "Last gpupdate time: $LastUpdate" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Yellow
                # Update the computer (this is a placeholder, replace with actual update commands)
                "Running updates on $env:COMPUTERNAME" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Cyan
                # Example: Install-WindowsUpdate -AcceptAll -AutoReboot
                gpupdate /force
                # Get recent update time and display it
                $CurrentUpdate = [datetime]::FromFileTime(([Int64] ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeHi) -shl 32) -bor ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeLo))
                "Current gpupdate time: $CurrentUpdate" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Yellow
            }
            #################
            # Driver Update #
            #################
            # Confirm connection to driver folder
            if (Test-Path "\\mad-wsitbob\C$") {
                # Get current driver versions and output them to the log file
                $BIOSCommandOutput = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_BIOS | Select-Object SMBIOSBIOSVersion}
                $CurrentBIOSVerion =  (($BIOSCommandOutput) -split "0")[1] | Tee-Object $LogFile -Append | Write-Host
                
                "Intel(R) Wireless Bluetooth (R)" | Tee-Object $LogFile -Append | Write-Host
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Wireless Bluetooth (R)'" | Select-Object DriverVersion} | Tee-Object $LogFile -Append | Write-Host

                "Intel(R) Management Engine WMI Provider" | Tee-Object $LogFile -Append | Write-Host
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Management Engine WMI Provider'" | Select-Object DriverVersion} | Tee-Object $LogFile -Append | Write-Host
                
                "Intel(R) Ethernet Connection (11) I219-LM" | Tee-Object $LogFile -Append | Write-Host
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Ethernet Connection (11) I219-LM'" | Select-Object DriverVersion} | Tee-Object $LogFile -Append | Write-Host

                "Intel(R) Wi-Fi 6 AX201 160MHz" | Tee-Object $LogFile -Append | Write-Host
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Wi-Fi 6 AX201 160MHz'" | Select-Object DriverVersion} | Tee-Object $LogFile -Append | Write-Host

                "Intel(R) UHD Graphics 630" | Tee-Object $LogFile -Append | Write-Host
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) UHD Graphics 630'" | Select-Object DriverVersion} | Tee-Object $LogFile -Append | Write-Host

                "Realtek High Definition Audio" | Tee-Object $LogFile -Append | Write-Host
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Realtek High Definition Audio'" | Select-Object DrvierVersion} | Tee-Object $LogFile -Append | Write-Host


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
                
                if ($CurrentBIOSVerion -lt '2.24.') {
                    Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& '\\MAD-WSITBOB\C$\Shares\Shared\Drivers\HP\HP 600 G6 Mini\BIOS HP S22 Ver.02.24.00 Rev.A, 12-8-2025 sp166136.exe' /s}
                }
                # Wait while installing wireless driver to continue until computer is responding again
                While (!(Test-Connection $FullComputerName)) {Write-Host "Waiting for computer to start connect. If waiting for long period, check computer."}
                # Confirm driver installs are matching versions
                $BIOSCommandOutput = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_BIOS | Select-Object SMBIOSBIOSVersion}
                $CurrentBIOSVerion =  (($BIOSCommandOutput) -split "0")[1] | Tee-Object $LogFile -Append | Write-Host
                
                "Intel(R) Wireless Bluetooth (R)" | Tee-Object $LogFile -Append | Write-Host
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Wireless Bluetooth (R)'" | Select-Object DriverVersion} | Tee-Object $LogFile -Append | Write-Host

                "Intel(R) Management Engine WMI Provider" | Tee-Object $LogFile -Append | Write-Host
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Management Engine WMI Provider'" | Select-Object DriverVersion} | Tee-Object $LogFile -Append | Write-Host
                
                "Intel(R) Ethernet Connection (11) I219-LM" | Tee-Object $LogFile -Append | Write-Host
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Ethernet Connection (11) I219-LM'" | Select-Object DriverVersion} | Tee-Object $LogFile -Append | Write-Host

                "Intel(R) Wi-Fi 6 AX201 160MHz" | Tee-Object $LogFile -Append | Write-Host
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Wi-Fi 6 AX201 160MHz'" | Select-Object DriverVersion} | Tee-Object $LogFile -Append | Write-Host

                "Intel(R) UHD Graphics 630" | Tee-Object $LogFile -Append | Write-Host
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) UHD Graphics 630'" | Select-Object DriverVersion} | Tee-Object $LogFile -Append | Write-Host

                "Realtek High Definition Audio" | Tee-Object $LogFile -Append | Write-Host
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Realtek High Definition Audio'" | Select-Object DrvierVersion} | Tee-Object $LogFile -Append | Write-Host
            }
        "Update completed successfully on $FullComputerName" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
        }
        catch {
            "An error occurred while updating $FullComputerName : $_" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Red
        }   
    }
}
else {
    "Computer DNS records do not match" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Red
}
