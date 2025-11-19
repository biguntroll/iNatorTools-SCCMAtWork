# SCCM Naming Conventions

This document defines the naming conventions for all SCCM objects in our environment. Consistent naming ensures clarity, simplifies management, and makes it easier to locate resources.

## General Principles

1. **Be Descriptive**: Names should clearly indicate purpose and scope
2. **Be Consistent**: Follow the same pattern for similar objects
3. **Be Concise**: Keep names reasonably short while remaining descriptive
4. **Use Standard Abbreviations**: Use approved abbreviations consistently
5. **Avoid Special Characters**: Use only letters, numbers, and hyphens

## Standard Abbreviations

| Abbreviation | Meaning |
|--------------|---------|
| DEV | Device |
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

---

## Collections

### Device Collections

**Format**: `DEV-[Purpose]-[Target]-[Qualifier]`

**Examples**:
- `DEV-Patching-Workstations-Group1`
- `DEV-Patching-Workstations-Group2`
- `DEV-SWDeploy-Finance-Laptops`
- `DEV-Maintenance-Servers-Weekend`
- `DEV-Pilot-Win11-Upgrade`
- `DEV-Inventory-NewDevices-30Days`

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

**Format**: `USR-[Purpose]-[Target]-[Qualifier]`

**Examples**:
- `USR-SWDeploy-Finance-All`
- `USR-AppAccess-Adobe-Creative`
- `USR-Compliance-Executives`
- `USR-Pilot-Office365-EarlyAdopters`

---

## Deployments

### Software Deployments

**Format**: `SW-[Target]-[Application]-[Date]`

**Examples**:
- `SW-Workstations-AdobeReader-2025-01`
- `SW-Finance-QuickBooks-2025-01`
- `SW-Pilot-Chrome-122-2025-01`
- `SW-AllUsers-Office365-2025-01`

### Update Deployments

**Format**: `UPD-[Target]-[UpdateType]-[Date]`

**Examples**:
- `UPD-Servers-Critical-2025-01`
- `UPD-Workstations-Security-2025-01-15`
- `UPD-Pilot-FeatureUpdate-2025-01`
- `UPD-SQLServers-CumulativeUpdate-2025-01`

### Configuration Deployments

**Format**: `CFG-[Target]-[Purpose]-[Date]`

**Examples**:
- `CFG-Workstations-BitLocker-2025-01`
- `CFG-Servers-Firewall-2025-01`
- `CFG-AllDevices-PasswordPolicy-2025-01`

---

## Applications

### Application Packages

**Format**: `[Vendor]-[Product]-[Version]`

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

### Application Deployment Types

**Format**: `[Application Name] - [Install Type] - [Architecture]`

**Examples**:
- `Adobe-AcrobatReader-DC-23.006 - MSI - x64`
- `Google-Chrome-122.0.6261 - EXE - x64`
- `CustomApp-InternalTool-1.5 - Script - AnyCPU`

---

## Software Update Groups

### Update Groups

**Format**: `SUG-[UpdateType]-[Year]-[Month]-[Target]`

**Examples**:
- `SUG-Critical-2025-01-AllSystems`
- `SUG-Security-2025-01-Workstations`
- `SUG-FeatureUpdate-2025-Q1-Pilot`
- `SUG-Office365-2025-01-Production`

### Automatic Deployment Rules

**Format**: `ADR-[UpdateType]-[Frequency]-[Target]`

**Examples**:
- `ADR-Critical-Monthly-Servers`
- `ADR-Security-Monthly-Workstations`
- `ADR-Definitions-Daily-AllSystems`
- `ADR-Office365-Monthly-Production`

---

## Task Sequences

### Operating System Deployment

**Format**: `TS-Deploy-[OS]-[Version]-[Type]`

**Examples**:
- `TS-Deploy-Win11-23H2-Workstation`
- `TS-Deploy-Win10-22H2-Laptop`
- `TS-Deploy-Server2022-Standard`
- `TS-Deploy-Win11-23H2-UEFI-BitLocker`

### Operating System Upgrade

**Format**: `TS-Upgrade-[FromOS]-to-[ToOS]-[Type]`

**Examples**:
- `TS-Upgrade-Win10-to-Win11-InPlace`
- `TS-Upgrade-Server2019-to-Server2022`

### Custom Task Sequences

**Format**: `TS-[Purpose]-[Target]-[Description]`

**Examples**:
- `TS-Config-Workstations-BaselineSetup`
- `TS-Maint-Servers-MonthlyCleanup`
- `TS-Troubleshoot-Network-Diagnostics`

---

## Configuration Items and Baselines

### Configuration Items

**Format**: `CI-[Category]-[Purpose]-[Target]`

**Examples**:
- `CI-Security-BitLocker-Workstations`
- `CI-Compliance-PasswordPolicy-AllSystems`
- `CI-Performance-PowerSettings-Laptops`
- `CI-Audit-LocalAdmins-Servers`

### Configuration Baselines

**Format**: `CB-[Purpose]-[Target]-[Version]`

**Examples**:
- `CB-SecurityBaseline-Workstations-v1.2`
- `CB-ComplianceCheck-Servers-v2.0`
- `CB-CIS-Windows11-Benchmark-v1.0`
- `CB-STIG-Server2022-Latest`

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

**Format**: `MW-[Target]-[Schedule]-[Time]`

**Examples**:
- `MW-Servers-Monthly-SaturdayNight`
- `MW-Workstations-Weekly-Sunday`
- `MW-Critical-Quarterly-Maintenance`
- `MW-TestEnvironment-Daily-Overnight`

---

## Special Considerations

### Production vs Test/Pilot

Add identifiers for non-production objects:
- `PILOT-` prefix for pilot collections and deployments
- `TEST-` prefix for test environments
- `DEV-` prefix for development (don't confuse with "Device")

**Examples**:
- `PILOT-SW-Workstations-Chrome-122`
- `TEST-UPD-Servers-January2025`
- `PILOT-DEV-Patching-IT-Department`

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

| Object Type | Pattern | Example |
|-------------|---------|---------|
| Device Collection | `DEV-[Purpose]-[Target]` | `DEV-Patching-Workstations-Group1` |
| User Collection | `USR-[Purpose]-[Target]` | `USR-AppAccess-Finance` |
| Application | `[Vendor]-[Product]-[Version]` | `Adobe-AcrobatReader-DC-23.006` |
| Software Deployment | `SW-[Target]-[App]-[Date]` | `SW-Finance-QuickBooks-2025-01` |
| Update Deployment | `UPD-[Target]-[Type]-[Date]` | `UPD-Servers-Critical-2025-01` |
| Update Group | `SUG-[Type]-[Year]-[Month]` | `SUG-Security-2025-01-Workstations` |
| ADR | `ADR-[Type]-[Frequency]` | `ADR-Critical-Monthly-Servers` |
| Task Sequence | `TS-[Action]-[OS]-[Type]` | `TS-Deploy-Win11-23H2-Workstation` |
| Config Item | `CI-[Category]-[Purpose]` | `CI-Security-BitLocker-Workstations` |
| Config Baseline | `CB-[Purpose]-[Target]-[Ver]` | `CB-SecurityBaseline-Workstations-v1.2` |
| Script | `[Verb]-[Noun]-[Purpose].ps1` | `Get-ComputerInventory-Extended.ps1` |
| Report | `RPT-[Category]-[Purpose]` | `RPT-Compliance-Updates-Summary` |
| Maintenance Window | `MW-[Target]-[Schedule]` | `MW-Servers-Monthly-SaturdayNight` |

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
