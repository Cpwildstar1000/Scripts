#This scirpt will set different parts of the policy
clear
#Tells the script what the policy is named
$name=read-host "What is the name of the policy you want?`t"
clear
#Tells the script what the context is
$context=read-host "What is the context you want to set?`t"
clear
#Tells the script what key you want to effect
$key=read-host "What is the key that you want to change?`t"
clear
#Tells the script what the name of the value is
$valuename=read-host "What is the name of the value that you want to change?`t"
clear
#Tells the script what value that you want to set for the key
$value=read-host "What is the value that you want to set?`t"
clear
#Tells the script what type of key that you want to work with
$type=read-host "What is the type of key that you want to change?`t"
clear
#Tells the script what you want to do to the key
$action=read-host "How do you want to effect the key?`t"
clear
Set-GPRegistryValue -name "$name" -context $context -valuename $valuename -key "$key" -value "$value" -type $type