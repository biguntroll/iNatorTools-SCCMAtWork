# Multi-Site SCCM Management

This document describes how to manage SCCM configurations across multiple sites in our environment.

## Our SCCM Environment

### Site Overview

| Site Code | Environment | Purpose | Promotion Path |
|-----------|-------------|---------|----------------|
| **DEV** | Development | Testing and development of SCCM configurations | First stop - all changes start here |
| **TST** | Test | Pre-production validation and user acceptance testing | Second stop - promoted from DEV |
| **PRD** | Production | Primary production environment | Third stop - promoted from TST |
| **CM1** | Production | Secondary production site (independent) | Parallel production site |

### Site Relationships

```
DEV (Development)
 ↓ Promote & Validate
TST (Test/UAT)
 ↓ Promote & Validate
PRD (Production)

CM1 (Production - Independent)
```

**Key Points**:
- **DEV → TST → PRD**: Sequential promotion workflow
- **CM1**: Independent production site, managed separately or promoted directly
- All sites are **standalone primary sites** (no CAS hierarchy)

---

## Site Identification in Repository

### Site Tags in Names

All SCCM objects should include the site code to clearly identify where they belong:

**Format**: `[Object-Type]-[Site]-[Purpose]-[Target]`

**Examples**:
- `DEV-DEV-Patching-Workstations-Group1` (Device collection in DEV)
- `SW-TST-AdobeReader-Workstations-2025-01` (Software deployment in TST)
- `SUG-PRD-Critical-2025-01-AllSystems` (Update group in PRD)
- `CB-CM1-SecurityBaseline-v1.2` (Config baseline in CM1)

### Documentation Site Tags

In documentation files, use frontmatter or headers to indicate applicable sites:

```markdown
# Collection: Patching Workstations Group 1

**Sites**: DEV, TST, PRD, CM1
**Status by Site**:
- DEV: Active, tested
- TST: Active, validated
- PRD: Active, in production
- CM1: Planned

**Last Updated**: 2025-01-19
```

---

## Promotion Workflow

### Standard Promotion Path: DEV → TST → PRD

#### Phase 1: Development (DEV)

**Purpose**: Create and test new configurations

**Activities**:
1. Create new collections, applications, or deployments
2. Test queries and configurations
3. Validate with small test groups
4. Document thoroughly using templates
5. Peer review before promotion

**Success Criteria**:
- Configuration works as intended
- No errors in logs
- Documentation complete
- Peer reviewed and approved

#### Phase 2: Testing (TST)

**Purpose**: Pre-production validation

**Activities**:
1. Promote configuration from DEV
2. Apply to broader test population
3. Conduct user acceptance testing (UAT)
4. Validate with actual business users
5. Monitor for 3-7 days
6. Update documentation with findings

**Success Criteria**:
- UAT passed
- No critical issues
- User feedback positive
- Performance acceptable
- Documentation updated

#### Phase 3: Production (PRD)

**Purpose**: Production deployment

**Activities**:
1. Promote validated configuration from TST
2. Use phased rollout approach
3. Monitor closely during initial deployment
4. Document lessons learned
5. Mark as production-ready

**Success Criteria**:
- Deployment successful
- Success rate >95%
- No major incidents
- Support tickets minimal

### CM1 Promotion Strategy

**Option 1: Direct from TST**
- Promote from TST to both PRD and CM1 simultaneously
- Use when CM1 environment is identical to PRD

**Option 2: After PRD Validation**
- Promote to PRD first, validate for 1-2 weeks
- Then promote to CM1 with any lessons learned applied
- Use when CM1 has different characteristics or is more critical

**Option 3: Independent Development**
- Create CM1-specific configurations as needed
- Use when CM1 has unique requirements

---

## Promotion Process

### Pre-Promotion Checklist

- [ ] Configuration tested in current environment
- [ ] Documentation complete and accurate
- [ ] Change request ticket created (if required)
- [ ] Peer review completed
- [ ] Success criteria met
- [ ] Rollback plan documented
- [ ] Target environment prepared
- [ ] Maintenance window scheduled (if needed)

