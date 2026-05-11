#This script will create a namespace
clear
#Sets what the user wants as the name for the folder that will be created
$targetpath=read-host "What is the sharename of the target folder?"
clear
#Sets what type of namespace that you want to create
$type=read-host "What is the type you want to create? (standalone, DomainV1, DomainV2)"
clear
#Sets the path to the folder that the user wants to create
$path=read-host "What is the path to the folder you want to use?"
clear
New-DFSnRoot -TargetPath $targetpath -Type $type -Path $path
.\ServerDFSConfig