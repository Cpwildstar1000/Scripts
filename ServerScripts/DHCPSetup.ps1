#This script will install DHCP
#installs DHCP
Install-WindowsFeature DHCP
#installs the GUI management tools for DHCP
Install-WindowsFeature RSAT-DHCP
#adds the DHCP Server to Active Directory
Add-DhcpServerInDC Server1 192.168.20.100
$restart=read-host "Server needs to restart in order to apply changes. Do you want to restart? (y/n)"
if ($restart -eq "y")
    {shutdown -r -t 0}
