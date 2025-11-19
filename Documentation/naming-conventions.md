# SCCM Naming Conventions

This document defines the naming conventions for all SCCM objects in our environment. Consistent naming ensures clarity, simplifies management, and makes it easier to locate resources.

## Multi-Site Environment

Our organization manages **four SCCM sites**:
- **DEV**: Development site
- **TST**: Test/UAT site
- **PRD**: Production site
- **CM1**: Secondary production site

**All object names must include the site code** to clearly identify which site they belong to.

## General Principles

1. **Include Site Code**: Always prefix with site code (DEV, TST, PRD, CM1)
2. **Be Descriptive**: Names should clearly indicate purpose and scope
3. **Be Consistent**: Follow the same pattern for similar objects
4. **Be Concise**: Keep names reasonably short while remaining descriptive
5. **Use Standard Abbreviations**: Use approved abbreviations consistently
6. **Avoid Special Characters**: Use only letters, numbers, and hyphens

## Standard Abbreviations

### Site Codes
| Abbreviation | Meaning |
|--------------|---------|
| DEV | Development site |
| TST | Test/UAT site |
| PRD | Production site |
| CM1 | Secondary production site |

### Object Type Abbreviations
| Abbreviation | Meaning |
|--------------|---------|
| DEV | Device (in collection context) |
| USR | User |
| SW | Software |
| UPD | Update |
| CFG | Configuration |
| DEPLOY | Deployment |
| MAINT | Maintenance |
| PILOT | Pilot/Test |
| PROD | Production |
| WKS | Workstation |
| SRV | Server |
| SEC | Security |
| CRIT | Critical |
| ADR | Automatic Deployment Rule |
| SUG | Software Update Group |
| TS | Task Sequence |
| CI | Configuration Item |
| CB | Configuration Baseline |
| DP | Distribution Point |

**Note**: DEV appears as both a site code and collection type. Context determines meaning:
- First position = Site code (e.g., **DEV**-DEV-Patching-Workstations)
- Second position = Collection type (e.g., DEV-**DEV**-Patching-Workstations)

---

## Collections

### Device Collections

**Format**: `[Site]-DEV-[Purpose]-[Target]-[Qualifier]`

Where:
- **[Site]**: Site code (DEV, TST, PRD, CM1)
- **DEV**: Device collection indicator
- **[Purpose]**: Collection purpose
- **[Target]**: Target devices
- **[Qualifier]**: Optional additional identifier

**Examples**:
- `DEV-DEV-Patching-Workstations-Group1` (Development site)
- `TST-DEV-Patching-Workstations-Group1` (Test site)
- `PRD-DEV-Patching-Workstations-Group1` (Production site)
- `CM1-DEV-Patching-Workstations-Group1` (CM1 site)
- `PRD-DEV-SWDeploy-Finance-Laptops`
- `TST-DEV-Maintenance-Servers-Weekend`
- `DEV-DEV-Pilot-Win11-Upgrade`
- `PRD-DEV-Inventory-NewDevices-30Days`

**Purpose Categories**:
- `Patching`: Update deployments
- `SWDeploy`: Software deployments
- `Maintenance`: Maintenance activities
- `Pilot`: Test/pilot deployments
- `Compliance`: Compliance baselines
- `Inventory`: Inventory and reporting
- `Troubleshoot`: Troubleshooting and diagnostics

**Target Categories**:
- `Workstations`: All workstation devices
- `Servers`: All server devices
- `Laptops`: Laptop devices specifically
- `Desktops`: Desktop devices specifically
- `VMs`: Virtual machines
- `[Department]`: Specific departments (Finance, HR, IT, etc.)
- `[Location]`: Specific locations (Building1, RemoteSites, etc.)

### User Collections

**Format**: `[Site]-USR-[Purpose]-[Target]-[Qualifier]`

Where:
- **[Site]**: Site code (DEV, TST, PRD, CM1)
- **USR**: User collection indicator
- **[Purpose]**: Collection purpose
- **[Target]**: Target users
- **[Qualifier]**: Optional additional identifier

**Examples**:
- `PRD-USR-SWDeploy-Finance-All`
- `TST-USR-AppAccess-Adobe-Creative`
- `PRD-USR-Compliance-Executives`
- `DEV-USR-Pilot-Office365-EarlyAdopters`
- `CM1-USR-SWDeploy-Finance-All`

