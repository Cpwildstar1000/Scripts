#This script will demote an Active Directory Server so that Active Directory can be uninstalled
Import-Module ADDSDeployment
Uninstall-ADDSDomainController `
-DemoteOperationMasterRole:$true `
-ForceRemoval:$true `
-Force:$true