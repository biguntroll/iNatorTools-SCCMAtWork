# SCCM Scripts

This folder contains PowerShell and other scripts used for SCCM automation, maintenance, and troubleshooting.

## Script Categories

### Automation Scripts
Scripts that automate routine SCCM tasks:
- Collection creation
- Application packaging
- Deployment creation
- Maintenance tasks

### Inventory Scripts
Scripts that collect custom inventory data:
- Hardware information
- Software installations
- Configuration settings
- Custom attributes

### Remediation Scripts
Scripts that fix common issues:
- Client repair
- Cache cleanup
- Policy reset
- Service restart

### Reporting Scripts
Scripts that generate custom reports:
- Compliance data
- Deployment status
- Inventory summaries
- Health checks

### Client-Side Scripts
Scripts deployed to endpoints via SCCM:
- Configuration changes
- Software installations
- Maintenance tasks
- Diagnostics

## Script Documentation

Each script should include:

```powershell
<#
.SYNOPSIS
    Brief description of what the script does

.DESCRIPTION
    Detailed description of the script's functionality

.PARAMETER ParameterName
    Description of each parameter

.EXAMPLE
    Example of how to use the script

.NOTES
    Author: Your Name
    Date: YYYY-MM-DD
    Version: 1.0

    Change History:
    1.0 - Initial release

.LINK
    Related documentation or resources
#>
```

## Best Practices

### Script Development
1. **Test Thoroughly**: Test in lab environment before production
2. **Error Handling**: Include try/catch blocks and proper error handling
3. **Logging**: Implement logging for troubleshooting
4. **Comments**: Comment complex logic and explain why, not just what
5. **Parameters**: Use parameters instead of hard-coded values

### Security
1. **No Hardcoded Credentials**: Use secure methods for authentication
2. **Least Privilege**: Run with minimum required permissions
3. **Input Validation**: Validate and sanitize all inputs
4. **Audit Trail**: Log who ran the script and when

### Performance
1. **Efficient Queries**: Optimize WMI and SQL queries
2. **Batch Operations**: Process items in batches when possible
3. **Resource Usage**: Be mindful of CPU, memory, and network usage
4. **Execution Time**: Consider script execution time for deployments

## Script Naming Convention

Use PowerShell approved verbs:
```
[Verb]-[Noun]-[Purpose].ps1
```

Examples:
- `Get-CCMClientInfo-Extended.ps1`
- `Set-MaintenanceWindow-Automated.ps1`
- `Remove-CCMCache-Cleanup.ps1`
- `Test-SCCMClientHealth-Diagnostics.ps1`
- `Invoke-CollectionUpdate-Manual.ps1`

**Common PowerShell Verbs**:
- **Get**: Retrieve information
- **Set**: Change configuration
- **New**: Create new object
- **Remove**: Delete or cleanup
- **Test**: Validate or check
- **Invoke**: Execute an operation
- **Start**: Begin a process
- **Stop**: End a process
- **Repair**: Fix issues

## Running Scripts in SCCM

### From SCCM Console

**Scripts Node** (Console Scripts):
1. Navigate to Software Library > Scripts
2. Create new script or import existing
3. Approve script (requires approval workflow)
4. Run against device collection

**Packages/Programs** (Legacy):
1. Create package with script source files
2. Create program with command line
3. Distribute content
4. Deploy to collection

**Applications** (Modern):
1. Create script deployment type
2. Configure detection method
3. Distribute content
4. Deploy to collection

### Script Execution Policy

Ensure endpoints have appropriate execution policy:
```powershell
# View current policy
Get-ExecutionPolicy

# Recommended for SCCM clients
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
```

## Common Script Patterns

### Connect to SCCM Site

```powershell
# Import ConfigMgr module
Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"

# Get site code
$SiteCode = (Get-PSDrive -PSProvider CMSite).Name

# Set location to SCCM site
Set-Location "$($SiteCode):"
```

