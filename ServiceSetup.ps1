#This script will install Active Directory
clear
#Checks if you want to look for a service or continue
$lookup=read-host "Do you want to look up a service?(y/n):`t"
clear
if ($lookup -eq "y")
	{
	#Sets the service that you want to look for as a variable
	$sl=read-host "What service do you want to look up?:`t"
	clear
	#looks for and displays the service that was stored in the variable
	get-windowsfeature "*$sl*"
	}
#Sets the service that you want to install
$service=read-host "`nWhat is the service that you want to install?:`t"
