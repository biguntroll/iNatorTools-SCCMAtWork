# CMPivot Query Library

**Purpose**: Master reference library containing all CMPivot queries used across all SCCM sites (DEV, TST, PRD, CM1)

**Note**: These queries are site-agnostic and work across all environments without modification.

**Last Updated**: 2025-01-19

---

## Software Update Queries

### Count unique update titles per device
```kql
SoftwareUpdate
| summarize dcount(Title) by Device
| order by dcount_ desc
```
*Description:* Counts distinct update titles installed on each device and orders by highest count.
*Tags:* #tags: SoftwareUpdate, Summary, Count

### Exclude specific KBs and a title substring
```kql
SoftwareUpdate
| where KBArticleIDs != 'kb4054566'
    and KBArticleIDs != 'kb4486105'
    and Title !contains '2022-03'
```
*Description:* Retrieves updates excluding two KB IDs and titles containing "2022-03."
*Tags:* #tags: SoftwareUpdate, Filter, Exclude

### Exclude specific KBs and multiple title substrings
```kql
SoftwareUpdate
| where KBArticleIDs != 'kb4054566'
    and KBArticleIDs != 'kb4486105'
    and Title !contains 'malicious'
    and Title !contains 'detector'
```
*Description:* Excludes two KB IDs and any titles with "malicious" or "detector."
*Tags:* #tags: SoftwareUpdate, Filter, Exclude

### Exclude three KBs and count per title
```kql
SoftwareUpdate
| where KBArticleIDs != 'kb4054566'
    and KBArticleIDs != 'kb4486105'
    and KBArticleIDs != 'kb4033369'
    and Title !contains 'malicious'
    and Title !contains 'detector'
    and Title !contains '2022-05'
| summarize count() by Title
| order by count_ desc
```
*Description:* Counts occurrences of each title after filtering out three KBs and unwanted substrings.
*Tags:* #tags: SoftwareUpdate, Filter, Count

### Exclude three KBs and count unique titles per device
```kql
SoftwareUpdate
| where KBArticleIDs != 'kb4054566'
    and KBArticleIDs != 'kb4486105'
    and KBArticleIDs != 'kb4033369'
    and Title !contains 'malicious'
    and Title !contains 'detector'
    and Title !contains '2022-04'
| summarize dcount(Title) by Device
| order by dcount_ desc
```
*Description:* For each device, counts how many distinct titles remain after filtering three KB IDs and substrings.
*Tags:* #tags: SoftwareUpdate, Filter, Summary

### Exclude three KBs and join OS info
```kql
SoftwareUpdate
| where KBArticleIDs != 'kb4054566'
    and KBArticleIDs != 'kb4486105'
    and KBArticleIDs != 'kb4033369'
    and Title !contains 'malicious'
    and Title !contains 'detector'
    and Title !contains '2022-04'
| summarize dcount(Title) by Device
| join (OperatingSystem)
| project Device, Caption, InstallDate, LastBootUpTime, dcount_
| order by dcount_ desc
```
*Description:* After filtering, counts distinct titles per device and enriches results with OS details.
*Tags:* #tags: SoftwareUpdate, OS, Join

### Find devices with any of three KBs and join OS info
```kql
SoftwareUpdate
| where KBArticleIDs == 'kb5017365'
    or KBArticleIDs == 'kb5017305'
    or KBArticleIDs == 'kb5017315'
| join (OperatingSystem)
| project Device, Caption, InstallDate, LastBootUpTime, KBArticleIDs, Title
```
*Description:* Locates devices with any one of three KBs, then displays OS info alongside update details.
*Tags:* #tags: SoftwareUpdate, Join, OR

### Find devices with any of four KBs and join OS info
```kql
SoftwareUpdate
| where KBArticleIDs == 'kb5018411'
    or KBArticleIDs == 'kb5018419'
    or KBArticleIDs == 'kb5018478'
    or KBArticleIDs == 'kb5018476'
| join (OperatingSystem)
| project Device, Caption, InstallDate, LastBootUpTime, KBArticleIDs, Title
```
*Description:* Similar to above but checks four specific KB IDs.
*Tags:* #tags: SoftwareUpdate, Join, OR

### Find devices with either of two KBs
```kql
SoftwareUpdate
| where KBArticleIDs == 'kb4566468'
    or KBArticleIDs == 'kb4580469'
```
*Description:* Retrieves devices having either KB 4566468 or 4580469 installed.
*Tags:* #tags: SoftwareUpdate, OR

