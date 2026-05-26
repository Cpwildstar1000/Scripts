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