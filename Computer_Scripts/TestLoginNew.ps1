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
$LogFileLocation = "$DesktopPath\ComputerScripts\Logs"
$LogFileName = "ComputerKeepAliveLog"
$Date = Get-Date -Format "MMddyy"
$LogFileFormatType = ".txt"
$LogFileFullName = "$LogFileName$Date$LogFileFormatType"
$LogFile = Join-Path $LogFileLocation $LogFileFullName

$IgnoredUsernames = @(
    "VHAMADRabbiS"
    "OITMADPulveC"
    "OITMADPulveC0"
)

$LoginDateMode = "Past"
$PastDaysToCheck = @(
    "2026-09-15"
)

if (Test-Path $LogFile) {"`r`n`r`n$Date`r`n" | Tee-Object $LogFile -Append}

# Confirm ComputerList.txt exists on desktop
if (!(Test-Path $DesktopPath\ComputerScripts -PathType Container)) {
    New-Item -Path $DesktopPath -Name "ComputerScripts" -ItemType Directory -Force | Out-Null
}
if (!(Test-Path $DesktopPath\ComputerScripts\Logs -PathType Container)) {
    New-Item -Path $DesktopPath\ComputerScripts -Name "Logs" -ItemType Directory -Force | Out-Null
}
if (!(Test-Path $DesktopPath\ComputerScripts\ComputerList.txt)) {
    New-Item -Path $DesktopPath\ComputerScripts -Name "ComputerList.txt" -ItemType File | Out-Null
    "Created computer list file: $DesktopPath\ComputerScripts\ComputerList.txt" | Tee-Object $LogFile -Append | Write-Host
}

# Confirm user is ready for script to run
"Please make sure the computers you want to run the script against are listed in $DesktopPath\ComputerScripts\ComputerList.txt, with one computer name per line." | Tee-Object $LogFile -Append | Write-Host -ForegroundColor Yellow
$Confirmation = Read-Host "Ready to run the script? (Y/N)"Pause

# Get computer list
$ComputerList = @()
$ComputerList = Get-Content -Path $DesktopPath\ComputerScripts\ComputerList.txt |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and -not $_.StartsWith('#') }

