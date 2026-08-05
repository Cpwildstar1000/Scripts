function Show-ProgressBar {
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
$LogFileLocation = "$DesktopPath\ComputerScripts"
$LogFileName = "ComputerKeepAliveLog"
$Date = Get-Date -Format "MMddyy"
$LogFileFormatType = ".txt"
$LogFileFullName = "$LogFileName$Date$LogFileFormatType"
$LogFile = Join-Path $LogFileLocation $LogFileFullName

if (Test-Path $LogFile) {"`r`n`r`n$Date`r`n" | Tee-Object $LogFile -Append}

# Create tracking Variables

$RestartedComputers = 0
$RestartedComputersList = @()
$NeedsUpdate = 0
$NeedsUpdateList = @()

# Confirm ComputerList.txt exists on desktop
if (!(Test-Path $DesktopPath\ComputerScripts -PathType Container)) {
    New-Item -Path $DesktopPath -Name "ComputerScripts" -ItemType Directory | Out-Null
}
if (!(Test-Path $DesktopPath\ComputerScripts\ComputerList.txt)) {
    New-Item -Path $DesktopPath\ComputerScripts -Name "ComputerList.txt" -ItemType File | Out-Null
    "Created computer list file: $DesktopPath\ComputerScripts\ComputerList.txt" | Tee-Object $LogFile -Append | Write-Host
}

<# Confirm ComputerNoRestartCounter.txt exists
if (!(Test-Path $DesktopPath\ComputerNoRestartCounter.txt)) {
    New-Item -Path $DesktopPath -Name "ComputerNoRestartCounter.csv" -ItemType File | Out-Null
    "Created computer no restart list file: $DesktopPath\ComputerNoRestartCounter.csv" | Tee-Object $LogFile -Append | Write-Host
}
else {$data = Import-CSV $DesktopPath\ComputerNoRestartCounter.csv}#>

# Confirm user is ready for script to run
"Please make sure the computers you want to run the script against are listed in $DesktopPath\ComputerScripts\ComputerList.txt, with one computer name per line." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Yellow
$Confirmation = Read-Host "Ready to run the script? (Y/N)"Pause

# Get computer list
$ComputerList = @()
$ComputerList = Get-Content -Path $DesktopPath\ComputerScripts\ComputerList.txt

<# Get computer NonRestart list
$NonRestartComputers = @()
$NonRestartList = @()
$NonRestartList = Import-CSV $DesktopPath\ComputerNoRestartCounter.csv
foreach ($Line in $NonRestartList) {
    $NonRestartComputers += $Line.ComputerName
    $NonRestartCount += $Line.NonRestartCount
    $NotOnListCount += $Line.NotOnListCount
}#>

if ($Confirmation -eq "Y") {
    $TotalComputers = $ComputerList.Count
    $currentCount = 0
    "Starting Computer Keep Alive script..." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
    foreach ($Computer in $ComputerList) {
        Clear-Host
        $Percent = [math]::Round(($currentCount / $TotalComputers) * 100)
        Show-ProgressBar -Percent $Percent -Activity "Running Through Computers"
        
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
        $PendingRebootStatus = (Get-PendingReboot $Computer).RebootNeeded
        if ($PendingRebootStatus) {
            "$Computer has a pending reboot. Checking for logged on users..." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Yellow
            $LoggedOnUserQuery = (Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Computer).UserName
            if ($LoggedOnUserQuery) {
                "There is a user logged on to $Computer : $LoggedOnUserQuery" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Yellow
                "Aborting further actions on $Computer to avoid disruption to logged on user(s)." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Red
                <#$NRCCount = 0
                foreach ($NonRestartComputer in $NonRestartComputers) {
                    if ($Computer -eq $NonRestartComputer) {
                        $NonRestartCount
                    }
                    else {
                        NRCCount++
                    }
                }#>
                $NeedsUpdateList += $Computer
                $NeedsUpdate++
                Start-Sleep -Seconds 3
            }
            else {
                "No users are logged on to $Computer." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
                "Starting reboot of $Computer..." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
                Restart-Computer -ComputerName $DNSName -Force -Wait -For PowerShell -Timeout 600 -Delay 5
                "$Computer has been rebooted" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
                $RestartedComputersList += $Computer
                $RestartedComputers++
                Start-Sleep -Seconds 3
            }
        }
        else {
            "$Computer does not have a pending reboot." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
            Start-Sleep -Seconds 3
        }

        $currentCount++
    }
    "Completed Computer Keep Alive script for $TotalComputers computers." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
    "Computers Restarted: $RestartedComputers" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor DarkCyan
    "Computers that still need reboot: $NeedsUpdate" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor DarkCyan
    $NeedsUpdateList | Tee-Object $LogFile -Append
}
<#
Add section to remember comptuers and if they are offline for 3 times just reboot computer without waiting for user
$ResultTable = foreach ($line in $data) {
    $ComputerName = $line.ComputerName
    [int]$NonRestartCount = $line.NonRestartCount
    [int]$NotOnListCount = $line.NotOnListCount

    foreach ($Computer in $NeedsUpdate) {
        # Check if computer is in list

        # If computer is not then add it to list
        # If computer is then incrament NonRestartCount field
        # If computer is at the 3rd incrament then restart even if user is logged on
        # If computer restarts that is on the list then remove from list
    }
}
#>