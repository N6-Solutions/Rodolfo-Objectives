# Script Name:                  PS
# Author:                       Rodolfo Gonzalez
# Date of latest revision:      12/20/2023
# Script 2:                     

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
        [string]$UserName,
        [string]$OUName
    )
    Try {
        $userParams = @{
            SamAccountName = $UserName
            UserPrincipalName = "$UserName@$DomainName"
            Name = $UserName
            GivenName = $UserName.Split(' ')[1]
            Surname = $UserName.Split(' ')[0]
            Path = "OU=$OUName,DC=$(($DomainName -split '\.')[0]),DC=$(($DomainName -split '\.')[1])"
            AccountPassword = $defaultPassword
            Enabled = $true
            PasswordNeverExpires = $true
            ChangePasswordAtLogon = $false
        }
        New-ADUser @userParams
        Write-Host "User '$UserName' created successfully in OU '$OUName'." -ForegroundColor Green
    }
    Catch {
        Write-Warning -Message "Failed to create new user '$UserName'. Error: $_.Exception.Message"
    }
}

# Main script execution

# Create OUs
$ouNames = @('OU1', 'OU2', 'OU3')
foreach ($ou in $ouNames) {
    Create-OrganizationalUnit -OUName $ou
}

# Create users
$userDetails = @{
    'Alpha One' = 'OU1';
    'Bravo Two' = 'OU2';
    'Charlie Three' = 'OU3'
}

foreach ($user in $userDetails.GetEnumerator()) {
    Create-NewUser -UserName $user.Name -OUName $user.Value
}
