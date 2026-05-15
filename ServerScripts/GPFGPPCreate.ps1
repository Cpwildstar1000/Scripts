#This script will create a fine grained password policy
clear
#this sets the name for the policy
$name=read-host "What do you want to name the policy?"
clear
#this sets the order in which it the policy will be applyed if there is more than one
$precedence=read-host "What is the precedence you want to assign?"
clear
#this sets the minimum password length
$mpl=read-host "What is the min. length of the password you want?"
clear
New-ADFineGrainedPasswordPolicy -Name $name -Precedence $precedence -MinPasswordLength $mpl
.\ServerGPConfig.ps1