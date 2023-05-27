<#
.SYNOPSIS
Retrieves the last logon time for a specified user on a remote computer.

.DESCRIPTION
This script retrieves the last logon time for a specified user on a remote computer using WMI.

.PARAMETER ComputerName
The IP address or hostname of the target computer.

.PARAMETER Username
The username in the format: domain\username or localhost\username.

.EXAMPLE
Get-LastLogonTime -ComputerName "192.168.10.17" -Username "localhost\administrator"

This example retrieves the last logon time for the "administrator" user on the computer with the IP address "192.168.10.17".

.NOTES
Author: Lance Mohesky
Date: 2023-05-26
#>


# Set the IP address or hostname of the target computer
$ComputerName = "<insert computer name or IP address>"

# Set the username in the format: domain\username or localhost\username
$Username = "localhost\administrator"

# Retrieve the last logon time for the specified user on the target computer
$LastLogon = Get-WmiObject -Class Win32_UserProfile -ComputerName $ComputerName | 
Where-Object { $_.LocalPath.split('\')[-1] -eq $Username.split('\')[-1] } |
Select-Object -ExpandProperty LastUseTime

# Check if the last logon time was retrieved successfully
if ($LastLogon) {
    # Display the last logon time for the user on the computer
    Write-Host "The last logon time for $Username on $ComputerName was: $LastLogon"
}
else {
    # Indicate that the user has never logged on to the computer
    Write-Host "No logon record for $Username on $ComputerName exists"
}
