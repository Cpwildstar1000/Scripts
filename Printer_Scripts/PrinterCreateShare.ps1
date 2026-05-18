clear
#sets the name of the printer that you are going to use
$name=read-host "What do you want to name the printer?"
#sets the drivename that you want to assign to the printer
$drivename=read-host "What drivename do you want to assign to the printer?"
#sets the port number that the printer will use
$portname=read-host "What is the port number that you want to assign to the printer?"
add-printer -name $name -drivename $drivename -portname $portname