### Promotion Steps

#### 1. Export from Source Site

**Collections**:
```powershell
# Export collection to MOF file
$SiteCode = "DEV"
Set-Location "$($SiteCode):"

$CollectionName = "DEV-DEV-Patching-Workstations-Group1"
$ExportPath = "E:\SCCM-Exports\Collections"

$Collection = Get-CMDeviceCollection -Name $CollectionName
Export-CMCollection -InputObject $Collection -ExportFilePath "$ExportPath\$CollectionName.mof"
```

**Applications**:
```powershell
# Export application
$ApplicationName = "Adobe-AcrobatReader-DC-23.006"
$ExportPath = "E:\SCCM-Exports\Applications"

Export-CMApplication -Name $ApplicationName -Path "$ExportPath\$ApplicationName.zip"
```

#### 2. Update for Target Site

- Change site code references
- Update collection names (DEV → TST → PRD)
- Adjust distribution point groups for target site
- Update any site-specific paths or references
- Review and adjust schedules if needed

#### 3. Import to Target Site

**Collections**:
```powershell
# Import collection
$SiteCode = "TST"
Set-Location "$($SiteCode):"

$ImportPath = "E:\SCCM-Exports\Collections"
$CollectionFile = "DEV-DEV-Patching-Workstations-Group1.mof"

Import-CMCollection -ImportFilePath "$ImportPath\$CollectionFile"

# Rename for target site
$OldName = "DEV-DEV-Patching-Workstations-Group1"
$NewName = "DEV-TST-Patching-Workstations-Group1"
Set-CMDeviceCollection -Name $OldName -NewName $NewName
```

**Applications**:
```powershell
# Import application
$ImportPath = "E:\SCCM-Exports\Applications"
$ApplicationFile = "Adobe-AcrobatReader-DC-23.006.zip"

Import-CMApplication -FilePath "$ImportPath\$ApplicationFile"

# Update content source paths for target site
# Update distribution point groups
```

#### 4. Validate in Target Site

- [ ] Object imported successfully
- [ ] Properties correct for target site
- [ ] Content distributed (applications/packages)
- [ ] Collection membership accurate
- [ ] Dependencies resolved
- [ ] Test deployment to pilot group

#### 5. Document Promotion

Update documentation with promotion details:

```markdown
## Promotion History

| Date | From | To | Promoted By | Ticket | Notes |
|------|------|-------|-------------|--------|-------|
| 2025-01-19 | DEV | TST | John Doe | CHG0012345 | Initial promotion |
| 2025-01-26 | TST | PRD | Jane Smith | CHG0012567 | Validated in TST for 7 days |
| 2025-01-26 | TST | CM1 | Jane Smith | CHG0012568 | Parallel to PRD |
```

---

## Site-Specific Considerations

### Development (DEV)

**Purpose**: Rapid iteration and testing

**Characteristics**:
- Smaller device population
- More frequent changes
- Shorter testing cycles
- Less strict change control

**Best Practices**:
- Test thoroughly even though it's dev
- Document everything for promotion
- Use consistent naming from the start
- Clean up failed experiments regularly

### Test (TST)

**Purpose**: Pre-production validation

**Characteristics**:
- Production-like environment
- Broader user base
- Formal UAT process
- Change control required

**Best Practices**:
- Mirror production environment as closely as possible
- Include diverse device types in test collections
- Conduct thorough UAT before promoting
- Monitor for longer period (3-7 days)

### Production (PRD)

**Purpose**: Primary production environment

**Characteristics**:
- Live production users
- Strict change control
- Maintenance windows enforced
- High availability requirements

**Best Practices**:
- Always use phased deployments
- Schedule during maintenance windows
- Have rollback plan ready
- Monitor continuously during rollout
- Maintain high documentation standards

### CM1 (Production)