---

## Deployments

### Software Deployments

**Format**: `[Site]-SW-[Target]-[Application]-[Date]`

Where:
- **[Site]**: Site code (DEV, TST, PRD, CM1)
- **SW**: Software deployment indicator
- **[Target]**: Target collection/audience
- **[Application]**: Application name
- **[Date]**: Deployment date (YYYY-MM or YYYY-MM-DD)

**Examples**:
- `PRD-SW-Workstations-AdobeReader-2025-01`
- `TST-SW-Finance-QuickBooks-2025-01`
- `DEV-SW-Pilot-Chrome-122-2025-01`
- `CM1-SW-AllUsers-Office365-2025-01`

### Update Deployments

**Format**: `[Site]-UPD-[Target]-[UpdateType]-[Date]`

Where:
- **[Site]**: Site code (DEV, TST, PRD, CM1)
- **UPD**: Update deployment indicator
- **[Target]**: Target collection
- **[UpdateType]**: Type of updates (Critical, Security, FeatureUpdate, etc.)
- **[Date]**: Deployment date

**Examples**:
- `PRD-UPD-Servers-Critical-2025-01`
- `TST-UPD-Workstations-Security-2025-01-15`
- `DEV-UPD-Pilot-FeatureUpdate-2025-01`
- `PRD-UPD-SQLServers-CumulativeUpdate-2025-01`
- `CM1-UPD-Servers-Critical-2025-01`

### Configuration Deployments

**Format**: `[Site]-CFG-[Target]-[Purpose]-[Date]`

Where:
- **[Site]**: Site code (DEV, TST, PRD, CM1)
- **CFG**: Configuration deployment indicator
- **[Target]**: Target collection
- **[Purpose]**: Configuration purpose
- **[Date]**: Deployment date

**Examples**:
- `PRD-CFG-Workstations-BitLocker-2025-01`
- `TST-CFG-Servers-Firewall-2025-01`
- `PRD-CFG-AllDevices-PasswordPolicy-2025-01`
- `CM1-CFG-Workstations-BitLocker-2025-01`

---

## Applications

### Application Packages

**Format**: `[Vendor]-[Product]-[Version]`

**Note**: Applications typically don't include site codes in their names as they represent the software package itself, which is often shared across sites. However, track site deployment status in documentation.

**Examples**:
- `Adobe-AcrobatReader-DC-23.006`
- `Microsoft-Office-365-ProPlus`
- `Google-Chrome-122.0.6261`
- `7Zip-23.01-x64`
- `VMware-Tools-12.3.5`

**Guidelines**:
- Include architecture (x86/x64) when both versions exist
- Use full version number when tracking versions
- For continuously updated products (Office 365), omit version or use generic identifier
- Maintain consistency with vendor's product naming
- Applications can be promoted across sites without renaming
- Track which sites have the application in documentation

### Application Deployment Types

**Format**: `[Application Name] - [Install Type] - [Architecture]`

**Examples**:
- `Adobe-AcrobatReader-DC-23.006 - MSI - x64`
- `Google-Chrome-122.0.6261 - EXE - x64`
- `CustomApp-InternalTool-1.5 - Script - AnyCPU`

---

## Software Update Groups

### Update Groups

**Format**: `[Site]-SUG-[UpdateType]-[Year]-[Month]-[Target]`

Where:
- **[Site]**: Site code (DEV, TST, PRD, CM1)
- **SUG**: Software Update Group indicator
- **[UpdateType]**: Type of updates (Critical, Security, FeatureUpdate, etc.)
- **[Year]-[Month]**: Time period (YYYY-MM or YYYY-QX)
- **[Target]**: Target audience

**Examples**:
- `PRD-SUG-Critical-2025-01-AllSystems`
- `TST-SUG-Security-2025-01-Workstations`
- `DEV-SUG-FeatureUpdate-2025-Q1-Pilot`
- `PRD-SUG-Office365-2025-01-Production`
- `CM1-SUG-Critical-2025-01-AllSystems`

### Automatic Deployment Rules

**Format**: `[Site]-ADR-[UpdateType]-[Frequency]-[Target]`

