# CMPivot-Security-MDE-InstallationStatus

## Purpose
Comprehensive check for Microsoft Defender for Endpoint (MDE) installation and activation status, including Windows Defender features, enrollment status, and service state.

## Use Cases
- Verify MDE deployment across the environment
- Identify devices with incomplete MDE installation
- Check enrollment status (TenantId)
- Validate Sense service is running
- Compliance auditing for endpoint protection
- Troubleshooting MDE deployment issues

## Query

```kusto
Device
| join kind=leftouter (
    Registry('hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\*')
    | where Key contains '~amd64~~'
    | where Key contains 'Windows-Defender-Server-Core-Package'
        or Key contains 'Windows-Defender-Server-Core-Group-Package'
        or Key contains 'Windows-Defender-Server-Service-Package'
        or Key contains 'Windows-Defender-Features-Package'
    | where Property == 'CurrentState'
    | where Value == '112' or Value == '0x00000070' or Value == '0x70'
    | summarize count() by Device
)
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
| project Device, DefenderWindowsFeatureInstalled = iif(isnull(count_), 'no', 'yes'), Value, State, StartMode, Status
| order by Value desc
```

## Query Breakdown

### Part 1: Windows Defender Feature Detection
```kusto
Registry('hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\*')
| where Key contains '~amd64~~'
| where Key contains 'Windows-Defender-Server-Core-Package'
    or Key contains 'Windows-Defender-Server-Core-Group-Package'
    or Key contains 'Windows-Defender-Server-Service-Package'
    or Key contains 'Windows-Defender-Features-Package'
| where Property == 'CurrentState'
| where Value == '112' or Value == '0x00000070' or Value == '0x70'
| summarize count() by Device
```

**What it checks**:
- Component Based Servicing packages for Windows Defender
- AMD64 architecture packages
- CurrentState property with values indicating "Installed" (112 / 0x70)
- Counts installed Defender packages per device

### Part 2: MDE Enrollment Status
```kusto
Registry('HKLM:\SOFTWARE\Microsoft\SenseCM')
| where Property == 'TenantId'
| project Device, Value
```

**What it checks**:
- SenseCM registry key (created when device is enrolled to MDE)
- TenantId value (your MDE tenant identifier)
- If TenantId exists, device is enrolled

### Part 3: Sense Service Status
```kusto
Service
| where Name == 'Sense'
| project Device, State, StartMode, Status
```

**What it checks**:
- Sense service (Microsoft Defender for Endpoint service)
- Current state (Running/Stopped)
- Start mode (Auto/Manual/Disabled)
- Service status

## Output Columns

| Column | Description | Expected Value |
|--------|-------------|----------------|
| `Device` | Computer name | Device hostname |
| `DefenderWindowsFeatureInstalled` | Windows Defender features present | `yes` = Installed, `no` = Not installed |
| `Value` | MDE TenantId (enrollment identifier) | GUID if enrolled, null if not |
| `State` | Sense service current state | `Running` = Active, `Stopped` = Inactive |
| `StartMode` | Sense service startup type | `Auto` = Automatic, `Manual` = Manual |
| `Status` | Sense service status | `OK` = Healthy |

## Example Results

### Fully Installed and Activated
```
Device: WKS-12345
DefenderWindowsFeatureInstalled: yes
Value: 12345678-1234-1234-1234-123456789012
State: Running
StartMode: Auto
Status: OK
```
✅ **Status**: MDE fully installed and activated

### Installed but Not Enrolled
```
Device: WKS-67890
DefenderWindowsFeatureInstalled: yes
Value: (null)
State: Stopped
StartMode: Manual
Status: OK
```
⚠️ **Status**: Defender installed but not enrolled to MDE

### Not Installed
```
Device: WKS-11111
DefenderWindowsFeatureInstalled: no
Value: (null)
State: (null)
StartMode: (null)
Status: (null)
```
❌ **Status**: MDE not installed

