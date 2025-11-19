# Microsoft Defender for Endpoint (MDE) Detection Collection

**Purpose**: Identify all devices with Microsoft Defender for Endpoint installed and activated

**Challenge**: The CMPivot query you use checks real-time data from endpoints. Collections use WQL against the SCCM database, which only contains data that's been inventoried. This document provides multiple approaches to achieve your goal.

---

## Approach 1: Use Existing SCCM Inventory (Basic Detection)

This approach uses data already available in SCCM without any configuration changes.

### Collection Query - Basic MDE Detection

**Detects**: Devices with the Sense service installed (indicates MDE client is present)

```sql
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
```

**Query Explanation**:
- Joins system information with the Services inventory class
- Filters for the "Sense" service (Microsoft Defender for Endpoint service)
- Checks that StartMode is "Auto" (should be automatically started)
- This indicates MDE client is installed

**Limitations**:
- Does not verify the service is running (only that it exists and is set to auto-start)
- Does not check enrollment status (TenantId)
- Does not verify Windows Defender features are enabled

---

## Approach 2: Extended Hardware Inventory (Recommended)

This approach extends hardware inventory to collect the exact registry keys from your CMPivot query, allowing more accurate detection.

### Step 1: Extend Hardware Inventory

You need to configure SCCM to collect these registry keys:

#### Registry Keys to Collect

1. **SenseCM TenantId** (indicates enrollment)
   - Path: `HKLM:\SOFTWARE\Microsoft\SenseCM`
   - Property: `TenantId`

2. **Windows Defender Features** (optional - for more comprehensive detection)
   - Path: `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\`
   - Look for packages containing "Windows-Defender"

### Step 2: Configure Hardware Inventory in SCCM

#### Using SCCM Console:

1. Navigate to **Administration > Client Settings > Default Client Settings**
2. Right-click and select **Properties**
3. Select **Hardware Inventory**
4. Click **Set Classes**
5. Click **Add** > **Connect**
6. Select a sample device (one with MDE installed)
7. Click **Add** > **Registry**
8. Configure registry key collection:

**For SenseCM TenantId**:
- **Display Name**: `Microsoft Defender for Endpoint - Enrollment`
- **Key**: `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SenseCM`
- **Value Name**: `TenantId`
- **Key Name**: `SenseCM_TenantId` (inventory class name)

9. Click **OK** and deploy the client settings
10. Wait for hardware inventory to run on clients (next scheduled scan + sync cycle)

### Step 3: WQL Query Using Extended Inventory

Once hardware inventory is collecting the SenseCM registry key:

```sql
select SMS_R_SYSTEM.ResourceID,
       SMS_R_SYSTEM.ResourceType,
       SMS_R_SYSTEM.Name,
       SMS_R_SYSTEM.SMSUniqueIdentifier,
       SMS_R_SYSTEM.ResourceDomainORWorkgroup,
       SMS_R_SYSTEM.Client
from SMS_R_System
inner join SMS_G_System_SERVICE on SMS_G_System_SERVICE.ResourceID = SMS_R_System.ResourceId
inner join SMS_G_System_SenseCM_TenantId on SMS_G_System_SenseCM_TenantId.ResourceID = SMS_R_System.ResourceId
where SMS_G_System_SERVICE.Name = "Sense"
    and SMS_G_System_SERVICE.StartMode = "Auto"
    and SMS_G_System_SenseCM_TenantId.TenantId is not NULL
    and SMS_G_System_SenseCM_TenantId.TenantId != ""
```

**Query Explanation**:
- Joins system info with Services inventory
- Joins with the custom registry inventory class (SenseCM_TenantId)
- Checks for Sense service set to Auto start
- Verifies TenantId exists and is not empty (indicates enrolled to MDE)

**This provides**:
- Accurate detection of MDE installation
- Verification of enrollment status
- Uses SCCM database (collection updates automatically)

---

## Approach 3: Configuration Baseline (Hybrid Approach)

Use a Configuration Baseline to check for MDE and report compliance. Then create a collection of compliant devices.

### Step 1: Create Configuration Item

**Detection Script** (PowerShell):
```powershell
# Check if Sense service exists and is running
$senseService = Get-Service -Name "Sense" -ErrorAction SilentlyContinue

if (-not $senseService) {
    return "Not Installed"
}

# Check if enrolled (TenantId exists)
$tenantId = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\SenseCM" -Name "TenantId" -ErrorAction SilentlyContinue

if ($tenantId -and $tenantId.TenantId) {
    # Check if service is running or can start
    if ($senseService.Status -eq "Running" -or $senseService.StartType -eq "Automatic") {
        return "Compliant"
    }
}

return "Not Compliant"
```

### Step 2: Create Configuration Baseline

1. Add the Configuration Item to a baseline
2. Deploy baseline to "All Systems"
3. Set evaluation schedule (e.g., every 1 day)

### Step 3: Create Collection

```sql
select SMS_R_SYSTEM.ResourceID,
       SMS_R_SYSTEM.ResourceType,
       SMS_R_SYSTEM.Name,
       SMS_R_SYSTEM.SMSUniqueIdentifier,
       SMS_R_SYSTEM.ResourceDomainORWorkgroup,
       SMS_R_SYSTEM.Client
