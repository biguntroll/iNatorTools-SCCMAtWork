# SCCM Deployment Template

Use this template when documenting deployments for software, updates, or configurations.

## Deployment Information

### Basic Details
- **Deployment Name**: [e.g., SW-Workstations-AdobeReader-2025-01]
- **Deployment Type**: [Software | Software Update | Configuration Baseline | Task Sequence | Script]
- **Package/Application**: [Name and version]
- **Purpose**: [Brief description of deployment goal]
- **Created By**: [Name]
- **Created Date**: [YYYY-MM-DD]
- **Deployment Status**: [Planned | Testing | Active | Completed | Suspended]

### Target Details
- **Target Collection**: [Collection name]
- **Expected Device Count**: [Approximate number]
- **Target Environment**: [Production | Test | Lab]

## Deployment Settings

### Deployment Configuration
- **Purpose**: [Available | Required]
- **Action**: [Install | Uninstall]
- **Deployment Availability**:
  - **Available Time**: [Date/Time or "As soon as possible"]
  - **Installation Deadline**: [Date/Time or "As soon as possible" or "None"]

### User Experience
- **User Notifications**: [Display in Software Center | Display all notifications | Hide all notifications]
- **Allow Users to Run Independently**: [Yes | No]
- **Software Installation**: [Yes | No - outside maintenance window]
- **System Restart**: [If required | Only if restart is required | Suppress]
- **Write Filter Handling**: [Commit at deadline | Commit during maintenance window | N/A]
- **Internet-based Clients**: [Allow | Do not allow]

### Deployment Options
- **Deadline Behavior**:
  - **Application/Software**: [Install | Required reboot]
  - **Allow Installation Outside Maintenance Window**: [Yes | No]
  - **If Deadline is Reached, Allow System Restart Outside Maintenance Window**: [Yes | No]

- **Download Behavior**:
  - **Deployment Options**: [Download and install | Download for installation | Do not download]
  - **When no distribution point available**: [Download from fallback source | Do not install]
  - **Allow clients on metered connection**: [Yes | No]

### Scheduling
- **Phased Deployment**: [Yes | No]
  - **Phase 1**: [Collection/Percentage] - [Start Date] - [Success Threshold]
  - **Phase 2**: [Collection/Percentage] - [Start Date] - [Success Threshold]
  - [Add more phases as needed]

- **Maintenance Windows**:
  - **Applied**: [Yes | No]
  - **Window Name**: [If applicable]
  - **Duration**: [Time range]

### Alerts
- **Generate Alert When Threshold Exceeded**: [Yes | No]
  - **Success Rate Below**: [e.g., 95%]
  - **Alert Time**: [After X days]

- **System Center Operations Manager Alert**: [Yes | No]

## Content Distribution

### Distribution Points
- **Distribution Point Groups**: [List DP groups]
- **Specific DPs**: [List individual DPs if applicable]
- **Pre-stage Content**: [Yes | No]

### Content Validation
- **Content Size**: [Size in MB/GB]
- **Content Hash**: [If applicable]
- **Source Files Location**: [UNC path]
- **Content Validated**: [Yes | No] - [Date]

## Requirements and Dependencies

### System Requirements
- **Operating System**: [Supported OS versions]
- **Disk Space**: [Required free space]
- **RAM**: [Minimum RAM]
- **CPU**: [Requirements if any]
- **Other**: [Any other requirements]

### Dependencies
- **Required Software**: [List prerequisite software]
- **Conflicting Software**: [Software that must be removed]
- **Detection Method**: [How installation is detected]

### Supersedence
- **Supersedes**: [Previous versions or applications]
- **Superseded By**: [Newer versions if applicable]

## Testing and Validation

### Pre-Deployment Testing
- [ ] Tested in lab environment
- [ ] Tested on pilot collection
- [ ] Installation verified successful
- [ ] Uninstallation verified (if applicable)
- [ ] Detection method validated
- [ ] User experience reviewed
- [ ] Performance impact assessed
- [ ] Rollback procedure tested

### Test Results
| Test Device | OS Version | Result | Issues | Date | Tester |
|-------------|------------|--------|--------|------|--------|
| [Name] | [OS] | [Pass/Fail] | [Notes] | [Date] | [Name] |

### Success Criteria
- **Installation Success Rate**: [Target percentage, e.g., >95%]
- **User Impact**: [Acceptable impact level]
- **Support Tickets**: [Acceptable ticket volume]

