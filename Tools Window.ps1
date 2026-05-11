# Create window
$obj = New-Object System.Windows.Forms.Form
$obj.Text = "Tools Program"
$obj.Size = New-Object System.Drawing.Size(300,200)
$obj.StartPosition = "CenterScreen"

# Creates buttons
$NewUserCreationButton = New-Object System.Windows.Forms.Button
$NewUserCreationButton.Location = New-Object System.Drawing.Size (75,100)
$NewUserCreationButton.Size = New-Object System.Drawing.Size(75,23)
$NewUserCreationButton.Text = "New User"
$obj.Controls.Add($NewUserCreationButton)