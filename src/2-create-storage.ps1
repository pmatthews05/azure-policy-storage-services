<# 
#  Before you start, connect to your Azure account and set the desired subscription context.
#  
#  Connect-AzAccount
#  Set-AzContext -SubscriptionId "your-subscription-id"
#
#  Install the required modules if not already installed:
#  Install-Module -Name Az.Resources -AllowClobber -Force
#  Install-Module -Name Az.Storage -AllowClobber -Force
#>
#Requires -Module Az.Resources
#Requires -Module Az.Storage

. $PSScriptRoot\variables.ps1

Write-Host "Creating a Storage Account in Resource Group..."
$storageAccount = New-AzStorageAccount `
    -ResourceGroupName $storageRgName `
    -Name $($storageAccountName).ToLower() `
    -Location $location `
    -SkuName Standard_LRS `
    -Kind StorageV2 `
    -EnableHttpsTrafficOnly $true `
    -AllowBlobPublicAccess $false

Write-Host "Storage Account '$($storageAccount.Name)' created successfully in Resource Group '$storageRgName'."