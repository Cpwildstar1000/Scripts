cls

## Adds the PowerCLI Snapin that runs the command line
Add-PSSnapin vmware.vimautomation.core

## Connects to the VMware server. Change the server to the VMware  server you want to run the script/commands on.
Connect-VIServer -Server aims-vcntr-02.aims.wisc.edu

## Stores VM/s with specified Name in variable $VM. Change -Name to store other VMs.
$VM = (Get-VM -Name udskinst*)

## Adds the user after -Principal to the VM/s stored in the $VM variable and assigns the -Role to the user. Change -Principal for the user and -Role for the role
New-VIPermission -Entity $VM -Principal "aims\AIMS-IncidentTeam-Senior" -Role AIMS-IncidentTeam-Senior
New-VIPermission -Entity $VM -Principal "aims\AIMS-IncidentTeam-Professional" -Role AIMS-IncidentTeam-Senior