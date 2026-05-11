################################################################################################
# Workstation Online Test Script                                                               #
# Description: This script tests to see if the provided list of computers is online or offline #
# Creator: Christopher Pulvermacher                                                            #
# Last Update: 5/11/2026                                                                       #
################################################################################################

# Gets current date for files
$Date = Get-Date -Format "MMddyy"

$userid = Get-WmiObject win32_computersystem | Select-Object -ExpandProperty username
$objUser = New-Object System.Security.Principal.NTAccount("$userid")
$UserSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier]).Value 
# Get the environment variables needed.
$UserProfile = (Get-ItemProperty "Registry::\HKEY_USERS\$UserSID\Volatile Environment").UserProfile
try {$OneDrivePath = (Get-ItemProperty "Registry::\HKEY_USERS\$UserSID\Environment").OneDriveCommercial}
catch {$OneDrivePath = "None"}

if ($OneDrivePath -ne "None") {
    # Tests if needed files exist and creates them if they dont
    if (!(Test-Path "$OneDrivePath\Desktop\Workstations.txt")) {
        New-Item -Path "$OneDrivePath\Desktop\" -Name "Workstations.txt" -ItemType File
        Write-Host "Please add computers to $OneDrivePath\Dekstop\Workstations.txt and press enter."
        Pause
    }
    if (!(Test-Path "$OneDrivePath\Desktop\Workstations_NotResponding$Date.txt")) {
        New-Item -Path "$OneDrivePath\Desktop\" -Name "Workstations_NotResponding$Date.txt" -ItemType File
    }
    if (!(Test-Path "$OneDrivePath\Desktop\Workstations_DNSError$Date.txt")) {
        New-Item -Path "$OneDrivePath\Desktop\" -Name "Workstations_DNSError$Date.txt" -ItemType File
    }
    
    #Get IPs of workstations
    $Computers += Get-Content $OneDrivePath\Desktop\Workstations.txt
    $Names = @()
    foreach ($Computer in $Computers) {
        $ComputerName = (Resolve-DnsName $Computer).Name
        $ComputerIP = (Resolve-DnsName $Computer).IPAddress
        $DNSName = (Resolve-DnsName $ComputerIP).NameHost
        if ($ComputerName -eq $DNSName) {
            $Test = Test-Connection $ComputerIP -Count 1 -Quiet
            [pscustomobject] @{
                DeviceName = $Computer
                Status = if ($Test) {'ONLINE'}
                    else {
                        'OFFLINE'
                        $Computer | Out-File "$OneDrivePath\Desktop\Workstations_NotResponding.txt" -Append
                    }
            }
        }
        else {
            $Names.Add($Computer)
            $Computer | Out-File "$OneDrivePath\Desktop\Workstations_DNSError.txt" -Append
        }
    }
    $Names
}
else {
    # Tests if needed files exist and creates them if they dont
    if (!(Test-Path "$UserProfile\Desktop\Workstations.txt")) {
        New-Item -Path "$UserProfile\Desktop\" -Name "Workstations.txt" -ItemType File
        Write-Host "Please add computers to $OneDrivePath\Dekstop\Workstations.txt and press enter."
        Pause
    }
    if (!(Test-Path "$UserProfile\Desktop\Workstations_NotResponding$Date.txt")) {
        New-Item -Path "$UserProfile\Desktop\" -Name "Workstations_NotResponding$Date.txt" -ItemType File
    }
    if (!(Test-Path "$UserProfile\Desktop\Workstations_DNSError$Date.txt")) {
        New-Item -Path "$UserProfile\Desktop\" -Name "Workstations_DNSError$Date.txt" -ItemType File
    }
    
    #Get IPs of workstations
    $Computers += Get-Content $UserProfile\Desktop\Workstations.txt
    $Names = @()
    foreach ($Computer in $Computers) {
        $ComputerName = (Resolve-DnsName $Computer).Name
        $ComputerIP = (Resolve-DnsName $Computer).IPAddress
        $DNSName = (Resolve-DnsName $ComputerIP).NameHost
        if ($ComputerName -eq $DNSName) {
            $Test = Test-Connection $ComputerIP -Count 1 -Quiet
            [pscustomobject] @{
                DeviceName = $Computer
                Status = if ($Test) {'ONLINE'}
                    else {
                        'OFFLINE'
                        $Computer | Out-File "$UserProfile\Desktop\Workstations_NotResponding.txt" -Append
                    }
            }
        }
        else {
            $Names.Add($Computer)
            $Computer | Out-File "$UserProfile\Desktop\Workstations_DNSError.txt" -Append
        }
    }
    $Names
}