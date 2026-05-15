#This script will grant users permissions to your DFS Folders
#site=http://technet.microsoft.com/en-us/library/jj884272.aspx
clear
#Sets the path of the folder that you want to modify the permisions for
$path=read-host "What is the path of the folder that you want to modify permissions for?"
clear
#Sets the account that you want to grant access to the folder
$account=read-host "What is the account that you want to grant access to?"
clear
Grant-DFSnAccess -Path $path -AccountName $account
.\ServerDFSConfig