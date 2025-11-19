# CMPivot Queries

This folder contains CMPivot queries for real-time device querying across all SCCM sites.

## What is CMPivot?

CMPivot is a real-time query tool in SCCM that allows you to query devices and get immediate results. Unlike collections which are scheduled and cached, CMPivot provides on-demand, real-time data.

## Site-Agnostic Queries

**CMPivot queries work across all sites** (DEV, TST, PRD, CM1) without modification. They query devices in real-time regardless of which site they belong to.

**No site code prefix needed** for CMPivot query names.

## Naming Convention

**Format**: `CMPivot-[Category]-[Purpose]`

Where:
- **CMPivot**: Query type indicator
- **[Category]**: Query category (Software, Hardware, Security, Performance, etc.)
- **[Purpose]**: What the query does

## Common Query Categories

### Software Queries
- Installed applications and versions
- Software updates and compliance
- Application usage

### Hardware Queries
- Disk space and storage
- Memory and CPU information
- Connected devices and peripherals

### Security Queries
- Local administrators
- Firewall status
- Antivirus status
- Security patches

### Performance Queries
- CPU and memory usage
- Disk performance
- Running processes

### Network Queries
- IP configuration
- Active connections
- Network adapters

### Services Queries
- Running services
- Service status
- Startup configuration

### Inventory Queries
- System information
- BIOS details
- Operating system details

## Query Documentation Template

When documenting CMPivot queries, use this format:

```markdown
# CMPivot-[Category]-[Purpose]

## Purpose
[Brief description of what this query does]

## Use Cases
- [Use case 1]
- [Use case 2]
- [Use case 3]

## Query

\```kusto
[Your CMPivot query here]
\```

## Parameters
- **[Parameter 1]**: [Description]
- **[Parameter 2]**: [Description]

## Example Results

| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Data | Data | Data |

## Notes
[Any special considerations, limitations, or tips]

## Related Queries
- [Related Query 1]
- [Related Query 2]

## Tags
[software, hardware, security, performance, network, etc.]
```

## Example Queries

### CMPivot-Software-InstalledApps-SearchByName

**Purpose**: Find devices with a specific application installed

**Query**:
```kusto
InstalledSoftware
| where ProductName contains "Adobe"
| project Device, ProductName, ProductVersion, Publisher
| order by Device
```

### CMPivot-Hardware-LowDiskSpace-Under10GB

**Purpose**: Identify devices with low disk space (under 10GB free)

**Query**:
```kusto
LogicalDisk
| where DriveType == "Fixed"
| extend FreeSpaceGB = FreeSpace / 1024
| where FreeSpaceGB < 10
| project Device, Name, FreeSpaceGB, Size, Description
| order by FreeSpaceGB
```

### CMPivot-Security-LocalAdmins-List

**Purpose**: List local administrators on devices

**Query**:
```kusto
Administrators
| project Device, Name, Caption, Disabled
| order by Device
```

### CMPivot-Performance-HighCPU-Over80Percent

**Purpose**: Find devices with high CPU usage

**Query**:
```kusto
Process
| summarize CPUPercent = sum(CPUTime) by Device
| where CPUPercent > 80
| order by CPUPercent desc
```

### CMPivot-Updates-PendingReboot-Check

**Purpose**: Check if devices have pending reboots

**Query**:
```kusto
Registry('HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\WindowsUpdate\\Auto Update\\RebootRequired')
| project Device
```

### CMPivot-Services-Running-FilterByName

**Purpose**: Check status of specific service

**Query**:
```kusto
Service
| where Name == "wuauserv"  // Windows Update service
| project Device, Name, DisplayName, State, StartMode, Status
| order by Device
```

## CMPivot Query Language (Kusto)

CMPivot uses the **Kusto Query Language (KQL)**, similar to Azure Monitor and Log Analytics.

### Common Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `where` | Filter rows | `where Name == "System"` |
| `project` | Select columns | `project Device, Name, Status` |
| `summarize` | Aggregate data | `summarize count() by Device` |
| `order by` | Sort results | `order by Name asc` |
| `extend` | Create calculated columns | `extend SizeGB = Size / 1024` |
| `join` | Combine data | `join kind=inner (...)` |
| `distinct` | Unique values | `distinct Device` |
| `take` | Limit rows | `take 10` |

### Common Functions

| Function | Description | Example |
|----------|-------------|---------|
| `contains` | String contains | `where Name contains "Adobe"` |
| `startswith` | String starts with | `where Name startswith "Microsoft"` |
| `endswith` | String ends with | `where Name endswith ".exe"` |
| `count()` | Count rows | `summarize count()` |
| `sum()` | Sum values | `summarize sum(Size)` |
| `avg()` | Average values | `summarize avg(CPUTime)` |
| `now()` | Current date/time | `where Timestamp > ago(1d)` |
| `ago()` | Time ago | `where Timestamp > ago(7d)` |

## CMPivot Entity Reference

### Common Entities

