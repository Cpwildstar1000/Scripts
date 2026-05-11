# Confirm C:\temp exists
$PathTest = Test-Path "C:\temp"
if (!$PathTest) {
    mkdir "C:\temp"
}

<# Download teams msix file from microsoft
$TeamsURL = ""
$TeamsPath = "C:\temp\teams.msi"
$TeamsURL32 = 'https://go.microsoft.com/fwlink/?linkid=2196060&clcid=0x409&culture=en-us&country=us'
#https://teams.microsoft.com/downloads/desktopurl?env=production&plat=windows&arch=x64&managedInstaller=true&download=true
$TeamsURL64 = 'https://go.microsoft.com/fwlink/?linkid=2196106&clcid=0x409&culture=en-us&country=us'
if(!$TeamsURL){
    if([Environment]::Is64BitOperatingSystem){
        $TeamsURL = $TeamsURL64
    }
    else{
        $TeamsURL = $TeamsURL32
    }
}
$client = new-object System.Net.WebClient
$client.DownloadFile($TeamsURL,$TeamsPath) 
#>

# Get ther user's SID
$userid = Get-WmiObject win32_computersystem | Select-Object -ExpandProperty username
$objUser = New-Object System.Security.Principal.NTAccount("$userid")
$UserSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier]).Value 
# Get the environment variables needed.
$UserProfile = (Get-ItemProperty "Registry::\HKEY_USERS\$userSID\Volatile Environment").UserProfile
$OneDrivePath = (Get-ItemProperty "Registry::\HKEY_USERS\$userSID\Environment").OneDriveCommercial

# Set Registry for changes later
[string]$RegValueName = "CustomizeTaskbar"
[string]$FullRegKeyName = "HKLM:\SOFTWARE\ccmexec\" 
If (!(Test-Path $FullRegKeyName)) {
    New-Item -Path $FullRegKeyName -type Directory -force 
    }
New-itemproperty $FullRegKeyName -Name $RegValueName -Value "1" -Type STRING -Force

## Download and Install teams setup **
# Download installer exe from microsoft
# Microsoft file https://learn.microsoft.com/en-us/microsoftteams/new-teams-bulk-install-client
$InstallerURL = 'https://go.microsoft.com/fwlink/?linkid=2243204&clcid=0x409'
$InstallerPath = "C:\temp\teamsbootstraper.exe"
$client = new-object System.Net.WebClient
$client.DownloadFile($InstallerURL,$InstallerPath)
# Run installer
C:\temp\teamsbootstraper.exe -p
# Tested but didnt install - Start-Process msiexec "/i $TeamsPath /qn"
#Add-AppxPackage -Path $TeamsPath
#$TeamsPackageFamilyName = (Get-AppxPackage -Name MSTeams).PackageFamilyName

<#$TriggerTime = (Get-Date).AddMinutes(1)
$action = New-ScheduledTaskAction -Execute "C:\temp\teams.msix"
$trigger = New-ScheduledTaskTrigger -At $TriggerTime
#$principal = "Contoso\Administrator"
$settings = New-ScheduledTaskSettingsSet
#$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings
$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings
Register-ScheduledTask TeamsInstall -InputObject $task#>

