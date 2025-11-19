# SCCM Collections

This folder contains documentation for device and user collection queries used in SCCM.

## Organization

- **Device-Collections/**: Device-based collection queries
- **User-Collections/**: User-based collection queries

## Using Collections

Each collection should be documented using the [Collection Template](../Templates/collection-template.md).

## Categories

### Device Collections

Device collections are organized by purpose:

- **Patching Collections**: Used for software update deployments
- **Software Deployment Collections**: Used for application deployments
- **Maintenance Collections**: Used for maintenance tasks and scripts
- **Inventory Collections**: Used for reporting and inventory
- **Pilot Collections**: Used for testing deployments
- **Compliance Collections**: Used for configuration baselines

### User Collections

User collections are organized by purpose:

- **Application Access**: User-based application deployments
- **Policy Deployment**: User-specific policies
- **Reporting**: User-based reporting collections

## Best Practices

1. **Always Use a Limiting Collection**: Never use unlimited collections for deployments
2. **Test Queries First**: Use "Preview Results" in SCCM console before creating the collection
3. **Document Thoroughly**: Use the template to document purpose, query logic, and dependencies
4. **Use Appropriate Update Schedules**:
   - Incremental updates for dynamic collections (limit to 200 total)
   - Full updates during off-peak hours
5. **Follow Naming Conventions**: See [Naming Conventions](../Documentation/naming-conventions.md)

## Creating a New Collection

1. Copy the [Collection Template](../Templates/collection-template.md)
2. Fill in all required fields
3. Test the query in SCCM console
4. Create the collection in SCCM
5. Save the documentation in the appropriate subfolder
6. Name the file using the collection name (e.g., `DEV-Patching-Workstations-Group1.md`)

## Quick Query Examples

See the [Collection Template](../Templates/collection-template.md) for common query patterns including:
- Operating System filtering
- Organizational Unit filtering
- Computer name patterns
- IP Subnet filtering
- Installed software detection
- Hardware characteristics (laptops, desktops)
- Client activity and health
