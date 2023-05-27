<#
.SYNOPSIS
Searches for a specific file on a remote computer.

.DESCRIPTION
This script searches for a specific file on a remote computer using the Get-ChildItem cmdlet.

.PARAMETER ComputerName
The name of the remote computer.

.PARAMETER FileName
The name of the file to search for.

.EXAMPLE
Search-File -ComputerName "localhost" -FileName "filename"

This example searches for the file with the name "filename" on the local computer.

.NOTES
Author: Lance Mohesky
Date: 2023-05-26
#>

# Set the name of the remote computer
$ComputerName = "localhost"

# Set the name of the file to search for
$FileName = "filename"

# Search for the specified file on the remote computer
$Results = Get-ChildItem -Path "\\$ComputerName\C$" -Recurse -ErrorAction SilentlyContinue | 
Where-Object { $_.Name -like $FileName } | 
Select-Object -Property FullName

# Check if any results were found
if ($Results) {
    # Display the results
    Write-Host "Results found for $FileName on $ComputerName :"
    $Results | ForEach-Object {
        Write-Host $_.FullName
    }
}
else {
    # Indicate that no results were found
    Write-Host "No results found for $FileName on $ComputerName"
}
