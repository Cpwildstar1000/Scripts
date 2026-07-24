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
$LogFileName = "ComputerProfileDeleteLog"
$Date = Get-Date -Format "MMddyy"
$LogFileFormatType = ".txt"
$LogFileFullName = "$LogFileName$LogFileFormatType"
$LogFile = Join-Path $LogFileLocation $LogFileFullName

if (Test-Path $LogFile) {"`r`n`r`n$Date`r`n" | Tee-Object $LogFile -Append}

# Create tracking Variables

$AccountsToKeep = @('Administrator','Public','Default','DefaultAccount','defaultuser0','WDAGUtilityAccount')
$ProfilesDeleted = 0
$ComputerProfileCount = @()

# Confirm ComputerList.txt exists on desktop
if (!(Test-Path $DesktopPath\ComputerList.txt)) {
    New-Item -Path $DesktopPath -Name "ComputerList.txt" -ItemType File | Out-Null
    "Created computer list file: $DesktopPath\ComputerList.txt" | Tee-Object $LogFile -Append | Write-Host
}

# Confirm user is ready for script to run
"Please make sure the computers you want to run the script against are listed in $DesktopPath\ComputerList.txt, with one computer name per line." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Yellow
$Confirmation = Read-Host "Ready to run the script? (Y/N)"Pause

# Get computer list
$ComputerList = @()
$ComputerList = Get-Content -Path $DesktopPath\ComputerList.txt

if ($Confirmation -eq "Y") {
    $TotalComputers = $ComputerList.Count
    $currentCount = 0
    "Starting Computer Keep Alive script..." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
    foreach ($Computer in $ComputerList) {
        Clear-Host
        $Percent = [math]::Round(($currentCount / $TotalComputers) * 100)
        Show-ProgressBar -Percent $Percent -Activity "Running Through Computers"

        $RowToAdd = [PSCustomObject]@{
            ComputerName = $Computer
            DeletedProfiles = 0
        }
        $ComputerProfileCount += $RowToAdd
        
        "`r`n`nPinging $Computer..." | Tee-Object $LogFile -Append | Write-Host 
        $PingResult = Test-Connection -ComputerName $Computer -Count 1 -ErrorAction SilentlyContinue
        if ($PingResult) {
            "Successfully pinged $Computer" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
        }
        else {
            "Failed to ping $Computer" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Red
        }
        $DNSName = (Resolve-DnsName $Computer).Name
        
        "Writing Profiles on $Computer to log..." | Tee-Object $LogFile -Append | Write-Host
        $Profiles =Invoke-Command -ComputerName $DNSName -ScriptBlock {Get-CimInstance -Class Win32_UserProfile | Where-Object {($_.Special -eq $false) -and ($_.LocalPath.Split('\') -notin $AccountsToKeep) -and ($_.Loaded -eq $false)}} | Tee-Object $LogFile -Append

        "Starting Profile Deletion on $Computer..." | Tee-Object $LogFile -Append | Write-Host
        foreach ($UserProfile in $Profiles) {
            Write-Host -ForegroundColor Yellow "Deleting Profile:" $UserProfile.LocalPath 
            $UserProfile | Invoke-Command -ComputerName $DNSName -ScriptBlock {Remove-CimInstance}
            $ProfilesDeleted++

            # Add to computer PSCustomObject profiles deleted 
            foreach ($row in $RowToAdd) {
                if ($row.ComputerName -eq $Computer) {
                    $row.DeletedProfiles++
                }
            }
        }
        
        $currentCount++
    }
    "Completed Computer Profile Deletion script for $TotalComputers computers." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Green
    "Profiles Deleted: $ProfilesDeleted" | Tee-Object $LogFile -Append | Write-Host -ForegroundColor DarkCyan
    Write-Host "Count of profiles deleted per computer:"
    $ComputerProfileCount | Format-Table
}