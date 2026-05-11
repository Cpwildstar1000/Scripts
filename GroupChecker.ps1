$folderExists = '0'
cls
Write-Host 'Folder will be created in directory you choose'
$saveFolder = Read-Host 'Where do you want to save the output?'
cls
$rootFolder = Read-Host 'What is the Root Folder?'
cls
$groupName = Read-Host 'What is the Name of the group?'
cls
Write-Host 'Checking ACLs for all folders'


# Recursively check ACL on all folders and files.
if ((Test-Path $rootFolder) -eq $true) {
	# Creates an array list called ACLFolderAccessList
	$script:ACLFolderAccessList = New-Object System.Collections.ArrayList
	# Gets a list of folders under the specified folder and stores them in the $folder variable. -SilentlyContinue is for the paths that are over 260 characters and create errors.
	$folders = Get-ChildItem $rootFolder -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.PSIsContainer}
	Foreach ($folder in $folders) {
		$ACL = Get-ACL -Path $folder.FullName
		Foreach ($ACE in $ACL.access) {
			if (($ACE.IdentityReference) -like "*\$groupName") {
				if (($ACE.IsInherited) -eq $false) {
					$ACLFolderAccessList.add($folder.FullName) | Out-Null
					Write-Host $folder.FullName
					$folderName = $folder.FullName
					$folderName | out-file -filepath C:\users\cpulvermacher\desktop\accesscheckoutput\ACLFolderAccessList.txt
					break
				}
			}
		}
	}
	
	if (Test-Path "$saveFolder\AccessCheckOutput") {
		Write-Host 'Removing old Folder'
		rmdir $saveFolder\AccessCheckOutput
		$folderExists = '1'
	}
	mkdir $saveFolder\AccessCheckOutput
	$outputFolder = "$saveFolder\AccessCheckOutput"

	Write-Host 'Compiling List'
	$ACLFolderAccessList.Sort()
	Foreach ($folder in $ACLFolderAccessList) {
		$Split = $folder.split()
		
		Write-Host $folder
	}
	#$ACLFolderAccessList | out-file -FilePath C:\users\cpulvermacher\desktop\accesscheckoutput\ACLFolderAccessList.txt
}
cls
Write-Host 'Checking ACLs for all folders...............[DONE]'
#Write-Host 'Checking 


For each server in your org:

recursively check SACL on all folders and files (system access control lists - these control auditing)
recursively check owner on all folders and files
recursively check ACL, SACL, and owner on all registry keys
recursively check ACL, SACL, and owner on all named pipes, processes and threads, services, jobs, etc.
Check all OS level privileges (though it is possible this can be made easier using GPOs...)
Check all COM+ roles, MSMQ roles, etc.
For each domain in your AD:
Check all domain-level privileges
check all GPOs (group policy objects)
For each database server:
Check all server roles
check all database roles
check all application roles (in MSSQL)
For each Sharepoint portal:
check all server-level roles and privileges
check all site-level and list-level roles and privileges
For each 3rd party application:
Check any use of AD groups
verify how the app uses these roles:
-> Group name vs. DN vs. group SID vs. ... e.g. group GUID
-> does the app explictly check direct role membership, or does it use the "smarter" recursive methods?
Note that this applies both to 3rd party packaged products and platforms (e.g. Oracle, SAP, MQSeries, WebSphere... ), and to custom developed business apps.