# iNatorTools-SCCMAtWork

A centralized repository for managing SCCM (System Center Configuration Manager) resources, including collection rules, deployment configurations, applications, scripts, and operational procedures.

## Multi-Site Environment

This repository manages SCCM configurations across **four sites**:

| Site Code | Environment | Purpose |
|-----------|-------------|---------|
| **DEV** | Development | Testing and development of SCCM configurations |
| **TST** | Test/UAT | Pre-production validation and user acceptance testing |
| **PRD** | Production | Primary production environment |
| **CM1** | Production | Secondary production site |

**Promotion Workflow**: DEV → TST → PRD/CM1

See [Multi-Site Management Guide](Documentation/multi-site-management.md) for detailed information about managing configurations across sites.

## Repository Structure

```
iNatorTools-SCCMAtWork/
├── Collections/              # Collection queries and rules
│   ├── Device-Collections/   # Device-based collection queries
│   └── User-Collections/     # User-based collection queries
├── Deployments/              # Deployment configurations
│   ├── Software/             # Software deployment configs
│   ├── Updates/              # Update deployment configs
│   └── Configurations/       # Configuration deployment configs
├── Applications/             # Application packages and configs
│   ├── Business-Apps/        # Business application configs
│   └── System-Tools/         # System tools and utilities
├── Scripts/                  # PowerShell and other scripts
├── TaskSequences/            # Task sequence exports and docs
├── Configuration-Items/      # Configuration items and baselines
├── Reports/                  # Custom SCCM reports and queries
├── CMPivot/                  # CMPivot queries (site-agnostic)
├── Templates/                # Templates for common SCCM tasks
└── Documentation/            # Guidelines and procedures
```

## Getting Started

### Prerequisites

- Access to SCCM Console
- Appropriate administrative permissions
- PowerShell 5.1 or higher (for scripts)
- SCCM PowerShell module installed

### Using This Repository

1. **Collections**: Browse device and user collection queries organized by purpose
2. **Deployments**: Review deployment configurations before implementing
3. **Applications**: Reference application package configurations
4. **Scripts**: Utilize tested PowerShell scripts for automation
5. **Templates**: Use templates to standardize your SCCM configurations

## Quick Links

- [Multi-Site Management Guide](Documentation/multi-site-management.md) - Managing configurations across DEV, TST, PRD, CM1
- [Naming Conventions](Documentation/naming-conventions.md) - Site-aware naming standards
- [Collection Rules Template](Templates/collection-template.md)
- [Deployment Template](Templates/deployment-template.md)
- [Best Practices Guide](Documentation/best-practices.md)

## Contributing

When adding new resources to this repository:

1. Use the appropriate template from the `Templates/` folder
2. Follow the naming conventions documented in `Documentation/naming-conventions.md`
3. Include comments and documentation for complex queries or configurations
4. Test configurations in a lab/test environment before committing
5. Update this README if adding new categories or major changes

## Naming Conventions

**All SCCM objects must include the site code** to identify which site they belong to.

**Site Codes**: DEV (Development), TST (Test), PRD (Production), CM1 (Secondary Production)

### Collections
- **Device Collections**: `[Site]-DEV-[Purpose]-[Target]`
- **User Collections**: `[Site]-USR-[Purpose]-[Target]`

Example: `PRD-DEV-Patching-Workstations`, `TST-USR-SoftwareDeploy-Accounting`

### Applications
- **Format**: `[Vendor]-[Product]-[Version]` (no site code - shared across sites)

Example: `Adobe-AcrobatReader-DC-23.006`, `Microsoft-Office-365-ProPlus`

### Deployments
- **Format**: `[Site]-[Type]-[Target]-[Purpose]-[Date]`

Example: `PRD-SW-Workstations-AdobeReader-2025-01`, `TST-UPD-Servers-CriticalPatch-2025-01`

### CMPivot Queries
- **Format**: `CMPivot-[Category]-[Purpose]` (no site code - work across all sites)

Example: `CMPivot-Software-InstalledApps`, `CMPivot-Hardware-LowDiskSpace`

See [Naming Conventions](Documentation/naming-conventions.md) for complete guidelines.

## Security Notes

- Never commit credentials or sensitive information
- Review configurations before applying to production
- Always test in a lab environment first
- Document any security-related changes

## Support

For issues or questions:
- Open an issue in this repository
- Review the `Documentation/` folder for guidelines
- Contact the SCCM team

## License

Internal use only - Property of [Your Organization]

## Changelog

### 2025-01-19
- Initial repository structure created
- Added templates for collections and deployments
- Created documentation for best practices
- Configured for multi-site environment (DEV, TST, PRD, CM1)
- Updated naming conventions to include site codes
- Added multi-site management guide
- Added promotion workflow documentation
- Created CMPivot queries folder
