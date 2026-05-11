## Starts logging for script
Start-Transcript C:\temp\ComputerSetup.log -Append

## Download and Install teams setup
$url = ""
$TeamsPath = "C:\temp\teams.msix"

$url32 = 'https://go.microsoft.com/fwlink/?linkid=2196060&clcid=0x409&culture=en-us&country=us'
$url64 = 'https://go.microsoft.com/fwlink/?linkid=2196106&clcid=0x409&culture=en-us&country=us'

if(!$url){
    if([Environment]::Is64BitOperatingSystem){
        $url = $url64
    }
    else{
        $url = $url32
    }
}

$client = new-object System.Net.WebClient
$client.DownloadFile($url,$TeamsPath) 
C:\temp\teams.msix

## Promt to complete tasks before script runs
# Prompt to sign into OneDrive
Write-Host "Please sign into OneDrive then continue script"
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
# Prompt to Run chrome for the first time
Write-Host "Please launch chrome and save a bookmark"
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Confirm C:\temp exists
$PathTest = Test-Path "C:\temp"
if (!$PathTest) {
    mkdir "C:\temp"
}

# Get ther user's SID
$userid = Get-WmiObject win32_computersystem | Select-Object -ExpandProperty username
$userid
$objUser = New-Object System.Security.Principal.NTAccount("$userid")
$objUser
$UserSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier]).Value 
$UserSID
# Get the environment variables needed.
$UserProfile = (Get-ItemProperty "Registry::\HKEY_USERS\$userSID\Volatile Environment").UserProfile
$UserProfile
$OneDrivePath = (Get-ItemProperty "Registry::\HKEY_USERS\$userSID\Environment").OneDriveCommercial
$OneDrivePath
## Configure OneDrive **NEEDS TESTING, Works (Probably that it doesnt have permissions to user folder as admin)**
# Tests if folders exist in OneDrive and creates folders if they dont
$OneDriveDesktop = Test-Path ("$OneDrivePath\Desktop")
$OneDriveDownloads = Test-Path ("$OneDrivePath\Downloads")
$OneDriveDocuments = Test-Path ("$OneDrivePath\Documents")
$OneDrivePictures = Test-Path ("$OneDrivePath\Pictures")
$OneDriveMusic = Test-Path ("$OneDrivePath\Music")
$OneDriveVideos = Test-Path ("$OneDrivePath\Videos")
If (!$OneDriveDesktop -eq 'True') {
    Move-Item $UserProfile\Desktop $OneDrivePath -Force
}
Else {
    Remove-Item $UserProfile\Desktop -Recurse -Force
}
If (!$OneDriveDownloads -eq 'True') {
    Move-Item $UserProfile\Downloads $OneDrivePath -Force
}
Else {
    Remove-Item $UserProfile\Downloads -Recurse -Force
}
If (!$OneDriveDocuments -eq 'True') {
    Move-Item $UserProfile\Documents $OneDrivePath -Force
}
Else {
    Remove-Item $UserProfile\Documents -Recurse -Force
}
If (!$OneDrivePictures -eq 'True') {
    Move-Item $UserProfile\Pictures $OneDrivePath -Force
}
Else {
    Remove-Item $UserProfile\Pictures -Recurse -Force
}
If (!$OneDriveMusic -eq 'True') {
    Move-Item $UserProfile\Music $OneDrivePath -Force
}
Else {
    Remove-Item $UserProfile\Music -Recurse -Force
}
If (!$OneDriveVideos -eq 'True') {
    Move-Item $UserProfile\Videos $OneDrivePath -Force
}
Else {
    Remove-Item $UserProfile\Videos -Recurse -Force
}
# Create link to folder
cmd /c mklink /D "$UserProfile\Desktop" "$OneDrivePath\Desktop"
cmd /c mklink /D "$UserProfile\Documents" "$OneDrivePath\Documents"
cmd /c mklink /D "$UserProfile\Downloads" "$OneDrivePath\Downloads"
cmd /c mklink /D "$UserProfile\Pictures" "$OneDrivePath\Pictures"
cmd /c mklink /D "$UserProfile\Music" "$OneDrivePath\Music"
cmd /c mklink /D "$UserProfile\Videos" "$OneDrivePath\Videos"

# Set Registry for changes later
[string]$RegValueName = "CustomizeTaskbar"
[string]$FullRegKeyName = "HKLM:\SOFTWARE\ccmexec\" 
If (!(Test-Path $FullRegKeyName)) {
    New-Item -Path $FullRegKeyName -type Directory -force 
    }
New-itemproperty $FullRegKeyName -Name $RegValueName -Value "1" -Type STRING -Force

## Configure Taskbar **NEEDS MORE SETTINGS IN HERE FOR OTHER TASKBAR SETTINGS**
## Things to disable:
# Copiolet
# Windows Store
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

## Move bookmark file into Chrome folder **DOESNT WORK YET, ONEDRIVE BOOKMARK DOESNT WORK**
#Move-Item "$UserProfile\Desktop\Bookmarks" "$UserProfile\AppData\Local\Google\Chrome\User Data\Default" -Force
$bookmarks = Get-Content "$env:UserProfile\AppData\Local\Google\Chrome\User Data\Default\bookmarks" | Out-String | ConvertFrom-Json
$data = @([PSCustomObject]@{date_added = "13350757614172959"; date_last_used = "0"; guid = "186ad16e-7826-45b4-a734-03a66ca046e3"; id = "100"; meta_info = "@{power_bookmark_meta=}"; name = "Office"; type = "url"; url = "portal.office.com"}, [PSCustomObject]@{date_added = "13350757614172959"; date_last_used = "0"; guid = "b1cd4369-dd13-4ffa-acb2-584475ac4fd4"; id = "101"; meta_info = "@{power_bookmark_meta=}"; name = "Outlook"; tpe = "url"; url = "https://outlook.office365.com"}, [PSCustomObject]@{date_added = "13350757614172959"; date_last_used = "0"; guid = "edb15874-6f59-4063-ad48-9bb9eb7ecf22"; id = "102"; meta_info = "@{power_bookmark_meta=}"; name = "OneDrive"; type = "url"; url = "www.microsoft365.com/onedrive"})
$bookmarks.roots.bookmark_bar.children = ($bookmarks.roots.bookmark_bar.children + $data)
$bookmarks | ConvertTo-Json -Depth 10 | Out-File "$env:UserProfile\AppData\Local\Google\Chrome\User Data\Default\bookmarks" -Encoding UTF8 -Force

## Stop logging
Stop-Transcript