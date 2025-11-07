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
3. Run the scripts in the following order:
   - `1-create-log-analytics.ps1`: Creates the Log Analytics workspace and User Assigned Managed Identity.
   - `2-create-storage.ps1`: Creates the Storage Account with diagnostics enabled.


## Walkthrough for Bug
1. Run the above scripts to create the resources.
2. Waiting as long as you like, but the storage account that gets created will remain non-compliant.
3. Manually remediate the Azure Policy assignment in the Azure Portal.
4. Observe that the storage account is now compliant.

### Manually create storage account
1. In the Azure Portal, navigate to "Storage Accounts" and click "Create".
2. Fill in the required details and create the storage account without enabling diagnostics.
3. Observe that the policy automatically remediates the storage account to enable diagnostics. (Less than 5 minutes)


## Cleanup
To remove all resources created by the scripts, run the `3-destroy.ps1` script.