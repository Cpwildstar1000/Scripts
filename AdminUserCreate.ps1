#This script will create a admin user
clear
#Tells the script what you want the name to be
$name=read-host "What do you want the name to be?:`t"
clear
#Tells the script what group you want to put the user in
$group=read-host "What is the group you want it to be a member of?:`t"
#sets the member
$member='$name"-"$group'
Add-ADGroupMmember -identity $name -Members $member 