################################
# Information gathering script #
################################

function ComputerInfo{
	cls
	wmic bios get serialnumber
	systeminfo | findstr /B /C:"OS Version" /C:"Domain"
}
function ProgramInfo{
	cls
	
}
function Exit{Exit}

clear
$title = "--------------------|Information Gathering Script|--------------------"
$message = "What do you want to run this on?"
$1=New-Object System.Management.Automation.Host.ChoiceDescription "&ComputerInfo", `
    "ComputerInfo."
$2=New-Object System.Management.Automation.Host.ChoiceDescription "&ProgramInfo", `
    "ProgramInfo."
$3=New-Object System.Management.Automation.Host.ChoiceDescription "&Exit", `
    "Exit"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($1, $2, $3)
$result = $host.ui.PromptForChoice($title, $message, $options, 0) 
switch ($result)
    {
		0{ComputerInfo}
		1{ProgramInfo}
		2{Exit}
    }