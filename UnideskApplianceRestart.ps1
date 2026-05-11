## Unidesk Appliance Restart script
##
## Last Modified:
## 09/20/2017	CJ Pulvermacher


## Connect to vcntr-02

Connect-VIServer aims-vcntr-02.aims.wisc.edu

## Restart Process for Unidesk VMs and wait

Restart-VMGuest -VM aims-umcn-01
Start-Sleep -s 180

Restart-VMGuest -VM aims-umcp-01
Start-Sleep -s 180

Restart-VMGuest -VM aims-d-ucpt-01
Start-Sleep -s 180

Restart-VMGuest -VM aims-d-ucpt-02
Start-Sleep -s 180

Restart-VMGuest -VM aims-d-ucpt-03
Start-Sleep -s 180

Restart-VMGuest -VM aims-m-ucpt-01
Start-Sleep -s 180

Restart-VMGuest -VM aims-m-ucpt-02
Start-Sleep -s 180

Restart-VMGuest -VM aims-m-ucpt-03