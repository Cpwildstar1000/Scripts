# This is the call script for DHCP
clear
$title = "--------------------|DHCP Configuration|--------------------"
$message = "What do you want to do?"
$1=New-Object System.Management.Automation.Host.ChoiceDescription "&Scope Creation", `
    "_."
$2=New-Object System.Management.Automation.Host.ChoiceDescription "&_", `
    "_."
$3=New-Object System.Management.Automation.Host.ChoiceDescription "&_", `
    "_."
$4=New-Object System.Management.Automation.Host.ChoiceDescription "&Back", `
    "Goes back to _."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($1, $2, $3, $4)
$result = $host.ui.PromptForChoice($title, $message, $options, 0) 
switch ($result)
    {
		0{.\DHCPScopeCreate.ps1}
		1{}
		2{}
		3{}
    }
