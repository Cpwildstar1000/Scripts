# Load the required assemblies
Add-Type -AssemblyName PresentationFramework
Add-Type -Path "C:\path\to\nuget\packages\oxyplot.wpf\2.1.0\lib\net45\OxyPlot.Wpf.dll"

# Sample email content
$emailContent = @"
Service record: 001
Company: Company A
Summary: Issue 1
Contact: John Doe
Phone: 123-456-7890
"@

# Function to parse email content
function Parse-EmailContent {
    param ($content)
    $lines = $content -split "`n"
    $data = [PSCustomObject]@{
        TicketNumber = ($lines | Where-Object { $_ -like 'Service record:*' }).Split(':')[1].Trim()
        Company = ($lines | Where-Object { $_ -like 'Company:*' }).Split(':')[1].Trim()
        Summary = ($lines | Where-Object { $_ -like 'Summary:*' }).Split(':')[1].Trim()
        Contact = ($lines | Where-Object { $_ -like 'Contact:*' }).Split(':')[1].Trim()
        Phone = ($lines | Where-Object { $_ -like 'Phone:*' }).Split(':')[1].Trim()
    }
    return $data
}

# Function to update the plot with the number of tickets by company
function Update-Plot {
    param ($listView, $plotModel)
    $data = $listView.Items | Group-Object -Property Company | Sort-Object -Property Count -Descending
    $plotModel.Series[0].Items.Clear()
    $plotModel.Axes[0].Items.Clear()
    foreach ($group in $data) {
        $plotModel.Series[0].Items.Add([OxyPlot.Series.ColumnItem]::new($group.Count))
        $plotModel.Axes[0].Items.Add($group.Name)
    }
    $plotModel.InvalidatePlot(true)
}

# Function to check for new emails
function Check-For-New-Emails {
    # Simulate checking for new email content (replace this with actual email fetching logic)
    $newEmailContent = @"
Service record: 003
Company: Company C
Summary: Issue 3
Contact: Alice Johnson
Phone: 555-555-5555
"@
    $newParsedData = Parse-EmailContent -content $newEmailContent
    $activeListView.Items.Add($newParsedData)
    Update-Plot -listView $activeListView -plotModel $plotModel
}

# Function to update the timer interval
function Update-Timer-Interval {
    param ($interval)
    switch ($interval) {
        '1 Minute' { $timer.Interval = [TimeSpan]::FromMinutes(1) }
        '5 Minutes' { $timer.Interval = [TimeSpan]::FromMinutes(5) }
        '30 Minutes' { $timer.Interval = [TimeSpan]::FromMinutes(30) }
        '1 Hour' { $timer.Interval = [TimeSpan]::FromHours(1) }
    }
    $timer.Stop()
    $timer.Start()
}

# Parse the sample email content
$parsedData = Parse-EmailContent -content $emailContent

# Create a new window
$window = New-Object System.Windows.Window
$window.Title = "PowerShell GUI Example"
$window.Width = 800
$window.Height = 600

# Create a StackPanel to arrange elements vertically
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = "Vertical"
$stackPanel.HorizontalAlignment = "Center"
$stackPanel.VerticalAlignment = "Center"

# Create a Label
$label = New-Object System.Windows.Controls.Label
$label.Content = "Ticket List"
$label.FontSize = 16
$label.HorizontalAlignment = "Center"
$label.Margin = "0,0,0,10"

# Create a ListView for active tickets
$activeListView = New-Object System.Windows.Controls.ListView
$activeListView.Width = 550
$activeListView.Height = 150
$activeListView.Margin = "0,0,0,10"

# Define the GridView for the ListView
$gridView = New-Object System.Windows.Controls.GridView

# Add columns to the GridView
$columns = @(
    @{Header="Ticket Number"; Width=100},
    @{Header="Company"; Width=100},
    @{Header="Summary"; Width=150},
    @{Header="Contact"; Width=100},
    @{Header="Phone"; Width=100}
)

foreach ($column in $columns) {
    $gridViewColumn = New-Object System.Windows.Controls.GridViewColumn
    $gridViewColumn.Header = $column.Header
    $gridViewColumn.Width = $column.Width
    $gridViewColumn.DisplayMemberBinding = New-Object System.Windows.Data.Binding ($column.Header -replace ' ', '')
    $gridView.Columns.Add($gridViewColumn)
}

$activeListView.View = $gridView

# Populate ListView with parsed data
$activeListView.ItemsSource = @($parsedData)

# Create a ListView for resolved tickets
$resolvedListView = New-Object System.Windows.Controls.ListView
$resolvedListView.Width = 550
$resolvedListView.Height = 150
$resolvedListView.Margin = "0,0,0,10"

# Use the same GridView for the resolved ListView
$resolvedListView.View = $gridView

