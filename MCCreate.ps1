#Creates multiple users in Active Directory
Import-Csv "Z:\CSVs\Computers.csv" | ForEach-Object {
 New-ADComputer -Name $_."name" -Path $_."path" -SamAccountName $_."name"}
.\ADConfig.ps1