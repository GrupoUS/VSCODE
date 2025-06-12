# WEEKLY INTEGRITY SCHEDULER - GRUPO US VIBECODE SYSTEM V4.0
# Automated weekly scheduling for structure integrity monitoring
# Created: 2025-01-10
# Purpose: Schedule and manage weekly integrity checks with reporting

param(
    [switch]$Install = $false,
    [switch]$Uninstall = $false,
    [switch]$Status = $false,
    [switch]$RunNow = $false
)

# ===============================================================================
# SCHEDULER CONFIGURATION
# ===============================================================================

$TASK_NAME = "GRUPOUS_ProjectCore_IntegrityMonitor"
$SCRIPT_PATH = "@project-core/automation/structure-integrity-monitor.ps1"
$LOG_PATH = "@project-core/monitoring/weekly-integrity-reports"
$SCHEDULE_TIME = "09:00"  # 9:00 AM every Monday
$SCHEDULE_DAY = "Monday"

# ===============================================================================
# SCHEDULER FUNCTIONS
# ===============================================================================

function Test-AdminPrivileges {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Initialize-LogDirectory {
    if (!(Test-Path $LOG_PATH)) {
        New-Item -ItemType Directory -Path $LOG_PATH -Force | Out-Null
        Write-Host "📁 Created log directory: $LOG_PATH" -ForegroundColor Green
    }
}

function Install-WeeklyScheduler {
    Write-Host "📅 Installing weekly integrity scheduler..." -ForegroundColor Yellow
    
    if (!(Test-AdminPrivileges)) {
        Write-Host "❌ Administrator privileges required for task scheduling" -ForegroundColor Red
        Write-Host "💡 Run PowerShell as Administrator and try again" -ForegroundColor Yellow
        return $false
    }
    
    # Check if task already exists
    $existingTask = Get-ScheduledTask -TaskName $TASK_NAME -ErrorAction SilentlyContinue
    if ($existingTask) {
        Write-Host "⚠️ Task already exists. Updating configuration..." -ForegroundColor Yellow
        Unregister-ScheduledTask -TaskName $TASK_NAME -Confirm:$false
    }
    
    # Create the scheduled task action
    $scriptFullPath = Resolve-Path $SCRIPT_PATH -ErrorAction SilentlyContinue
    if (!$scriptFullPath) {
        Write-Host "❌ Script not found at: $SCRIPT_PATH" -ForegroundColor Red
        return $false
    }
    
    $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptFullPath`" -AlertMode -Detailed"
    
    # Create the trigger (every Monday at 9:00 AM)
    $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek $SCHEDULE_DAY -At $SCHEDULE_TIME
    
    # Create task settings
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
    
    # Create the principal (run as SYSTEM)
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
    
    # Register the scheduled task
    try {
        Register-ScheduledTask -TaskName $TASK_NAME -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description "GRUPO US VIBECODE SYSTEM V4.0 - Weekly @project-core structure integrity monitoring"
        
        Write-Host "✅ Weekly scheduler installed successfully!" -ForegroundColor Green
        Write-Host "  • Task Name: $TASK_NAME" -ForegroundColor White
        Write-Host "  • Schedule: Every $SCHEDULE_DAY at $SCHEDULE_TIME" -ForegroundColor White
        Write-Host "  • Script: $scriptFullPath" -ForegroundColor White
        
        return $true
    }
    catch {
        Write-Host "❌ Failed to install scheduler: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Uninstall-WeeklyScheduler {
    Write-Host "🗑️ Uninstalling weekly integrity scheduler..." -ForegroundColor Yellow
    
    if (!(Test-AdminPrivileges)) {
        Write-Host "❌ Administrator privileges required for task management" -ForegroundColor Red
        return $false
    }
    
    $existingTask = Get-ScheduledTask -TaskName $TASK_NAME -ErrorAction SilentlyContinue
    if ($existingTask) {
        try {
            Unregister-ScheduledTask -TaskName $TASK_NAME -Confirm:$false
            Write-Host "✅ Weekly scheduler uninstalled successfully!" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "❌ Failed to uninstall scheduler: $($_.Exception.Message)" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "ℹ️ No scheduled task found with name: $TASK_NAME" -ForegroundColor Blue
        return $true
    }
}

function Get-SchedulerStatus {
    Write-Host "📊 Checking weekly scheduler status..." -ForegroundColor Yellow
    
    $existingTask = Get-ScheduledTask -TaskName $TASK_NAME -ErrorAction SilentlyContinue
    if ($existingTask) {
        $taskInfo = Get-ScheduledTaskInfo -TaskName $TASK_NAME
        
        Write-Host "✅ Weekly scheduler is installed and active" -ForegroundColor Green
        Write-Host "  • Task Name: $($existingTask.TaskName)" -ForegroundColor White
        Write-Host "  • State: $($existingTask.State)" -ForegroundColor White
        Write-Host "  • Last Run: $($taskInfo.LastRunTime)" -ForegroundColor White
        Write-Host "  • Next Run: $($taskInfo.NextRunTime)" -ForegroundColor White
        Write-Host "  • Last Result: $($taskInfo.LastTaskResult)" -ForegroundColor White
        
        # Check recent logs
        $recentLogs = Get-ChildItem $LOG_PATH -Filter "*.txt" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 3
        if ($recentLogs) {
            Write-Host "  • Recent Reports:" -ForegroundColor White
            foreach ($log in $recentLogs) {
                Write-Host "    - $($log.Name) ($(Get-Date $log.LastWriteTime -Format 'yyyy-MM-dd HH:mm'))" -ForegroundColor Gray
            }
        }
        
        return $true
    } else {
        Write-Host "❌ Weekly scheduler is not installed" -ForegroundColor Red
        Write-Host "💡 Run with -Install parameter to set up weekly monitoring" -ForegroundColor Yellow
        return $false
    }
}

function Invoke-ImmediateIntegrityCheck {
    Write-Host "🔄 Running immediate integrity check..." -ForegroundColor Yellow
    
    Initialize-LogDirectory
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $reportPath = "$LOG_PATH/immediate-check-$timestamp.txt"
    
    # Execute the integrity monitor
    $scriptPath = Resolve-Path $SCRIPT_PATH -ErrorAction SilentlyContinue
    if (!$scriptPath) {
        Write-Host "❌ Integrity monitor script not found at: $SCRIPT_PATH" -ForegroundColor Red
        return $false
    }
    
    try {
        # Run the integrity monitor and capture output
        $output = & PowerShell.exe -ExecutionPolicy Bypass -File $scriptPath -AlertMode -Detailed 2>&1
        
        # Save output to report file
        $output | Out-File $reportPath -Encoding UTF8
        
        Write-Host "✅ Immediate integrity check completed!" -ForegroundColor Green
        Write-Host "📝 Report saved to: $reportPath" -ForegroundColor Blue
        
        # Display summary
        $violations = $output | Where-Object { $_ -match "❌|⚠️" }
        if ($violations) {
            Write-Host "⚠️ Violations detected:" -ForegroundColor Red
            foreach ($violation in $violations) {
                Write-Host "  $violation" -ForegroundColor Red
            }
        } else {
            Write-Host "✅ No violations detected - System healthy!" -ForegroundColor Green
        }
        
        return $true
    }
    catch {
        Write-Host "❌ Failed to run integrity check: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Show-SchedulerHelp {
    Write-Host "📋 WEEKLY INTEGRITY SCHEDULER - USAGE GUIDE" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "PARAMETERS:" -ForegroundColor Cyan
    Write-Host "  -Install     Install weekly scheduler (requires admin privileges)" -ForegroundColor White
    Write-Host "  -Uninstall   Remove weekly scheduler (requires admin privileges)" -ForegroundColor White
    Write-Host "  -Status      Check scheduler status and recent reports" -ForegroundColor White
    Write-Host "  -RunNow      Execute immediate integrity check" -ForegroundColor White
    Write-Host ""
    Write-Host "EXAMPLES:" -ForegroundColor Cyan
    Write-Host "  .\weekly-integrity-scheduler.ps1 -Install" -ForegroundColor Gray
    Write-Host "  .\weekly-integrity-scheduler.ps1 -Status" -ForegroundColor Gray
    Write-Host "  .\weekly-integrity-scheduler.ps1 -RunNow" -ForegroundColor Gray
    Write-Host ""
    Write-Host "SCHEDULE:" -ForegroundColor Cyan
    Write-Host "  • Frequency: Weekly" -ForegroundColor White
    Write-Host "  • Day: $SCHEDULE_DAY" -ForegroundColor White
    Write-Host "  • Time: $SCHEDULE_TIME" -ForegroundColor White
    Write-Host "  • Reports: $LOG_PATH" -ForegroundColor White
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

function Start-WeeklySchedulerManager {
    Write-Host "📅 WEEKLY INTEGRITY SCHEDULER - GRUPO US VIBECODE SYSTEM V4.0" -ForegroundColor Magenta
    Write-Host ""
    
    Initialize-LogDirectory
    
    if ($Install) {
        return Install-WeeklyScheduler
    }
    elseif ($Uninstall) {
        return Uninstall-WeeklyScheduler
    }
    elseif ($Status) {
        return Get-SchedulerStatus
    }
    elseif ($RunNow) {
        return Invoke-ImmediateIntegrityCheck
    }
    else {
        Show-SchedulerHelp
        return $true
    }
}

# Execute scheduler manager
$result = Start-WeeklySchedulerManager

# Return result
return $result