## Interpreting Results

### Healthy MDE Installation
- `DefenderWindowsFeatureInstalled`: `yes`
- `Value` (TenantId): Present (GUID)
- `State`: `Running`
- `StartMode`: `Auto`
- `Status`: `OK`

### Incomplete Installation
- `DefenderWindowsFeatureInstalled`: `yes` but `Value` is null
- **Action**: Onboard the device to MDE

### Service Issues
- `DefenderWindowsFeatureInstalled`: `yes`, `Value` present, but `State`: `Stopped`
- **Action**: Investigate why service is stopped, restart Sense service

### Not Installed
- All values null or `DefenderWindowsFeatureInstalled`: `no`
- **Action**: Deploy MDE to device

## Variations

### Check Only Enrollment Status
```kusto
Device
| join kind=leftouter (
    Registry('HKLM:\SOFTWARE\Microsoft\SenseCM')
    | where Property == 'TenantId'
    | project Device, TenantId = Value
)
| where TenantId != ""
| project Device, TenantId
```

### Check Only Service Status
```kusto
Service
| where Name == 'Sense'
| project Device, State, StartMode, Status
| order by State asc
```

### Find Devices Without MDE
```kusto
Device
| join kind=leftanti (
    Service
    | where Name == 'Sense'
    | project Device
)
| project Device
```

## Related Queries

- [CMPivot-Security-LocalAdmins-List](Query-Library.md#security-log-sign-ins) - Check local administrators
- [CMPivot-Services-Running-FilterByName](Query-Library.md#sense-service-stopped) - Generic service check
- Registry queries for other security software

## Usage Tips

### Filter for Specific TenantId
If you have multiple tenants, filter for a specific one:
```kusto
| where Value == '12345678-1234-1234-1234-123456789012'
```

### Find Devices with Service Stopped
```kusto
| where DefenderWindowsFeatureInstalled == 'yes' and State == 'Stopped'
```

### Find Devices Not Enrolled
```kusto
| where DefenderWindowsFeatureInstalled == 'yes' and isnull(Value)
```

### Export Device List for Remediation
```kusto
| where isnull(Value) or State != 'Running'
| project Device
```

## Performance Considerations

- **This is a complex query** with multiple joins and registry lookups
- **Runtime**: Can take 1-5 minutes depending on collection size
- **Recommendation**: Run against smaller collections first, then scale up
- **Best for**: Targeted troubleshooting or scheduled compliance checks
- **Not recommended for**: Ad-hoc queries on "All Systems" (too slow)

## Troubleshooting

### Query times out
- Reduce target collection size
- Run during off-peak hours
- Increase CMPivot timeout setting

### Registry queries return no data
- Verify CMPivot has permission to read registry
- Check that devices are online
- Ensure client version supports registry queries

### Service data missing
- Verify Service inventory entity is available in your SCCM version
- Check that clients are responding to CMPivot

## Deployment Validation Workflow

1. **Before Deployment**: Run query to establish baseline (devices without MDE)
2. **During Deployment**: Run query to track progress
3. **After Deployment**: Verify all devices show full installation
4. **Ongoing**: Schedule regular compliance checks

## Alternative: Create SCCM Collection

For ongoing monitoring, consider creating a collection instead of running this query repeatedly.

See: [Collections/Device-Collections/MDE-Defender-Installation-Detection.md](../Collections/Device-Collections/MDE-Defender-Installation-Detection.md)

**Collection Benefits**:
- Automatic updates
- Faster than CMPivot
- Can be used for deployments
- Historical tracking

**CMPivot Benefits**:
- Real-time data
- More detailed validation
- Troubleshooting specific devices

## Tags
#MDE #Defender #Security #Endpoint #Compliance #Registry #Service #Enrollment #TenantId

---

**Last Updated**: 2025-01-19
**Contributed By**: swill
**Validated On**: All SCCM sites (DEV, TST, PRD, CM1)
