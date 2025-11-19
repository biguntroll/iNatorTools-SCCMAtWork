<#
.SYNOPSIS
    Exports SCCM collection information to a formatted markdown template file.

.DESCRIPTION
    This script connects to an SCCM site, retrieves detailed information about a specified collection,
    and generates a markdown documentation file based on the collection template format.

    The script extracts:
    - Collection basic details (name, type, comment, limiting collection)
    - Membership rules (Query, Direct, Include, Exclude)
    - Update schedules (Full and Incremental)
    - Member counts
    - Maintenance window assignments
    - Site information

.PARAMETER CollectionName
    The name of the collection to export (required)

.PARAMETER SiteCode
    The SCCM site code. If not specified, will auto-detect from PSDrive

.PARAMETER OutputPath
    The output directory for the markdown file. Defaults to repository structure.
    If not specified, will save to Collections/Device-Collections/ or Collections/User-Collections/

.PARAMETER RepositoryRoot
    Root path of the iNatorTools-SCCMAtWork repository. Defaults to script's parent directory.

.EXAMPLE
    .\Export-CollectionToTemplate.ps1 -CollectionName "PRD-DEV-Patching-Workstations-Group1"

    Exports the specified collection to a markdown file in the appropriate Collections folder.

.EXAMPLE
    .\Export-CollectionToTemplate.ps1 -CollectionName "PRD-DEV-Patching-Workstations-Group1" -SiteCode "PRD"

    Exports collection from the PRD site explicitly.

.EXAMPLE
    .\Export-CollectionToTemplate.ps1 -CollectionName "PRD-DEV-Patching-Workstations-Group1" -OutputPath "C:\Temp"

    Exports collection to a custom output directory.

.NOTES
    Author: SCCM Admin Team
    Date: 2025-01-19
    Version: 1.0

    Requirements:
    - SCCM Console installed
    - ConfigurationManager PowerShell module
    - Appropriate SCCM permissions to read collections

.LINK
    Repository: https://github.com/biguntroll/iNatorTools-SCCMAtWork
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Name of the collection to export")]
    [string]$CollectionName,

    [Parameter(Mandatory = $false, HelpMessage = "SCCM Site Code (auto-detects if not specified)")]
    [ValidateSet("DEV", "TST", "PRD", "CM1")]
    [string]$SiteCode,

    [Parameter(Mandatory = $false, HelpMessage = "Output directory for the markdown file")]
    [string]$OutputPath,

    [Parameter(Mandatory = $false, HelpMessage = "Root path of the repository")]
    [string]$RepositoryRoot
)

#region Functions

function Write-Log {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet("INFO", "WARN", "ERROR", "SUCCESS")]
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "INFO" { "White" }
        "WARN" { "Yellow" }
        "ERROR" { "Red" }
        "SUCCESS" { "Green" }
    }

    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

function Get-SCCMSiteCode {
    <#
    .SYNOPSIS
        Attempts to auto-detect the SCCM site code
    #>
    try {
        $drive = Get-PSDrive -PSProvider CMSite -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($drive) {
            return $drive.Name
        }
        return $null
    }
    catch {
        return $null
    }
}

function Format-UpdateSchedule {
    <#
    .SYNOPSIS
        Formats SCCM update schedule object into readable string
    #>
    param($Schedule)

    if (-not $Schedule) { return "Not configured" }

    try {
        $scheduleString = ""

        if ($Schedule.DaySpan -gt 0) {
            $scheduleString += "Every $($Schedule.DaySpan) day(s)"
        }
        elseif ($Schedule.HourSpan -gt 0) {
            $scheduleString += "Every $($Schedule.HourSpan) hour(s)"
        }
        elseif ($Schedule.MinuteSpan -gt 0) {
            $scheduleString += "Every $($Schedule.MinuteSpan) minute(s)"
        }
        else {
            $scheduleString += "Custom schedule"
        }

        if ($Schedule.StartTime) {
            $scheduleString += " starting at $($Schedule.StartTime)"
        }

        return $scheduleString
    }
    catch {
        return "Schedule details unavailable"
    }
}

function Get-CollectionMemberCount {
    <#
    .SYNOPSIS
        Gets current member count for a collection
    #>
    param($CollectionID, $SiteCode)

    try {
        $originalLocation = Get-Location
        Set-Location "$($SiteCode):"

        $members = Get-CMCollectionMember -CollectionId $CollectionID -ErrorAction SilentlyContinue
        $count = ($members | Measure-Object).Count

        Set-Location $originalLocation
        return $count
    }
    catch {
        return "Unable to retrieve"
    }
}

#endregion

#region Main Script

Write-Log "Starting SCCM Collection Export to Template" -Level INFO
Write-Log "Collection Name: $CollectionName" -Level INFO