### Find devices with a specific KB
```kql
SoftwareUpdate
| where KBArticleIDs == 'kb4566468'
```
*Description:* Shows devices that have KB 4566468 installed.
*Tags:* #tags: SoftwareUpdate, Filter

### Find devices with a specific KB and join OS info
```kql
SoftwareUpdate
| where KBArticleIDs == 'KB4535680'
| join (OperatingSystem)
| project Device, Caption, InstallDate, LastBootUpTime, KBArticleIDs, Title
```
*Description:* Filters for KB 4535680 and enriches with operating system details.
*Tags:* #tags: SoftwareUpdate, Join

---

## Quick Fix Engineering

### Recent Quick Fixes (last 14 days)
```kql
QuickFixEngineering
| where InstalledOn >= ago(14d)
```
*Description:* Lists QFEs installed in the past two weeks.
*Tags:* #tags: QFE, DateFilter

---

## CCM Log Queries

### WUAHandler: Agent datastore download failures
```kql
CcmLog('WUAHandler')
| where LogText contains 'Failed to download updates to the WUAgent datastore'
| project Device, LogText, DateTime
```
*Description:* Captures WUAHandler errors when update files fail to download.
*Tags:* #tags: CCMLog, UpdateFailure

### WUAHandler: Specific error 0x80073712
```kql
CcmLog('WUAHandler')
| where LogText contains '0x80073712'
| project Device, LogText, DateTime
```
*Description:* Finds Windows Update Agent events for error code 0x80073712.
*Tags:* #tags: CCMLog, ErrorCode

### WUAHandler: Success cancellation
```kql
CcmLog('WUAHandler')
| where LogText contains 'Successfully canceled running installation'
| project Device, LogText, DateTime
```
*Description:* Detects when running update installs are canceled successfully.
*Tags:* #tags: CCMLog, Success

### LocationServices: No boundary group
```kql
CcmLog('LocationServices')
| where LogText contains 'Client is not in any boundary group.'
| project Device, LogText, DateTime
```
*Description:* Shows devices reporting they aren't in any SCCM boundary group.
*Tags:* #tags: CCMLog, Boundary

### LocationServices: AD site retrieval failure
```kql
CcmLog('LocationServices')
| where LogText contains 'Unable to retrieve AD site membership'
| project Device, LogText, DateTime
```
*Description:* Captures AD site lookup failures.
*Tags:* #tags: CCMLog, AD

### UpdatesDeployment: Initiated by user (6d)
```kql
CcmLog('UpdatesDeployment', 6d)
| where LogText contains 'InstallUpdates Initiated by user'
| distinct Device
| project Device
```
*Description:* Identifies devices where updates were initiated manually in the last 6 days.
*Tags:* #tags: CCMLog, ManualInstall

### CIStore: Dependency enumeration failures
```kql
CcmLog('CIStore')
| where LogText contains 'EnumAllDependantCIs failed'
| project Device, LogText, DateTime
```
*Description:* Detects failures enumerating dependent configuration items.
*Tags:* #tags: CCMLog, CIStore

### WUAHandler: Finished installing marker
```kql
CcmLog('WUAHandler')
| where LogText contains '(17b46563-df34-4749-9958-ee53b89a6c3a) finished installing'
| project Device, LogText, DateTime
```
*Description:* Looks for a specific install-completion identifier.
*Tags:* #tags: CCMLog, InstallComplete

---

## File Queries

### Find PowerShell scripts on any drive
```kql
File('c:\\*\\*.ps1')
```
*Description:* Lists all `.ps1` files across all drives.
*Tags:* #tags: File, Script

### InstalledSoftware missing MpSigStub
```kql
InstalledSoftware
| where ProductName like 'configuration Manager Client'
| join kind=leftouter (File('C:\\WINDOWS\\System32\\MpSigStub.exe'))
| where isnull(FileName)
| project Device
```
*Description:* Finds devices with ConfigMgr client installed but missing the MpSigStub file.
*Tags:* #tags: File, Join

### Java wsdetect.dll versions
```kql
File('C:\\Program Files\\Java\\*\\*\\wsdetect.dll')
| project Device, FileName, Version
```
*Description:* Reports versions of `wsdetect.dll` under Java directories.
*Tags:* #tags: File, Java

