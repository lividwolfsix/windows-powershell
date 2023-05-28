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

        Write-Host "Virtual Machine Name: $($vm.Name)"
        Write-Host "IP Address(es): $($ipAddresses -join ', ')"
        Write-Host "OS Information: $os"
        Write-Host "------------------------------------"
    }
}