**Purpose**: Secondary production site

**Considerations**:
- Determine if CM1 should mirror PRD exactly or has unique needs
- Coordinate deployments with PRD when appropriate
- May have different maintenance windows
- Could serve different user populations or locations

**Best Practices**:
- Document differences from PRD
- Consider whether to promote simultaneously with PRD or after
- Maintain consistent configurations when possible
- Track any CM1-specific customizations

---

## Cross-Site Configuration Management

### Shared Configurations

Some configurations should be **identical across all sites**:

- Security baselines
- Compliance policies
- Standard application packages
- Core operating system images
- Client settings (mostly)
- Boundary configurations (site-specific boundaries but consistent approach)

**Management Approach**:
- Develop once in DEV
- Promote through TST → PRD → CM1
- Use version control in this repository
- Document any site-specific variations

### Site-Specific Configurations

Some configurations are **unique to each site**:

- Distribution point groups
- Maintenance windows
- Collection update schedules
- Site system roles
- Boundary definitions
- Site-specific applications

**Management Approach**:
- Document clearly as site-specific
- Don't promote to other sites
- Use site code prefix in names
- Maintain separate documentation files if needed

---

## Version Control Strategy

### Branching Strategy

**Option 1: Single Branch with Site Tags** (Recommended for your workflow)
- All sites in `main` branch
- Use site tags in filenames and documentation
- Promotion is export/import with documentation update

**Option 2: Branch per Site**
- `main` branch for shared resources
- `dev`, `tst`, `prd`, `cm1` branches for site-specific
- Merge from `dev` → `tst` → `prd`/`cm1` to represent promotions

**Recommendation**: Option 1 (site tags) works best for your shared structure preference

### Commit Messages for Promotions

```bash
git commit -m "Promote: Collection Patching-Workstations-Group1 from TST to PRD

- Validated in TST for 7 days
- No issues encountered
- Success rate: 98%
- Change ticket: CHG0012567

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Site Configuration Reference

### Site Details

Create a reference document with key details for each site:

| Detail | DEV | TST | PRD | CM1 |
|--------|-----|-----|-----|-----|
| **Site Code** | DEV | TST | PRD | CM1 |
| **Site Server** | sccm-dev.domain.com | sccm-tst.domain.com | sccm-prd.domain.com | sccm-cm1.domain.com |
| **SQL Server** | sql-dev.domain.com | sql-tst.domain.com | sql-prd.domain.com | sql-cm1.domain.com |
| **Database Name** | CM_DEV | CM_TST | CM_PRD | CM_CM1 |
| **Approx. Clients** | [#] | [#] | [#] | [#] |
| **Primary DP** | [server] | [server] | [server] | [server] |
| **DP Groups** | DPG-Dev | DPG-Tst | DPG-Prd | DPG-CM1 |
| **Maintenance Window** | Flexible | Tue 10PM-2AM | Sat 10PM-6AM | Sun 10PM-6AM |
| **Change Control** | Informal | Required | Required | Required |
| **Approval Process** | Team Lead | Change Board | Change Board | Change Board |

---

## Troubleshooting Multi-Site Issues

### Common Issues

#### Configuration Works in DEV but Fails in TST/PRD

**Possible Causes**:
- Hard-coded DEV-specific paths
- Different distribution point groups
- Network/firewall differences
- Client version differences
- Different security contexts

**Resolution**:
- Review all paths and update for target site
- Check distribution point groups
- Validate network connectivity from target site clients
- Ensure client versions are compatible
- Test with same permissions as target environment

#### Collection Membership Different Across Sites

**Possible Causes**:
- Different device populations
- Site-specific OUs or naming conventions
- Timing of updates
- Query logic assumptions

**Resolution**:
- Review query logic for site-specific assumptions
- Validate limiting collections exist in target
- Check for hard-coded values that should be dynamic
- Test query results before deploying

#### Application Deployments Failing After Promotion

**Possible Causes**:
- Content not distributed to target DPs
- Detection methods not working in target environment
- Requirements not met (OS version, prerequisites)
- Installation source paths incorrect

**Resolution**:
- Verify content distribution complete
- Test detection method manually on target site client
- Check requirements against target site clients
- Update source paths for target site DPs

---

## Best Practices Summary

### For Developers/Administrators

1. **Always start in DEV** - Never create directly in production
2. **Document immediately** - Don't wait until promotion time
3. **Use site tags** - Make it clear which site an object belongs to
4. **Test thoroughly** - Each environment has a purpose
5. **Follow the workflow** - Don't skip TST even if "it's just a small change"
6. **Plan for promotion** - Design with all sites in mind
7. **Validate after promotion** - Don't assume it worked
8. **Update documentation** - Record the promotion and any issues

### For Change Management

1. **Require separate change tickets** for each site (TST, PRD, CM1)
2. **Enforce waiting periods** between promotions (e.g., 7 days in TST before PRD)
3. **Track promotion success** metrics
4. **Require rollback plans** for production promotions
5. **Schedule maintenance windows** appropriately

---

## Tools and Automation

### Promotion Helper Script Template

```powershell
<#
.SYNOPSIS
    Promotes SCCM configuration from one site to another

