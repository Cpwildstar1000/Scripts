$subnet = Read-Host "What is the first IP in your subnet?: "
for ($i=1; $i -le 254; $i++) {
    $ip = "$subnet.$i"
    Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue
    if ($?) {Write-Host "Active IP: $ip"}
}