# This is the call script for Group Policy Configuration
clear
$title = "--------------`n|Group Policy|`n--------------"
write-host " "
write-host "1) Create a Group Policy Object"
write-host "2) Link a Group Policy Object"
write-host "3) Create a Starter GPO"
write-host "4)Back"
write-host " "
$result=read-host "What do you want to do?"
switch ($result)
    {
		0{.\GPOCreate}
		1{.\GPOLink}
		2{.\StarterGPOCreate}
		3{.\RoleConfig}
    }
