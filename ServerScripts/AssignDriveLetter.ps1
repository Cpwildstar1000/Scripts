#This script will create folders in DFS
clear
#Sets the drive letter that the user wants to assign
$name=read-host "What is the drive letter you want to assign?"
#Sets the path of the folder that the user wants to assign the drive letter to
$path=read-host "What is the path to the folder you want to use?"
net use $name $path
.\ServerDFSConfig