from SMS_R_System
inner join SMS_G_System_DCM_DeploymentCompliantStatus on SMS_G_System_DCM_DeploymentCompliantStatus.ResourceID = SMS_R_System.ResourceId
where SMS_G_System_DCM_DeploymentCompliantStatus.BaselineName = "Microsoft Defender for Endpoint - Detection"
    and SMS_G_System_DCM_DeploymentCompliantStatus.Status = 1
```

**Query Explanation**:
- Joins with compliance data
- Filters for devices reporting "Compliant" (Status = 1) for the MDE baseline
- Only compliant devices (those with MDE properly installed/activated) are members

---

## Comparison of Approaches

| Approach | Accuracy | Setup Effort | Update Speed | Detection Details |
|----------|----------|--------------|--------------|-------------------|
| **Approach 1** (Basic) | Medium | None | Immediate | Service exists only |
| **Approach 2** (Extended HW Inv) | High | Medium | Automatic | Service + Enrollment |
| **Approach 3** (Baseline) | Highest | High | Scheduled | Full validation |

---

## Recommended Implementation

**For Quick Setup**: Use **Approach 1** immediately while you set up Approach 2

**For Production**: Implement **Approach 2** (Extended Hardware Inventory)
- Most accurate without ongoing overhead
- Integrates naturally with SCCM
- Collection updates automatically
- Can be used for compliance reporting

**For Comprehensive Validation**: Add **Approach 3** if you need to verify service state and full functionality

---

## Creating the Collection

### Using Approach 1 (Immediate):

1. Open SCCM Console
2. Navigate to **Assets and Compliance > Device Collections**
3. Right-click and select **Create Device Collection**
4. **Name**: `PRD-DEV-MDE-Installed` (adjust site code as needed)
5. **Limiting Collection**: `All Systems`
6. **Comment**: `Devices with Microsoft Defender for Endpoint (Sense service installed)`
7. Add **Membership Rules** > **Query Rule**
8. **Rule Name**: `MDE Sense Service Detected`
9. Paste the query from Approach 1
10. Configure update schedule (recommend: Full daily, Incremental enabled)
11. Click **OK**

### Using PowerShell:

```powershell
# Import SCCM Module
Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"

# Set location to SCCM site
$SiteCode = "PRD"  # Change to your site code: DEV, TST, PRD, or CM1
Set-Location "$($SiteCode):"

# Collection variables
$CollectionName = "$SiteCode-DEV-MDE-Installed"
$LimitingCollection = "All Systems"
$Comment = "Devices with Microsoft Defender for Endpoint installed (Sense service detected)"

# Create new device collection
$Collection = New-CMDeviceCollection -Name $CollectionName `
    -LimitingCollectionName $LimitingCollection `
    -Comment $Comment

# Add query membership rule - Approach 1 (Basic)
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

# Set update schedule (Full update daily at 2 AM, incremental every 1 hour)
$Schedule = New-CMSchedule -Start "01/01/2025 02:00:00" -RecurInterval Days -RecurCount 1
Set-CMCollection -CollectionId $Collection.CollectionID -RefreshSchedule $Schedule -RefreshType Both

Write-Host "Collection created successfully: $CollectionName" -ForegroundColor Green
Write-Host "Run this CMPivot query to validate members:" -ForegroundColor Yellow
Write-Host "Service | where Name == 'Sense' | project Device, State, StartMode" -ForegroundColor Cyan
```

---

## Validation

### Using CMPivot to Validate:

Run your original CMPivot query against the collection to verify members:

```kql
Device
| join kind=leftouter (
    Registry('HKLM:\SOFTWARE\Microsoft\SenseCM')
    | where Property == 'TenantId'
    | project Device, Value
)
| join kind=leftouter (
    Service
    | where Name == 'Sense'
    | project Device, State, StartMode, Status
)
| project Device, TenantId = Value, ServiceState = State, ServiceStartMode = StartMode
```

Compare the devices in your new collection with the CMPivot results.

---

## Troubleshooting

### Collection has no members:

1. **Check if Sense service is in hardware inventory**:
   ```sql
   select * from SMS_G_System_SERVICE where Name0 = 'Sense'
   ```
   - If no results, hardware inventory may not be collecting service data
   - Check Client Settings > Hardware Inventory > Services is enabled

2. **Verify a known MDE device**:
   - Run CMPivot against one device you know has MDE
   - Check if it appears in Service inventory in SCCM
   - If not, trigger hardware inventory: Right-click device > Client Notification > Download Computer Policy

### Collection shows devices without MDE:

- Query may be too broad
- Use Approach 2 (Extended Inventory) for more accurate detection
- Add TenantId check to verify enrollment

---

## Next Steps

1. **Implement Approach 1** now for immediate results
2. **Plan Approach 2** for more accurate long-term solution
   - Schedule maintenance window to extend hardware inventory
   - Test on pilot collection first
   - Roll out to all clients
3. **Document** which approach you're using and why
4. **Monitor** collection membership over time
5. **Use for deployments** of MDE-related updates or configurations

---

## Related Collections

Consider creating complementary collections:

- `[Site]-DEV-MDE-NotInstalled` - Devices WITHOUT MDE (inverse query)
- `[Site]-DEV-MDE-ServiceStopped` - MDE installed but service stopped
- `[Site]-DEV-MDE-NotEnrolled` - MDE installed but no TenantId (Approach 2 only)

---

## Tags
#MDE #Defender #Security #Endpoint #Detection #Service #Compliance

---

**Created**: 2025-01-19
**Approach Used**: [Select: Approach 1 | Approach 2 | Approach 3]
**Last Validated**: [Date]
