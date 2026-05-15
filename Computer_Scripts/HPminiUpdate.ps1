#################
# Things to add #
#################
# Error logging

#################
# Things to Fix #
#################
# Fix Log File output
# Add user confirmation that DNS names match


# Set up Driver Files in array for later copy
$DriverFiles = @(
    'INTEL BLUETOOTH'
    'INTEL MGMT DRIVERS'
    'INTEL NIC DRIVER'
    'INTEL THUNDERBOLT DRIVER'
    'INTEL VIDEO AND CONTROL PANEL'
    'REALTEK AUDIO DRIVER'
    'WIRELESS LAN DRIVERS'
)

# Create and write to file on computer to store the update log
$LogFileLocation = "C:\"
$LogFileName = "HPUpdateLog"
$Date = Get-Date -Format "MMddyy"
$LogFileFormatType = ".txt"
$LogFileFullName = "$LogFileName" + "$Date" + "$LogFileFormatType"
$LogFile = "$LogFileLocation" + "$LogFileFullName"

if (!(Test-Path "$LogFile")) {
    New-Item -Path "$LogFileLocation" -Name "$LogFileFullName" -ItemType File
    "Created log file: $LogFile" | Tee-Object $LogFile -Append | Write-Host
}

# Get computer name and IP address
$ComputerName = Read-Host "Enter the computer name to update"
$FullComputerName = (Resolve-DnsName $ComputerName).Name
$ComputerIP = (Resolve-DnsName $ComputerName).IPAddress
$DNSComputerName = (Resolve-DnsName $ComputerIP).NameHost