if ($Confirmation -eq "Y" -or "yes") {
    $UserCount = 0
    $Now = Get-Date
    $AllLoginResults = @()

    switch ($LoginDateMode.ToLower()) {
        "today" {
            $WindowsToCheck = @([PSCustomObject]@{
                    CheckDate = $Now.Date
                    Period = if ($Now.Hour -lt 12) { "AM" } else { "PM" }
                    StartHour = if ($Now.Hour -lt 12) { 0 } else { 12 }
                })
        }
        "past" {
            if (-not $PastDaysToCheck) {
                throw "PastDaysToCheck must contain at least one date when LoginDateMode is set to Past."
            }
            $WindowsToCheck = foreach ($PastDay in $PastDaysToCheck) {
                $PastDate = ([datetime]$PastDay).Date
                [PSCustomObject]@{ CheckDate = $PastDate; Period = "AM"; StartHour = 0 }
                [PSCustomObject]@{ CheckDate = $PastDate; Period = "PM"; StartHour = 11 }
            }
        }
        default {
            throw "LoginDateMode must be set to Today or Past."
        }
    }

    foreach ($WindowToCheck in $WindowsToCheck) {
        $CheckDate = $WindowToCheck.CheckDate
        $Period = $WindowToCheck.Period
        $StartOfWindow = $CheckDate.AddHours($WindowToCheck.StartHour)
        $EndOfWindow = $StartOfWindow.AddHours(12)
        Write-Host $StartOfWindow
        Write-Host $EndOfWindow

        foreach ($ComputerEntry in $ComputerList) {
            $Room = ""
            $ComputerName = $ComputerEntry
            $SeparatorIndex = $ComputerEntry.IndexOf("\")
            if ($SeparatorIndex -ge 0) {
                $Room = $ComputerEntry.Substring(0, $SeparatorIndex).Trim()
                $ComputerName = $ComputerEntry.Substring($SeparatorIndex + 1).Trim()
            }

            try {
                $LoginResults = Invoke-Command -ComputerName $ComputerName -ArgumentList $StartOfWindow, $EndOfWindow, $Room, $ComputerName, $CheckDate, $Period -ErrorAction SilentlyContinue -ScriptBlock {
                    param($StartOfWindow, $EndOfWindow, $Room, $ComputerName, $CheckDate, $Period)

                    #Write-Host $StartOfWindow
                    #Write-Host $EndOfWindow

                    $LogonSessions = Get-CimInstance -ClassName Win32_LogonSession |
                        Where-Object {
                            $_.StartTime -ge $StartOfWindow -and
                            $_.StartTime -lt $EndOfWindow -and
                            $_.AuthenticationPackage -eq "Kerberos" -and
                            $_.LogonType -in $(if ($Period -eq "PM") {@(2, 7, 10)} else {@(2, 10)})
                        }
                    #Write-Host $LogonSessions
                    $SessionIds = @{}
                    foreach ($LogonSession in $LogonSessions) {
                        #Write-Host $LogonSession
                        $SessionIds[[string]$LogonSession.LogonId] = $LogonSession
                    }

                    foreach ($LoggedOnUser in Get-CimInstance -ClassName Win32_LoggedOnUser) {
                        $SessionId = [string]$LoggedOnUser.Dependent.LogonId
                        if (-not $SessionIds.ContainsKey($SessionId)) { continue }
                        $LogonSession = $SessionIds[$SessionId]
                        [PSCustomObject]@{
                            Room = $Room
                            ComputerName = $ComputerName
                            CheckDate = $CheckDate
                            Period = $Period
                            Username = $LoggedOnUser.Antecedent.Name
                            Domain = $LoggedOnUser.Antecedent.Domain
                            LoggedIn = $true
                            LogonID = $LogonSession.LogonId
                            AuthenticationType = $LogonSession.AuthenticationPackage
                            StartTime = $LogonSession.StartTime
                            LogonType = switch ($LogonSession.LogonType) {
                                2 { "Interactive" }
                                7 { "Unlock" }
                                10 { "RemoteInteractive" }
                                Default { "Unknown" }
                            }
                        }
                    }
                }

                foreach ($LoginResult in $LoginResults) {
                    if ($IgnoredUsernames -contains $LoginResult.Username) {
                        continue
                    }

                    $AllLoginResults += $LoginResult
                    $UserCount++
                }
            }
            catch {
                Write-Warning "Unable to query ${ComputerName} for $($CheckDate.ToShortDateString()): $($_.Exception.Message)"
            }
        }
    }
}
Write-Host $UserCount

if ($AllLoginResults) {
    $AllLoginResults | Format-Table -AutoSize

    if ($LoginDateMode.ToLower() -eq "past") {
        $LoginDifferences = foreach ($LoginGroup in ($AllLoginResults | Group-Object CheckDate, Room, ComputerName, Domain, Username)) {
            $Periods = @($LoginGroup.Group.Period | Sort-Object -Unique)
            [PSCustomObject]@{
                CheckDate = $LoginGroup.Group[0].CheckDate
                Room = $LoginGroup.Group[0].Room
                ComputerName = $LoginGroup.Group[0].ComputerName
                Domain = $LoginGroup.Group[0].Domain
                Username = $LoginGroup.Group[0].Username
                AM = $Periods -contains "AM"
                PM = $Periods -contains "PM"
                Difference = if ($Periods -contains "AM" -and $Periods -contains "PM") { "Both" } elseif ($Periods -contains "AM") { "AM only" } else { "PM only" }
            }
        }

        "`nAM/PM login comparison:" | Write-Host
        $LoginDifferences | Format-Table -AutoSize
    }
}