Where:
- **[Site]**: Site code (DEV, TST, PRD, CM1)
- **ADR**: Automatic Deployment Rule indicator
- **[UpdateType]**: Type of updates
- **[Frequency]**: Update frequency (Daily, Weekly, Monthly)
- **[Target]**: Target collection

**Examples**:
- `PRD-ADR-Critical-Monthly-Servers`
- `TST-ADR-Security-Monthly-Workstations`
- `PRD-ADR-Definitions-Daily-AllSystems`
- `PRD-ADR-Office365-Monthly-Production`
- `CM1-ADR-Critical-Monthly-Servers`

---

## Task Sequences

### Operating System Deployment

**Format**: `[Site]-TS-Deploy-[OS]-[Version]-[Type]`

Where:
- **[Site]**: Site code (DEV, TST, PRD, CM1)
- **TS**: Task Sequence indicator
- **Deploy**: Deployment action
- **[OS]**: Operating system
- **[Version]**: OS version
- **[Type]**: Type/configuration

**Examples**:
- `PRD-TS-Deploy-Win11-23H2-Workstation`
- `TST-TS-Deploy-Win10-22H2-Laptop`
- `PRD-TS-Deploy-Server2022-Standard`
- `DEV-TS-Deploy-Win11-23H2-UEFI-BitLocker`
- `CM1-TS-Deploy-Win11-23H2-Workstation`

### Operating System Upgrade

**Format**: `[Site]-TS-Upgrade-[FromOS]-to-[ToOS]-[Type]`

**Examples**:
- `PRD-TS-Upgrade-Win10-to-Win11-InPlace`
- `TST-TS-Upgrade-Server2019-to-Server2022`
- `DEV-TS-Upgrade-Win10-to-Win11-InPlace`

### Custom Task Sequences

**Format**: `[Site]-TS-[Purpose]-[Target]-[Description]`

**Examples**:
- `PRD-TS-Config-Workstations-BaselineSetup`
- `PRD-TS-Maint-Servers-MonthlyCleanup`
- `DEV-TS-Troubleshoot-Network-Diagnostics`
- `CM1-TS-Config-Workstations-BaselineSetup`

---

## Configuration Items and Baselines

### Configuration Items

**Format**: `[Site]-CI-[Category]-[Purpose]-[Target]`

Where:
- **[Site]**: Site code (DEV, TST, PRD, CM1)
- **CI**: Configuration Item indicator
- **[Category]**: Category (Security, Compliance, Performance, etc.)
- **[Purpose]**: Specific purpose
- **[Target]**: Target devices

**Examples**:
- `PRD-CI-Security-BitLocker-Workstations`
- `TST-CI-Compliance-PasswordPolicy-AllSystems`
- `PRD-CI-Performance-PowerSettings-Laptops`
- `PRD-CI-Audit-LocalAdmins-Servers`
- `CM1-CI-Security-BitLocker-Workstations`

### Configuration Baselines

**Format**: `[Site]-CB-[Purpose]-[Target]-[Version]`

Where:
- **[Site]**: Site code (DEV, TST, PRD, CM1)
- **CB**: Configuration Baseline indicator
- **[Purpose]**: Baseline purpose
- **[Target]**: Target devices
- **[Version]**: Version number

**Examples**:
- `PRD-CB-SecurityBaseline-Workstations-v1.2`
- `TST-CB-ComplianceCheck-Servers-v2.0`
- `PRD-CB-CIS-Windows11-Benchmark-v1.0`
- `PRD-CB-STIG-Server2022-Latest`
- `CM1-CB-SecurityBaseline-Workstations-v1.2`

---

## Packages and Programs

### Packages (Legacy)

**Format**: `PKG-[Vendor]-[Product]-[Version]`

**Examples**:
- `PKG-Custom-MaintenanceScript-v1.5`
- `PKG-Drivers-Dell-Latitude7420`
- `PKG-Tools-SysInternals-Latest`

**Note**: Prefer Applications over Packages when possible

### Programs

**Format**: `[Action] [Product] - [Qualifier]`

**Examples**:
- `Install Adobe Reader - Silent`
- `Uninstall Chrome - Force`
- `Repair Office - Online`
- `Update Drivers - Dell Latitude`

---

## Distribution Points and Groups

### Distribution Point Groups

