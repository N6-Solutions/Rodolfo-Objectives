# Script Name:                  PS
# Author:                       Rodolfo Gonzalez
# Date of latest revision:      12/20/2023
# This cript displays the changes made by the other two scripts.

# Check the current computer name
Write-Host "Current Computer Name: $($env:COMPUTERNAME)"
Write-Host ""



# Domain Controller status
Write-Host "Domain Controller Status:"

# Retrieve and display information about Domain Controllers
Get-ADDomainController -Filter * | Format-Table Name, Site, IPv4Address, OSVersion, IsGlobalCatalog, IsReadOnly -AutoSize
Write-Host ""



# List Organizational Units
Write-Host "List of Organizational Units:"

# Retrieve and display a list of Organizational Units in Active Directory
Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Format-Table Name, DistinguishedName -AutoSize
Write-Host ""



# List AD Users
Write-Host "List of AD Users:"

# Retrieve and display a list of Active Directory Users with various properties
Get-ADUser -Filter * -Properties * | Format-Table Name, UserPrincipalName, Enabled, PasswordNeverExpires, PasswordLastSet, DistinguishedName -AutoSize


  
  