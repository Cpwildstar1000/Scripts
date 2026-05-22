# MonitorTools.psm1

function Convert-ByteString {
    [CmdletBinding()]
    param(
        [byte[]]$Value
    )

    if (-not $Value) {
        return $null
    }

    (-join [char[]]$Value).Trim([char]0)
}

function Get-MonitorInfo {
    [CmdletBinding(DefaultParameterSetName = 'Local')]
    param(
        [Parameter(
            ParameterSetName = 'ComputerName',
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string[]]
        $ComputerName,

        [Parameter(
            ParameterSetName = 'CimSession',
            ValueFromPipeline
        )]
        [Microsoft.Management.Infrastructure.CimSession[]]
        $CimSession
    )

    begin {

        # D3DKMDT_VIDEO_OUTPUT_TECHNOLOGY
        $adapterTypes = @{
            -2 = 'Unknown'
            -1 = 'Other'
             0 = 'HD15/VGA'
             1 = 'S-Video'
             2 = 'Composite Video'
             3 = 'Component Video'
             4 = 'DVI'
             5 = 'HDMI'
             6 = 'LVDS'
             8 = 'D-Jpn'
             9 = 'SDI'
            10 = 'DisplayPort External'
            11 = 'DisplayPort Embedded'
            12 = 'UDI External'
            13 = 'UDI Embedded'
            14 = 'SDTV Dongle'
            15 = 'Miracast'
            16 = 'Indirect Wired'
            ([uint32]2147483648) = 'Internal'
        }
    }

    process {
        $sessionsToRemove = @()
        switch ($PSCmdlet.ParameterSetName) {
            'ComputerName' {
                foreach ($computer in $ComputerName) {
                    try {
                        $session = New-CimSession -ComputerName $computer -ErrorAction Stop
                        $sessionsToRemove += $session

                        Get-MonitorData -Session $session -AdapterTypes $adapterTypes
                    }
                    catch {
                        Write-Warning "Failed to create CIM session to [$computer] : $_"
                    }
                }
            }

            'CimSession' {
                foreach ($session in $CimSession) {
                    Get-MonitorData -Session $session -AdapterTypes $adapterTypes
                }
            }

            default {
                Get-MonitorData -AdapterTypes $adapterTypes
            }
        }

        if ($sessionsToRemove.Count -gt 0) {
            $sessionsToRemove | Remove-CimSession
        }
    }
}

function Get-MonitorData {

    [CmdletBinding()]
    param(
        [Microsoft.Management.Infrastructure.CimSession]
        $Session,

        [hashtable]
        $AdapterTypes
    )

    $cimParams = @{
        Namespace   = 'root/WMI'
        ErrorAction = 'SilentlyContinue'
    }

    if ($Session) {
        $cimParams.CimSession = $Session
    }

    $monitors = Get-CimInstance @cimParams -ClassName WmiMonitorID
    $connections = Get-CimInstance @cimParams -ClassName WmiMonitorConnectionParams

    # Build lookup table
    $connectionMap = @{}

    foreach ($connection in $connections) {

        # Remove only trailing _0, _1, etc.
        $normalizedName = $connection.InstanceName -replace '_\d+$'

        $connectionMap[$normalizedName] = $connection
    }

    foreach ($monitor in $monitors) {

        # Normalize monitor instance name
        $normalizedMonitorName = $monitor.InstanceName -replace '_\d+$'

        $connection = $connectionMap[$normalizedMonitorName]

        $videoTech = if ($connection) {
            [int]$connection.VideoOutputTechnology
        }
        else {
            $null
        }

        $connectionType = $AdapterTypes[$videoTech]

        if (-not $connectionType) {

            # Handle unsigned internal value returned by some drivers
            if ($connection.VideoOutputTechnology -eq 2147483648) {
                $connectionType = 'Internal'
            }
            else {
                $connectionType = "Unknown ($videoTech)"
            }
        }

        [PSCustomObject]@{
            PSTypeName   = 'MonitorTools.MonitorInfo'

            ComputerName = if ($Session) {
                $Session.ComputerName
            }
            else {
                $env:COMPUTERNAME
            }

            CimSessionId = if ($Session) {
                $Session.Id
            }
            else {
                $null
            }

            Manufacturer = Convert-ByteString $monitor.ManufacturerName
            Model        = Convert-ByteString $monitor.UserFriendlyName
            Serial       = Convert-ByteString $monitor.SerialNumberID
            Connection   = $connectionType
            VideoOutputTechnology = $videoTech
        }
    }
}

Export-ModuleMember -Function Get-MonitorInfo