.DESCRIPTION
    Exports configuration from source site, updates for target site, and imports

.PARAMETER SourceSite
    Source SCCM site code (DEV, TST, PRD, CM1)

.PARAMETER TargetSite
    Target SCCM site code (DEV, TST, PRD, CM1)

.PARAMETER ObjectType
    Type of object to promote (Collection, Application, TaskSequence, etc.)

.PARAMETER ObjectName
    Name of the object to promote

.EXAMPLE
    .\Promote-SCCMConfig.ps1 -SourceSite DEV -TargetSite TST -ObjectType Collection -ObjectName "DEV-DEV-Patching-Workstations"
#>

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("DEV","TST","PRD","CM1")]
    [string]$SourceSite,

    [Parameter(Mandatory=$true)]
    [ValidateSet("DEV","TST","PRD","CM1")]
    [string]$TargetSite,

    [Parameter(Mandatory=$true)]
    [ValidateSet("Collection","Application","Package","TaskSequence")]
    [string]$ObjectType,

    [Parameter(Mandatory=$true)]
    [string]$ObjectName
)

# Validation: Ensure valid promotion path
$ValidPromotions = @(
    @{From="DEV"; To="TST"},
    @{From="TST"; To="PRD"},
    @{From="TST"; To="CM1"},
    @{From="PRD"; To="CM1"}
)

$IsValidPath = $ValidPromotions | Where-Object {$_.From -eq $SourceSite -and $_.To -eq $TargetSite}
if (-not $IsValidPath) {
    Write-Error "Invalid promotion path: $SourceSite -> $TargetSite"
    Write-Host "Valid promotion paths:"
    $ValidPromotions | ForEach-Object {"  $($_.From) -> $($_.To)"}
    exit 1
}

# Export location
$ExportPath = "E:\SCCM-Exports\$ObjectType"
if (-not (Test-Path $ExportPath)) {
    New-Item -Path $ExportPath -ItemType Directory -Force
}

# TODO: Implement export/import logic based on ObjectType
# TODO: Update object name with new site code
# TODO: Validate import
# TODO: Update documentation

Write-Host "Promotion initiated: $SourceSite -> $TargetSite" -ForegroundColor Green
Write-Host "Object: $ObjectName ($ObjectType)" -ForegroundColor Green
```

---

## Related Documentation

- [Naming Conventions](naming-conventions.md) - Includes site tagging standards
- [Best Practices](best-practices.md) - General SCCM best practices
- [Collection Template](../Templates/collection-template.md) - Includes site tracking
- [Deployment Template](../Templates/deployment-template.md) - Includes site tracking

---

**Last Updated**: 2025-01-19
**Document Owner**: SCCM Admin Team
