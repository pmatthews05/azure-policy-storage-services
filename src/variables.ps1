$YourPrefix = "cf"  # Replace with your unique prefix
$YourSuffix = "pm"  # Replace with your unique suffix
$location = "UKSouth"

$policyName = "$($YourPrefix)StoragePolicy"
$policyDisplayName = "$($YourPrefix.ToUpper()) Storage Policy"
$policyAssignmentName = "$($YourPrefix)StoragePolicyAssignment"

$logAnalyticsRgName = "$YourPrefix-loganalytics-rg"
$workspaceName = "$($YourPrefix)loganalytics$($YourSuffix)"

$storageRgName = "$YourPrefix-storage-rg"
$storageAccountName = "$($YourPrefix)storage$($YourSuffix)"

$userIdentityName = "$($YourPrefix)StoragePolicyIdentity$($YourSuffix)"