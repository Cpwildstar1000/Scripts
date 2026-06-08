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

# Remote restart timer and cancellation helpers
function Start-RemoteRestartTimer {
    param(
        [Parameter(Mandatory=$true)][string]$ComputerName,
        [int]$DelayMinutes = 5
    )
    $id = [guid]::NewGuid().ToString()

    # Start a local background job to show prompt on remote machine and handle restart
    $job = Start-Job -Name "RestartTimer_$id" -ScriptBlock {
        param($ComputerName, $DelayMinutes, $id)

        $scriptPath = "C:\Windows\Temp\ComputerKeepAlivePopup-$id.ps1"
        $responseFile = "C:\Windows\Temp\ComputerKeepAliveResponse-$id.txt"
        $taskName = "ComputerKeepAlivePrompt-$id"

        $popupScript = @"
Add-Type -AssemblyName System.Windows.Forms
try {
    `$result = [System.Windows.Forms.MessageBox]::Show(
        'This computer needs to restart. It will restart in $DelayMinutes minute(s).`n`nDo you want to proceed with the restart?',
        'System Restart Pending',
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
    if (`$result -eq [System.Windows.Forms.DialogResult]::Yes) {
        'YES' | Out-File -FilePath '$responseFile' -Encoding ASCII
    } else {
        'NO' | Out-File -FilePath '$responseFile' -Encoding ASCII
    }
} catch {
    'ERROR' | Out-File -FilePath '$responseFile' -Encoding ASCII
}
"@

        Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            param($PopupScript, $ScriptPath, $TaskName)
            Set-Content -Path $ScriptPath -Value $PopupScript -Encoding ASCII -Force

            $taskCommand = "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Normal -File `"$ScriptPath`""
            schtasks.exe /Create /F /TN $TaskName /TR $taskCommand /SC ONCE /ST 00:00 /RL HIGHEST /RU SYSTEM /IT | Out-Null
            schtasks.exe /Run /TN $TaskName | Out-Null
        } -ArgumentList $popupScript, $scriptPath, $taskName -ErrorAction Stop

        $userResponse = $null
        $deadline = [DateTime]::UtcNow.AddMinutes(15)
        while (([DateTime]::UtcNow) -lt $deadline) {
            $userResponse = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                param($ResponseFile)
                if (Test-Path $ResponseFile) {
                    Get-Content -Path $ResponseFile -ErrorAction Stop | Select-Object -First 1
                }
            } -ArgumentList $responseFile -ErrorAction SilentlyContinue

            if ($userResponse) { break }
            Start-Sleep -Seconds 2
        }

        Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            param($TaskName, $ScriptPath, $ResponseFile)
            schtasks.exe /Delete /TN $TaskName /F | Out-Null
            Remove-Item -Path $ScriptPath,$ResponseFile -ErrorAction SilentlyContinue
        } -ArgumentList $taskName, $scriptPath, $responseFile -ErrorAction SilentlyContinue

        if ($userResponse -eq 'NO') {
            Write-Output "CANCELED:$ComputerName :$id"
            return
        }

        if ($userResponse -ne 'YES') {
            Write-Output "FAILED:$ComputerName :$id:Unable to display prompt on remote machine"
            return
        }

        Start-Sleep -Seconds ($DelayMinutes * 60)

        try {
            Restart-Computer -ComputerName $ComputerName -Force -ErrorAction Stop
            Write-Output "RESTARTED:$ComputerName :$id"
        } catch {
            Write-Output "FAILED:$ComputerName :$id :$($_.Exception.Message)"
        }
    } -ArgumentList $ComputerName, $DelayMinutes, $id

    # Return job id pair to caller
    ,@{ Id = $id; Job = $job }
}


function Wait-ForRestartJobs {
    param(
        [Parameter(Mandatory=$true)][array]$Jobs
    )
    if (-not $Jobs) { return }
    while ($true) {
        foreach ($j in @($Jobs)) {
            if ($j.State -in 'Completed','Failed','Stopped') {
                $out = Receive-Job -Job $j -Keep
                foreach ($line in $out) {
                    if ($line -like 'CANCELED:*') {
                        $parts = $line -split ':'
                        Write-Host "Restart canceled for $($parts[1]) (id $($parts[2]))" -ForegroundColor Yellow
                    } elseif ($line -like 'RESTARTED:*') {
                        $parts = $line -split ':'
                        Write-Host "Restarted $($parts[1]) (id $($parts[2]))" -ForegroundColor Green
                    } elseif ($line -like 'FAILED:*') {
                        $parts = $line -split ':'
                        Write-Host "Restart failed for $($parts[1]) (id $($parts[2])) - $($parts[3])" -ForegroundColor Red
                    } else {
                        Write-Host $line
                    }
                }
                Remove-Job -Job $j -Force -ErrorAction SilentlyContinue
                $Jobs = $Jobs | Where-Object { $_.Id -ne $j.Id }
            }
        }
        if (-not ($Jobs | Where-Object { $_.State -eq 'Running' })) { break }
        Start-Sleep -Seconds 2
    }
}

<#function Reboot-Computer {
    param(
        [string[]]$DelayTime
    )
    try {
        # Delay time
        $DelayConfirmed = 300
        $DelayTimeDisplay = $DelayTime/60

        # Create user popup for confirmation
        $PopupTitle = "Pending Restart Confirmation"
        $RestartMessage = "This system is scheduled to restart in $DelayTimeDisplay minutes. Do you want to proceed?"

        # Show popup to user
        $Result = [System.Windows.MessageBox]::Show(
            $PopupTitle,
            $RestartMessage,
            'YesNo',
            'Warning'
        )

        if ($Result -eq 'Yes') {
            shutdown -r -t $DelayConfirmed /c "System will restart in $DelayTimeDisplay minutes."
        }
        elseif ($Result -eq 'No') {
            shutdown -a
            Write-Host "Shutdown canceled by user."
        }
        else {

        }
    }
    catch {

    }
}#>

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
$Date = Get-Date -Format "MMddyy"
$LogFileFormatType = ".txt"
$LogFileFullName = "$LogFileName$LogFileFormatType"
$LogFile = Join-Path $LogFileLocation $LogFileFullName

if (Test-Path $LogFile) {"`r`n`r`n$Date`r`n" | Tee-Object $LogFile -Append}

# Create tracking Variables

$RestartedComputers = 0
$RestartedComputersList = @()
$NeedsUpdate = 0
$NeedsUpdateList = @()
$RestartJobs = @()

# Confirm ComputerKeepAliveList.txt exists on desktop
if (!(Test-Path $DesktopPath\ComputerKeepAliveList.txt)) {
    New-Item -Path $DesktopPath -Name "ComputerKeepAliveList.txt" -ItemType File | Out-Null
    "Created computer list file: $DesktopPath\ComputerKeepAliveList.txt" | Tee-Object $LogFile -Append | Write-Host
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
        Clear-Host
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
        $PendingRebootStatus = (Get-PendingReboot $Computer).RebootNeeded
        if ($PendingRebootStatus) {
            "$Computer has a pending reboot. Checking for logged on users..." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Yellow
            $LoggedOnUserQuery = (Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Computer).UserName
            if ($LoggedOnUserQuery) {
                "There is a user logged on to $Computer : $LoggedOnUserQuery" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Yellow
                # Offer to schedule a delayed restart that will prompt the logged-on user and allow cancellation
                $delayInput = Read-Host "Enter delay in minutes to notify user and schedule restart (leave blank to skip)"
                if ([int]::TryParse($delayInput, [ref]$null) -and $delayInput -gt 0) {
                    $minutes = [int]$delayInput
                    "Scheduling a $minutes-minute delayed restart for $Computer (ID will be returned)" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Cyan
                    $res = Start-RemoteRestartTimer -ComputerName $Computer -DelayMinutes $minutes
                    if ($res -and $res.Job) { $RestartJobs += $res.Job }
                    $NeedsUpdateList += $Computer
                    $NeedsUpdate++
                } else {
                    "Skipping restart scheduling for $Computer to avoid disrupting logged-on user(s)." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Red
                    $NeedsUpdateList += $Computer
                    $NeedsUpdate++
                }
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
    if ($RestartJobs -and $RestartJobs.Count -gt 0) {
        "There are $($RestartJobs.Count) pending restart timer(s). Monitoring until complete..." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Cyan
        Wait-ForRestartJobs -Jobs $RestartJobs
        "All restart timers completed." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
    }
}