# Import ConfigurationManager module
try {
    if (-not (Get-Module -Name ConfigurationManager)) {
        Write-Log "Importing ConfigurationManager module..." -Level INFO
        Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" -ErrorAction Stop
    }
    Write-Log "ConfigurationManager module loaded successfully" -Level SUCCESS
}
catch {
    Write-Log "Failed to import ConfigurationManager module: $_" -Level ERROR
    Write-Log "Ensure SCCM Console is installed and SMS_ADMIN_UI_PATH is set" -Level ERROR
    exit 1
}

# Determine Site Code
if (-not $SiteCode) {
    Write-Log "Site code not specified, attempting auto-detection..." -Level INFO
    $SiteCode = Get-SCCMSiteCode
    if ($SiteCode) {
        Write-Log "Auto-detected site code: $SiteCode" -Level SUCCESS
    }
    else {
        Write-Log "Unable to auto-detect site code. Please specify -SiteCode parameter" -Level ERROR
        exit 1
    }
}
else {
    Write-Log "Using specified site code: $SiteCode" -Level INFO
}

# Save current location and navigate to SCCM site
$originalLocation = Get-Location
try {
    Set-Location "$($SiteCode):" -ErrorAction Stop
    Write-Log "Connected to SCCM site: $SiteCode" -Level SUCCESS
}
catch {
    Write-Log "Failed to connect to SCCM site ${SiteCode}: $_" -Level ERROR
    exit 1
}

# Retrieve Collection
Write-Log "Retrieving collection: $CollectionName" -Level INFO
try {
    $collection = Get-CMCollection -Name $CollectionName -ErrorAction Stop

    if (-not $collection) {
        Write-Log "Collection '$CollectionName' not found" -Level ERROR
        Set-Location $originalLocation
        exit 1
    }

    Write-Log "Collection found: $($collection.Name) (ID: $($collection.CollectionID))" -Level SUCCESS
}
catch {
    Write-Log "Error retrieving collection: $_" -Level ERROR
    Set-Location $originalLocation
    exit 1
}

# Determine collection type
$collectionType = if ($collection.CollectionType -eq 2) { "Device" } else { "User" }
Write-Log "Collection Type: $collectionType" -Level INFO

# Get member count
Write-Log "Retrieving member count..." -Level INFO
$memberCount = Get-CollectionMemberCount -CollectionID $collection.CollectionID -SiteCode $SiteCode
Write-Log "Member Count: $memberCount" -Level INFO

# Get query rules
Write-Log "Retrieving collection rules..." -Level INFO
$queryRules = $collection.CollectionRules | Where-Object { $_.SmsProviderObjectPath -like "*SMS_CollectionRuleQuery*" }
$directRules = $collection.CollectionRules | Where-Object { $_.SmsProviderObjectPath -like "*SMS_CollectionRuleDirect*" }
$includeRules = $collection.CollectionRules | Where-Object { $_.SmsProviderObjectPath -like "*SMS_CollectionRuleIncludeCollection*" }
$excludeRules = $collection.CollectionRules | Where-Object { $_.SmsProviderObjectPath -like "*SMS_CollectionRuleExcludeCollection*" }

# Get limiting collection
$limitingCollection = if ($collection.LimitToCollectionName) { $collection.LimitToCollectionName } else { "Not specified" }

# Get refresh schedule
$refreshType = switch ($collection.RefreshType) {
    1 { "Manual" }
    2 { "Scheduled" }
    4 { "Incremental" }
    6 { "Incremental and Scheduled" }
    default { "Unknown" }
}

# Extract site code from collection name (first segment before first hyphen)
$siteFromName = if ($CollectionName -match '^([A-Z0-9]+)-') { $Matches[1] } else { $SiteCode }

# Return to original location
Set-Location $originalLocation

# Determine output path
if (-not $OutputPath) {
    if (-not $RepositoryRoot) {
        # Assume script is in Scripts folder, go up one level
        $RepositoryRoot = Split-Path -Parent $PSScriptRoot
    }

    $collectionFolder = if ($collectionType -eq "Device") { "Device-Collections" } else { "User-Collections" }
    $OutputPath = Join-Path $RepositoryRoot "Collections\$collectionFolder"
}

# Create output directory if it doesn't exist
if (-not (Test-Path $OutputPath)) {
    Write-Log "Creating output directory: $OutputPath" -Level INFO
    New-Item -Path $OutputPath -ItemType Directory -Force | Out-Null
}

# Generate filename
$fileName = "$CollectionName.md"
$outputFile = Join-Path $OutputPath $fileName

Write-Log "Generating markdown documentation..." -Level INFO

# Build markdown content
$markdown = @"
# SCCM Collection: $CollectionName

## Collection Information

### Basic Details
- **Collection Name**: $CollectionName
- **Collection Type**: $collectionType
- **Collection ID**: $($collection.CollectionID)
- **Purpose**: $($collection.Comment)
- **Limiting Collection**: $limitingCollection
- **Update Schedule**: $refreshType