### Linux-style wildcard for jvm.dll
```kql
File('C:\\Program Files\\Java\\*\\*\\*\\jvm.dll')
| project Device, FileName, Version
```
*Description:* Finds `jvm.dll` across nested Java folders.
*Tags:* #tags: File, Java

### System32 tcpip.sys version
```kql
File('%windir%\\system32\\drivers\\tcpip.sys')
| project Device, FileName, Version
```
*Description:* Retrieves version of the `tcpip.sys` driver.
*Tags:* #tags: File, Driver

### Windows kernel version
```kql
File('%windir%\\system32\\ntoskrnl.exe')
| project Device, FileName, Version
```
*Description:* Shows OS kernel file version.
*Tags:* #tags: File, OS

### PresentationCFF Rasterizer native DLL
```kql
File('%windir%\\system32\\presentationcffrasterizernative_v0300.dll')
| where Version contains '3.0.6920.7903'
| project Device, FileName, Version
```
*Description:* Checks for a specific version of the Presentation RDF native DLL.
*Tags:* #tags: File, Version

### SQL CE files
```kql
File('C:\\Program Files\\Microsoft SQL Server Compact Edition\\v4.0\\*')
```
*Description:* Lists all files under SQL Server Compact Edition v4.0.
*Tags:* #tags: File, SQL

### Serv-U Archive content
```kql
File('C:\\chef\\log\\client.log')
| project Device, FileName, LastWriteTime
```
*Description:* Captures Chef client log file details.
*Tags:* #tags: File, Log

---

## Missing File Queries

### Devices missing `client.log`
```kql
Device
| join kind=leftouter (File('C:\\chef\\log\\client.log'))
| where isnull(FileName)
| project Device
```
*Description:* Finds machines without the Chef `client.log` file.
*Tags:* #tags: MissingFile, Log

---

## File Content Queries

### Detect cookbook install errors
```kql
FileContent('C:\\chef\\log\\client.log')
| where Content contains 'could not find recipe install_CiscoSE for cookbook tps'
| summarize dcount(Content) by Device
```
*Description:* Counts distinct occurrences of a missing-recipe error in Chef logs.
*Tags:* #tags: Log, Chef

### KeyNotFoundException in Chef logs
```kql
FileContent('C:\\chef\\log\\client.log')
| where Content contains 'System.Collections.Generic.KeyNotFoundException'
| summarize dcount(Content) by Device
```
*Description:* Tallies `KeyNotFoundException` occurrences per device.
*Tags:* #tags: Log, Exception

### IBM WinCollect install config
```kql
FileContent('C:\\Program Files\\IBM\\WinCollect\\config\\install_config.txt')
| where Content contains 'StatusServer'
    or Content contains 'ApplicationIdentifier'
```
*Description:* Extracts critical fields from WinCollect install config.
*Tags:* #tags: WinCollect, Config

### Scheduled reboot check
```kql
FileContent('c:\\utilities\\powershelloutput\\MWRebootCheckiNator\\scheduledreboot.txt')
```
*Description:* Reads the scheduled reboot record from your custom output.
*Tags:* #tags: Reboot, Custom

---

## Operating System Queries

### List all devices with their OS info
```kql
OperatingSystem
| project Device, Caption, InstallDate, LastBootUpTime
```
*Description:* Basic inventory of OS caption, install, and last boot times.
*Tags:* #tags: OS, Inventory

### Recent OS installs (last 10 days)
```kql
OperatingSystem
| where InstallDate >= ago(10d)
| project Device, Caption, InstallDate, LastBootUpTime
```
*Description:* Shows devices whose OS was installed within the past ten days.
*Tags:* #tags: OS, DateFilter

### OS with update counts
```kql
OperatingSystem
| project Device, Caption, InstallDate, LastBootUpTime
| join (
    SoftwareUpdate
    | summarize dcount(Title) by Device
)
| order by dcount_ desc
```
*Description:* Joins OS info to per-device update counts for prioritization.
*Tags:* #tags: OS | Join

### Chrome on older OS
```kql
OperatingSystem
| where Caption contains '2012'
| join InstalledSoftware
| where ProductName contains 'Chrome'
| project Device, Caption, InstallDate, LastBootUpTime, ProductVersion
```
*Description:* Identifies Chrome versions running on Windows Server 2012 systems.
*Tags:* #tags: OS, Chrome

---

## Installed Software Queries

