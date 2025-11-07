$YourPrefix = "ICS"  # Replace with your unique prefix
$YourSuffix = "pm"  # Replace with your unique suffix
$location = "UKSouth"

$policyName = "$($YourPrefix)StoragePolicy"
$policyDisplayName = "$YourPrefix Storage Policy"
$policyAssignmentName = "$($YourPrefix)StoragePolicyAssignment"

$logAnalyticsRgName = "$YourPrefix-LogAnalytics-RG"
$workspaceName = "$($YourPrefix)LogAnalytics$($YourSuffix)"

$storageRgName = "$YourPrefix-Storage-RG"
$storageAccountName = "$($YourPrefix)storage$($YourSuffix)"

$userIdentityName = "$($YourPrefix)StoragePolicyIdentity$($YourSuffix)"