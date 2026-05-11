#Creates multiple users in Active Directory
clear
#Sets the name that you want to assign to the computer
$name=read-hsot "What do you want to name the computer?"
clear
#Sets the path of where you want to store the new computer
$path=read-hsot "Where do you want to put the computer?"
 New-ADComputer -Name $name -Path $path -SamAccountName $name
.\ADConfig.ps1