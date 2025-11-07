<# 
#  Before you start, connect to your Azure account and set the desired subscription context.
#  
#  Connect-AzAccount
#  Set-AzContext -SubscriptionId "your-subscription-id"
#
#  Install the required modules if not already installed:
#  Install-Module -Name Az.Resources -AllowClobber -Force
#  Install-Module -Name Az.OperationalInsights -AllowClobber -Force
#  Install-Module -Name Az.ManagedServiceIdentity -AllowClobber -Force
#  Install-Module -Name Az.PolicyInsights -AllowClobber -Force
#>
#Requires -Module Az.Resources
#Requires -Module Az.OperationalInsights
#Requires -Module Az.ManagedServiceIdentity
#Requires -Module Az.PolicyInsights

. $PSScriptRoot\variables.ps1

Write-Host "Checking registration status of Microsoft.PolicyInsights provider..."
$results = Get-AzResourceProvider -ProviderNamespace 'Microsoft.PolicyInsights' |
Select-Object -Property ResourceTypes, RegistrationState

$nonRegistered = $results | Where-Object { $_.RegistrationState -ne 'Registered' }

if ($null -ne $nonRegistered) {
    Write-Host "Registering Microsoft.PolicyInsights provider..."
    Register-AzResourceProvider -ProviderNamespace 'Microsoft.PolicyInsights'
}

$policyFilePath = "$PSScriptRoot\policy\storage_policy.json"

Write-Host "Creating Azure Policy Definition from $policyFilePath ..."
$policyDefinition = New-AzPolicyDefinition -Name "$policyName" `
    -DisplayName "$policyDisplayName" `
    -Description "Policy to ensure storage accounts are configured according to given standards." `
    -Policy $policyFilePath `
    -Mode All

Write-Host "Create a Resource Group for Log Analytics Workspace..."
$rg = New-AzResourceGroup -Name $logAnalyticsRgName -Location $location -Force
Write-Host "Creating Log Analytics Workspace..."
$logAnalyticsWorkspace = New-AzOperationalInsightsWorkspace `
    -ResourceGroupName $logAnalyticsRgName `
    -Name $workspaceName `
    -Location $location `
    -Sku pergb2018 `
    -RetentionInDays 30 -Force

Write-Host "Create a Resource Group for Storage Accounts...."
$storageRg = New-AzResourceGroup -Name $storageRgName -Location $location -Force

Write-Host "Create a User Managed Identity for Policy Assignment..."
$identity = New-AzUserAssignedIdentity -Name "$userIdentityName" -ResourceGroupName $logAnalyticsRgName -Location $location

Write-Host "Assigning 'Log Analytics Contributor' and 'Monitoring Contributor' role to the User Managed Identity at subscription scope..."

$existingAssignment1 = Get-AzRoleAssignment -ObjectId $identity.PrincipalId -RoleDefinitionName "Log Analytics Contributor" -Scope "/subscriptions/$($(Get-AzContext).Subscription.Id)" -ErrorAction SilentlyContinue
if (-not $existingAssignment1) {
    $existingAssignment1 = New-AzRoleAssignment -ObjectId $identity.PrincipalId -RoleDefinitionName "Log Analytics Contributor" -Scope "/subscriptions/$($(Get-AzContext).Subscription.Id)"
}
else {
    Write-Host "Role assignment 'Log Analytics Contributor' already exists."
}

$existingAssignment2 = Get-AzRoleAssignment -ObjectId $identity.PrincipalId -RoleDefinitionName "Monitoring Contributor" -Scope "/subscriptions/$($(Get-AzContext).Subscription.Id)" -ErrorAction SilentlyContinue
if (-not $existingAssignment2) {
    $existingAssignment2 = New-AzRoleAssignment -ObjectId $identity.PrincipalId -RoleDefinitionName "Monitoring Contributor" -Scope "/subscriptions/$($(Get-AzContext).Subscription.Id)"
}
else {
    Write-Host "Role assignment 'Monitoring Contributor' already exists."
}

Write-Host "Creating a Policy Assignment for $prefix Storage Policy..."
$policyAssignment = New-AzPolicyAssignment -Name "$policyAssignmentName" `
    -PolicyDefinition $policyDefinition `
    -Scope $storageRg.ResourceId `
    -IdentityType UserAssigned `
    -IdentityId $identity.Id `
    -Location $location `
    -PolicyParameterObject @{
    "logAnalytics" = $logAnalyticsWorkspace.ResourceId
}

Write-Host "Setup completed successfully."