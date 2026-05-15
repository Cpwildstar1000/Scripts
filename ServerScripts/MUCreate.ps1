#Creates multiple users in Active Directory
clear
#Imports the users from the file named Users.csv from the desktop
Import-Csv "Z:\CSVs\Users.csv" | ForEach-Object {
 New-ADUser -Name $_."DisplayName" -Path $_."Path" -SamAccountName $_."LogonName" -DisplayName $_."DisplayName" -AccountPassword (convertto-securestring "Pa$$w0rd" -asplaintext -force) -enable
 }
.\ADConfig.ps1