# Create a Button to add new tickets
$addButton = New-Object System.Windows.Controls.Button
$addButton.Content = "Add Ticket"
$addButton.FontSize = 16
$addButton.HorizontalAlignment = "Center"
$addButton.Padding = "5,5,5,5"

# Define the button click event for adding new tickets
$addButton.Add_Click({
    # You can add logic to fetch new email content and parse it
    $newEmailContent = @"
Service record: 002
Company: Company B
Summary: Issue 2
Contact: Jane Smith
Phone: 098-765-4321
"@
    $newParsedData = Parse-EmailContent -content $newEmailContent
    $activeListView.Items.Add($newParsedData)
    Update-Plot -listView $activeListView -plotModel $plotModel
})

# Create a Button to mark tickets as resolved
$resolveButton = New-Object System.Windows.Controls.Button
$resolveButton.Content = "Mark as Resolved"
$resolveButton.FontSize = 16
$resolveButton.HorizontalAlignment = "Center"
$resolveButton.Padding = "5,5,5,5"

# Define the button click event for resolving tickets
$resolveButton.Add_Click({
    $selectedItems = $activeListView.SelectedItems
    if ($selectedItems.Count -gt 0) {
        foreach ($item in $selectedItems) {
            $resolvedListView.Items.Add($item)
            $activeListView.Items.Remove($item)
        }
        Update-Plot -listView $activeListView -plotModel $plotModel
    } else {
        [System.Windows.MessageBox]::Show("Please select a ticket to mark as resolved.")
    }
})

# Create a PlotView for the graph
$plotModel = New-Object OxyPlot.PlotModel -Property @{
    Title = "Number of Tickets by Company"
}

$categoryAxis = New-Object OxyPlot.Axes.CategoryAxis
$categoryAxis.Position = [OxyPlot.Axes.AxisPosition]::Bottom
$plotModel.Axes.Add($categoryAxis)

$linearAxis = New-Object OxyPlot.Axes.LinearAxis
$linearAxis.Position = [OxyPlot.Axes.AxisPosition]::Left
$plotModel.Axes.Add($linearAxis)

$columnSeries = New-Object OxyPlot.Series.ColumnSeries
$plotModel.Series.Add($columnSeries)

# Create a PlotView control and set the PlotModel
$plotView = New-Object OxyPlot.Wpf.PlotView
$plotView.Model = $plotModel
$plotView.Height = 200
$plotView.Width = 550
$plotView.Margin = "0,0,0,10"

# Initial plot update
Update-Plot -listView $activeListView -plotModel $plotModel

# Create a ComboBox for the email check interval
$intervalLabel = New-Object System.Windows.Controls.Label
$intervalLabel.Content = "Check Email Every:"
$intervalLabel.FontSize = 14
$intervalLabel.HorizontalAlignment = "Center"
$intervalLabel.Margin = "0,10,0,5"

$intervalComboBox = New-Object System.Windows.Controls.ComboBox
$intervalComboBox.Width = 200
$intervalComboBox.Margin = "0,0,0,10"
$intervalComboBox.HorizontalAlignment = "Center"
$intervalComboBox.Items.Add("1 Minute")
$intervalComboBox.Items.Add("5 Minutes")
$intervalComboBox.Items.Add("30 Minutes")
$intervalComboBox.Items.Add("1 Hour")
$intervalComboBox.SelectedIndex = 0

# Create a Timer for checking emails
$timer = New-Object System.Timers.Timer
$timer.AutoReset = $true
$timer.Add_Elapsed({
    Check-For-New-Emails
})

# Start the timer with the initial interval
Update-Timer-Interval -interval $intervalComboBox.SelectedItem

# Define the ComboBox selection changed event
$intervalComboBox.Add_SelectionChanged({
    Update-Timer-Interval -interval $intervalComboBox.SelectedItem
})

# Add the controls to the StackPanel
$stackPanel.Children.Add($label)
$stackPanel.Children.Add($activeListView)
$stackPanel.Children.Add($addButton)
$stackPanel.Children.Add($resolveButton)
$stackPanel.Children.Add($plotView)
$stackPanel.Children.Add($intervalLabel)
$stackPanel.Children.Add($intervalComboBox)

# Create a label for resolved tickets
$resolvedLabel = New-Object System.Windows.Controls.Label
$resolvedLabel.Content = "Resolved Tickets"
$resolvedLabel.FontSize = 16
$resolvedLabel.HorizontalAlignment = "Center"
$resolvedLabel.Margin = "0,10,0,10"

$stackPanel.Children.Add($resolvedLabel)
$stackPanel.Children.Add($resolvedListView)

# Set the content of the window to the StackPanel
$window.Content = $stackPanel

# Show the window
$window.ShowDialog()
