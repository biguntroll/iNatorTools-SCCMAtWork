# SCCM Collection Template

Use this template when creating new collection queries for documentation.

## Collection Information

### Basic Details
- **Collection Name**: [e.g., PRD-DEV-Patching-Workstations-Group1]
- **Collection Type**: [Device | User]
- **Purpose**: [Brief description of what this collection is for]
- **Limiting Collection**: [What collection is this limited to?]
- **Update Schedule**: [Full Update | Incremental Update frequency]

### Site Information
- **Primary Site**: [DEV | TST | PRD | CM1]
- **Deployed to Sites**:
  - [x] DEV - Status: [Active/Testing/Planned]
  - [ ] TST - Status: [Active/Testing/Planned/N/A]
  - [ ] PRD - Status: [Active/Testing/Planned/N/A]
  - [ ] CM1 - Status: [Active/Testing/Planned/N/A]
- **Site-Specific Variations**: [None | Describe any differences between sites]

### Membership Rules

#### Query Rule
```sql
-- WQL Query
select SMS_R_SYSTEM.ResourceID,
       SMS_R_SYSTEM.ResourceType,
       SMS_R_SYSTEM.Name,
       SMS_R_SYSTEM.SMSUniqueIdentifier,
       SMS_R_SYSTEM.ResourceDomainORWorkgroup,
       SMS_R_SYSTEM.Client
from SMS_R_System
where [CONDITION]
```

**Query Explanation**:
[Explain what the query does in plain language]

#### Direct Rule
- **Include/Exclude**: [List any direct membership rules]
- **Reason**: [Why direct rules are needed]

#### Include Collections
- [List any included collections]
- **Reason**: [Why these collections are included]

#### Exclude Collections
- [List any excluded collections]
- **Reason**: [Why these collections are excluded]

## Deployment Usage

### Intended Use
- [ ] Software Deployments
- [ ] Software Update Deployments
- [ ] Configuration Baseline Deployments
- [ ] Operating System Deployments
- [ ] Script Deployments
- [ ] Other: [Specify]

### Maintenance Windows
- **Maintenance Window Applied**: [Yes | No]
- **Window Details**: [Time and duration if applicable]

## Validation

### Expected Member Count
- **Approximate Size**: [e.g., ~500 devices]
- **Last Verified**: [Date]

### Testing Checklist
- [ ] Query syntax validated in SCCM console
- [ ] Test query returned expected results
- [ ] Collection limited to appropriate parent
- [ ] Update schedule configured
- [ ] Membership reviewed for accuracy
- [ ] No duplicate members
- [ ] Collection documented in this repository

## Dependencies

### Required Attributes
[List any custom attributes or hardware inventory items required]

### Related Collections
[List collections that work with or depend on this one]

## Notes

### Important Considerations
[Any special considerations, caveats, or warnings]

### Promotion History
| Date | From Site | To Site | Promoted By | Validation Period | Ticket | Notes |
|------|-----------|---------|-------------|-------------------|--------|-------|
| YYYY-MM-DD | DEV | TST | [Name] | [X days] | CHG-XXXXX | [Any issues or changes made] |
| YYYY-MM-DD | TST | PRD | [Name] | [X days] | CHG-XXXXX | [Any issues or changes made] |

### Change History
| Date | Site | Author | Change Description |
|------|------|--------|-------------------|
| YYYY-MM-DD | DEV | [Name] | Initial creation |

## Example Query Patterns

### By Operating System
```sql
where SMS_R_System.OperatingSystemNameandVersion like "%Workstation 10%"
```

### By Organizational Unit
```sql
where SMS_R_System.SystemOUName = "DOMAIN.COM/WORKSTATIONS/FINANCE"
```

### By Computer Name Pattern
```sql
where SMS_R_System.Name like "WKS-%"
```

### By Last Logon User
```sql
where SMS_R_System.LastLogonUserName = "DOMAIN\\username"
```

### By IP Subnet
```sql
where SMS_R_System.IPSubnets = "192.168.1.0"
```

### By Installed Software
```sql
select SMS_R_System.ResourceId, SMS_R_System.Name
from  SMS_R_System
inner join SMS_G_System_INSTALLED_SOFTWARE on SMS_G_System_INSTALLED_SOFTWARE.ResourceID = SMS_R_System.ResourceId
where SMS_G_System_INSTALLED_SOFTWARE.ProductName like "%Adobe%Reader%"
```

### By Hardware - Laptop Chassis Type
```sql
select SMS_R_System.ResourceId, SMS_R_System.Name
from  SMS_R_System
inner join SMS_G_System_SYSTEM_ENCLOSURE on SMS_G_System_SYSTEM_ENCLOSURE.ResourceID = SMS_R_System.ResourceId
where SMS_G_System_SYSTEM_ENCLOSURE.ChassisTypes in ("8","9","10","11","14")
```

### By Client Version
```sql
where SMS_R_System.ClientVersion like "5.00.9078%"
```

### Active Clients (Last 30 Days)
```sql
where DateDiff(day, SMS_R_System.LastLogonTimestamp, GetDate()) <= 30
```

## PowerShell Script to Create Collection

```powershell
# Import SCCM Module
Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"

# Set location to SCCM site
$SiteCode = "PRD"  # Change to your site code: DEV, TST, PRD, or CM1
Set-Location "$($SiteCode):"

# Collection variables
$CollectionName = "PRD-DEV-Patching-Workstations-Group1"  # Use [Site]-DEV-[Purpose]-[Target] format
$LimitingCollection = "All Systems"  # or appropriate limiting collection
$Comment = "Workstations for patching - Group 1 (Site: $SiteCode)"

# Create new device collection
$Collection = New-CMDeviceCollection -Name $CollectionName `
    -LimitingCollectionName $LimitingCollection `
    -Comment $Comment

# Add query membership rule
$QueryRule = @"
[Your WQL Query Here]
"@

Add-CMDeviceCollectionQueryMembershipRule -CollectionId $Collection.CollectionID `
    -RuleName "Query Rule" `
    -QueryExpression $QueryRule

# Set update schedule (Full update daily at 2 AM, incremental every 1 hour)
$Schedule = New-CMSchedule -Start "01/01/2025 02:00:00" -RecurInterval Days -RecurCount 1
Set-CMCollection -CollectionId $Collection.CollectionID -RefreshSchedule $Schedule -RefreshType Both

Write-Host "Collection created successfully: $CollectionName" -ForegroundColor Green
```

## Tags
[Add relevant tags: patching, deployment, workstations, servers, laptops, etc.]
