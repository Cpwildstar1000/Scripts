# Creates a single user in Active Directory
clear
#Tells the script what the first name of the user is
$firstname=read-host "What is the first name of the User?:`t"
clear
#Tells the script what the last name of the user is
$lastname=read-host "What is the last name of the User?:`t"
clear
#Tells the script where you want the user stored
$path=read-host "What is the path you want it stored in?:`t"
clear
#Tells the script what password you want assigned to the user
$password=read-host "What is the password that you want the user to have?:`t"
clear
#Sets the username of the user
$username="$firstname $lastname"`
new-aduser -Name "$username"`
-DisplayName "$username"`
-AccountPassword (convertto-securestring "Pa$$w0rd" -asplaintext -force)`
-SamAccountName "firstname"`
-path "$path"`
-enabled $true
.\ADConfig