# This is the Active Directory Configuration choice script
clear
$title = "--------------------------------`n|Active Directory Configuration|`n--------------------------------"
write-host " "
write-host "1) Create a Single User"
write-host "2) Create Multiple Users (Requires a CSV file)"
write-host "3) Create a Group"
write-host "4) Create a Organizational Unit"
write-host "5) Create a Single Computer"
write-host "6) Create Multiple Computers (Requires a CSV file)"
write-host "7) Back"
write-host " "
$result=read-host "What do you want to do?"
switch ($result)
    {
		0{.\SUCreate}
		1{.\MUCreate}
		2{.\GroupCreate}
		3{.\OUCreate}
		4{.\SCCreate}
		5{.\MCCreate}
		6{.\RoleConfig}
    }