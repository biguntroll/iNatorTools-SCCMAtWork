# iNatorTools-SCCMAtWork

A centralized repository for managing SCCM (System Center Configuration Manager) resources, including collection rules, deployment configurations, applications, scripts, and operational procedures.

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

- [Collection Rules Template](Templates/collection-template.md)
- [Deployment Template](Templates/deployment-template.md)
- [Best Practices Guide](Documentation/best-practices.md)
- [Naming Conventions](Documentation/naming-conventions.md)

## Contributing

When adding new resources to this repository:

1. Use the appropriate template from the `Templates/` folder
2. Follow the naming conventions documented in `Documentation/naming-conventions.md`
3. Include comments and documentation for complex queries or configurations
4. Test configurations in a lab/test environment before committing
5. Update this README if adding new categories or major changes

## Naming Conventions

### Collections
- **Device Collections**: `DEV-[Purpose]-[Target]`
- **User Collections**: `USR-[Purpose]-[Target]`

Example: `DEV-Patching-Workstations`, `USR-SoftwareDeploy-Accounting`

### Applications
- **Format**: `[Vendor]-[Product]-[Version]`

Example: `Adobe-AcrobatReader-DC`, `Microsoft-Office-365`

### Deployments
- **Format**: `[Type]-[Target]-[Purpose]-[Date]`

Example: `SW-Workstations-AdobeReader-2025-01`, `UPD-Servers-CriticalPatch-2025-01`

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
