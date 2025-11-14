. $PSScriptRoot\..\src\variables.ps1

New-AZResourceGroupDeployment -ResourceGroupName $storageRgName -TemplateFile "$PSScriptRoot\template.json" -TemplateParameterFile "$PSScriptRoot\parameters.json" -Verbose