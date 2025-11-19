# CMPivot Quick Reference

**Purpose**: Fast reference for common CMPivot queries - copy, paste, run!

**See**: [Query-Library.md](Query-Library.md) for complete query collection with detailed descriptions

---

## Most Common Queries

### Check if a specific KB is installed
```kql
SoftwareUpdate | where KBArticleIDs == 'kb5018411'
```

### Find devices with low disk space (< 11GB)
```kql
LogicalDisk | where FreeSpace < 11000 and VolumeName !contains 'BEK'
```

### Check OS version on all devices
```kql
OperatingSystem | project Device, Caption, InstallDate, LastBootUpTime
```

### Find devices with specific software installed
```kql
InstalledSoftware | where ProductName contains 'Chrome' | project Device, ProductName, ProductVersion
```

### Check service status
```kql
Service | where Name == 'Sense' | project Device, Name, State, StartMode
```

---

## Software Updates

| Query | One-Liner |
|-------|-----------|
| `SoftwareUpdate \| where KBArticleIDs == 'kb4566468'` | Find specific KB |
| `SoftwareUpdate \| summarize dcount(Title) by Device` | Count updates per device |
| `QuickFixEngineering \| where InstalledOn >= ago(14d)` | Recent QFEs (2 weeks) |

---

## Operating System

| Query | One-Liner |
|-------|-----------|
| `OperatingSystem \| project Device, Caption, LastBootUpTime` | OS info & last boot |
| `OperatingSystem \| where InstallDate >= ago(10d)` | Recently installed OS |
| `OperatingSystem \| where Caption contains '2012'` | Find specific OS version |

---

## Installed Software

| Query | One-Liner |
|-------|-----------|
| `InstalledSoftware \| summarize count() by ProductName` | Software inventory count |
| `InstalledSoftware \| where ProductName contains 'Adobe'` | Find Adobe products |
| `InstalledSoftware \| where ProductName like 'configuration Manager Client'` | Find SCCM clients |

---

## Files & Versions

| Query | One-Liner |
|-------|-----------|
| `File('c:\\*\\*.ps1')` | Find all PS1 scripts |
| `File('%windir%\\system32\\ntoskrnl.exe') \| project Device, Version` | Kernel version |
| `File('%windir%\\system32\\drivers\\tcpip.sys') \| project Device, Version` | TCP/IP driver version |

---

## Network & IP

| Query | One-Liner |
|-------|-----------|
| `IPConfig \| where Status == 'Up' \| project Device, IPV4Address` | Active IP addresses |
| `IPConfig \| where DNSServerList !contains '10.234.128.20'` | Non-standard DNS |

---

## Services

| Query | One-Liner |
|-------|-----------|
| `Service \| where Name == 'Sense' and State == 'Stopped'` | Stopped Defender |
| `Service \| where Name like 'tib%' and StartMode == 'Auto'` | TIBCO services |
| `Service \| where StartMode == 'Auto' and State == 'Stopped'` | Auto services stopped |

---

## Registry

| Query | One-Liner |
|-------|-----------|
| `Registry('HKLM:\\SOFTWARE\\Microsoft\\SenseCM') \| where Property == 'TenantId'` | Defender Tenant ID |
| `Registry('HKLM:\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\SCHANNEL\\Protocols\\TLS *\\*')` | TLS settings |

---

## CCM Logs (Troubleshooting)

| Query | One-Liner |
|-------|-----------|
| `CcmLog('WUAHandler') \| where LogText contains 'Failed to download updates'` | Update download failures |
| `CcmLog('LocationServices') \| where LogText contains 'not in any boundary group'` | Boundary issues |
| `CcmLog('UpdatesDeployment', 6d) \| where LogText contains 'Initiated by user'` | User-initiated updates |

---

## Event Logs

| Query | One-Liner |
|-------|-----------|
| `WinEvent('Security') \| where ID == 4624` | Logon events |
| `WinEvent('Microsoft-Windows-Resource-Exhaustion-Detector/Operational') \| where ID == 1003` | Resource exhaustion |
| `EventLog('Application') \| where EventID == 4098` | Application errors |

---

## Disk Space

| Query | One-Liner |
|-------|-----------|
| `LogicalDisk \| where FreeSpace < 11000` | Low disk space (< 11GB) |
| `LogicalDisk \| project Device, Name, FreeSpace, Size` | All disk space info |

---

## Security & Compliance

| Query | One-Liner |
|-------|-----------|
| `InstalledSoftware \| where ProductName like 'Cisco Secure Endpoint'` | Cisco endpoint installed |
| `Service \| where Name == 'Sense' \| project Device, State, StartMode` | Defender service status |
| `Registry('HKLM:\\SOFTWARE\\Microsoft\\Cryptography\\Wintrust\\Config') \| where Property == 'EnableCertPaddingCheck'` | Cert padding check |

---

## Joins (Enriched Data)

### KB with OS Info
```kql
SoftwareUpdate
| where KBArticleIDs == 'KB4535680'
| join (OperatingSystem)
| project Device, Caption, KBArticleIDs, Title
```

### Software with OS Info
```kql
InstalledSoftware
| where ProductName contains 'Chrome'
| join (OperatingSystem)
| project Device, Caption, ProductName, ProductVersion
```

### Missing Software Check
```kql
InstalledSoftware
| where ProductName like 'configuration Manager Client'
| join kind=leftouter (InstalledSoftware | where ProductName like 'Cisco Secure Endpoint')
| where isnull(ProductName1)
| project Device
```

---

## Time-Based Queries

| Time Filter | Syntax |
|-------------|--------|
| Last 1 day | `ago(1d)` |
| Last 7 days | `ago(7d)` |
| Last 14 days | `ago(14d)` |
| Last 30 days | `ago(30d)` |
| Last 30 minutes | `ago(30m)` |
| Last 1 hour | `ago(1h)` |

**Example**:
```kql
OperatingSystem | where InstallDate >= ago(7d)
```

---

## Common Filters

### Exclude Items
```kql
| where KBArticleIDs != 'kb4054566'
| where Title !contains 'malicious'
| where VolumeName !contains 'BEK'
```

### Include Items (OR)
```kql
| where KBArticleIDs == 'kb5018411' or KBArticleIDs == 'kb5018419'
| where ProductName contains 'Chrome' or ProductName contains 'Firefox'
```

### Multiple Conditions (AND)
```kql
| where StartMode == 'Auto' and State == 'Stopped'
| where Status == 'Up' and DNSServerList !contains '10.234.128.20'
```

---

## Common Aggregations

### Count per Device
```kql
SoftwareUpdate | summarize dcount(Title) by Device
```

### Count per Product
```kql
InstalledSoftware | summarize count() by ProductName
```

### Distinct Devices
```kql
SoftwareUpdate | where KBArticleIDs == 'kb4566468' | distinct Device
```

---

## Pro Tips

### Copy Only Device Names
```kql
[Your Query] | project Device
```

### Sort Results
```kql
[Your Query] | order by Device asc
[Your Query] | order by FreeSpace desc
```

### Limit Results
```kql
[Your Query] | take 10
```

### Combined
```kql
LogicalDisk
| where FreeSpace < 11000
| project Device, Name, FreeSpace
| order by FreeSpace asc
| take 20
```

---

## Need More Details?

- **Full Library**: [Query-Library.md](Query-Library.md) - All 58 queries with detailed descriptions
- **CMPivot Guide**: [README.md](README.md) - Complete CMPivot documentation
- **Kusto Reference**: [Naming Conventions](../Documentation/naming-conventions.md#cmpivot-queries)

---

**Quick Access**: Bookmark this page for fast query reference!
