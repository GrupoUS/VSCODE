# STRUCTURE INTEGRITY MONITOR - GRUPO US VIBECODE SYSTEM V4.0
# Automated monitoring for @project-core directory structure integrity
# Created: 2025-01-10
# Purpose: Detect nested duplications, validate RAG systems, ensure workflow integrity

param(
    [switch]$Detailed = $false,
    [switch]$AlertMode = $false,
    [string]$LogPath = "@project-core/monitoring/structure-integrity-log.txt"
)

# ===============================================================================
# CRITICAL STRUCTURE DEFINITIONS
# ===============================================================================

$CRITICAL_DIRECTORIES = @(
    "@project-core/memory",
    "@project-core/rules", 
    "@project-core/automation",
    "@project-core/configs"
)

$PROTECTED_FILES = @(
    "master_rule.md",
    "@project-core/memory/self_correction_log.md",
    "@project-core/memory/global-standards.md",
    "@project-core/rules/00-vibecode-system-v4-master.md"
)

$RAG_SYSTEMS = @(
    "@project-core/memory/native-rag-system",
    "@project-core/memory/rag-enhanced"
)

$FORBIDDEN_PATTERNS = @(
    "@project-core/@project-core",
    "@project-core/memory/@project-core",
    "@project-core/*/memory/@project-core"
)

# ===============================================================================
# MONITORING FUNCTIONS
# ===============================================================================

