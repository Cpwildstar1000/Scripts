#This script creates a replication group
$groupname=read-host "What do you want to name the replication group?"
new-dfsreplicationgroup -groupname "$groupname"
.ServerDFSConfig