**Format**: `DPG-[Location/Purpose]`

**Examples**:
- `DPG-Headquarters`
- `DPG-RemoteSites`
- `DPG-BranchOffices-WestRegion`
- `DPG-BranchOffices-EastRegion`
- `DPG-Critical-Servers`

---

## Query Names

### WQL Queries

**Format**: `Query-[ResourceType]-[Criteria]`

**Examples**:
- `Query-Devices-Win10-Workstations`
- `Query-Devices-LastBoot-Over30Days`
- `Query-Users-Department-Finance`
- `Query-Devices-LowDiskSpace-Under10GB`
- `Query-Devices-MissingUpdates-Critical`

---

## Boundaries and Boundary Groups

### Boundaries

**Format**: `BND-[Type]-[Location]-[Identifier]`

**Examples**:
- `BND-IPSubnet-HQ-192.168.1.0`
- `BND-IPSubnet-Branch1-10.10.1.0`
- `BND-ADSite-HQ-Default-First-Site`

### Boundary Groups

**Format**: `BG-[Location/Purpose]`

**Examples**:
- `BG-Headquarters`
- `BG-Branch-Office-Seattle`
- `BG-Remote-Workers-VPN`
- `BG-Cloud-AzureAD`

---

## Scripts

### PowerShell Scripts

**Format**: `[Verb]-[Noun]-[Purpose].ps1`

**Examples**:
- `Get-ComputerInventory-Extended.ps1`
- `Set-PowerSettings-Laptops.ps1`
- `Remove-TempFiles-Cleanup.ps1`
- `Test-NetworkConnectivity-Diagnostics.ps1`
- `Repair-CCMClient-ResetCache.ps1`

**Use PowerShell approved verbs**: Get, Set, New, Remove, Test, Invoke, Start, Stop, etc.

---

## Folders and Organization

### Console Folders

**Format**: `[Category] - [Subcategory]`

**Examples**:
- `Collections - Patching`
- `Collections - Software Deployment`
- `Collections - Maintenance`
- `Deployments - 2025`
- `Deployments - Archive`
- `Applications - Business Apps`
- `Applications - System Tools`
- `Packages - Drivers`

---

## Reports

### Custom Reports

**Format**: `RPT-[Category]-[Purpose]`

**Examples**:
- `RPT-Compliance-SoftwareUpdates-Summary`
- `RPT-Deployment-ApplicationStatus-ByCollection`
- `RPT-Inventory-HardwareChanges-Last30Days`
- `RPT-Security-LocalAdmins-AllServers`
- `RPT-Audit-UnauthorizedSoftware-Workstations`

---

## Maintenance Windows

### Maintenance Windows

**Format**: `[Site]-MW-[Target]-[Schedule]-[Time]`

Where:
- **[Site]**: Site code (DEV, TST, PRD, CM1)
- **MW**: Maintenance Window indicator
- **[Target]**: Target collection
- **[Schedule]**: Schedule frequency
- **[Time]**: Time description

**Examples**:
- `PRD-MW-Servers-Monthly-SaturdayNight`
- `TST-MW-Workstations-Weekly-Sunday`
- `PRD-MW-Critical-Quarterly-Maintenance`
- `DEV-MW-TestEnvironment-Daily-Overnight`
- `CM1-MW-Servers-Monthly-SundayNight`

---

## CMPivot Queries

### CMPivot Query Naming

**Format**: `CMPivot-[Category]-[Purpose]`

**Note**: CMPivot queries are site-agnostic and work across all sites. No site code needed.

Where:
- **CMPivot**: Query type indicator
- **[Category]**: Query category (Software, Hardware, Security, Performance, etc.)
- **[Purpose]**: What the query does

**Examples**:
- `CMPivot-Software-InstalledApps-SearchByName`
- `CMPivot-Hardware-LowDiskSpace-Under10GB`
- `CMPivot-Security-LocalAdmins-List`
- `CMPivot-Performance-HighCPU-Over80Percent`
- `CMPivot-Network-ActiveConnections`
- `CMPivot-Services-Running-FilterByName`
- `CMPivot-Updates-PendingReboot-Check`

