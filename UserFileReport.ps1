## Script to search for files from a user on a computer
# Confirm C:\temp exists
$PathTest = Test-Path "C:\temp"
if (!$PathTest) {
    mkdir "C:\temp"
}
# Gets username of user to search for
$User = Read-Host "Username of person you want to check for their files"
# Looks through file C:\ and generates report
$Content = Get-ChildItem C:\*.* -Recurse
Foreach ($Object in $Content) {
    $OwnerFull = ($Object | Get-Acl | Select-Object Owner).Owner
    $Owner = $OwnerFull.Split("\")[1]
    If ($User -eq $Owner) {
        $Object 
        $Object > C:\Temp\FileReport.txt
        #Get-Content C:\Temp\FileReport.txt | Out-GridView
    }
}