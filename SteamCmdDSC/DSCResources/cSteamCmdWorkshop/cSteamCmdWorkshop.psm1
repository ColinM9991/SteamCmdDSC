function Get-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SteamCMDPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AppId,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $WorkshopItemId
    )

    @{ }
}

function Set-TargetResource {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SteamCMDPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AppId,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $WorkshopItemId,

        [Parameter()]
        [System.String]
        $AppInstallPath,

        [Parameter()]
        [System.String]
        $Username,

        [Parameter()]
        [System.String]
        $Password,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure
    )

    $steamCmdExecutable = Join-Path $SteamCMDPath "steamcmd.exe"
    $steamCmdArguments = @(
        "+login"
    )

    if ($Username -and $Password) {
        Write-Verbose "Steam credentials supplied, using those."
        $steamCmdArguments += @($Username, "`"$Password`"")
    }
    else {
        Write-Verbose "No Steam credentials specified, using anonymous mode."
        $steamCmdArguments += @("anonymous")
    }

    if ($AppInstallPath) {
        $steamCmdArguments += @("+force_install_dir", "`"$AppInstallPath`"")
    }

    foreach ($workshopItem in $workshopItemId) {
        $steamCmdArguments += @("+workshop_download_item", $AppId, $workshopItem)
    }

    $steamCmdArguments += @(
        "+validate"
        "+quit")

    if (!(Test-Path $steamCmdExecutable)) {
        Write-Error "SteamCmd does not exist in $SteamCMDPath, please use the cSteamCMD resource to install SteamCMD."
        Return
    }
    
    Write-Verbose "Executing $steamCmdExecutable with arguments $($steamCmdArguments | Where-Object {$_ -ne `"$Password`"})"
    Start-Process $steamCmdExecutable -ArgumentList $steamCmdArguments -NoNewWindow -Wait
}

function Test-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SteamCMDPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AppId,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $WorkshopItemId,

        [Parameter()]
        [System.String]
        $AppInstallPath,

        [Parameter()]
        [System.String]
        $Username,

        [Parameter()]
        [System.String]
        $Password,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure
    )

    $False
}

Export-ModuleMember -Function *-TargetResource