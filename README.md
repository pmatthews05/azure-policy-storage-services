# Azure Policy Storage Services Diagnostics Example

This repo has been created to given an example of how to create the necessary resources to enable Azure Policy Storage Services Diagnostics.

## Prerequisites
- Azure PowerShell Module
- An active Azure subscription
- Permissions to create resources in the subscription

## Bugs and Issues
It seems when this policy is created, although it allows the storage account to be manually remediated, the policy does not automatically remediate non-compliant storage accounts that have been created via code. 

If a storage account is created manually in the portal, then the policy will remediate it automatically.

## Usage
1. Clone the repository to your local machine.
2. Open PowerShell and navigate to the cloned repository directory.
3. Check the [variables.ps1](/src/variables.ps1) file and modify the following variables as needed:

| Variable Name | Description                                            |
| ------------- | ------------------------------------------------------ |
| $YourPrefix   | A unique prefix for resource names to avoid conflicts. |
| $YourSuffix   | A unique suffix for resource names to avoid conflicts. |
| $Location     | The Azure region where resources will be created.      |

4. Run the scripts in the following order:
   - [1-setup.ps1](/src/1-setup.ps1): Creates the Log Analytics workspace and User Assigned Managed Identity.
   - [2-create-storage.ps1](/src/2-create-storage.ps1): Creates the Storage Account with diagnostics enabled.


## Walkthrough for Bug
1. Run the above scripts to create the resources.
2. Waiting as long as you like, but the storage account that gets created will remain non-compliant.
3. Manually remediate the Azure Policy assignment in the Azure Portal.
> Note: If the storage account isn't showing up as non-compliant yet (or compliant if the bug is fixed) in the portal for Azure Policy, then run the following powershell which forces an evaluation:
> ```powershell
> Install-Module -Name Az.PolicyInsights -AllowClobber -Force #If required
> Start-AzPolicyComplianceScan -ResourceGroupName "$storageRgName"
> ```
> Once the evaluation is complete, you should see the storage account showing in the Azure Portal ready to remediate.

4. Observe that the storage account is now compliant.

### Manually create storage account
1. In the Azure Portal, navigate to "Storage Accounts" and click "Create".
2. Fill in the required details and create the storage account without enabling diagnostics.
3. Observe that the policy automatically remediates the storage account to enable diagnostics. (Less than 5 minutes)


## Resources Created
| Resource Type           | Name                                     | Description                                                                  |
| ----------------------- | ---------------------------------------- | ---------------------------------------------------------------------------- |
| Azure Policy Definition | `$(yourprefix)StoragePolicy`             | Custom policy definition to enforce diagnostics on storage account services. |
| Resource Group          | `$(yourprefix)-loganalytics-rg`          | Resource group for Log Analytics workspace, and User Managed Identity        |
| Log Analytics Workspace | `$(yourprefix)LogAnalytics$(yoursuffix)` | Workspace to store diagnostics logs.                                         |
| Resource Group          | `$(yourprefix)-storage-rg`                | Resource group for Storage Accounts.                                          |
| User Managed Identity  | `$(yourprefix)StoragePolicyIdentity$(yoursuffix)` | Identity used by the policy to enable diagnostics on storage accounts.       |
| Role Assignments        | N/A                                      | Assigns necessary permissions to the User Managed Identity. (Log Analytics Contributor and Monitoring Contributor) at Subscription scope. |
| Azure Policy Assignment | `$(yourprefix)StoragePolicyAssignment`   | Policy assignment to enforce the storage policy on the specified scope.     |


## Cleanup
To remove all resources created by the scripts, run the [3-destroy.ps1](/src/3-destroy.ps1) script.