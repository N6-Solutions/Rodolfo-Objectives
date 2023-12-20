# PowerShell script to deploy a Windows Server VM as a Domain Controller for Mistic Technologies Inc.
# With improved error checking and rollback

# Function to set static IP and rename computer
function Set-NetworkAndRename {
    param (
      [parameter(Mandatory=$true, ValidatePattern='\d{1,3}(\.\d{1,3}){3}')]
      [string]$ipAddress,
      [parameter(Mandatory=$true, ValidateRange=8..32)]
      [int]$prefixLength,
      [parameter(Mandatory=$true, ValidatePattern='\d{1,3}(\.\d{1,3}){3}')]
      [string]$gateway,
      [parameter(Mandatory=$true, ValidatePattern='\d{1,3}(\.\d{1,3}){3}')]
      [string]$dns,
      [string]$newName
    )
  
    # Set Static IP
    Write-Host "Setting Static IP to $ipAddress..."
    try {
      New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress $ipAddress -PrefixLength $prefixLength -DefaultGateway $gateway
      Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $dns
    } catch {
      Write-Error $_.Exception.Message
      throw $_
    }
  
    # Rename the Computer
    Write-Host "Renaming the Computer to $newName..."
    try {
      Rename-Computer -NewName $newName
      Restart-Computer -Force
    } catch {
      Write-Error $_.Exception.Message
      throw $_
    }
  
    Start-Sleep -s 60
  }
  
  # Function to install AD Domain Services and create OU
  function Install-ADServices {
    param (
      [parameter(Mandatory=$true, ValidatePattern='\w+\..*')]
      [string]$domainName,
      [parameter(Mandatory=$true)]
      [System.Security.SecureString]$userPassword,
      [string]$ouName
    )
  
    # Install AD Domain Services
    Write-Host "Installing Active Directory Domain Services..."
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
  
    # Create AD Forest and Organizational Unit
    Write-Host "Creating Active Directory Forest..."
    try {
      Install-ADDSForest -DomainName $domainName -SafeModeAdministratorPassword $userPassword
    } catch {
      Write-Error $_.Exception.Message
      throw $_
    }
  
    Write-Host "Creating Organizational Unit..."
    New-ADOrganizationalUnit -Name $ouName
  }
  
  # Function to rollback changes
  function Rollback-Changes {
    Write-Host "Rolling back changes..."
  
    # Remove the AD DS role
    Write-Host "Removing Active Directory Domain Services role..."
    Uninstall-WindowsFeature -Name AD-Domain-Services
  
    # Reset networking settings and computer name (optional)
    # Set-NetIPAddress -InterfaceAlias "Ethernet" -DHCP Enabled
    # Rename-Computer -NewName "OriginalComputerName"
  
    # Additional rollback steps can be added here
  }
  
  # Main script
  try {
    # Set Network and Rename
    Set-NetworkAndRename -ipAddress "192.168.11.5" -prefixLength 24 -gateway "192.168.11.1" -dns "192.168.11.1" -newName "MisticTechnologies.com-DC01"
  
    # Install AD Services
    Install-ADServices -domainName "MisticTechnologies.com" -userPassword (ConvertTo-SecureString "Password123" -AsPlainText -Force) -ouName "MisticEmployees"
  
    # Confirm changes
    $confirm = Read-Host "Do you want to keep these changes? (Y/N)"
    if ($confirm -ne 'Y') {
      Rollback-Changes
    } else {
      Write-Host "Deployment successful!"
    }
  } catch {
    Write-Error $_.Exception.Message
    Rollback-Changes
  }
  
  