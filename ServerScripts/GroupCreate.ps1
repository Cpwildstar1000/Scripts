#Creates a group in Active Directory
clear
#Tells the script what you want to call the group
$name=read-host "What is the name of the group that you want to create?`t"
clear
#Tells the script what you want for the category (eg. Security)
$category=read-host "What is the category of the group you want to create?`t"
clear
#Tells the script what you want for the scope (eg. global)
$scope=read-host "What is the scope of the group you want to create?`t"
clear
#Tells the script what you want the displayname to be for the group
$displayname=read-host "What is the displayname that you want?`t"
clear
#Tells the script where you want to put the group
$path=read-host "What is the path you want it to be created in?(eg. ou=groups,ou=MyCompany,dc=Company,dc=priv)`t"
clear
new-adgroup -name "$name" -samaccountname "$name" -displayname "$displayname" -groupcategory $category -groupscope $scope -path "$path"
.\ADConfig.ps1