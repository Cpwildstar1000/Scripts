function Show-FedoraProgressBar {
    param(
        [int]$Percent,
        [string]$Activity = "Progress"
    )

    $Percent = [Math]::Max(0, [Math]::Min(100, $Percent))
    $width = 40
    $filled = [Math]::Round(($Percent / 100) * $width)
    Write-Host -NoNewline "`r$Activity ["

    for ($i = 0; $i -lt $width; $i++) {
        if ($i -lt $filled) {
            Write-Host -NoNewline "█" -ForegroundColor Cyan
        }
        else {
            Write-Host -NoNewline "░" -ForegroundColor DarkGray
        }
    }
    Write-Host -NoNewline "] "

    if ($Percent -lt 100) {
        Write-Host -NoNewline "$Percent%" -ForegroundColor White
    }
    else {
        Write-Host "Done!" -ForegroundColor Green
    }
}

# Get directory lists
$userid = Get-CimInstance win32_computersystem | Select-Object -ExpandProperty username
$objUser = New-Object System.Security.Principal.NTAccount("$userid")
$UserSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier]).Value 
$UserProfile = (Get-ItemProperty "Registry::\HKEY_USERS\$UserSID\Volatile Environment").UserProfile
try {$OneDrivePath = (Get-ItemProperty "Registry::\HKEY_USERS\$UserSID\Environment").OneDriveCommercial}
catch {$OneDrivePath = "None"}

if ($OneDrivePath -eq "None") {$DesktopPath = "$UserProfile\Desktop"}
else {$DesktopPath = "$OneDrivePath\Desktop"}

# Create log file
$LogFileLocation = "$DesktopPath"
$LogFileName = "ComputerKeepAliveLog"
#$Date = Get-Date -Format "MMddyy"
$LogFileFormatType = ".txt"
$LogFileFullName = "$LogFileName$LogFileFormatType"
$LogFile = Join-Path $LogFileLocation $LogFileFullName

if (Test-Path $LogFile) {"`r`n`r`n" | Tee-Object $LogFile -Append}

# Confirm ComputerKeepAliveList.txt exists on desktop
if (!(Test-Path $DesktopPath\ComputerKeepAliveList.txt)) {
    New-Item -Path $DesktopPath -Name "ComputerKeepAliveList.txt" -ItemType File | Out-Null
    "Created computer list file: $DesktopPath\ComputerKeepAliveList.txt" | Tee-Object $LogFile -Append | Write-Host
}

function Get-PendingReboot {
    param(
        [string[]]$ComputerName = "localhost"
    )
    foreach ($Computer in $ComputerName) {
    # Check for pending reboot registry keys
    $HKLM = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $Computer)
    $CBS = $HKLM.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending")
    $WU = $HKLM.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired")
    $SM = $HKLM.OpenSubKey("SYSTEM\CurrentControlSet\Control\Session Manager")
    $Rename = $SM.GetValue("PendingFileRenameOperations")
    $Rename2 = $SM.GetValue("PendingFileRenameOperations2")
        [PSCustomObject]@{
            Computer = $Computer
            RebootNeeded = [bool]($CBS -or $WU -or $Rename -or $Rename2)
        }
    }
}

# Confirm user is ready for script to run
"Please make sure the computers you want to run the script against are listed in $DesktopPath\ComputerKeepAliveList.txt, with one computer name per line." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Yellow
$Confirmation = Read-Host "Ready to run the script? (Y/N)"Pause

# Get computer list
$ComputerList = @()
$ComputerList = Get-Content -Path $DesktopPath\ComputerKeepAliveList.txt

if ($Confirmation -eq "Y") {
    $TotalComputers = $ComputerList.Count
    $currentCount = 0
    "Starting Computer Keep Alive script..." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
    foreach ($Computer in $ComputerList) {
        $Percent = [math]::Round(($currentCount / $TotalComputers) * 100)
        Show-FedoraProgressBar -Percent $Percent -Activity "Running Through Computers"
        
        "`r`n`nPinging $Computer..." | Tee-Object $LogFile -Append | Write-Host 
        $PingResult = Test-Connection -ComputerName $Computer -Count 1 -ErrorAction SilentlyContinue
        if ($PingResult) {
            "Successfully pinged $Computer" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
        }
        else {
            "Failed to ping $Computer" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Red
        }
        
        "Starting GPUpdate on $Computer..." | Tee-Object $LogFile -Append | Write-Host
        $DNSName = (Resolve-DnsName $Computer).Name
        if (!($DNSName)) {
            "Failed to resolve DNS name for $Computer. Skipping GPUpdate." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Red
            continue
        }
        else {
            "Resolved DNS name for $Computer : $DNSName" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
            Invoke-Command -ComputerName $DNSName -ScriptBlock {gpupdate} | Out-Null
            "Completed GPUpdate on $Computer" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
        }

        "Checking if $Computer has a pending reboot..." | Tee-Object $LogFile -Append | Write-Host
        $PendingRebootStatus = (Get-PendingReboot "$Computer").PendingReboot
        if ($PendingRebootStatus -eq "True") {
            "$Computer has a pending reboot. Checking for logged on users..." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Yellow
            $LoggedOnUserQuery = (Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Computer).UserName
            if ($LoggedOnUserQuery) {
                "There is a user logged on to $Computer : $LoggedOnUserQuery" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Yellow
                "Aborting further actions on $Computer to avoid disruption to logged on user(s)." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Red
                Start-Sleep -Seconds 3
            }
            else {
                "No users are logged on to $Computer." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
                "Starting reboot of $Computer..." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
                Restart-Computer -ComputerName $FullComputerName -Force -Wait -For PowerShell -Timeout 600 -Delay 5
                "$Computer has been rebooted" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
                Start-Sleep -Seconds 3
            }
        }
        else {
            "$Computer does not have a pending reboot." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
            Start-Sleep -Seconds 3
        }

        $currentCount++
        Clear-Host
    }
    "Completed Computer Keep Alive script for $TotalComputers computers." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
}