## Configure Taskbar !!WORKS!!
REG LOAD HKLM\Default C:\Users\Default\NTUSER.DAT
# Removes Task View from the Taskbar
New-ItemProperty "HKLM:\Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value "0" -PropertyType Dword -Force
# Removes Widgets from the Taskbar
New-ItemProperty "HKLM:\Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value "0" -PropertyType Dword -Force
# Removes Chat from the Taskbar
New-ItemProperty "HKLM:\Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Value "0" -PropertyType Dword -Force
# Default StartMenu alignment 0=Left
New-ItemProperty "HKLM:\Default\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value "0" -PropertyType Dword -Force
[GC]::Collect()
REG UNLOAD HKLM\Default
$UserProfiles = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*" | Where-Object { $_.PSChildName -match "S-1-5-21-(\d+-?){4}$" } | Select-Object @{Name = "SID"; Expression = { $_.PSChildName } }, @{Name = "UserHive"; Expression = { "$($_.ProfileImagePath)\NTuser.dat" } }
# Loop through each profile on the machine
foreach ($UserProfile in $UserProfiles) {
    # Load User NTUser.dat if it's not already loaded
    if (($ProfileWasLoaded = Test-Path Registry::HKEY_USERS\$($UserProfile.SID)) -eq $false) {
        Start-Process -FilePath "CMD.EXE" -ArgumentList "/C REG.EXE LOAD HKU\$($UserProfile.SID) $($UserProfile.UserHive)" -Wait -WindowStyle Hidden
    }
    # Removes Task View from the Taskbar
    New-ItemProperty "registry::HKEY_USERS\$UserSID\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value "0" -PropertyType Dword -Force
    # Removes Widgets from the Taskbar
    New-ItemProperty "registry::HKEY_USERS\$UserSID\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value "0" -PropertyType Dword -Force
    # Removes Chat from the Taskbar
    New-ItemProperty "registry::HKEY_USERS\$UserSID\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Value "0" -PropertyType Dword -Force
    # Default StartMenu alignment 0=Left
    New-ItemProperty "registry::HKEY_USERS\$UserSID\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value "0" -PropertyType Dword -Force
    # Unload NTUser.dat
    if ($ProfileWasLoaded -eq $false) {
        [GC]::Collect()
        Start-Sleep 1
        Start-Process -FilePath "CMD.EXE" -ArgumentList "/C REG.EXE UNLOAD HKU\$($UserProfile.SID)" -Wait -WindowStyle Hidden
    }
}

## Set default applications ?
Move-Item "$UserProfile\Desktop\Bookmarks" "$UserProfile\AppData\Local\Google\Chrome\User Data\Default" -Force

## Configure OneDrive ?
# Prompt to sign into OneDrive
Write-Host "Please sign into OneDrive then continue script"
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
# Tests if folders exist in OneDrive and creates folders if they dont
$OneDriveDesktop = Test-Path ("$OneDrivePath\Desktop")
$OneDriveDownloads = Test-Path ("$OneDrivePath\Downloads")
$OneDriveDocuments = Test-Path ("$OneDrivePath\Documents")
$OneDrivePictures = Test-Path ("$OneDrivePath\Pictures")
$OneDriveMusic = Test-Path ("$OneDrivePath\Music")
$OneDriveVideos = Test-Path ("$OneDrivePath\Videos")
If ($OneDriveDesktop -eq 'False') {
    Move-Item $UserProfile\Desktop $OneDrivePath -Force
}
Else {
    rmdir $UserProfile\Desktop -Recurse -Force
}
If ($OneDriveDownloads -eq 'False') {
    Move-Item $UserProfile\Downloads $OneDrivePath -Force
}
Else {
    rmdir $UserProfile\Downloads -Recurse -Force
}
If ($OneDriveDocuments -eq 'False') {
    Move-Item $UserProfile\Documents $OneDrivePath -Force
}
Else {
    rmdir $UserProfile\Documents -Recurse -Force
}
If ($OneDrivePictures -eq 'False') {
    Move-Item $UserProfile\Pictures $OneDrivePath -Force
}
Else {
    rmdir $UserProfile\Pictures -Recurse -Force
}
If ($OneDriveMusic -eq 'False') {
    Move-Item $UserProfile\Music $OneDrivePath -Force
}
Else {
    rmdir $UserProfile\Music -Recurse -Force
}
If ($OneDriveVideos -eq 'False') {
    Move-Item $UserProfile\Videos $OneDrivePath -Force
}
Else {
    rmdir $UserProfile\Videos -Recurse -Force
}
# Create link to folder
cmd /c mklink /D "$UserProfile\Desktop" "$OneDrivePath\Desktop"
cmd /c mklink /D "$UserProfile\Documents" "$OneDrivePath\Documents"
cmd /c mklink /D "$UserProfile\Downloads" "$OneDrivePath\Downloads"
cmd /c mklink /D "$UserProfile\Pictures" "$OneDrivePath\Pictures"
cmd /c mklink /D "$UserProfile\Music" "$OneDrivePath\Music"
cmd /c mklink /D "$UserProfile\Videos" "$OneDrivePath\Videos"