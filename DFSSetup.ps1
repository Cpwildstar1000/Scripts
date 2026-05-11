#This script will install DFS
install-windowsfeature ADFS-Proxy
install-windowsfeature FS-DFS-Namespace
install-windowsfeature FS-DFS-Replication
install-windowsfeature RSAT-DFS-Mgmt-Con
.\RoleSetup