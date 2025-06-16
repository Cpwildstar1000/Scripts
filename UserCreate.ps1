# Creates a single user in Active Directory
clear
#Tells the script what the first name of the user is
$firstname = read-host "What is the first name of the User?:`t"
clear
#Tells the script what the last name of the user is
$lastname = read-host "What is the last name of the User?:`t"
clear
#Sets up username for User
$title = "--------------------|Username Format|--------------------"
$message = "What format do you want the username to be?"
$1=New-Object System.Management.Automation.Host.ChoiceDescription "&FirstLast", `
    "FirstLast."
$2=New-Object System.Management.Automation.Host.ChoiceDescription "&Program", `
    "FirstLeterFirstFullLast."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($1, $2)
$result = $host.ui.PromptForChoice($title, $message, $options, 0) 
switch ($result)
    {
		0{FirstLast}
		1{FirstLeterFirstFullLast}
    }

function FirstLast {
	$Username = "$firstname" + '.' + "$lastname"
}

function FirstLeterFirstFullLast {
	$Username = "$firstname[0]" + "$lastname"
}
#Searches for if username exists
clear
$UserExistance = (Get-ADUser -Filter $Username).SamAccountName
if ($UserExistance -match "$Username") {
	Write-Host "User Exists Already!!!"
	Pause
	exit
}
else {
	#Tells the script where you want the user stored
	$OU = Get-ADOrginizationalUnit -LDAPFilter "(name=Users)" | Out-GridView -Output single
	clear	
	#Tells the script what password you want assigned to the user
	$password = read-host "What is the password that you want the user to have?:`t"
	clear
	#Sets DisplayName
	$DisplayName = "$lastname" + ', ' + "$firstname"
	#Creates user account
	New-ADUser -Name "$Username"`
	-GivenName "$firstname"
	-Surname "$lastname"
	-DisplayName "$$FirstNameLastName"`
	-AccountPassword $password`
	-SamAccountName "$Username"`
	-path "$OU"`
	-enabled $true
}

Display name: Last, first
SamAccountName: username
Surname: last
Given: first