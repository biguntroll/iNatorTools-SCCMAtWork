# SCCM Best Practices Guide

This document outlines best practices for managing System Center Configuration Manager (SCCM) in our environment.

## Table of Contents
1. [Collection Management](#collection-management)
2. [Deployment Strategy](#deployment-strategy)
3. [Application Management](#application-management)
4. [Software Updates](#software-updates)
5. [Reporting and Monitoring](#reporting-and-monitoring)
6. [Security and Compliance](#security-and-compliance)
7. [Performance Optimization](#performance-optimization)
8. [Documentation Standards](#documentation-standards)

---

## Collection Management

### Collection Design Principles

#### Keep Collections Simple and Purposeful
- Each collection should have a single, clear purpose
- Avoid overly complex query logic that's difficult to troubleshoot
- Document the intent of every collection

#### Limiting Collections
- Always use appropriate limiting collections
- Use "All Systems" or "All Desktop and Server Clients" for broad collections
- Use more specific limiting collections for narrower scopes
- Never use unlimited collections for deployments

#### Collection Hierarchy
```
All Systems
├── All Workstations
│   ├── Workstations - Windows 10
│   ├── Workstations - Windows 11
│   └── Workstations by Department
│       ├── Finance Workstations
│       ├── HR Workstations
│       └── IT Workstations
└── All Servers
    ├── Production Servers
    ├── Test Servers
    └── Servers by Role
        ├── Web Servers
        ├── Database Servers
        └── File Servers
```

### Collection Membership Rules

#### Query Rules
- Prefer query rules over direct membership for dynamic membership
- Test queries before implementing in production collections
- Keep queries efficient to avoid performance impact
- Use appropriate WQL operators (LIKE, IN, =, etc.)

#### Direct Rules
- Use sparingly and only when necessary
- Document why direct membership is required
- Review direct memberships regularly for accuracy

#### Include/Exclude Rules
- Use exclude rules to remove exceptions from larger collections
- Document the reason for exclusions
- Be cautious with include rules as they can create dependencies

### Update Schedules

#### Full Updates
- Schedule during off-peak hours (e.g., 2-4 AM)
- Daily for active/critical collections
- Weekly for less critical collections

#### Incremental Updates
- Enable for collections requiring real-time updates
- Limit to 200 or fewer collections with incremental updates
- Use 5-minute intervals for most scenarios
- Disable for static collections that change infrequently

### Collection Naming Conventions

Follow consistent naming patterns:
- **Device Collections**: `DEV-[Purpose]-[Target]`
- **User Collections**: `USR-[Purpose]-[Target]`
- **Deployment Collections**: `DEPLOY-[Type]-[Target]`
- **Maintenance Collections**: `MAINT-[Purpose]-[Target]`

Examples:
- `DEV-Patching-Workstations-Group1`
- `USR-AppDeploy-Finance`
- `DEPLOY-SW-AdobeReader`
- `MAINT-Reboot-Servers-Weekend`

---

## Deployment Strategy

### Phased Deployment Approach

#### Phase 1: Pilot (1-5% of population)
- Deploy to IT staff or known test devices
- Duration: 24-48 hours
- Monitor closely for issues
- Success threshold: 95%+

#### Phase 2: Limited Production (10-25% of population)
- Deploy to early adopters or less critical systems
- Duration: 2-5 days
- Continue monitoring
- Success threshold: 95%+

#### Phase 3: Broad Production (Remaining population)
- Deploy to all remaining systems
- Staged rollout if large population
- Ongoing monitoring

#### Emergency Rollout
- Reserved for critical security updates
- Requires approval from IT leadership
- Accelerated testing and deployment
- Enhanced monitoring

### Deployment Configuration

#### Required vs Available Deployments

**Use Required when:**
- Security patches and critical updates
- Compliance-mandated software
- Core business applications
- Standardized system configurations

**Use Available when:**
- Optional software
- User-requested applications
- Tools that vary by user need
- Non-critical utilities

#### Deployment Deadlines

**Set reasonable deadlines:**
- Critical security: 24-72 hours
- Important updates: 7 days
- Standard software: 14-30 days
- Optional software: No deadline (Available)

**Consider:**
- Maintenance windows
- Business impact
- User notification time
- Testing period results

### User Experience

#### Notifications
- Always notify users for Required deployments
- Provide clear instructions in Software Center
- Set appropriate reminder intervals
- Allow users to postpone if possible (with limits)

#### Restarts
- Minimize forced restarts during business hours
- Provide adequate warning (at least 2 hours)
- Allow users to postpone restarts
- Schedule automatic restarts outside business hours
- Consider maintenance windows

---

## Application Management

### Application Creation

#### Detection Methods
- Use multiple detection methods when appropriate
- Prefer registry keys or file versions over file existence
- Test detection methods thoroughly
- Document detection logic

**Common detection methods:**
1. Windows Installer Product Code
2. Registry key existence and values
3. File system (file version, file existence)
4. Custom PowerShell script

#### Requirements Rules
- Define minimum OS version
- Specify required disk space
- Check for prerequisites
- Validate system architecture (x86 vs x64)

#### Installation Behavior
- Run installations with system privileges
- Set appropriate installation time limits
- Configure return codes correctly
- Test both installation and uninstallation

### Application Content

#### Source Files
- Maintain clean, organized source folder structure
- Version control source files
- Test source files before distribution
- Keep sources on highly available storage

#### Content Distribution
- Distribute to appropriate DP groups
- Pre-stage content for large applications
- Validate content after distribution
- Monitor distribution status

### Application Supersedence

#### When to Use Supersedence
- Application version upgrades
- Product replacements
- Deprecated software removal

#### Supersedence Configuration
- Test supersedence chain thoroughly
- Choose uninstall previous vs upgrade
- Consider deployment timing
- Document supersedence relationships

---

## Software Updates

### Update Deployment Process

#### Patch Tuesday Schedule
```
Week 1: Microsoft Patch Tuesday
├── Day 1 (Tuesday): Patches released
├── Day 2-3 (Wed-Thu): Review and test in lab
├── Day 4-5 (Fri-Mon): Deploy to pilot
└── Week 2: Deploy to production (phased)

Week 3: Non-Microsoft updates
└── Same phased approach
```

#### Update Groups
Organize updates into logical groups:
- **Critical Security Updates**: High priority, fast deployment
- **Security Updates**: Standard priority, phased deployment
- **Update Rollups**: Test thoroughly, slower deployment
- **Feature Updates**: Extensive testing, controlled rollout
- **Definition Updates**: Automatic, frequent deployment

### Automatic Deployment Rules (ADRs)

#### ADR Best Practices
- Create separate ADRs for different update classifications
- Use consistent naming conventions
- Schedule ADR runs after Microsoft releases (Day 1-2)
- Test ADR results before deploying
- Set appropriate supersedence rules

#### ADR Example Structure
```
ADR-DefinitionUpdates-Daily
ADR-CriticalSecurity-Monthly
ADR-SecurityUpdates-Monthly
ADR-UpdateRollups-Monthly
```

### Update Compliance

#### Monitoring
- Review compliance dashboards daily
- Track deployment success rates
- Identify non-compliant devices
- Address recurring failures

#### Compliance Goals
- Critical Security: 95%+ within 7 days
- Security Updates: 90%+ within 14 days
- Other Updates: 85%+ within 30 days

---

## Reporting and Monitoring

### Key Reports to Monitor

#### Daily Reviews
- Software deployment status
- Failed deployments
- Software update compliance
- Client health status

#### Weekly Reviews
- Collection membership trends
- Application usage statistics
- Distribution point health
- Site system performance

#### Monthly Reviews
- Overall deployment success rates
- Update compliance by collection
- Storage and capacity planning
- License compliance

### Custom Reports

#### Creating Effective Reports
- Identify the business question to answer
- Use clear, descriptive names
- Include filters and parameters
- Test with production data
- Document report purpose and usage

#### Report Categories
1. **Compliance Reports**: Track policy and update compliance
2. **Inventory Reports**: Hardware and software inventory
3. **Deployment Reports**: Application and update deployment status
4. **Asset Management**: License usage and compliance
5. **Troubleshooting Reports**: Error diagnosis and resolution

---

## Security and Compliance

### Security Configuration

#### Role-Based Administration
- Follow principle of least privilege
- Use security roles appropriately
- Regular access reviews
- Document role assignments

#### Content Security
- Sign packages when possible
- Validate content integrity
- Use HTTPS for client communication
- Secure source file locations

### Compliance Settings

#### Configuration Baselines
- Align with organizational security policies
- Test baselines before deployment
- Use remediation carefully
- Monitor compliance regularly

#### Compliance Reporting
- Track baseline compliance
- Investigate non-compliance
- Report to security team
- Document exceptions

---

## Performance Optimization

### Database Maintenance

#### Regular Maintenance Tasks
- Rebuild indexes weekly
- Update statistics daily
- Monitor database size
- Archive old data
- Review SQL Server performance

### Boundary and Boundary Groups

#### Design Guidelines
- Keep boundaries simple and non-overlapping
- Use IP subnet boundaries when possible
- Configure boundary groups with fallback
- Test client location assignment

### Distribution Points

#### DP Configuration
- Enable BranchCache where applicable
- Configure appropriate content validation
- Monitor DP storage capacity
- Distribute content efficiently

#### DP Group Strategy
- Create logical DP groups by location
- Use DP groups for content distribution
- Consider failover and load balancing

### Client Settings

#### Performance Settings
- Adjust inventory schedules appropriately
- Configure hardware inventory to collect necessary data only
- Set reasonable client cache sizes
- Tune client policy polling intervals

---

## Documentation Standards

### Required Documentation

#### For Every Collection
- Purpose and intent
- Query logic explanation
- Update schedule rationale
- Expected member count
- Related collections

#### For Every Deployment
- Target collection and reason
- Deployment configuration justification
- Testing results
- Rollback plan
- Success criteria

#### For Every Application
- Installation and uninstallation commands
- Detection method logic
- Requirements and dependencies
- Known issues
- Support contact

### Change Management

#### Change Control Process
1. **Request**: Document the change request
2. **Plan**: Create detailed implementation plan
3. **Test**: Test in lab/pilot environment
4. **Approve**: Obtain necessary approvals
5. **Implement**: Execute the change
6. **Verify**: Validate success
7. **Document**: Update documentation

#### Change Documentation
- Change request ticket number
- Risk assessment
- Implementation steps
- Rollback procedure
- Post-implementation validation

---

## Common Pitfalls to Avoid

### Collections
- Creating too many collections with incremental updates
- Circular dependencies between collections
- Overly complex query logic
- Not using limiting collections
- Ignoring membership update schedules

### Deployments
- Deploying to "All Systems" without testing
- Not providing user notifications
- Forcing restarts during business hours
- Insufficient testing before production
- No rollback plan

### Applications
- Poor detection methods
- Incorrect return codes
- Missing dependencies
- Inadequate testing
- Poorly documented installation requirements

### Updates
- Skipping pilot testing
- Automatic approval without review
- Ignoring update supersedence
- Not monitoring compliance
- Insufficient maintenance windows

---

## Troubleshooting Quick Reference

### Common Issues and Solutions

#### Client Not Receiving Deployment
1. Verify collection membership
2. Check deployment configuration
3. Review client logs (AppEnforce.log, AppDiscovery.log)
4. Verify distribution point access
5. Check boundary configuration

#### Application Installation Failing
1. Review AppEnforce.log on client
2. Check return code meaning
3. Verify detection method
4. Test installation manually
5. Review requirements and dependencies

#### Collection Not Updating
1. Check update schedule configuration
2. Review colleval.log on site server
3. Verify query syntax
4. Check limiting collection
5. Force collection update manually

---

## Resources and References

### SCCM Log Files
- **Client Logs**: `C:\Windows\CCM\Logs`
- **Server Logs**: `C:\Program Files\Microsoft Configuration Manager\Logs`
- **Key Logs**:
  - CollEval.log: Collection evaluation
  - DistMgr.log: Content distribution
  - AppEnforce.log: Application installation
  - UpdatesDeployment.log: Software updates

### Microsoft Documentation
- [SCCM Documentation](https://docs.microsoft.com/en-us/mem/configmgr/)
- [SCCM Support Center](https://docs.microsoft.com/en-us/mem/configmgr/core/support/support-center)
- [SCCM Community Hub](https://docs.microsoft.com/en-us/mem/configmgr/core/servers/manage/community-hub)

### Community Resources
- Reddit: r/SCCM
- TechNet Forums
- ConfigMgr UserVoice
- SCCM Blogs and MVPs

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-01-19 | Initial | Created initial best practices guide |

---

## Feedback and Updates

This is a living document. If you have suggestions for improvements or additional best practices to include, please:
- Open an issue in this repository
- Submit a pull request with proposed changes
- Contact the SCCM admin team

Last Updated: 2025-01-19
