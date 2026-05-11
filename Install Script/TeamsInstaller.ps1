#Make script work with msix file

# Confirm C:\temp exists
$PathTest = Test-Path "C:\temp"
if (!$PathTest) {
    mkdir "C:\temp"
}

# Variables
$url = ""
$TeamsPath = "C:\temp\teams.msi"
$InstallerPath = "C:\Program Files (x86)\Teams Installer\Teams.exe"

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

# Install teams setup
#msiexec.exe /i $TeamsPath /norestart
Add-AppxPackage -Path $TeamsPath

<# Run Teams setup
Test-Path $InstallerPath
Start-Process $InstallerPath "powershell"
Start-Sleep 10

# Cleanup
#Uninstall-Package -Name "Teams Machine-Wide Installer" -Force
#rmdir "C:\temp" -Force

<#Confirm process is finished
$Uninstalled = Test-Path "C:\Program Files (x86)\Teams Installer"
$Uninstalled
If ($Uninstalled) {
    Write-Host "Finished"
    Pause
}
Else {
    Write-Host "Teams Machine-Wide Installer hasnt uninstalled. Manual uninstallation required"
    Pause
}#>