function Initialize-MonitoringLog {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logDir = Split-Path $LogPath -Parent
    
    if (!(Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }
    
    "[$timestamp] STRUCTURE INTEGRITY MONITOR - SESSION STARTED" | Out-File $LogPath -Append
    Write-Host "📊 Structure Integrity Monitor Initialized" -ForegroundColor Green
}

function Test-NestedDuplicates {
    Write-Host "🔍 Scanning for nested @project-core duplicates..." -ForegroundColor Yellow
    
    $violations = @()
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    foreach ($pattern in $FORBIDDEN_PATTERNS) {
        if (Test-Path $pattern) {
            $violation = @{
                Type      = "NESTED_DUPLICATE"
                Path      = $pattern
                Severity  = "CRITICAL"
                Timestamp = $timestamp
            }
            $violations += $violation
            
            $message = "❌ CRITICAL: Nested duplicate detected at $pattern"
            Write-Host $message -ForegroundColor Red
            "[$timestamp] $message" | Out-File $LogPath -Append
        }
    }
    
    if ($violations.Count -eq 0) {
        Write-Host "  ✅ No nested duplicates detected" -ForegroundColor Green
        "[$timestamp] ✅ No nested duplicates detected" | Out-File $LogPath -Append
    }
    
    return $violations
}

function Test-RAGSystemsIntegrity {
    Write-Host "🧠 Validating RAG systems location..." -ForegroundColor Yellow
    
    $violations = @()
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    foreach ($ragSystem in $RAG_SYSTEMS) {
        if (!(Test-Path $ragSystem)) {
            $violation = @{
                Type      = "RAG_SYSTEM_MISSING"
                Path      = $ragSystem
                Severity  = "HIGH"
                Timestamp = $timestamp
            }
            $violations += $violation
            
            $message = "⚠️ HIGH: RAG system missing at $ragSystem"
            Write-Host $message -ForegroundColor Red
            "[$timestamp] $message" | Out-File $LogPath -Append
        }
        else {
            Write-Host "  ✅ RAG system verified: $ragSystem" -ForegroundColor Green
            if ($Detailed) {
                "[$timestamp] ✅ RAG system verified: $ragSystem" | Out-File $LogPath -Append
            }
        }
    }
    
    return $violations
}

function Test-CriticalFilesIntegrity {
    Write-Host "🔒 Verifying critical files integrity..." -ForegroundColor Yellow
    
    $violations = @()
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    foreach ($file in $PROTECTED_FILES) {
        if (!(Test-Path $file)) {
            $violation = @{
                Type      = "CRITICAL_FILE_MISSING"
                Path      = $file
                Severity  = "CRITICAL"
                Timestamp = $timestamp
            }
            $violations += $violation
            
            $message = "❌ CRITICAL: Protected file missing at $file"
            Write-Host $message -ForegroundColor Red
            "[$timestamp] $message" | Out-File $LogPath -Append
        }
        else {
            Write-Host "  ✅ Critical file verified: $(Split-Path $file -Leaf)" -ForegroundColor Green
            if ($Detailed) {
                "[$timestamp] ✅ Critical file verified: $file" | Out-File $LogPath -Append
            }
        }
    }
    
    return $violations
}

function Test-WorkflowHierarchy {
    Write-Host "🔄 Validating workflow hierarchy integrity..." -ForegroundColor Yellow
    
    $violations = @()
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    # Check for Sequential Thinking MCP configuration
    $mcpConfig = "@project-core/configs/mcp-master-unified.json"
    if (Test-Path $mcpConfig) {
        $configContent = Get-Content $mcpConfig -Raw | ConvertFrom-Json
        
        $requiredMCPs = @("sequential-thinking", "think-mcp-server", "mcp-shrimp-task-manager")
        $missingMCPs = @()
        
        foreach ($mcp in $requiredMCPs) {
            if (!($configContent.PSObject.Properties.Name -contains $mcp)) {
                $missingMCPs += $mcp
            }
        }
        
        if ($missingMCPs.Count -gt 0) {
            $violation = @{
                Type      = "WORKFLOW_HIERARCHY_INCOMPLETE"
                Path      = $mcpConfig
                Details   = "Missing MCPs: $($missingMCPs -join ', ')"
                Severity  = "HIGH"
                Timestamp = $timestamp
            }
            $violations += $violation
            
            $message = "⚠️ HIGH: Workflow hierarchy incomplete - Missing: $($missingMCPs -join ', ')"
            Write-Host $message -ForegroundColor Red
            "[$timestamp] $message" | Out-File $LogPath -Append
        }
        else {
            Write-Host "  ✅ Workflow hierarchy verified: Sequential Thinking → think-mcp-server → MCP Shrimp" -ForegroundColor Green
            "[$timestamp] ✅ Workflow hierarchy verified" | Out-File $LogPath -Append
        }
    }
    else {
        $violation = @{
            Type      = "MCP_CONFIG_MISSING"
            Path      = $mcpConfig
            Severity  = "CRITICAL"
            Timestamp = $timestamp
        }
        $violations += $violation
        
        $message = "❌ CRITICAL: MCP configuration missing at $mcpConfig"
        Write-Host $message -ForegroundColor Red
        "[$timestamp] $message" | Out-File $LogPath -Append
    }
    
    return $violations
}

function Test-DirectoryStructureHealth {
    Write-Host "📁 Analyzing directory structure health..." -ForegroundColor Yellow
    
    $violations = @()
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    foreach ($dir in $CRITICAL_DIRECTORIES) {
        if (!(Test-Path $dir)) {
            $violation = @{
                Type      = "CRITICAL_DIRECTORY_MISSING"
                Path      = $dir
                Severity  = "CRITICAL"
                Timestamp = $timestamp
            }
            $violations += $violation
            
            $message = "❌ CRITICAL: Critical directory missing at $dir"
            Write-Host $message -ForegroundColor Red
            "[$timestamp] $message" | Out-File $LogPath -Append
        }
        else {
            Write-Host "  ✅ Critical directory verified: $(Split-Path $dir -Leaf)" -ForegroundColor Green
            if ($Detailed) {
                "[$timestamp] ✅ Critical directory verified: $dir" | Out-File $LogPath -Append
            }
        }
    }
    
    return $violations
}

function Send-AlertNotification {
    param([array]$Violations)
    
    if ($Violations.Count -eq 0) {
        return
    }
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $alertMessage = "🚨 STRUCTURE INTEGRITY ALERT - $($Violations.Count) violations detected at $timestamp"
    
    Write-Host $alertMessage -ForegroundColor Red -BackgroundColor Yellow
    "[$timestamp] $alertMessage" | Out-File $LogPath -Append
    
    foreach ($violation in $Violations) {
        $violationMsg = "  • $($violation.Severity): $($violation.Type) at $($violation.Path)"
        Write-Host $violationMsg -ForegroundColor Red
        "[$timestamp] $violationMsg" | Out-File $LogPath -Append
    }
    
    # Future enhancement: Email/Slack notifications
    Write-Host "💡 Consider implementing email/Slack notifications for critical violations" -ForegroundColor Yellow
}

function Start-StructureIntegrityMonitor {
    Write-Host "🔧 STRUCTURE INTEGRITY MONITOR - GRUPO US VIBECODE SYSTEM V4.0" -ForegroundColor Magenta
    Write-Host "Mode: $(if ($AlertMode) { 'ALERT MODE' } else { 'STANDARD MONITORING' })" -ForegroundColor Cyan
    Write-Host ""
    
    Initialize-MonitoringLog
    
    # Execute all integrity checks
    $allViolations = @()
    $allViolations += Test-NestedDuplicates
    $allViolations += Test-RAGSystemsIntegrity
    $allViolations += Test-CriticalFilesIntegrity
    $allViolations += Test-WorkflowHierarchy
    $allViolations += Test-DirectoryStructureHealth
    
    Write-Host ""
    Write-Host "📊 INTEGRITY MONITORING SUMMARY:" -ForegroundColor Green
    Write-Host "  • Total checks performed: 5" -ForegroundColor White
    Write-Host "  • Violations detected: $($allViolations.Count)" -ForegroundColor $(if ($allViolations.Count -eq 0) { 'Green' } else { 'Red' })
    
    if ($allViolations.Count -eq 0) {
        Write-Host "  • Status: ✅ ALL SYSTEMS HEALTHY" -ForegroundColor Green
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "[$timestamp] ✅ ALL SYSTEMS HEALTHY - No violations detected" | Out-File $LogPath -Append
    }
    else {
        Write-Host "  • Status: ⚠️ VIOLATIONS DETECTED" -ForegroundColor Red
        
        if ($AlertMode) {
            Send-AlertNotification -Violations $allViolations
        }
    }
    
    Write-Host ""
    Write-Host "✅ Structure integrity monitoring completed!" -ForegroundColor Green
    Write-Host "📝 Log saved to: $LogPath" -ForegroundColor Blue
    
    return $allViolations
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

# Execute structure integrity monitoring
Start-StructureIntegrityMonitor
