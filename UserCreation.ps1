Import-Module ActiveDirectory
cls
#Write-Host 'Welcome to the User Creation Tool. This tool is designed to create a user with the proper information for the UW system. Please fill out as much information as you can. If you cant find some information the tool will try and find it for you.' -ForegroundColor "Yellow"
$correct = 0
while ($correct -eq 0){
	$FirstName = Read-Host 'What is the users First Name?'
	$LastName = Read-Host 'What is the users Last Name?'
	$EmployeeID = Read-Host 'What is the users EmployeeID?'
	$Company = Read-Host 'What is the users Company?'
	$Password = Read-Host 'What is the users Password?'
	$scriptPath = Read-Host 'What is the scriptPath for the user?'
	$samaccountName = Read-Host 'What is the users sAMAccountName?'
	$Path = Read-Host 'Where is the users OU?'
	}
$username = "$LastName" + ', ' + "$FirstName"
if ($PVI -match "UW*"){}
else{
	$ErrorLvl = 0
	# $FileRead = Read-Host 'What is the path to the file that you want to read from?'
	# $FileWrite = Read-Host 'What is the path that you want to store the file in?'
	$UserName = Read-Host 'What is your username?'
	$Password = Read-Host 'What is your password?'
	$username = "$UserName" 
	$password = "$Password" 
	write-host "Begin User Search `n"
	write-host "Launching IE`n"
	# Creates a new instance of IE
	$ie = New-Object -com InternetExplorer.Application 
	$html = $ie.document
	# Makes IE Visible
	$ie.visible=$true;
	# Gives IE Time to load
	start-sleep -milliseconds 5000
	write-host "`nNavigating to PersonLookup"
	# Goes to PersonLookup Site
	$ie.navigate("https://www.aims.wisc.edu/aims/aimsadmin/personlookup/tabid/194/default.aspx");
	write-host "`nLoging in"
	while($ie.Busy -eq $true) {start-sleep -m 5000} 
	# Puts Credentials in the login form
	$ie.document.getElementById('j_username').value= "$username"
	$ie.document.getElementById('j_password').value = "$password"
	# $ie.document.getElementById('_idp_authn_lc_key').click();
	start-sleep 3

	# Starts the user lookup process
	# Gets the Users
	cls
	$i=0
	Import-Csv -Path "..\Files\UserInfo.csv" | ForEach-Object {
		$LastName=$_.SurName
		$FirstName=$_.GivenName
		$Name='EmployeeName: '+"$LastName"+', '+"$FirstName"
		# Write-Host $Name
		$Name | Out-File -FilePath "..\Files\UserLookup.txt" -append
		# Puts Last Name Information in the form	
		$ie.document.getElementById('dnn_ctr755_View_ctrlSearchCriteria_txtLastName').value= $LastName
		# Puts First Name Information in the form
		$ie.document.getElementById('dnn_ctr755_View_ctrlSearchCriteria_txtFirstName').value= $FirstName
		# Submits the Information
		$ie.document.getElementById('dnn_ctr755_View_ctrlSearchCriteria_ctrlCOBSearch').click();
		# Searches the Objects that were returned
		start-sleep 10
		$ie.document.getElementById('dnn_ctr755_View_ctrlPeopleSearchResult_gv_ctl02_ImageButton1').click();
		# Gets the PVI Information
		start-sleep 10
		# One of these two is getting the EmployeeID
		$ie.document.getElementsByTagName('span') | ? { $_.className -eq 'Bdata' } | % {
		$ID  = $_.getAttributeNode('dnn_ctr755_View_ctl00_lbPVI').value | % { $_.innerText }}

		$PVIsub = $ie.document.getElementById('dnn_ctr755_View_ctl00_lbPVI').innerHTML
		$PVI = 'EmployeeID: '+"$PVIsub"
		# Write-Host $PVI
		$PVI | Out-File -FilePath "..\Files\UserPVIInfo" -append
		start-sleep 15
	}
	Write-Host 'PersonLookup Complete. UserPVIInfo.txt was created.'
	}
<# if (){
	
	}
 New-ADUser -DisplayName "$username" -SamAccountName "$sAMAccountName" -EmployeeID "$EmployeeID" -Path "$Path" -Company "$Company" -ScriptPath "$scriptPath" -AccountPassword (convertto-securestring "$Password" -asplaintext -force) -ChangePasswordAtLogon -enabled $true #>
