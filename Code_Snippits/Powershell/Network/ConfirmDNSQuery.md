# Confirms computer DNS entry is correct

$Computer = Read-Host "Enter the computer name to update"
$ComputerName = (Resolve-DnsName $Computer).Name
$IP = (Resolve-DnsName).IPAddress
$IPComputerName = (Resolve-DnsName).NameHost
if ($ComputerName -eq $FullComputerName) {
    # Enter code here
}