#This script will install WSUS and the Managment tools that go with it
install-windowsfeature UpdateServices -IncludeManagementTools
cd "C:\Program Files\Update Services\Tools"
.\wsusutil.exe postinstall CONTENT_DIR=C:\WSUS
.\RoleSetup