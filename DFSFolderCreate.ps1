#This script will create folders in DFS
clear
#Sets the name that the user wants to use 
$name=read-host "What is the drive letter you want to assign?"
#Sets the path of where the folder that you want to deploy is
$path=read-host "What is the path to the folder you want to use?"
net use $name $path
# .\ServerDFSConfig