## Monitoring and Reporting

### Key Metrics to Monitor
- [ ] Installation success rate
- [ ] Failure error codes
- [ ] User complaint volume
- [ ] Performance impact
- [ ] Network bandwidth usage
- [ ] Distribution point health

### Monitoring Schedule
- **First 24 Hours**: [Monitoring frequency]
- **Week 1**: [Monitoring frequency]
- **Ongoing**: [Monitoring frequency]

### Reports to Review
1. [Deployment Status Summary]
2. [Error Status Report]
3. [Client Activity Report]

## Rollback Plan

### Rollback Triggers
[List conditions that would trigger a rollback]

### Rollback Procedure
1. [Step-by-step rollback procedure]
2. [Include collection modifications]
3. [Include uninstall or previous version deployment]
4. [Communication plan]

### Rollback Testing
- **Rollback Tested**: [Yes | No]
- **Test Date**: [Date]
- **Test Result**: [Pass/Fail/Notes]

## Communication Plan

### Stakeholders
- **IT Leadership**: [Names/Roles]
- **Help Desk**: [Notified | Not Notified]
- **End Users**: [Notification method]
- **Change Management**: [Ticket number]

### Communication Timeline
| Date | Audience | Message | Method |
|------|----------|---------|--------|
| [Date] | [Group] | [Summary] | [Email/Portal/etc] |

### User Documentation
- **Documentation Location**: [Link or path]
- **Known Issues Published**: [Yes | No]
- **FAQ Created**: [Yes | No]

## Risk Assessment

### Risk Level
- [ ] Low - Standard deployment
- [ ] Medium - Requires monitoring
- [ ] High - Requires phased approach and approval

### Identified Risks
| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| [Risk description] | [High/Med/Low] | [High/Med/Low] | [Mitigation plan] |

### Compliance and Security
- **Security Review Required**: [Yes | No]
- **Security Approved By**: [Name/Date]
- **Compliance Requirements**: [List any compliance considerations]
- **Data Protection Impact**: [Assessment]

## Post-Deployment

### Deployment Summary
- **Total Targeted**: [Number]
- **Successfully Installed**: [Number/Percentage]
- **Failed**: [Number/Percentage]
- **Pending**: [Number/Percentage]
- **Unknown**: [Number/Percentage]

### Common Issues Encountered
| Error Code | Description | Resolution | Occurrences |
|------------|-------------|------------|-------------|
| [Code] | [Description] | [How resolved] | [Count] |

### Lessons Learned
[Document what went well and what could be improved]

### Follow-up Actions
- [ ] [Action item 1]
- [ ] [Action item 2]
- [ ] [Action item 3]

## Change History
| Date | Author | Change Description |
|------|--------|-------------------|
| YYYY-MM-DD | [Name] | Initial creation |

## PowerShell Deployment Script

```powershell
# Import SCCM Module
Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"

# Set location to SCCM site
$SiteCode = "XXX"  # Change to your site code
Set-Location "$($SiteCode):"

# Deployment variables
$ApplicationName = "[Application Name]"
$CollectionName = "[Target Collection]"
$DeploymentPurpose = "Required"  # or "Available"
$DeploymentComment = "[Deployment description]"

# Available time (immediate or specific date)
$AvailableTime = Get-Date

# Deadline (7 days from available time, or specific date)
$DeadlineTime = (Get-Date).AddDays(7)

# Create deployment
New-CMApplicationDeployment -Name $ApplicationName `
    -CollectionName $CollectionName `
    -DeployPurpose $DeploymentPurpose `
    -DeployAction Install `
    -UserNotification DisplayAll `
    -AvailableDateTime $AvailableTime `
    -DeadlineDateTime $DeadlineTime `
    -TimeBaseOn LocalTime `
    -RebootOutsideServiceWindow $false `
    -OverrideServiceWindow $false `
    -Comment $DeploymentComment

Write-Host "Deployment created successfully" -ForegroundColor Green

# Verify deployment
Get-CMApplicationDeployment -Name $ApplicationName |
    Where-Object {$_.CollectionName -eq $CollectionName} |
    Select-Object ApplicationName, CollectionName, DeploymentTime, EnforcementDeadline

```

## Tags
[Add relevant tags: software, updates, critical, standard, pilot, production, etc.]

## Approval
- **Approved By**: [Name]
- **Approval Date**: [Date]
- **Change Request**: [Ticket/Request number]
