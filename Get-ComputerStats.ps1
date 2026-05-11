## This script gets the CPU and Memory stats of a remote server
##
## Created by:		Christopher Pulvermacher
## Last Modified:	11/19/2014

function Get-ComputerStats {
  param(
    [ComputerName(Mandatory=$true, Position=0, 
               ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNull()]
    [string[]]$ComputerName
  )

  process {
    foreach ($c in $ComputerName) {
        $avg = Get-WmiObject win32_processor -computername $c | 
                   Measure-Object -property LoadPercentage -Average | 
                   Foreach {$_.Average}
        $mem = Get-WmiObject win32_operatingsystem -ComputerName $c |
                   Foreach {"{0:N2}" -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)*100)/ $_.TotalVisibleMemorySize)}
        $free = Get-WmiObject Win32_Volume -ComputerName $c -Filter "DriveLetter = 'C:'" |
                    Foreach {"{0:N2}" -f (($_.FreeSpace / $_.Capacity)*100)}
        new-object psobject -prop @{ # Work on PowerShell V2 and below
        # [pscustomobject] [ordered] @{ # Only if on PowerShell V3
            ComputerName = $c
            AverageCpu = $avg
            MemoryUsage = $mem
            PercentFree = $free
        }
    }
  }