<#
.SYNOPSIS
    List Virtual Workstations on Hyper-V Host.

.DESCRIPTION
    This script lists all virtual workstations on a Hyper-V host by their name, IP address, and OS information.

.EXAMPLE
    .\list_workstations.ps1
    Lists all virtual workstations on the Hyper-V host.

.NOTES
    Author: Lance Mohesky
    Date:   2023-May-28
#>

# Module manifest
$ModuleVersion = '1.0.0'
$GUID = 'put-your-guid-here'

$ModuleManifest = @{
    RootModule = 'VirtualWorkstationsModule.psm1'
    ModuleVersion = $ModuleVersion
    Guid = $GUID
    FunctionsToExport = '*'
    CmdletsToExport = '*'
    AliasesToExport = '*'
    VariablesToExport = '*'
    ModuleToProcess = ''
    Description = 'A PowerShell module to list virtual workstations on your Hyper-V host.'
    Author = 'Lance Mohesky'
    PrivateData = @{
        PSData = @{
            Tags = @('Hyper-V', 'Virtual Machines')
            ProjectUri = 'https://github.com/lividwolfsix/windows-powershell'
            LicenseUri = ''
            ReleaseNotes = ''
        }
        Prerelease = $false
    }
}

$ModuleManifestPath = Join-Path -Path $PSScriptRoot -ChildPath ($ModuleName + '.psd1')
$ModuleManifest | Out-String | Set-Content -Path $ModuleManifestPath -Encoding UTF8


# Script functions
function Get-VirtualWorkstations {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$HyperVHost = 'localhost'
    )

    # Import the Hyper-V module
    Import-Module Hyper-V

    # Get all virtual machines
    $virtualMachines = Get-VM

    # Iterate through each virtual machine
    foreach ($vm in $virtualMachines) {
        # Get the IP addresses of the virtual machine
        $ipAddresses = Get-VMNetworkAdapter -VMName $vm.Name | Select-Object -ExpandProperty IPAddresses

        # If the virtual machine has IP addresses, display its details
        if ($ipAddresses) {
            # Get the OS information of the virtual machine
            $os = (Get-WmiObject -Namespace "root\virtualization\v2" -Query "SELECT * FROM Msvm_ComputerSystem WHERE ElementName='$($vm.Name)'").Caption

            [PSCustomObject]@{
                'Virtual Machine Name' = $vm.Name
                'IP Address(es)' = $ipAddresses -join ', '
                'OS Information' = $os
            }
        }
    }
}
