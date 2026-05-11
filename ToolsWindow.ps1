#[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
#[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

Function MainWindow {
    $MainWindow = New-Object System.Windows.Forms.Form
    $MainWindow.Text = "Tools Program"
    $MainWindow.Size = New-Object System.Drawing.Size(250,100)
    $MainWindow.StartPosition = "CenterScreen"
    $MainWindow.focu

    $NewUserCreationButton = New-Object System.Windows.Forms.Button
    $NewUserCreationButton.Location = New-Object System.Drawing.Size (25,25)
    $NewUserCreationButton.Size = New-Object System.Drawing.Size(100,23)
    $NewUserCreationButton.Text = "User Creation"
    $NewUserCreationButton.add_click({
        $MainWindow.Close()
        . UserCreateChoice
    })
    $MainWindow.Controls.Add($NewUserCreationButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Size (150,25)
    $CancelButton.Size = New-Object System.Drawing.Size (75,23)
    $CancelButton.Text = "Cancel"
    $CancelButton.add_click({$MainWindow.Close()})
    $MainWindow.Controls.Add($CancelButton)

    $MainWindow.TopMost = $false
    $MainWindow.ShowDialog()
}


Function UserCreateChoice {
    $NewUserChoice = New-Object System.Windows.Forms.Form
    $NewUserChoice.Text = "New User"
    $NewUserChoice.Size = New-Object System.Drawing.Size(325,100)
    $NewUserChoice.StartPosition = "CenterScreen"

    $NewUserChoiceNew = New-Object System.Windows.Forms.Button
    $NewUserChoiceNew.Location = New-Object System.Drawing.Size(25,25)
    $NewUserChoiceNew.Size = New-Object System.Drawing.Size(75,23)
    $NewUserChoiceNew.Text = "Create User"
    $NewUserChoiceNew.add_click({. NewUserCreate})
    $NewUserChoice.Controls.Add($NewUserChoiceNew)

    $NewUserChoiceCopy = New-Object System.Windows.Forms.Button
    $NewUserChoiceCopy.Location = New-Object System.Drawing.Size(125,25)
    $NewUserChoiceCopy.Size = New-Object System.Drawing.Size(75,23)
    $NewUserChoiceCopy.Text = "Copy User"
    $NewUserChoiceCopy.add_click({. NewUserCopy})
    $NewUserChoice.Controls.Add($NewUserChoiceCopy)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Size (225,25)
    $CancelButton.Size = New-Object System.Drawing.Size (75,23)
    $CancelButton.Text = "Cancel"
    $CancelButton.add_click({$NewUserChoice.Close()})
    $NewUserChoice.Controls.Add($CancelButton)

    $NewUserChoice.TopMost = $false
    $NewUserChoice.ShowDialog()
}


Function NewUserCreate {
$NewUserCreate = New-Object System.Windows.Forms.Form
$NewUserCreate.Text = "Crete New User"
$NewUserCreate.Size = New-Object System.Drawing.Size (200,150)
$NewUserCreate.StartPosition = "CenterScreen"

<#$NewUserCreateFirstName = New-Object System.Windows.Forms.TextBox
$NewUserCreateFirstName.Location = New-Object System.Drawing.Size (10,40)
$NewUserCreateFirstName.Size = New-Object System.Drawing.Size (280,20)
$NewUserCreateFirstName.KeyPreview = $True
$NewUserCreate.Controls.Add($NewUserCreateFirstName)

$NewUserCreateLastName = New-Object System.Windows.Forms.TextBox
$NewUserCreateLastName.Location = New-Object System.Drawing.Size ()
$NewUserCreateLastName.Size = New-Object System.Drawing.Size ()
$NewUserCreateLastName.KeyPreview = $True
$NewUserCreate.Controls.Add($NewUserCreateLastName)

    Function Company {
    $NewUserCreateCompany = New-Object System.Windows.Forms.ListBox
    $NewUserCreateCompany.Location = New-Object System.Drawing.Size (10,20)
    $NewUserCreateCompany.Size = New-Object System.Drawing.Size (150,20)
    $NewUserCreateCompany.Height = 80
    $NewUserCreate.Controls.Add($NewUserCreateCompany)

    $NewUserCreateCompany.Items.Add("AIMS")
    $NewUserCreateCompany.Items.Add("BusSvc")
    $NewUserCreateCompany.Items.Add("CEE")
    $NewUserCreateCompany.Items.Add("CQPI")
    $NewUserCreateCompany.Items.Add("DCS")
    $NewUserCreateCompany.Items.Add("ECE")
    $NewUserCreateCompany.Items.Add("FPM")
    $NewUserCreateCompany.Items.Add("OCR")
    $NewUserCreateCompany.Items.Add("OHR")
    $NewUserCreateCompany.Items.Add("PopHealth")
    $NewUserCreateCompany.Items.Add("RecSports")
    $NewUserCreateCompany.Items.Add("UWEBC")
    $NewUserCreateCompany.Items.Add("VCFA")
    $NewUserCreateCompany.Items.Add("VCOC")
    }
    #>
$NewUserCreate.TopMost = $False
$NewUserCreate.ShowDialog()
<#
$RequestingUser = Read-Host 'What user do you want to copy? (Last, First)'
$RequestingUserInfo = Get-ADUser -Filter "Name -like '$RequestingUser'"
Write-Host ''
$RequestingUserInfo
Write-Host 'If the users info didnt appear then press ctrl+c' -ForegroundColor Yellow
Write-Host ''

$FirstName = Read-Host 'What is the first name of the person?'
$LastName = Read-Host 'What is the last name of the person?'
$UserName = Read-Host 'What is the username that you want to assign?'
$Name = "$LastName" + ', ' + "$FirstName"
$Password = Read-Host 'What is the password you want to assign?'
$Script = Read-Host 'What is the script you want to assign?'
$Company = Read-Host 'What is the users company?'
$Path = Read-Host 'Where should the user be created?'
$UserAccount = "$UserName" + '@aims.wisc.edu'

$AccountTest = (Get-ADUser -Identity $UserName -ErrorAcrion SilentlyContinue)
if (!$AccountTest -and $AccountTest -ne "$UserName") {Write-Host 'Account Doesnt Exist'}
elseif ($AccountTest -eq "$UserName") {Write-Host 'Account Already exists'}#>
}


Function NewUserCopy {
$CopyUser = Read-Host 'What user do you want to copy? (Last, First)'
$CopyUserInfo = Get-ADUser -Filter "Name -like '$CopyUser'"
Write-Host ''
$CopyUserInfo
Write-Host 'If the users info didnt appear then press ctrl+c' -ForegroundColor Yellow
Write-Host ''

$FirstName = Read-Host 'What is the first name of the person?'
$LastName = Read-Host 'What is the last name of the person?'
$UserName = Read-Host 'What is the username that you want to assign?'
$Name = "$LastName" + ', ' + "$FirstName"
$Password = Read-Host 'What is the password you want to assign?'
$Script = Read-Host 'What is the script you want to assign?'
$Company = Read-Host 'What is the users company?'
$Path = Read-Host 'Where should the user be created?'
$UserAccount = "$UserName" + '@aims.wisc.edu'

New-ADUser -Name $Name -AccountPassword (ConvertTo-SecureString "$Password" -AsPlainText -Force) -Company $Company -DisplayName $Name -Enabled $true -GivenName $FirstName -Path $Path -SamAccountName $UserName -ScriptPath $Script -Surname $LastName -UserPrincipalName $UserAccount

$CopyUserPath = $CopyUserInfo.DistinguishedName
$CopyUserGroups = (Get-ADPrincipalGroupMembership $CopyUserPath).name
ForEach ($Group in $CopyUserGroups) {
	Add-ADGroupMember -Identity $Group -Members $UserName
}

switch ($Company) {
	AIMS {$Comp = "\\aims-fs-03.aims.wisc.edu\E$\AIMS\$UserName"}
	BusSvc {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\BusSvc\$UserName"}
	CEE {$Comp = "\\aims-fs-03.aims.wisc.edu\E$\CEE\$UserName"}
	CQPI {$Comp = "\\aims-fs-03.aims.wisc.edu\E$\CQPI\$UserName"}
	DCS {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\DCS\$UserName"}
	ECE {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\ECE\$UserName"}
	FPM {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\FPM\$UserName"}
	OCR {$Comp = "\\aims-fs-03.aims.wisc.edu\E$\OCR\$UserName"}
	OHR {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\OHR\$UserName"}
	PopHealth {$Comp = "\\aims-fs-03.aims.wisc.edu\E$\PopHealth\$UserName"}
	RecSports {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\RecSports\$UserName"}
	UWEBC {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\UWEBC\$UserName"}
	VCFA {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\VCFA\$UserName"}
	VCOC {$Comp = "\\aims-fs-03.aims.wisc.edu\G$\VCOC\$UserName"}
	Test {$Comp = "C:\temp\$UserName"}
}

$Permissions = 0
if (!(Test-Path $Comp))
    {New-Item -ItemType Directory -Path $Comp}
while ($Permissions -le 3) {
	$Permissions
	if ($Permissions -eq 0) {
		$Acl = Get-Acl $Comp
		$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule ("SYSTEM", "FullControl", "Allow")
		$Acl.SetAccessRule($Ar)
		$Acl.SetAccessRuleProtection($true,$false)
		Set-Acl $Comp $Acl
	}
	elseif ($Permissions -eq 1) {
		$Acl = Get-Acl $Comp
		$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule ("Domain Admins", "FullControl", "Allow")
		$Acl.SetAccessRule($Ar)
		$Acl.SetAccessRuleProtection($true,$false)
		Set-Acl $Comp $Acl
	}
	elseif ($Permissions -eq 2) {
		$Acl = Get-Acl $Comp
		$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule ("Administrators", "FullControl", "Allow")
		$Acl.SetAccessRule($Ar)
		$Acl.SetAccessRuleProtection($true,$false)
		Set-Acl $Comp $Acl
	}
	elseif ($Permissions -eq 3) {
		$Acl = Get-Acl $Comp
		$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule ("$UserName", "FullControl", "Allow")
		$Acl.SetAccessRule($Ar)
		$Acl.SetAccessRuleProtection($true,$false)
		Set-Acl $Comp $Acl
	}
	$Permissions = $Permissions + 1
}
}

. MainWindow