# Confirm DNS Names match with user before testing with if statement
"Full Computer Name: $FullComputerName" | Tee-Object $LogFile -Append | Write-Host
"DNS Computer Name: $DNSComputerName" | Tee-Object $LogFile -Append | Write-Host
Write-Host "Please confirm that the Full Computer Name and DNS Computer Name match. If they do not match, please check the computer and try again." -ForegroundColor Yellow
$Confirmation = Read-Host "Do the computer names match? (Y/N)"
if ($Confirmation -eq "Y") {
    "User confirmed computer names match" | Tee-Object $LogFile -Append | Write-Host
#}


# Run gpupdate on computer
#if ($DNSComputerName -eq $FullComputerName) {
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
            ############
            # gpupdate #
            ############
            $LastUpdate = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {
                # Get last gpupdate time before update and display it
                [datetime]::FromFileTime(([Int64] ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeHi) -shl 32) -bor ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeLo))
            }
            "Last gpupdate time: $LastUpdate" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Yellow
            # Update the computer (this is a placeholder, replace with actual update commands)
            "Running updates on $FullComputerName" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Cyan
            # Example: Install-WindowsUpdate -AcceptAll -AutoReboot
            Invoke-Command -ComputerName $FullComputerName -ScriptBlock {gpupdate /force}
            $CurrentUpdate = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {
                # Get recent update time and display it
                [datetime]::FromFileTime(([Int64] ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeHi) -shl 32) -bor ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeLo))
            }
            "Current gpupdate time: $CurrentUpdate" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Yellow
            #################
            # Driver Update #
            #################
            # Copy driver installers locally to computer
            $TestForDriversFolderOnComputer = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Test-Path C:\DriverInstallFiles}
            if (!($TestForDriversFolderOnComputer)) {Invoke-Command -ComputerName $FullComputerName -ScriptBlock {
                New-Item -Path "C:\" -Name "DriverInstallFiles" -ItemType Directory}
                "Folder C:\DriverInstallFiles was created" | Tee-Object $LogFile -Append | Write-Host
            }
            if (Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Test-Path C:\DriverInstallFiles}) {
                foreach ($Driver in $DriverFiles) {
                    Copy-Item -Path "\\mad-wsitbob\C$\Shares\Shared\Drivers\HP\HP 600 G6 Mini\$Driver.exe" -Destination "\\$FullComputerName\C$\DriverInstallFiles\$Driver.exe"
                    "Copied $Driver to $FullComputerName" | Tee-Object $LogFile -Append | Write-Host
                }
            }

            # Get current driver versions and output them to the log file
            $PreUpdateBIOS = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_BIOS | Select-Object SMBIOSBIOSVersion}
            $BIOSTest = (($PreUpdateBIOS) -split "0")[1]
            if ($BIOSTest -lt "2.24.") {"Please update BIOS on device" | Tee-Object $LogFile -Append | Write-Host}
            
            "Intel(R) Wireless Bluetooth(R)" | Tee-Object $LogFile -Append | Write-Host
            $PreUpdateBluetoothDriver = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Wireless Bluetooth(R)'"}
            $PreUpdateBluetoothDriver.DriverVersion | Tee-Object $LogFile -Append | Write-Host -ForegroundColor DarkYellow

            "Intel(R) Management Engine WMI Provider" | Tee-Object $LogFile -Append | Write-Host
            $PreUpdateMGMTDriver = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Management Engine WMI Provider'"}
            $PreUpdateMGMTDriver.DriverVersion | Tee-Object $LogFile -Append | Write-Host -ForegroundColor DarkYellow
            
            "Intel(R) Ethernet Connection (11) I219-LM" | Tee-Object $LogFile -Append | Write-Host
            $PreUpdateEthernetDriver = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Ethernet Connection (11) I219-LM'"}
            $PreUpdateEthernetDriver.DriverVersion | Tee-Object $LogFile -Append | Write-Host -ForegroundColor DarkYellow

            "Intel(R) Wi-Fi 6 AX201 160MHz" | Tee-Object $LogFile -Append | Write-Host
            $PreUpdateWiFiDriver = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Wi-Fi 6 AX201 160MHz'"}
            $PreUpdateWiFiDriver.DriverVersion | Tee-Object $LogFile -Append | Write-Host -ForegroundColor DarkYellow

            "Intel(R) UHD Graphics 630" | Tee-Object $LogFile -Append | Write-Host
            $PreUpdateGraphicsDriver = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) UHD Graphics 630'"}
            $PreUpdateGraphicsDriver.DriverVersion | Tee-Object $LogFile -Append | Write-Host -ForegroundColor DarkYellow

            "Realtek High Definition Audio" | Tee-Object $LogFile -Append | Write-Host
            $PreUpdateAudioDriver = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Realtek High Definition Audio'"}
            $PreUpdateAudioDriver.DriverVersion | Tee-Object $LogFile -Append | Write-Host -ForegroundColor DarkYellow


            # Run installers on remote computer
            Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& 'C:\DriverInstallFiles\INTEL BLUETOOTH.exe' /s}
            "Ran Bluetooth driver update" | Tee-Object $LogFile -Append | Write-Host
            Start-Sleep -Seconds 30
            Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& 'C:\DriverInstallFiles\INTEL MGMT DRIVERS.exe' /s}
            "Ran MGMT driver update" | Tee-Object $LogFile -Append | Write-Host
            Start-Sleep -Seconds 30
            Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& 'C:\DriverInstallFiles\INTEL NIC DRIVER.exe' /s}
            "Ran NIC driver update" | Tee-Object $LogFile -Append | Write-Host
            Start-Sleep -Seconds 30
            Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& 'C:\DriverInstallFiles\INTEL THUNDERBOLT DRIVER.exe' /s}
            "Ran Thunderbolt driver update" | Tee-Object $LogFile -Append | Write-Host
            Start-Sleep -Seconds 30
            Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& 'C:\DriverInstallFiles\INTEL VIDEO AND CONTROL PANEL.exe' /s}
            "Ran Graphics driver update" | Tee-Object $LogFile -Append | Write-Host
            Start-Sleep -Seconds 30
            Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& 'C:\DriverInstallFiles\REALTEK AUDIO DRIVER.exe' /s}
            "Ran Audio driver update" | Tee-Object $LogFile -Append | Write-Host
            Start-Sleep -Seconds 30
            Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& 'C:\DriverInstallFiles\WIRELESS LAN DRIVERS.exe' /s}
            "Ran Wi-Fi driver update" | Tee-Object $LogFile -Append | Write-Host
            Start-Sleep -Seconds 30

            <#if ($PreUpdateBIOS -lt '2.24.') {
                Invoke-Command -ComputerName $FullComputerName -ScriptBlock {& 'C:\DriverInstallFiles\BIOS HP S22 Ver.02.24.00 Rev.A, 12-8-2025 sp166136.exe' /s}
                "Ran BIOS update" | Tee-Object $LogFile -Append | Write-Host
                Start-Sleep -Seconds 30
            }#>

            # Wait while installing wireless driver to continue until computer is responding again
            While (!(Test-Connection $FullComputerName)) {Write-Host "Waiting for computer to start connect. If waiting for long period, check computer."}
            # Confirm driver installs are matching versions
            #$PostUpdateBIOS = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_BIOS | Select-Object SMBIOSBIOSVersion}
            #(($PostUpdateBIOS) -split "0")[1] | Tee-Object $LogFile -Append | Write-Host
            
            "Intel(R) Wireless Bluetooth(R)" | Tee-Object $LogFile -Append | Write-Host
            $PostUpdateBluetoothDriver = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Wireless Bluetooth(R)'"}
            $PostUpdateBluetoothDriver.DriverVersion | Tee-Object $LogFile -Append | Write-Host -ForegroundColor DarkYellow

            "Intel(R) Management Engine WMI Provider" | Tee-Object $LogFile -Append | Write-Host
            $PostUpdateMGMTDriver = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Management Engine WMI Provider'"}
            $PostUpdateMGMTDriver.DriverVersion | Tee-Object $LogFile -Append | Write-Host -ForegroundColor DarkYellow
            
            "Intel(R) Ethernet Connection (11) I219-LM" | Tee-Object $LogFile -Append | Write-Host
            $PostUpdateEthernetDriver = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Ethernet Connection (11) I219-LM'"}
            $PostUpdateEthernetDriver.DriverVersion | Tee-Object $LogFile -Append | Write-Host -ForegroundColor DarkYellow

            "Intel(R) Wi-Fi 6 AX201 160MHz" | Tee-Object $LogFile -Append | Write-Host
            $PostUpdateWiFiDriver = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) Wi-Fi 6 AX201 160MHz'"}
            $PostUpdateWiFiDriver.DriverVersion | Tee-Object $LogFile -Append | Write-Host -ForegroundColor DarkYellow

            "Intel(R) UHD Graphics 630" | Tee-Object $LogFile -Append | Write-Host
            $PostUpdateGraphicsDriver = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Intel(R) UHD Graphics 630'"}
            $PostUpdateGraphicsDriver.DriverVersion | Tee-Object $LogFile -Append | Write-Host -ForegroundColor DarkYellow

            "Realtek High Definition Audio" | Tee-Object $LogFile -Append | Write-Host
            $PostUpdateAudioDriver = Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Get-WMIObject Win32_PNPSignedDriver -Filter "Description='Realtek High Definition Audio'"}
            $PostUpdateAudioDriver.DriverVersion | Tee-Object $LogFile -Append | Write-Host -ForegroundColor DarkYellow

            "Update completed successfully on $FullComputerName" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green

            #########################
            # Clean up driver files #
            #########################
            "Starting cleanup of driver installation folder and files" | Tee-Object $LogFile -Append | Write-Host
            Invoke-Command -ComputerName $FullComputerName -ScriptBlock {Remove-Item C:\DriverInstallFiles -Recurse}
            "Cleaned up driver installation folder and files" | Tee-Object $LogFile -Append | Write-Host
        }
        catch {
            "An error occurred while updating $FullComputerName : $_" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Red
        }   
    }
}
<#else {
    "Computer DNS records do not match" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Red
}#>
else {
    "User did not confirm computer names match. Please check the computer and try again." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Red
    exit
}