#This script will apply a fine grained password policy to an ou
clear
#gets a list of password policies that have been created
Get-ADFineGrainedPasswordPolicy -filter {name -like "*"}|ft Name,Precedence,MaxPasswordAge,MinPasswordLength -A
#stores the name of the password policy that you want to apply
$identity=read-host "What is the name of the password policy that you want to apply?"
clear
#stores the name of the place that you want the password policy applyed to
$subjects=read-host "What is the name of the place that you want the password policy applyed to?"
clear
Add-ADFineGrainedPasswordPolicySubject -Identity $identity -Subjects $subjects
.\ServerGPConfig