**Common Categories**:
- **Software**: Installed software, versions, updates
- **Hardware**: Disk space, memory, CPU, devices
- **Security**: Admins, firewall, antivirus, patches
- **Performance**: CPU, memory, disk usage
- **Network**: Connections, adapters, configuration
- **Services**: Running services, status
- **Updates**: Update status, pending reboots
- **Inventory**: General system information

---

## Special Considerations

### Site-Agnostic Objects

Some objects are shared across all sites and don't require site codes:
- **Applications**: Represent software packages, shared across sites
- **CMPivot Queries**: Real-time queries that work across all sites
- **Reports**: Can query any site's data
- **Scripts** (optional): Can be shared if environment-agnostic

**Examples**:
- `Adobe-AcrobatReader-DC-23.006` (Application)
- `CMPivot-InstalledSoftware-SearchByName` (CMPivot Query)
- `RPT-Compliance-Updates-Summary` (Report)
- `Get-ComputerInventory-Extended.ps1` (Script)

### Temporary Objects

Use `TEMP-` prefix for temporary objects:
- `TEMP-Collection-Troubleshooting-Issue123`
- `TEMP-Deployment-Hotfix-Emergency`

**Note**: Review and remove TEMP objects regularly

### Date Formats

When including dates in names:
- Use ISO format: `YYYY-MM-DD` or `YYYY-MM`
- Examples: `2025-01-15`, `2025-01`
- For quarters: `2025-Q1`

---

## Naming Convention Quick Reference

| Object Type | Pattern | Example | Site Code? |
|-------------|---------|---------|------------|
| Device Collection | `[Site]-DEV-[Purpose]-[Target]` | `PRD-DEV-Patching-Workstations-Group1` | ✓ Required |
| User Collection | `[Site]-USR-[Purpose]-[Target]` | `PRD-USR-AppAccess-Finance` | ✓ Required |
| Application | `[Vendor]-[Product]-[Version]` | `Adobe-AcrobatReader-DC-23.006` | ✗ No site code |
| Software Deployment | `[Site]-SW-[Target]-[App]-[Date]` | `PRD-SW-Finance-QuickBooks-2025-01` | ✓ Required |
| Update Deployment | `[Site]-UPD-[Target]-[Type]-[Date]` | `PRD-UPD-Servers-Critical-2025-01` | ✓ Required |
| Update Group | `[Site]-SUG-[Type]-[Year]-[Month]` | `PRD-SUG-Security-2025-01-Workstations` | ✓ Required |
| ADR | `[Site]-ADR-[Type]-[Frequency]` | `PRD-ADR-Critical-Monthly-Servers` | ✓ Required |
| Task Sequence | `[Site]-TS-[Action]-[OS]-[Type]` | `PRD-TS-Deploy-Win11-23H2-Workstation` | ✓ Required |
| Config Item | `[Site]-CI-[Category]-[Purpose]` | `PRD-CI-Security-BitLocker-Workstations` | ✓ Required |
| Config Baseline | `[Site]-CB-[Purpose]-[Target]-[Ver]` | `PRD-CB-SecurityBaseline-Workstations-v1.2` | ✓ Required |
| Maintenance Window | `[Site]-MW-[Target]-[Schedule]` | `PRD-MW-Servers-Monthly-SaturdayNight` | ✓ Required |
| CMPivot Query | `CMPivot-[Category]-[Purpose]` | `CMPivot-Software-InstalledApps` | ✗ No site code |
| Script | `[Verb]-[Noun]-[Purpose].ps1` | `Get-ComputerInventory-Extended.ps1` | ✗ No site code |
| Report | `RPT-[Category]-[Purpose]` | `RPT-Compliance-Updates-Summary` | ✗ No site code |

**Site Codes**: DEV (Development), TST (Test), PRD (Production), CM1 (Secondary Production)

---

## Review and Updates

This naming convention document should be reviewed:
- Quarterly for accuracy and relevance
- When new object types are introduced
- When patterns prove ineffective
- Based on team feedback

**Last Updated**: 2025-01-19

**Document Owner**: SCCM Admin Team

---

## Exceptions and Special Cases

Exceptions to these naming conventions must be:
1. Documented with justification
2. Approved by SCCM admin team
3. Tracked in the exceptions log below

### Exception Log

| Object Name | Reason | Approved By | Date |
|-------------|--------|-------------|------|
| [Example] | [Reason] | [Name] | [Date] |
