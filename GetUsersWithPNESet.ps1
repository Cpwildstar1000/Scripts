## This script gets a list of all accounts that are set to not expire and the last time the password was changed and makes a list
##

if (!(Test-Path "C:\Temp")) {
	New-Item -ItemType Directory -Path "C:\Temp"
}

function AllOUs {
# Set up first line of file
$FirstLine = "Users" + "`t" + "PasswordLastSet"
Set-Content -Path C:\Temp\UsersWithPNESet.txt -Value $FirstLine -Force
Test-Path C:\Temp\UsersWithPNESet.csv
# Get AD Accounts with the password doesn't expire set
$UserAccounts = (Search-ADAccount -PasswordNeverExpires -UsersOnly).name
ForEach ($User in $UserAccounts)
{
# Use list of AD Accounts to get PasswordLastSet times
$PasswordLastSet = (Get-ADUser -Filter "name -like '$User'" -Properties PasswordLastSet).PasswordLastSet
# Create variable that can be exported to a file (CSV Format)
$UserAccountInfo = "$User" + "`t" + "$PasswordLastSet"
# Export variable to the file
Add-Content -Path C:\Temp\UsersWithPNESet.txt -Value $UserAccountInfo -Force
}
# Change file to be a CSV
Import-CSV -Path C:\Temp\UsersWithPNESet.txt -Delimiter "`t" | Export-CSV C:\Temp\UsersWithPNESet.csv -NoTypeInformation
}

function SpecificOU {
#Get OU to search
$OUInput = Read-Host "What OU do you want to search"
#Searches through AD and creates window to select OU user wants
$OU = Get-ADOrginizationalUnit -LDAPFilter "(name=$OUInput*)" | Out-GridView -OutputMode Single
# Set up first line of file
$FirstLine = "Users" + "`t" + "PasswordLastSet"
Set-Content -Path C:\Temp\UsersWithPNESet.txt -Value $FirstLine -Force
Test-Path C:\Temp\UsersWithPNESet.csv
# Get AD Accounts with the password doesn't expire set
$UserAccounts = (Search-ADAccount -PasswordNeverExpires -UsersOnly -SearchBase $OU).name
ForEach ($User in $UserAccounts)
{
# Use list of AD Accounts to get PasswordLastSet times
$PasswordLastSet = (Get-ADUser -Filter "name -like '$User'" -Properties PasswordLastSet).PasswordLastSet
# Create variable that can be exported to a file (CSV Format)
$UserAccountInfo = "$User" + "`t" + "$PasswordLastSet"
# Export variable to the file
Add-Content -Path C:\Temp\UsersWithPNESet.txt -Value $UserAccountInfo -Force
}
# Change file to be a CSV
Import-CSV -Path C:\Temp\UsersWithPNESet.txt -Delimiter "`t" | Export-CSV C:\Temp\UsersWithPNESet.csv -NoTypeInformation
}

function Exit {Exit}

clear
$title = "--------------------|AD Accounts with PasswordNeverExpires set|--------------------"
$message = "What do you want to run this on?"
$1=New-Object System.Management.Automation.Host.ChoiceDescription "&AllOUs", `
    "AllOUs."
$2=New-Object System.Management.Automation.Host.ChoiceDescription "&SpecificOU", `
    "Specific OU."
$3=New-Object System.Management.Automation.Host.ChoiceDescription "&Exit", `
    "Exit"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($1, $2, $3)
$result = $host.ui.PromptForChoice($title, $message, $options, 0) 
switch ($result)
    {
		0{AllOUs}
		1{SpecificOU}
		2{Exit}
    }

# | Out-File -FilePath C:\Temp\UsersWithPNESet.txt