### Count installs by product
```kql
InstalledSoftware
| summarize count() by ProductName
| order by ProductName asc
```
*Description:* Shows how many devices have each product installed.
*Tags:* #tags: InstalledSoftware, Summary

### List specific endpoint agents
```kql
InstalledSoftware
| where ProductName contains 'Cisco amp'
    or ProductName contains 'Datadog'
| project Device, ProductName, ProductVersion
```
*Description:* Reports installed versions of Cisco AMP and Datadog.
*Tags:* #tags: Endpoint, Security

### Missing secure endpoint after ConfigMgr
```kql
InstalledSoftware
| where ProductName like 'configuration Manager Client'
| join kind=leftouter (
    InstalledSoftware | where ProductName like 'Cisco Secure Endpoint'
)
| where isnull(ProductName1)
| project Device
```
*Description:* Finds ConfigMgr clients lacking Cisco Secure Endpoint.
*Tags:* #tags: InstalledSoftware, Join

### Azure CLI versions
```kql
InstalledSoftware
| where ProductName contains 'Microsoft Azure CLI'
| project Device, ProductName, ProductVersion
| order by ProductVersion asc
```
*Description:* Lists all detected Azure CLI installs, sorted by version.
*Tags:* #tags: AzureCLI, Version

---

## Network & Registry Queries

### Active IPv4 addresses
```kql
IPConfig
| where Status == 'Up'
| project Device, IPV4Address
```
*Description:* Shows devices with up interfaces and their IPv4 addresses.
*Tags:* #tags: IPConfig, Network

### DNS servers not matching policy
```kql
IPConfig
| where Status == 'Up'
    and DNSServerList !contains '10.234.128.20'
| project Device, DNSServerList
| order by DNSServerList asc
```
*Description:* Identifies devices using nonstandard DNS servers.
*Tags:* #tags: IPConfig, DNS

### Block cross-protocol IE nav
```kql
Registry('HKLM:\\SOFTWARE\\Policies\\Microsoft\\Internet Explorer\\Main\\FeatureControl\\FEATURE_BLOCK_CROSS_PROTOCOL_FILE_NAVIGATION')
```
*Description:* Checks whether IE's cross-protocol navigation feature is enforced.
*Tags:* #tags: Registry, IE

### EnableCertPaddingCheck status
```kql
Registry('HKLM:\\SOFTWARE\\Microsoft\\Cryptography\\Wintrust\\Config')
| where Property == 'EnableCertPaddingCheck'
| project Device, Key, Property, Value
```
*Description:* Verifies if cert padding checks are enabled in Wintrust config.
*Tags:* #tags: Registry, Security

### TIBCO service tags
```kql
Registry('HKLM:\\SOFTWARE\\WOW6432Node\\Tanium\\Tanium Client\\Sensor Data\\Tags')
```
*Description:* Reads custom tag data from the Tanium client registry.
*Tags:* #tags: Registry, Tanium

### SCHANNEL TLS protocol registry settings with OS version
```kql
Registry('HKLM:\\SYSTEM\\CurrentControlSet\\Control\\SecurityProviders\\SCHANNEL\\Protocols\\TLS *\\*')
| join (OperatingSystem | project Device, OSVersion=Caption)
| order by Device asc
```
*Description:* Retrieves TLS protocol registry settings and joins with OS version information, ordered by device name.
*Tags:* #tags: Registry, TLS, Security, OS

---

## Event Log Queries

### DNS client operational filtering
```kql
WinEvent('Microsoft-Windows-DNS-Client/Operational')
| where Message contains '10.234.128.4'
    or Message contains '10.234.128.5'
| where Message !contains 'name TNDCP001'
    and Message !contains 'name TNDCP002'
    and Message !contains 'prod.trizettoprovider.com'
| project Device, DateTime, Message
| order by Message
```
*Description:* Captures DNS client events for specific servers, excluding noise.
*Tags:* #tags: DNS, EventLog

### Resource exhaustion detector
```kql
WinEvent('Microsoft-Windows-Resource-Exhaustion-Detector/Operational')
| where ID == 1003
| project Device, DateTime, Message
| order by Message
```
*Description:* Finds memory or handle exhaustion events (ID 1003).
*Tags:* #tags: Resource, EventLog

### Security log sign-ins
```kql
WinEvent('Security')
| where Message contains 'tpsadmin'
| where ID == 4624 or ID == 4648
```
*Description:* Tracks TPS admin account logon successes and explicit credentials.
*Tags:* #tags: Security, Login

