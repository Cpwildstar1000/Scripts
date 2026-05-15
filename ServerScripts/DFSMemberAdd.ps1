#This script will add members to a replication group
#Sets the name that the user wants to assign to the group
$groupname=read-host "What is the group name that you want to add members to?"
#Sets what the source computer is that the members will be added to
$srccomp=read-host "What is the source computer?"
#Sets what the destination computer is that will become a member
$destcomp=read-host "What is the destination computer?"
add-dfsconnection -groupname $groupname -sourcecomputername $srccomp -destinationcomputername
.\ServerDFSComfig