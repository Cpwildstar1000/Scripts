# This is the Server Role script
clear
$title = "--------------`n|Server Roles|`n--------------"
write-host " "
write-host "1) Install a Role"
write-host "2) Configure a Role"
write-host "3) Back"
write-host " "
$result=read-host "What do you want to do?"
switch ($result)
    {
		0{.\RoleSetup}
		1{.\RoleConfig}
		2{.\Start}
    }