### Application event 4098
```kql
EventLog('Application')
| where EventID == 4098
| join (
    OperatingSystem
    | project Device, InstallDate, Caption, LastBootUpTime
)
```
*Description:* Correlates App log errors (4098) with OS info.
*Tags:* #tags: EventLog, Application

---

## Miscellaneous Queries

### Logical disks below threshold
```kql
LogicalDisk
| where VolumeName !contains 'BEK'
    and VolumeName !contains 'Temporary Storage'
    and FreeSpace < 11000
```
*Description:* Finds disks with under 11 GB free, excluding special volumes.
*Tags:* #tags: Disk, Threshold

### TIBCO services stopped recently
```kql
Service
| where Name like 'tib%'
    and StartMode == 'Auto'
| order by State
```
*Description:* Lists auto-start TIBCO services and their states.
*Tags:* #tags: Service, TIBCO

### Sense service stopped
```kql
Service
| where Name == 'Sense'
    and State == 'Stopped'
| join OS
| project Device, Caption, State, Status
| order by Device asc
```
*Description:* Detects machines where the "Sense" service has stopped.
*Tags:* #tags: Service, Security

### Microsoft Defender for Endpoint (Sense) Status
```kql
Device
| join kind=leftouter (
    Registry('HKLM:\\SOFTWARE\\Microsoft\\SenseCM')
    | where Property == 'TenantId'
    | project Device, Value
)
| join kind=leftouter (
    Service
    | where Name == 'Sense'
    | project Device, State, StartMode, Status
)
| project Device, Value, State, StartMode, Status
```
*Description:* Gathers Microsoft Defender for Endpoint (Sense) status, including Tenant ID, service state, and antivirus signature details.
*Tags:* #tags: Registry, Service, EPStatus, Security, Defender, Sense

---

## Configuration Change Queries

### Stopped SCCM Client service in last 30 minutes
```kql
ConfigurationChange
| where ConfigChangeType == "WindowsServices"
    and SvcChangeType == "State"
    and SvcName startswith "ccmexec"
    and SvcStartupType == "Auto"
    and SvcPreviousState == "Running"
    and SvcState == "Stopped"
    and TimeGenerated > ago(30m)
```
*Description:* Alerts on auto-start ConfigMgr client service stoppages in the last half-hour.
*Tags:* #tags: ConfigChange, SCCM

### Stopped TIBCO services in last 15 minutes
```kql
ConfigurationChange
| where ConfigChangeType == "WindowsServices"
    and SvcChangeType == "State"
    and SvcDisplayName startswith "tib"
    and SvcStartupType == "Auto"
    and SvcPreviousState == "Running"
    and SvcState == "Stopped"
    and TimeGenerated > ago(15m)
```
*Description:* Monitors auto-start TIBCO services that have stopped recently.
*Tags:* #tags: ConfigChange, TIBCO

---

## Query Categories Summary

| Category | Query Count | Primary Use Case |
|----------|-------------|------------------|
| Software Updates | 11 | Update compliance, KB tracking |
| Quick Fix Engineering | 1 | QFE inventory |
| CCM Logs | 8 | SCCM troubleshooting |
| Files | 9 | File inventory, version tracking |
| Missing Files | 1 | Compliance checking |
| File Content | 4 | Log analysis, config validation |
| Operating System | 4 | OS inventory, age tracking |
| Installed Software | 4 | Software inventory, compliance |
| Network & Registry | 6 | Network config, registry settings |
| Event Logs | 4 | Security, troubleshooting |
| Miscellaneous | 4 | Disk space, services |
| Configuration Change | 2 | Real-time monitoring |

**Total Queries**: 58

---

## Usage Notes

### Running Queries
1. Open CMPivot from SCCM Console
2. Select target collection
3. Copy query from this library
4. Paste into CMPivot query window
5. Click Run Query

### Modifying Queries
- Replace specific KB numbers with your target KBs
- Adjust date ranges (e.g., `ago(14d)` to `ago(30d)`)
- Modify file paths for your environment
- Update IP addresses and server names

### Saving Queries
- Save frequently used queries in SCCM CMPivot
- Use naming convention: `CMPivot-[Category]-[Purpose]`
- Document any environment-specific modifications

---

**Maintained by**: SCCM Admin Team
**Repository**: iNatorTools-SCCMAtWork/CMPivot/
