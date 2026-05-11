function Get-PrinterSerialNumber {
    <#
    .SYNOPSIS
    Retrieves the serial number of a printer in the network for Windows.
 
    .DESCRIPTION
    This function retrieves the serial number of a printer in the network for Windows by querying the WMI class 'Win32_Printer'.
 
    .PARAMETER PrinterName
    Specifies the name of the printer for which to retrieve the serial number.
 
    .EXAMPLE
    PS C:\> Get-PrinterSerialNumber -PrinterName "Printer01"
    Retrieves the serial number of the printer named "Printer01".
 
    .NOTES
    This function requires administrative privileges to access the WMI class 'Win32_Printer'.
 
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$PrinterName
    )
 
    try {
        # Query the WMI class 'Win32_Printer' to retrieve printer information
        $printer = Get-WmiObject -Class Win32_Printer -Filter "Name = '$PrinterName'"
 
        if ($printer) {
            # Retrieve the serial number property
            $serialNumber = $printer.SerialNumber
 
            if ($serialNumber) {
                # Return the serial number
                return $serialNumber
            }
            else {
                throw "Serial number not found for printer '$PrinterName'"
            }
        }
        else {
            throw "Printer '$PrinterName' not found"
        }
    }
    catch {
        # Log the error
        Write-Error $_.Exception.Message
        return $null
    }
}