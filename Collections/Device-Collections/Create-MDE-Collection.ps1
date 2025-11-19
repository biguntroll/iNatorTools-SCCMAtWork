<#
.SYNOPSIS
    Creates an SCCM collection for devices with Microsoft Defender for Endpoint (MDE) installed

.DESCRIPTION
    This script creates a device collection that identifies all computers with MDE installed
    by checking for the Sense service. The collection can be used for:
    - Compliance reporting
    - MDE-specific deployments
    - Monitoring MDE coverage

.PARAMETER SiteCode
    SCCM Site Code (DEV, TST, PRD, or CM1)

.PARAMETER CollectionPrefix
    Optional prefix for the collection name. Defaults to site code.

.EXAMPLE
    .\Create-MDE-Collection.ps1 -SiteCode "PRD"
    Creates collection: PRD-DEV-MDE-Installed

.NOTES
    Author: SCCM Admin Team
    Date: 2025-01-19
    Version: 1.0

    Based on CMPivot query validation showing:
    - DefenderWindowsFeatureInstalled: yes
    - TenantId: de08c407-19b9-427d-9fe8-edf254300ca7
    - Service State: Running, StartMode: Auto, Status: OK
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("DEV", "TST", "PRD", "CM1")]
    [string]$SiteCode,

    [Parameter(Mandatory = $false)]
    [string]$CollectionPrefix
)

# Import SCCM Module
Write-Host "Importing ConfigurationManager module..." -ForegroundColor Cyan
Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" -ErrorAction Stop

# Set location to SCCM site
Set-Location "$($SiteCode):" -ErrorAction Stop
Write-Host "Connected to SCCM site: $SiteCode" -ForegroundColor Green

# Collection variables
if (-not $CollectionPrefix) {
    $CollectionPrefix = $SiteCode
}

$CollectionName = "$CollectionPrefix-DEV-MDE-Installed"
$LimitingCollection = "All Systems"
$Comment = "Devices with Microsoft Defender for Endpoint installed and Sense service configured. Created from validated CMPivot query on 2025-01-19. TenantId: de08c407-19b9-427d-9fe8-edf254300ca7"

Write-Host "`nCreating collection: $CollectionName" -ForegroundColor Cyan

# Check if collection already exists
$existingCollection = Get-CMDeviceCollection -Name $CollectionName -ErrorAction SilentlyContinue
if ($existingCollection) {
    Write-Host "Collection '$CollectionName' already exists!" -ForegroundColor Yellow
    $overwrite = Read-Host "Do you want to recreate it? (Y/N)"
    if ($overwrite -ne "Y") {
        Write-Host "Exiting without changes." -ForegroundColor Yellow
        exit 0
    }
    Write-Host "Removing existing collection..." -ForegroundColor Yellow
    Remove-CMCollection -Id $existingCollection.CollectionID -Force
}

# Create new device collection
Write-Host "Creating device collection..." -ForegroundColor Cyan
$Collection = New-CMDeviceCollection -Name $CollectionName `
    -LimitingCollectionName $LimitingCollection `
    -Comment $Comment

if (-not $Collection) {
    Write-Host "Failed to create collection!" -ForegroundColor Red
    exit 1
}

Write-Host "Collection created successfully: $($Collection.Name) (ID: $($Collection.CollectionID))" -ForegroundColor Green

# Add query membership rule
Write-Host "Adding query membership rule..." -ForegroundColor Cyan

$QueryRule = @"
select SMS_R_SYSTEM.ResourceID,
       SMS_R_SYSTEM.ResourceType,
       SMS_R_SYSTEM.Name,
       SMS_R_SYSTEM.SMSUniqueIdentifier,
       SMS_R_SYSTEM.ResourceDomainORWorkgroup,
       SMS_R_SYSTEM.Client
from SMS_R_System
inner join SMS_G_System_SERVICE on SMS_G_System_SERVICE.ResourceID = SMS_R_System.ResourceId
where SMS_G_System_SERVICE.Name = "Sense"
    and SMS_G_System_SERVICE.StartMode = "Auto"
"@

Add-CMDeviceCollectionQueryMembershipRule -CollectionId $Collection.CollectionID `
    -RuleName "MDE Sense Service Detected" `
    -QueryExpression $QueryRule

Write-Host "Query rule added successfully" -ForegroundColor Green

# Set update schedule (Full update daily at 2 AM, incremental every 1 hour)
Write-Host "Configuring update schedule..." -ForegroundColor Cyan

$Schedule = New-CMSchedule -Start "01/01/2025 02:00:00" -RecurInterval Days -RecurCount 1
Set-CMCollection -CollectionId $Collection.CollectionID -RefreshSchedule $Schedule -RefreshType Both

Write-Host "Update schedule configured: Full daily at 2 AM, Incremental every 1 hour" -ForegroundColor Green

# Force collection update
Write-Host "`nForcing initial collection update..." -ForegroundColor Cyan
Invoke-CMCollectionUpdate -CollectionId $Collection.CollectionID

Write-Host "`n=== Collection Created Successfully ===" -ForegroundColor Green
Write-Host "Collection Name: $CollectionName" -ForegroundColor White
Write-Host "Collection ID: $($Collection.CollectionID)" -ForegroundColor White
Write-Host "Limiting Collection: $LimitingCollection" -ForegroundColor White
Write-Host "Update Schedule: Full daily + Incremental" -ForegroundColor White

Write-Host "`n=== Next Steps ===" -ForegroundColor Cyan
Write-Host "1. Wait 5-10 minutes for initial collection evaluation" -ForegroundColor White
Write-Host "2. Verify members: SCCM Console > Assets and Compliance > Device Collections > $CollectionName" -ForegroundColor White
Write-Host "3. Expected members based on CMPivot: PTNJUMP012S, PTNJUMP021S" -ForegroundColor White
Write-Host "4. Validate with CMPivot:" -ForegroundColor White
Write-Host "   Service | where Name == 'Sense' | project Device, State, StartMode" -ForegroundColor Yellow
Write-Host "5. Document in repository: Collections/Device-Collections/$CollectionName.md" -ForegroundColor White

Write-Host "`nCollection creation complete!" -ForegroundColor Green
