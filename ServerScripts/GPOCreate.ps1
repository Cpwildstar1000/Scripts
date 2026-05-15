#This script will create a GPO
clear
#Tells the script what you want to name the GPO
$name=read-host "What so you want to name the GPO?`t"
New-GPO -Name $name
.\ServerGPConfig.ps1