| Entity | Description |
|--------|-------------|
| `Device` | Basic device information |
| `InstalledSoftware` | Installed applications |
| `LogicalDisk` | Disk drives and space |
| `PhysicalMemory` | RAM information |
| `Processor` | CPU information |
| `OperatingSystem` | OS details |
| `Service` | Windows services |
| `Process` | Running processes |
| `Registry` | Registry keys and values |
| `File` | File system queries |
| `EventLog` | Event log entries |
| `Administrators` | Local admins |
| `AutoStartSoftware` | Startup programs |
| `Connection` | Network connections |
| `IPConfig` | Network configuration |

## Best Practices

### Query Design
1. **Start Specific**: Begin with specific entities and filters
2. **Limit Results**: Use `take` to limit results when testing
3. **Project Early**: Select only needed columns to reduce data transfer
4. **Filter First**: Apply filters as early as possible in the query
5. **Test Incrementally**: Build complex queries step by step

### Performance Considerations
1. **Target Specific Collections**: Run queries against smaller, targeted collections
2. **Avoid Wildcard Searches**: Be specific when possible
3. **Use Appropriate Timeout**: Set reasonable timeout values
4. **Monitor Query Impact**: Be aware of the impact on client devices
5. **Schedule Wisely**: Run resource-intensive queries during off-peak hours

### Security and Compliance
1. **Limit Access**: Only authorized users should run CMPivot queries
2. **Audit Usage**: Review CMPivot audit logs regularly
3. **Protect Sensitive Data**: Be cautious with queries that return sensitive information
4. **Document Queries**: Document what each query does and why it's needed

## Troubleshooting CMPivot Queries

### Query Returns No Results
- Verify target collection has online devices
- Check that entity is supported on target OS versions
- Verify CMPivot prerequisites are met (client version, ports, etc.)
- Check firewall rules allow CMPivot traffic

### Query Times Out
- Reduce the scope (smaller collection)
- Add filters to reduce result set
- Increase timeout value
- Check network connectivity to devices

### Syntax Errors
- Verify entity names are correct (case-sensitive)
- Check for missing pipes `|` between operators
- Ensure proper quote usage for strings
- Validate function names and parameters

## Running CMPivot Queries

### From SCCM Console

1. Navigate to **Assets and Compliance > Device Collections**
2. Select a collection
3. Click **CMPivot** in the ribbon
4. Enter your query
5. Click **Run Query**

### From PowerShell

```powershell
# This is a preview example - full PowerShell support may vary
Invoke-CMCMPivot -CollectionName "All Systems" -Query "OperatingSystem | project Device, Caption, Version"
```

## Saving and Sharing Queries

### Save Queries in SCCM
1. Run the query in CMPivot
2. Click **Save** or **Save As**
3. Provide a name following naming convention
4. Query is saved for reuse

### Share Queries in This Repository
1. Document query using the template above
2. Save as markdown file: `CMPivot-[Category]-[Purpose].md`
3. Place in this folder
4. Commit and push to repository

## Real-Time Use Cases

### Security Incident Response
- Identify devices with specific vulnerability
- Check for indicators of compromise (IOCs)
- Verify security patches are applied
- Audit local administrator accounts

### Troubleshooting
- Check service status across devices
- Identify disk space issues
- Find devices running specific processes
- Verify application versions

### Compliance Auditing
- Check for unauthorized software
- Verify required applications are installed
- Audit security configurations
- Check for compliance with policies

### Asset Management
- Inventory specific hardware
- Track software installations
- Identify obsolete systems
- Locate specific devices

## CMPivot vs. Collections vs. Reports

| Feature | CMPivot | Collections | Reports |
|---------|---------|-------------|---------|
| **Speed** | Real-time | Scheduled updates | Scheduled/On-demand |
| **Data Freshness** | Current | Cached | Historical |
| **Target** | Device-level | Device groups | Database queries |
| **Use Case** | Troubleshooting, ad-hoc queries | Deployments, targeting | Analysis, compliance |
| **Requires** | Online devices | SCCM client | SCCM database |
| **Best For** | Quick investigations | Ongoing operations | Reports and dashboards |

## CMPivot Prerequisites

### SCCM Requirements
- Configuration Manager current branch version 1806 or later
- Appropriate permissions (CMPivot operator or administrator)
- Target devices must be online
- Fast channel for client notification

### Client Requirements
- SCCM client version 1806 or later
- PowerShell 4.0 or later
- WMI must be functional
- Firewall ports open for client notification

### Network Requirements
- Client notification channel must be operational
- TCP port 135 (RPC) must be open
- Dynamic ports (RPC) must be allowed
- HTTPS recommended for security

## Additional Resources

### Microsoft Documentation
- [CMPivot Overview](https://docs.microsoft.com/en-us/mem/configmgr/core/servers/manage/cmpivot)
- [CMPivot Queries](https://docs.microsoft.com/en-us/mem/configmgr/core/servers/manage/cmpivot-queries)
- [Kusto Query Language](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/)

### Internal Resources
- SCCM Admin Team
- Security Team (for security-related queries)
- Helpdesk (for troubleshooting use cases)

---

**Last Updated**: 2025-01-19

**Note**: CMPivot queries in this repository are shared across all sites (DEV, TST, PRD, CM1) and do not require site-specific modifications.
