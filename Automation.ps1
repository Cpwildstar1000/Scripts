##########
# Script #
##########

function Departments {
	function CTC {}
	function FSR {}
	function GAM {}
	function SGA {
		function Approvals {
			Write-Host 'Onboarding/Offboarding' `n 'Pre Approved, Include Marina Zhang on CC' `n `n 'Shared Mailbox' `n 'Marina Zhang'			
		}
		function GreatPlains {
			Write-Host `n '1. Run Setup.exe' `n '2. Click Yes' `n '3. Click on Microsoft Dynamics GP under Install' `n '4. Make sure United States is selected and click next' `n '5. Accept the License Agreement and click next' `n '6. Install Fixed Asset Management on Features page' `n '7. Click next' `n '8. Type SGASQL03 for the server name and click next' `n '9. Click install' `n '10. Click exit' `n '11. Launch GP' `n '12. Click Yes to run Dynamics GP Utilities' `n '13. Click Yes on UAC prompt' `n '14. Set System DNS to ____'
		}
		function Users {
			function Onboarding {
				function GenerateForm {

[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null

$form1 = New-Object System.Windows.Forms.Form
$button1 = New-Object System.Windows.Forms.Button
$button2 = New-Object System.Windows.Forms.Button
$listBox1 = New-Object System.Windows.Forms.ListBox
$checkBox1 = New-Object System.Windows.Forms.CheckBox
$checkBox2 = New-Object System.Windows.Forms.CheckBox
$checkBox3 = New-Object System.Windows.Forms.CheckBox
$checkBox4 = New-Object System.Windows.Forms.CheckBox
$checkBox5 = New-Object System.Windows.Forms.CheckBox
$checkBox6 = New-Object System.Windows.Forms.CheckBox
$checkBox7 = New-Object System.Windows.Forms.CheckBox
$checkBox8 = New-Object System.Windows.Forms.CheckBox
$checkBox9 = New-Object System.Windows.Forms.CheckBox
$checkBox10 = New-Object System.Windows.Forms.CheckBox
$checkBox11 = New-Object System.Windows.Forms.CheckBox
$checkBox12 = New-Object System.Windows.Forms.CheckBox
$checkBox13 = New-Object System.Windows.Forms.CheckBox
$checkBox14 = New-Object System.Windows.Forms.CheckBox
$checkBox15 = New-Object System.Windows.Forms.CheckBox
$checkBox16 = New-Object System.Windows.Forms.CheckBox
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

$b1= $false
$b2= $false
$b3= $false
$b4= $false
$b5= $false
$b6= $false
$b7= $false
$b8= $false
$b9= $false
$b10= $false
$b11= $false
$b12= $false
$b13= $false
$b14= $false
$b15= $false
$b16= $false

#----------------------------------------------
#Generated Event Script Blocks
#----------------------------------------------

$handler_button1_Click= 
{
    $listBox1.Items.Clear();    
	
	$listBox1.Items.Add("");
	$listBox1.Items.Add( "Hello _,");
	$listBox1.Items.Add( "" );
	$listBox1.Items.Add( "We've received an onboarding request for _. I've setup their new account and email." );
	$listBox1.Items.Add( "" );
	$listBox1.Items.Add( "Username: ");
	$listBox1.Items.Add( "Email: " );
	$listBox1.Items.Add( "Password: " );
	$listBox1.Items.Add( "" );
	$listBox1.Items.Add( "This account and password can be used to log into an SGA computer at an SGA office. If they need to access this email account from a personal device before signing into an SGA computer, please call us at 224-315-4320 to reset the password and to give you a non temporary password." );
	$listBox1.Items.Add( "" );
	$listBox1.Items.Add( "Best regards," );
	$listBox1.Items.Add( "_" );
	$listBox1.Items.Add( "" );
	$listBox1.Items.Add( "Ticket Notes:" );

    if ($checkBox1.Checked)     {  $listBox1.Items.Add( "Logged into DC" ); $listBox1.Items.Add( "Created user object" ) }
    if ($checkBox2.Checked)    {  $listBox1.Items.Add( "Added user to All-Staff" ) }
    if ($checkBox3.Checked)    {  $listBox1.Items.Add( "Logged into AADC" ); $listBox1.Items.Add( "Ran sync command" ) }
	if ($checkBox4.Checked)    {  $listBox1.Items.Add( "Created CW contact" ) }
	if ($checkBox5.Checked)    {  $listBox1.Items.Add( "Logged into M365" ) }
	if ($checkBox6.Checked)    {  $listBox1.Items.Add( "Assigned license to new mailbox" ) }
	if ($checkBox7.Checked)    {  $listBox1.Items.Add( "Connected to exchange online" ) }
	if ($checkBox8.Checked)    {  $listBox1.Items.Add( "Got the Exchange GUID" ) }
	if ($checkBox9.Checked)    {  $listBox1.Items.Add( "Logged into MSC" ) }
	if ($checkBox10.Checked)    {  $listBox1.Items.Add( "Ran command to enable mailuser" ) }
	if ($checkBox11.Checked)    {  $listBox1.Items.Add( "Ran command to enable remote mailbox" ) }
	if ($checkBox12.Checked)    {  $listBox1.Items.Add( "Ran command to set remote mailbox" ) }
	if ($checkBox13.Checked)    {  $listBox1.Items.Add( "Opened ecp page" ) }
	if ($checkBox14.Checked)    {  $listBox1.Items.Add( "Searched for user mailbox" ) }
	if ($checkBox15.Checked)    {  $listBox1.Items.Add( "Opened mailbox settings" ) }
	if ($checkBox16.Checked)    {  $listBox1.Items.Add( "Changed remote routing address" ) }

    if ( !$checkBox1.Checked -and !$checkBox2.Checked -and !$checkBox3.Checked -and !$checkBox4.Checked -and !$checkBox5.Checked -and !$checkBox6.Checked -and !$checkBox7.Checked -and !$checkBox8.Checked -and !$checkBox9.Checked -and !$checkBox10.Checked -and !$checkBox11.Checked -and !$checkBox12.Checked -and !$checkBox13.Checked -and !$checkBox14.Checked -and !$checkBox15.Checked -and !$checkBox16.Checked ) {   $listBox1.Items.Add('No CheckBox selected....')} 
}

$handler_button2_Click= {
	$i=14
	$CopiedText = [System.Collections.ArrayList]::new()
	$CopiedText.Add($listBox1.Items[1])
	$CopiedText.Add($listBox1.Items[2])
	$CopiedText.Add($listBox1.Items[3])
	$CopiedText.Add($listBox1.Items[4])
	$CopiedText.Add($listBox1.Items[5])
	$CopiedText.Add($listBox1.Items[6])
	$CopiedText.Add($listBox1.Items[7])
	$CopiedText.Add($listBox1.Items[8])
	$CopiedText.Add($listBox1.Items[9])
	$CopiedText.Add($listBox1.Items[10])
	$CopiedText.Add($listBox1.Items[11])
	$CopiedText.Add($listBox1.Items[12])
	$CopiedText.Add($listBox1.Items[13])
	$CopiedText.Add($listBox1.Items[14])
	if ($checkBox1.Checked) { $i++; $CopiedText.Add($listBox1.Items[$i]); $i++; $CopiedText.Add($listBox1.Items[$i]) }
	if ($checkBox2.Checked) { $i++; $CopiedText.Add($listBox1.Items[$i]) }
	if ($checkBox3.Checked) { $i++; $CopiedText.Add($listBox1.Items[$i]); $i++; $CopiedText.Add($listBox1.Items[$i]) }
	if ($checkBox4.Checked) { $i++; $CopiedText.Add($listBox1.Items[$i]) }
	if ($checkBox5.Checked) { $i++; $CopiedText.Add($listBox1.Items[$i]) }
	if ($checkBox6.Checked) { $i++; $CopiedText.Add($listBox1.Items[$i]) }
	if ($checkBox7.Checked) { $i++; $CopiedText.Add($listBox1.Items[$i]) }
	if ($checkBox8.Checked) { $i++; $CopiedText.Add($listBox1.Items[$i]) }
	if ($checkBox9.Checked) { $i++; $CopiedText.Add($listBox1.Items[$i]) }
	if ($checkBox10.Checked) { $i++; $CopiedText.Add($listBox1.Items[$i]) }
	if ($checkBox11.Checked) { $i++; $CopiedText.Add($listBox1.Items[$i]) }
	if ($checkBox12.Checked) { $i++; $CopiedText.Add($listBox1.Items[$i]) }
	if ($checkBox13.Checked) { $i++; $CopiedText.Add($listBox1.Items[$i]) }
	if ($checkBox14.Checked) { $i++; $CopiedText.Add($listBox1.Items[$i]) }
	if ($checkBox15.Checked) { $i++; $CopiedText.Add($listBox1.Items[$i]) }
	if ($checkBox16.Checked) { $i++; $CopiedText.Add($listBox1.Items[$i]) }
	$CopiedText | Set-Clipboard
}

$OnLoadForm_StateCorrection=
{
	#Correct the initial state of the form to prevent the .Net maximized form issue
    $form1.WindowState = $InitialFormWindowState
}

#----------------------------------------------
#region Generated Form Code
$form1.Text = "SGA User Onboarding"
$form1.Name = "form1"
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 1100
$System_Drawing_Size.Height = 600
$form1.ClientSize = $System_Drawing_Size

$button1.TabIndex = 4
$button1.Name = "button1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 23
$button1.Size = $System_Drawing_Size
$button1.UseVisualStyleBackColor = $True
$button1.Text = "Run Script"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 496
$button1.Location = $System_Drawing_Point
$button1.DataBindings.DefaultDataSourceUpdateMode = 0
$button1.add_Click($handler_button1_Click)
$form1.Controls.Add($button1)

$button2.TabIndex = 5
$button2.Name = "button2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 23
$button2.Size = $System_Drawing_Size
$button2.UseVisualStyleBackColor = $True
$button2.Text = "Copy Text"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 127
$System_Drawing_Point.Y = 496
$button2.Location = $System_Drawing_Point
$button2.DataBindings.DefaultDataSourceUpdateMode = 0
$button2.add_Click($handler_button2_Click)
$form1.Controls.Add($button2)

$listBox1.FormattingEnabled = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 600
$System_Drawing_Size.Height = 512
$listBox1.Size = $System_Drawing_Size
$listBox1.DataBindings.DefaultDataSourceUpdateMode = 0
$listBox1.Name = "listBox1"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 447
$System_Drawing_Point.Y = 13
$listBox1.Location = $System_Drawing_Point
$listBox1.TabIndex = 3
$listBox1.HorizontalScrollBar = $true
$form1.Controls.Add($listBox1)

$checkBox1.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 404
$System_Drawing_Size.Height = 24
$checkBox1.Size = $System_Drawing_Size
$checkBox1.TabIndex = 0
$checkBox1.Text = "Log into DC and create New User object in Active Directory"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 13
$checkBox1.Location = $System_Drawing_Point
$checkBox1.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox1.Name = "checkBox1"
$form1.Controls.Add($checkBox1)

$checkBox2.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 404
$System_Drawing_Size.Height = 24
$checkBox2.Size = $System_Drawing_Size
$checkBox2.TabIndex = 1
$checkBox2.Text = "Check if All-Staff is checked and add if it is"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 44
$checkBox2.Location = $System_Drawing_Point
$checkBox2.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox2.Name = "checkBox2"
$form1.Controls.Add($checkBox2)

$checkBox3.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 424
$System_Drawing_Size.Height = 24
$checkBox3.Size = $System_Drawing_Size
$checkBox3.TabIndex = 2
$checkBox3.Text = "Run sync command on SGAAADC1 from powershell"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 75
$checkBox3.Location = $System_Drawing_Point
$checkBox3.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox3.Name = "checkBox3"
$form1.Controls.Add($checkBox3)

$checkBox4.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 404
$System_Drawing_Size.Height = 24
$checkBox4.Size = $System_Drawing_Size
$checkBox4.TabIndex = 3
$checkBox4.Text = "Create CW contact"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 106
$checkBox4.Location = $System_Drawing_Point
$checkBox4.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox4.Name = "checkBox4"
$form1.Controls.Add($checkBox4)

$checkBox5.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 404
$System_Drawing_Size.Height = 24
$checkBox5.Size = $System_Drawing_Size
$checkBox5.TabIndex = 4
$checkBox5.Text = "Log into M365"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 137
$checkBox5.Location = $System_Drawing_Point
$checkBox5.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox5.Name = "checkBox5"
$form1.Controls.Add($checkBox5)

$checkBox6.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 404
$System_Drawing_Size.Height = 24
$checkBox6.Size = $System_Drawing_Size
$checkBox6.TabIndex = 5
$checkBox6.Text = "Assigned license to new mailbox"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 168
$checkBox6.Location = $System_Drawing_Point
$checkBox6.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox6.Name = "checkBox6"
$form1.Controls.Add($checkBox6)

$checkBox7.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 404
$System_Drawing_Size.Height = 24
$checkBox7.Size = $System_Drawing_Size
$checkBox7.TabIndex = 6
$checkBox7.Text = "Connect to Exchange Online"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 199
$checkBox7.Location = $System_Drawing_Point
$checkBox7.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox7.Name = "checkBox7"
$form1.Controls.Add($checkBox7)

$checkBox8.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 404
$System_Drawing_Size.Height = 34
$checkBox8.Size = $System_Drawing_Size
$checkBox8.TabIndex = 7
$checkBox8.Text = "Run command Get-Mailbox example@sga-youth.org | ft alias,identity,exchangeguid
"
$System_Dawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 230
$checkBox8.Location = $System_Drawing_Point
$checkBox8.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox8.Name = "checkBox8"
$form1.Controls.Add($checkBox8)

$checkBox9.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 404
$System_Drawing_Size.Height = 24
$checkBox9.Size = $System_Drawing_Size
$checkBox9.TabIndex = 8
$checkBox9.Text = "Log into MSC"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 266
$checkBox9.Location = $System_Drawing_Point
$checkBox9.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox9.Name = "checkBox9"
$form1.Controls.Add($checkBox9)

$checkBox10.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 404
$System_Drawing_Size.Height = 34
$checkBox10.Size = $System_Drawing_Size
$checkBox10.TabIndex = 9
$checkBox10.Text = 'Run command Enable-Mailuser -Identity "example@sga-youth.org" -ExternalEmailAddress "example@sga-youth.org"'
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 297
$checkBox10.Location = $System_Drawing_Point
$checkBox10.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox10.Name = "checkBox10"
$form1.Controls.Add($checkBox10)

$checkBox11.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 404
$System_Drawing_Size.Height = 34
$checkBox11.Size = $System_Drawing_Size
$checkBox11.TabIndex = 10
$checkBox11.Text = 'Run command Enable-Remotemailbox "example@sga-youth.org"'
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 333
$checkBox11.Location = $System_Drawing_Point
$checkBox11.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox11.Name = "checkBox11"
$form1.Controls.Add($checkBox11)

$checkBox12.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 404
$System_Drawing_Size.Height = 34
$checkBox12.Size = $System_Drawing_Size
$checkBox12.TabIndex = 11
$checkBox12.Text = 'Run command Set-RemoteMailbox "example@sga-youth.org" -ExchangeGuid "PUT THE GUID HERE BETWEEN THESE QUOTES"'
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 369
$checkBox12.Location = $System_Drawing_Point
$checkBox12.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox12.Name = "checkBox12"
$form1.Controls.Add($checkBox12)

$checkBox13.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 444
$System_Drawing_Size.Height = 24
$checkBox13.Size = $System_Drawing_Size
$checkBox13.TabIndex = 12
$checkBox13.Text = "Launch IE and log in"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 405
$checkBox13.Location = $System_Drawing_Point
$checkBox13.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox13.Name = "checkBox13"
$form1.Controls.Add($checkBox13)

$checkBox14.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 444
$System_Drawing_Size.Height = 24
$checkBox14.Size = $System_Drawing_Size
$checkBox14.TabIndex = 12
$checkBox14.Text = "Search for the user"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 436
$checkBox14.Location = $System_Drawing_Point
$checkBox14.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox14.Name = "checkBox14"
$form1.Controls.Add($checkBox14)

$checkBox15.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 444
$System_Drawing_Size.Height = 24
$checkBox15.Size = $System_Drawing_Size
$checkBox15.TabIndex = 12
$checkBox15.Text = "Open mamilbox settings"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 467
$checkBox15.Location = $System_Drawing_Point
$checkBox15.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox15.Name = "checkBox15"
$form1.Controls.Add($checkBox15)

$checkBox16.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 444
$System_Drawing_Size.Height = 24
$checkBox16.Size = $System_Drawing_Size
$checkBox16.TabIndex = 12
$checkBox16.Text = "Change the remote routing address"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
$System_Drawing_Point.Y = 468
$checkBox16.Location = $System_Drawing_Point
$checkBox16.DataBindings.DefaultDataSourceUpdateMode = 0
$checkBox16.Name = "checkBox16"
$form1.Controls.Add($checkBox16)


#Save the initial state of the form
$InitialFormWindowState = $form1.WindowState
#Init the OnLoad event to correct the initial state of the form
$form1.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$form1.ShowDialog()| Out-Null
} #End Function

#Call the Function
GenerateForm
			}
			function Offboarding {
				
			}
			function ComputerSetup {}
			
			clear
			$title = "--------------------|SGA Users Menu|--------------------"
			$message = "What information do you need?"
			$1=New-Object System.Management.Automation.Host.ChoiceDescription "&Onboarding", `
				"Onboarding."
			$2=New-Object System.Management.Automation.Host.ChoiceDescription "&Offboarding", `
				"Offboarding."
			$3=New-Object System.Management.Automation.Host.ChoiceDescription "&COmputer Setup", `
				"ComputerSetup"
			$options = [System.Management.Automation.Host.ChoiceDescription[]]($1, $2, $3)
			$result = $host.ui.PromptForChoice($title, $message, $options, 0) 
			switch ($result)
				{
					0{Onboarding}
					1{Offboarding}
					2{ComputerSetup}
				}
		}
		function VPN {}
		
		clear
		$title = "--------------------|SGA Menu|--------------------"
		$message = "What information do you need?"
		$1=New-Object System.Management.Automation.Host.ChoiceDescription "&Approvals", `
			"Approvals."
		$2=New-Object System.Management.Automation.Host.ChoiceDescription "&Great Plains", `
			"Great Plains."
		$3=New-Object System.Management.Automation.Host.ChoiceDescription "&Users", `
			"Users"
		$4=New-Object System.Management.Automation.Host.ChoiceDescription "&VPN", `
			"VPN"
		$options = [System.Management.Automation.Host.ChoiceDescription[]]($1, $2, $3, $4)
		$result = $host.ui.PromptForChoice($title, $message, $options, 0) 
		switch ($result)
			{
				0{Approvals}
				1{GreatPlains}
				2{Users}
				3{VPN}
			}
	}
	function Vivify {}

	clear
	$title = "--------------------|Department Menu|--------------------"
	$message = "What Department do you need information for?"
	$1=New-Object System.Management.Automation.Host.ChoiceDescription "&CTC", `
		"CTC."
	$2=New-Object System.Management.Automation.Host.ChoiceDescription "&FSR", `
		"FSR."
	$3=New-Object System.Management.Automation.Host.ChoiceDescription "&GAM", `
		"GAM"
	$4=New-Object System.Management.Automation.Host.ChoiceDescription "&SGA", `
		"SGA"
	$5=New-Object System.Management.Automation.Host.ChoiceDescription "&Vivify", `
		"Vivify"
	$options = [System.Management.Automation.Host.ChoiceDescription[]]($1, $2, $3, $4, $5)
	$result = $host.ui.PromptForChoice($title, $message, $options, 0) 
	switch ($result)
		{
			0{CTC}
			1{FSR}
			2{GAM}
			3{SGA}
			4{Vivify}
		}
}

function Program {
	
}

function Troubleshooting {
	
}

function Exit {Exit}

clear
$title = "--------------------|Automation Script|--------------------"
$message = "What information do you need?"
$1=New-Object System.Management.Automation.Host.ChoiceDescription "&Departments", `
    "Departments."
$2=New-Object System.Management.Automation.Host.ChoiceDescription "&Program", `
    "Program."
$3=New-Object System.Management.Automation.Host.ChoiceDescription "&Exit", `
    "Exit"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($1, $2, $3)
$result = $host.ui.PromptForChoice($title, $message, $options, 0) 
switch ($result)
    {
		0{Departments}
		1{Program}
		2{Exit}
    }