### Site Information
- **Primary Site**: $siteFromName
- **Deployed to Sites**:
  - [x] $siteFromName - Status: Active
  - [ ] [Other sites as needed]
- **Site-Specific Variations**: None

### Membership Rules

#### Query Rules
"@

if ($queryRules) {
    foreach ($rule in $queryRules) {
        $markdown += @"

**Rule Name**: $($rule.RuleName)

``````sql
$($rule.QueryExpression)
``````

**Query Explanation**:
[Add explanation of what this query does]

"@
    }
}
else {
    $markdown += @"

No query rules defined.

"@
}

$markdown += @"

#### Direct Membership Rules
"@

if ($directRules) {
    $markdown += @"

**Direct Members**:
"@
    foreach ($rule in $directRules) {
        $markdown += @"

- $($rule.RuleName)
"@
    }
    $markdown += @"

- **Reason**: [Document why direct membership is needed]
"@
}
else {
    $markdown += @"

No direct membership rules defined.
"@
}

$markdown += @"


#### Include Collections
"@

if ($includeRules) {
    foreach ($rule in $includeRules) {
        $markdown += @"

- $($rule.IncludeCollectionID)
"@
    }
    $markdown += @"

- **Reason**: [Document why these collections are included]
"@
}
else {
    $markdown += @"

No include collection rules defined.
"@
}

$markdown += @"


#### Exclude Collections
"@

if ($excludeRules) {
    foreach ($rule in $excludeRules) {
        $markdown += @"

- $($rule.ExcludeCollectionID)
"@
    }
    $markdown += @"

- **Reason**: [Document why these collections are excluded]
"@
}
else {
    $markdown += @"

No exclude collection rules defined.
"@
}

$markdown += @"


## Deployment Usage

### Intended Use
- [ ] Software Deployments
- [ ] Software Update Deployments
- [ ] Configuration Baseline Deployments
- [ ] Operating System Deployments
- [ ] Script Deployments
- [ ] Other: [Specify]

### Maintenance Windows
- **Maintenance Window Applied**: [Yes | No]
- **Window Details**: [Time and duration if applicable]

## Validation

### Expected Member Count
- **Approximate Size**: $memberCount devices/users
- **Last Verified**: $(Get-Date -Format 'yyyy-MM-dd')

### Testing Checklist
- [ ] Query syntax validated in SCCM console
- [x] Collection exported from production
- [ ] Update schedule configured
- [ ] Membership reviewed for accuracy
- [ ] No duplicate members
- [x] Collection documented in this repository

## Dependencies

### Required Attributes
[List any custom attributes or hardware inventory items required]

### Related Collections
[List collections that work with or depend on this one]

## Notes

### Important Considerations
[Any special considerations, caveats, or warnings]

### Promotion History
| Date | From Site | To Site | Promoted By | Validation Period | Ticket | Notes |
|------|-----------|---------|-------------|-------------------|--------|-------|
| [Date] | [Site] | [Site] | [Name] | [X days] | CHG-XXXXX | [Notes] |

### Change History
| Date | Site | Author | Change Description |
|------|------|--------|-------------------|
| $(Get-Date -Format 'yyyy-MM-dd') | $siteFromName | Script Export | Initial documentation generated from SCCM |

## Tags
[Add relevant tags: patching, deployment, workstations, servers, laptops, etc.]
"@

# Write to file
try {
    $markdown | Out-File -FilePath $outputFile -Encoding UTF8 -Force
    Write-Log "Successfully created: $outputFile" -Level SUCCESS
    Write-Log "Collection documentation exported successfully!" -Level SUCCESS
}
catch {
    Write-Log "Failed to write output file: $_" -Level ERROR
    exit 1
}

# Summary
Write-Log "" -Level INFO
Write-Log "=== Export Summary ===" -Level INFO
Write-Log "Collection: $CollectionName" -Level INFO
Write-Log "Type: $collectionType" -Level INFO
Write-Log "Members: $memberCount" -Level INFO
Write-Log "Query Rules: $($queryRules.Count)" -Level INFO
Write-Log "Direct Rules: $($directRules.Count)" -Level INFO
Write-Log "Include Rules: $($includeRules.Count)" -Level INFO
Write-Log "Exclude Rules: $($excludeRules.Count)" -Level INFO
Write-Log "Output File: $outputFile" -Level SUCCESS
Write-Log "" -Level INFO
Write-Log "Next steps:" -Level INFO
Write-Log "1. Review and edit the generated file: $outputFile" -Level INFO
Write-Log "2. Fill in [bracketed] sections with appropriate information" -Level INFO
Write-Log "3. Add query explanations and intended use details" -Level INFO
Write-Log "4. Commit the file to your repository" -Level INFO

#endregion
