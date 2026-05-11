# ================================================================
#
# File Delete Script
#
# AUTHOR: CJ Pulvermacher
# DATE  : 6/27/2016
# COMMENT: Script Finds files on remote server and deletes them.
#
# ================================================================

$Servers = Get-Content C:\Temp\ServerList.txt

ForEach ($Server in $Servers) {
    Write-Host 'If one of the bellow commands fails quit the script.'
    nslookup $Server
    ping $Server
    pause
	cls
	$CheckPSDrive = (!(Get-PSDrive -Name X))
	if ($CheckPSDrive -eq 'False')
		{Write-Host 'X Exists!'}
	else {Write-Host 'X is free'}
    #New-PSDrive -Name X -PSProvider FileSystem -Root \\$Server\F$\inetpub
	#New-PSDrive -Name X -PSProvider FileSystem -Root \\$Server\D$\data\inetpub
	#New-PSDrive -Name X -PSProvider FileSystem -Root \\$Server\D$\inetpub
	New-PSDrive -Name X -PSProvider FileSystem -Root \\$Server\C$\inetpub\wwwroot
    Write-Host "Gathering folder/file structure details on $Server"
    $ServerFiles = Get-ChildItem X:\ -Recurse | Where-Object {$_.PSIsContainer -eq $False}
    #$ServerFiles > \\$Server\C$\Temp\FileList.txt
    Write-Host "`nChecking gathered structure for specified files"
    ForEach ($File in $ServerFiles) {
        #$File | select name,directory
        $NewFile = 'Old' + "$File"
        switch ($File) {
            DotNetNuke.install.config {
                $NewFile = 'Old' + "$File"
                Rename-Item $File.PSPath $NewFile
                Write-Host "$File was renamed"
            }
            DotNetNuke.install.config.resources {
                $NewFile = 'Old' + "$File"
                Rename-Item $File.PSPath $NewFile
                Write-Host "$File was renamed"
            }
            InstallWizard.aspx {
                $NewFile = 'Old' + "$File"
                Rename-Item $File.PSPath $NewFile
                Write-Host "$File was renamed"
            }
            InstallWizard.aspx.cs {
                $NewFile = 'Old' + "$File"
                Rename-Item $File.PSPath $NewFile
                Write-Host "$File was renamed"
            }
            InstallWizard.aspx.designer.cs {
                $NewFile = 'Old' + "$File"
                Rename-Item $File.PSPath $NewFile                
                Write-Host "$File was renamed"
            }
            UpgradeWizard.aspx {
                $NewFile = 'Old' + "$File"
                Rename-Item $File.PSPath $NewFile
                Write-Host "$File was renamed"
            }
            UpgradeWizard.aspx.cs {
                $NewFile = 'Old' + "$File"
                Rename-Item $File.PSPath $NewFile
                Write-Host "$File was renamed"
            }
            UpgradeWizard.aspx.designer.cs {
                $NewFile = 'Old' + "$File"
                Rename-Item $File.PSPath $NewFile
                Write-Host "$File was renamed"
            }
            Install.aspx {
                $NewFile = 'Old' + "$File"
                Rename-Item $File.PSPath $NewFile
                Write-Host "$File was renamed"
            }
            Install.aspx.cs {
                $NewFile = 'Old' + "$File"
                Rename-Item $File.PSPath $NewFile
                Write-Host "$File was renamed"
            }
            Install.aspx.designer.cs {
                $NewFile = 'Old' + "$File"
                Rename-Item $File.PSPath $NewFile
                Write-Host "$File was renamed"
            }
        }
        <#switch ($File) {
            DotNetNuke.install.config {
                Write-Host "$File was found. Now deleting the file."
                pause
                }
            DotNetNuke.install.config.resources {
                Write-Host "$File was found. Now deleting the file."
                pause
            }
            InstallWizard.aspx {
                Write-Host "$File was found. Now deleting the file."
                pause
            }
            InstallWizard.aspx.cs {
                Write-Host "$File was found. Now deleting the file."
                pause
            }
            InstallWizard.aspx.designer.cs {
                Write-Host "$File was found. Now deleting the file."
                pause
            }
            UpgradeWizard.aspx {
                Write-Host "$File was found. Now deleting the file."
                pause
            }
            UpgradeWizard.aspx.cs {
                Write-Host "$File was found. Now deleting the file."
                pause
            }
            UpgradeWizard.aspx.desifner.cs {
                Write-Host "$File was found. Now deleting the file."
                pause
            }
            Install.aspx {
                Write-Host "$File was found. Now deleting the file."
                pause
            }
            Install.aspx.cs {
                Write-Host "$File was found. Now deleting the file."
                pause
            }
            Install.aspx.designer.cs {
                Write-Host "$File was found. Now deleting the file."
                pause
            }#>
    }
}
Write-Host 'Script has completed.'