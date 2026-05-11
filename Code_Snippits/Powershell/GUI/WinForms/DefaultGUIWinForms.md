# Import Assembly Types
Add-type -AssemblyName System.Windows.Forms
Add-type -AssemblyName System.Drawing

# Create MainWindow
$MainWindow = New-object System.Windows.Forms.Form
$MainWindow.Text = "Ticket Notes Creation"
$MainWindow.Size = New-Object System.Drawing.Size(1200,800)
$MainWindow.StartPosition = "CenterScreen"
$MainWindow.TopMost = $true

# Launch Window
[void]$MainWindow.ShowDialog()