#This script will install IIS
Install-WindowsFeature Web-Server -includeallsubfeature 
install-windowsfeature adfs-web-agents
Install-WindowsFeature BITS -includeallsubfeature
.\RoleSetup