### Query SCCM Database

```powershell
# Connection string
$SQLServer = "SCCMServer.domain.com"
$Database = "CM_XXX"

# Query
$Query = @"
SELECT Name, ResourceID FROM v_R_System
WHERE Active = 1
"@

# Execute
$Connection = New-Object System.Data.SqlClient.SqlConnection
$Connection.ConnectionString = "Server=$SQLServer;Database=$Database;Integrated Security=True"
$Connection.Open()

$Command = $Connection.CreateCommand()
$Command.CommandText = $Query
$Adapter = New-Object System.Data.SqlClient.SqlDataAdapter $Command
$DataSet = New-Object System.Data.DataSet
$Adapter.Fill($DataSet)

$Connection.Close()

$DataSet.Tables[0]
```

### Client-Side: Get CCM Client Info

```powershell
# Check if ConfigMgr client is installed
$CCMClient = Get-Service -Name CcmExec -ErrorAction SilentlyContinue

if ($CCMClient) {
    # Get client info
    $Client = Get-WmiObject -Namespace root\ccm -Class SMS_Client
    $ClientVersion = $Client.ClientVersion

    # Get last policy request time
    $PolicyAgent = Get-WmiObject -Namespace root\ccm -Class SMS_Authority
    $LastPolicyRequest = $PolicyAgent.LastUpdateTime

    Write-Output "Client Version: $ClientVersion"
    Write-Output "Last Policy Request: $LastPolicyRequest"
}
```

### Logging Template

```powershell
function Write-Log {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [ValidateSet("INFO","WARN","ERROR")]
        [string]$Level = "INFO",

        [Parameter(Mandatory=$false)]
        [string]$LogPath = "$env:TEMP\ScriptLog.log"
    )

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "$Timestamp [$Level] $Message"

    Add-Content -Path $LogPath -Value $LogEntry

    switch ($Level) {
        "INFO" { Write-Host $LogEntry -ForegroundColor Green }
        "WARN" { Write-Host $LogEntry -ForegroundColor Yellow }
        "ERROR" { Write-Host $LogEntry -ForegroundColor Red }
    }
}

# Usage
Write-Log -Message "Script started" -Level INFO
Write-Log -Message "Warning: Low disk space" -Level WARN
Write-Log -Message "Error: Failed to connect" -Level ERROR
```

## Testing Scripts

### Pre-Deployment Checklist
- [ ] Tested in lab environment
- [ ] Error handling implemented
- [ ] Logging implemented
- [ ] Parameters validated
- [ ] Execution time acceptable
- [ ] Resource usage acceptable
- [ ] Documentation complete
- [ ] Code reviewed
- [ ] Approved by team

### Test Scenarios
1. **Happy Path**: Script runs successfully with valid inputs
2. **Invalid Input**: Script handles bad input gracefully
3. **Permission Denied**: Script handles insufficient permissions
4. **Network Failure**: Script handles connectivity issues
5. **Timeout**: Script handles long-running operations
6. **Concurrent Execution**: Script handles multiple instances

## Troubleshooting

### Script Not Running
1. Check execution policy
2. Verify script syntax (use PowerShell ISE)
3. Review SCCM logs (Scripts.log, ScriptExecutionAgent.log)
4. Check account permissions
5. Verify network connectivity

### Script Failing
1. Review error messages
2. Check script logs
3. Test manually on affected device
4. Verify prerequisites are met
5. Check for environmental differences

## Resources

### PowerShell Resources
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [ConfigMgr PowerShell Cmdlets](https://docs.microsoft.com/en-us/powershell/module/configurationmanager/)

### SCCM Scripting
- [Run Scripts in SCCM](https://docs.microsoft.com/en-us/mem/configmgr/apps/deploy-use/create-deploy-scripts)
- [CMPivot Queries](https://docs.microsoft.com/en-us/mem/configmgr/core/servers/manage/cmpivot)

---

**Last Updated**: 2025-01-19
