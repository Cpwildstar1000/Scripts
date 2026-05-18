# Get directory list
$userid = Get-WmiObject win32_computersystem | Select-Object -ExpandProperty username
$objUser = New-Object System.Security.Principal.NTAccount("$userid")
$UserSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier]).Value 
# Get the environment variables needed.
$UserProfile = (Get-ItemProperty "Registry::\HKEY_USERS\$UserSID\Volatile Environment").UserProfile
try {$OneDrivePath = (Get-ItemProperty "Registry::\HKEY_USERS\$UserSID\Environment").OneDriveCommercial}
catch {$OneDrivePath = "None"}

if ($OneDrivePath -eq "None") {$DesktopPath = "$UserProfile\Desktop"}
else {"$OneDrivePath\Desktop"}

# Get Mailbox sizes
$Names = Get-Content "$DesktopPath\PeopleMailboxSizeList.csv"
ForEach ($User in $Names) {
	Get-MailboxStatistics -Identity "$User" | Format-Table DisplayName, TotalItemSize, ItemCount >> C:\Users\OCP\Desktop\UserMailboxSize2.csv
}