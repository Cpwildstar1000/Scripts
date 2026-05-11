# 
clear
$title = "-------------------`n|DNS Configuration|`n-------------------"
write-host " "
write-host "1) Create a Forward Lookup Zone"
write-host "2) Create a Reverse Lookup Zone"
write-host "3) Create a A Record"
write-host "4) Create a CNAME Record"
write-host "5) Create a MX Record"
write-host "6) Create a PRT Record"
write-host "7) Back"
write-host " "
$result=read-host "What do you want to do?" 
switch ($result)
    {
		0{.\ForwardCreate}
		1{.\ReverseCreate}
		2{.\ARecordCreate}
		3{.\CNAMERecordCreate}
		4{.\MXRecordCreate}
		5{.\PTRRecordCreate}
		6{.\RoleConfig}
    }
