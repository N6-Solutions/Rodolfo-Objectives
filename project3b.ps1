# Script Name:                  PS
# Author:                       Rodolfo Gonzalez
# Date of latest revision:      12/20/2023
# Script 2:                     

# Execution policy need to be changed or your script wont run.
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

param (
    [string]$DomainName = 'MysticTechnologies.com'
)

# Default password for user accounts
$defaultPassword = ConvertTo-SecureString -AsPlainText 'Password123' -Force

# Function to create Organizational Units (OUs)
function Create-OrganizationalUnit {
    param (
        [string]$OUName
    )
    Try {
        New-ADOrganizationalUnit -Name $OUName -Path "DC=$(($DomainName -split '\.')[0]),DC=$(($DomainName -split '\.')[1])"
        Write-Host "Organizational Unit '$OUName' created successfully." -ForegroundColor Green
    }
    Catch {
        Write-Warning -Message "Failed to create OU '$OUName'. Error: $_.Exception.Message"
    }
}

# Function to create a new user in the specified OU
function Create-NewUser {
    param (
        [string]$FullName,
        [string]$UserLogon,
        [string]$Department
    )
    Try {
        $userParams = @{
            SamAccountName = $UserLogon.Split('@')[0]
            UserPrincipalName = $UserLogon
            Name = $FullName
            GivenName = $FullName.Split(' ')[0]
            Surname = $FullName.Split(' ')[1]
            Path = "OU=$Department,DC=$(($DomainName -split '\.')[0]),DC=$(($DomainName -split '\.')[1])"
            AccountPassword = $defaultPassword
            Enabled = $true
            PasswordNeverExpires = $true
            ChangePasswordAtLogon = $false
        }
        New-ADUser @userParams
        Write-Host "User '$FullName' created successfully in OU '$Department'." -ForegroundColor Green
    }
    Catch {
        Write-Warning -Message "Failed to create new user '$FullName'. Error: $_.Exception.Message"
    }
}

# Main script execution

# Define departments and their users
$departments = @{
    'Sales and Marketing' = @(
        @{ FullName = 'James Smith'; UserLogon = 'JamSmith@MysticTechnologies.com' },
        @{ FullName = 'Jennifer Demark'; UserLogon = 'JenDem@MysticTechnologies.com' },
        @{ FullName = 'Alex Woodall'; UserLogon = 'AlWoodall@MysticTechnologies.com' }
    )
    'Research and Development' = @(
        @{ FullName = 'Robert Gray'; UserLogon = 'RobGray@MysticTechnologies.com' },
        @{ FullName = 'Susan Remos'; UserLogon = 'SusRemos@MysticTechnologies.com' }
    )
    'Future Expansion' = @(
        @{ FullName = 'William King'; UserLogon = 'WilKing@MysticTechnologies.com' },
        @{ FullName = 'Ashley Beket'; UserLogon = 'AshBindes@MysticTechnologies.com' }
    )
    'Management' = @(
        @{ FullName = 'Juan Cruz'; UserLogon = 'JCruz@MysticTechnologies.com' }
    )
}

# Create OUs and Users
foreach ($department in $departments.Keys) {
    Create-OrganizationalUnit -OUName $department
    foreach ($user in $departments[$department]) {
        Create-NewUser -FullName $user.FullName -UserLogon $user.UserLogon -Department $department
    }
}
