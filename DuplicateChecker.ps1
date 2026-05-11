$file = Read-Host 'Where is the file located?'
Get-Content $file | sort -u > C:\users\cpulvermacher\Desktop\UniqueItems.txt