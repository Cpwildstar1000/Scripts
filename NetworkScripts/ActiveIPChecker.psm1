##################################
# Script to check for Active IPs #
##################################


function Test-IPAddressRange {
    param (
        OptionalParameters
    )
    
}

# Variable Setup
$UpIPs = New-Object System.Collections.Generic.List[System.Object]
$NormalPorts = New-Object System.Collections.Generic.List[System.Object]

<# Variable Population
$NormalPorts.Add(20)
$NormalPorts.Add(21)
$NormalPorts.Add(22)
$NormalPorts.Add(53)
$NormalPorts.Add(67)
$NormalPorts.Add(68)
$NormalPorts.Add(69)
$NormalPorts.Add(80)
$NormalPorts.Add(88)
$NormalPorts.Add(109)
$NormalPorts.Add(110)
$NormalPorts.Add(115)
$NormalPorts.Add(118)
$NormalPorts.Add(123)
$NormalPorts.Add(143)
$NormalPorts.Add(156)
$NormalPorts.Add(161)
$NormalPorts.Add(443)
$NormalPorts.Add(445)
$NormalPorts.Add(464)
$NormalPorts.Add(520)
$NormalPorts.Add(521)
$NormalPorts.Add(546)
$NormalPorts.Add(547)
$NormalPorts.Add(631)
$NormalPorts.Add(691)
$NormalPorts.Add(853)
$NormalPorts.Add(860)
$NormalPorts.Add(989)
$NormalPorts.Add(990)
$NormalPorts.Add(992)
$NormalPorts.Add(993)
$NormalPorts.Add(995)
$NormalPorts.Add(1194)
$NormalPorts.Add(3389)
$NormalPorts.Add(
#>

# Gets IP from user input and generates variable for range
$IPRange = Read-Host "What is the IP Range?"
$FinalOctet = 1..254

#
ForEach ($i in $FinalOctet) {
    $IP = $IPRange.split(".")[0] + "." + $IPRange.split(".")[1] + "." + $IPRange.split(".")[2] + "." + $i
    if ($(ping -n 1 -w 1000 $IP > $null; $?)) {
        $UpIPs.Add($IP)
    } 
    else {
        $Responce = 'down'
    }
}


#Test Ports
