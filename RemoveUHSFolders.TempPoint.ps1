<#	
	.NOTES
	===========================================================================
	 Created on:   	6/13/2018 1:58 PM
	 Created by:   	cpulvermacher
	 Edited:
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

# All variables
$PNCFolderPath = 'C:\pncapp\$FolderName'
$ProfilePath = 'C:\Users\$FolderName'

# Create variable for all xen servers
$Servers = @()
$Servers += "xendesk06", "xendesk07", "xendesk08", "xendesk09", "xendesk10", "xendesk11", "xendesk12", "xendesk13", "xendesk14"

# Delete folder on server
foreach ($Server in $Servers)
{
	$TestPNCFolderPath = Test-Path $PNCFolderPath
	$TestProfilePath = Test-Path $ProfilePath
	if ($TestPNCFolderPath -eq "True")
	{
		Remove-Item -Path $PNCFolderPath
	}
	
	if ($TestProfilePath -eq "True")
	{
		Remove-Item	-Path $ProfilePath
	}
}