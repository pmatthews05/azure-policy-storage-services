<#
#  This script will remove all resources created by 1-setup.ps1 and 2-create-storage.ps1.
#  Before you start, connect to your Azure account and set the desired subscription context.
#  Connect-AzAccount
#  Set-AzContext -SubscriptionId "your-subscription-id"
#>
#Requires -Module Az.Resources
#Requires -Module Az.OperationalInsights
#Requires -Module Az.ManagedServiceIdentity
#Requires -Module Az.Storage

. $PSScriptRoot\variables.ps1

Write-Host "Removing Policy Assignment..."
$policyAssignment = Get-AzPolicyAssignment -Name $policyAssignmentName -Scope "/subscriptions/$($(Get-AzContext).Subscription.Id)/resourceGroups/$storageRgName" -ErrorAction SilentlyContinue
if ($policyAssignment) {
    Remove-AzPolicyAssignment -Name $policyAssignmentName -Scope "/subscriptions/$($(Get-AzContext).Subscription.Id)/resourceGroups/$storageRgName" -Force
    Write-Host "Policy Assignment removed."
}
else {
    Write-Host "Policy Assignment not found."
}

Write-Host "Removing Policy Definition..."
$policyDefinition = Get-AzPolicyDefinition -Name $policyName -ErrorAction SilentlyContinue
if ($policyDefinition) {
    Remove-AzPolicyDefinition -Name $policyName -Force
    Write-Host "Policy Definition removed."
}
else {
    Write-Host "Policy Definition not found."
}

Write-Host "Removing Storage Account..."
$storageAccount = Get-AzStorageAccount -ResourceGroupName $storageRgName -Name $($storageAccountName).ToLower() -ErrorAction SilentlyContinue
if ($storageAccount) {
    Remove-AzStorageAccount -ResourceGroupName $storageRgName -Name $($storageAccountName).ToLower() -Force
    Write-Host "Storage Account removed."
}
else {
    Write-Host "Storage Account not found."
}

Write-Host "Removing User Assigned Managed Identity..."
$identity = Get-AzUserAssignedIdentity -ResourceGroupName $logAnalyticsRgName -Name $userIdentityName -ErrorAction SilentlyContinue
if ($identity) {
    Remove-AzUserAssignedIdentity -ResourceGroupName $logAnalyticsRgName -Name $userIdentityName
    Write-Host "User Assigned Managed Identity removed."
}
else {
    Write-Host "User Assigned Managed Identity not found."
}

Write-Host "Removing Log Analytics Workspace..."
$logAnalyticsWorkspace = Get-AzOperationalInsightsWorkspace -ResourceGroupName $logAnalyticsRgName -Name $workspaceName -ErrorAction SilentlyContinue
if ($logAnalyticsWorkspace) {
    Remove-AzOperationalInsightsWorkspace -ResourceGroupName $logAnalyticsRgName -Name $workspaceName -Force
    Write-Host "Log Analytics Workspace removed."
}
else {
    Write-Host "Log Analytics Workspace not found."
}

Write-Host "Removing Resource Groups..."
$rg1 = Get-AzResourceGroup -Name $logAnalyticsRgName -ErrorAction SilentlyContinue
if ($rg1) {
    Remove-AzResourceGroup -Name $logAnalyticsRgName -Force
    Write-Host "Resource Group '$logAnalyticsRgName' removal started."
}
else {
    Write-Host "Resource Group '$logAnalyticsRgName' not found."
}

$rg2 = Get-AzResourceGroup -Name $storageRgName -ErrorAction SilentlyContinue
if ($rg2) {
    Remove-AzResourceGroup -Name $storageRgName -Force
    Write-Host "Resource Group '$storageRgName' removal started."
}
else {
    Write-Host "Resource Group '$storageRgName' not found."
}

Write-Host "Destroy completed."
