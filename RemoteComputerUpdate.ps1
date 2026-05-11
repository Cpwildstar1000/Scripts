# Get computer name
$ComputerName = Read-Host "Enter the computer name to update"
$FullComputerName = (Resolve-DnsName $ComputerName).Name
if ($ComputerName -eq $FullComputerName) {
    # Update remote computer
    try {
        Write-Host "Updating remote computer: $FullComputerName" -ForegroundColor Green
        Invoke-Command -ComputerName $FullComputerName -ScriptBlock {
            # Get last gpupdate time before update and display it
            $LastUpdate = [datetime]::FromFileTime(([Int64] ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeHi) -shl 32) -bor ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeLo))
            Write-Host "Last gpupdate time: $LastUpdate" -ForegroundColor Yellow
            # Update the computer (this is a placeholder, replace with actual update commands)
            Write-Host "Running updates on $env:COMPUTERNAME" -ForegroundColor Cyan
            # Example: Install-WindowsUpdate -AcceptAll -AutoReboot
            gpupdate /force
            # Get recent update time and display it
            $CurrentUpdate = [datetime]::FromFileTime(([Int64] ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeHi) -shl 32) -bor ((Get-ItemProperty -Path "Registry::HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Extension-List\{00000000-0000-0000-0000-000000000000}").startTimeLo))
            Write-Host "Current gpupdate time: $CurrentUpdate" -ForegroundColor Yellow
        }
        Write-Host "Update completed successfully on $FullComputerName" -ForegroundColor Green
    }
    catch {
        Write-Host "An error occurred while updating $FullComputerName: $_" -ForegroundColor Red
    }   
}
else {
    Write-Host "Computer DNS records do not match" -ForegroundColor Red
}