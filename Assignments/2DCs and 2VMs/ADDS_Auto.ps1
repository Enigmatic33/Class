# Define parameters for the new forest
$DomainName = "AutoClass.com"
$SafeModeAdminPassword = "P@5%w0rd!133"  # Replace with a secure password
$DsrMPassword = (ConvertTo-SecureString $SafeModeAdminPassword -AsPlainText -Force)

# Install the AD DS role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Import the ADDSDeployment module
Import-Module ADDSDeployment

# Install a new forest
Install-ADDSForest -DomainName $DomainName `
                   -SafeModeAdministratorPassword $DsrMPassword `
                   -InstallDNS `
                   -Force `
                   -NoRebootOnCompletion

# Define the path to the new script file
$newScriptPath = "C:\adds\domain_admin.ps1"  # Replace with the desired path

# Define the content of the new script
$scriptContent = @'
# Define parameters for the new forest
$DomainName = "AutoClass.com"

# Define parameters for the new domain admin account
$AdminUsername = "Eddy.Admin"
$AdminPassword = "P@ssw0rd!"  # Replace with a secure password
$SecureAdminPassword = (ConvertTo-SecureString $AdminPassword -AsPlainText -Force)

# Create a new domain admin account
New-ADUser -Name $AdminUsername `
           -GivenName "Eddy" `
           -Surname "Admin" `
           -SamAccountName $AdminUsername `
           -UserPrincipalName "$AdminUsername@$DomainName" `
           -Path "CN=Users,DC=$(($DomainName -split '\.')[0]),DC=$(($DomainName -split '\.')[1])" `
           -AccountPassword $SecureAdminPassword `
           -Enabled $true

# Add the new account to the Domain Admins group
Add-ADGroupMember -Identity "Domain Admins" -Members $AdminUsername

Write-Output "Created domain admin account: $AdminUsername"
'@

# Write the content to the new script file
$scriptContent | Out-File -FilePath $newScriptPath -Encoding UTF8

# Reboot the server to complete the installation
Restart-Computer