## Script will restart the Unidesk VMs
##
## Last Edited: 10/19/2017	CJ Pulvermacher

## Open PowerCLI


## Sign in to PowerCLI
Connect-VIServer -Server aims-vcntr-02.aims.wisc.edu

## Restart the UMCN
Restart-VMGuest -VM AIMS-UMCN-01
Start-Sleep -s 120

## Restart the UMCP
Restart-VMGuest -VM AIMS-UMCP-01
Start-Sleep -s 120

## Restart the CPs
Restart-VMGuest -VM AIMS-D-UCPT-01
Restart-VMGuest -VM AIMS-D-UCPT-02
Restart-VMGuest -VM AIMS-D-UCPT-03
Restart-VMGuest -VM AIMS-M-UCPT-01
Restart-VMGuest -VM AIMS-M-UCPT-02
Restart-VMGuest -VM AIMS-M-UCPT-03