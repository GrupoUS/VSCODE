# Pre-Task Checklist Script (PowerShell)
# GRUPO US VIBECODE SYSTEM V2.0
# 
# This script enforces TaskMaster integration for complex tasks
# and prevents protocol violations like the GitLab MCP integration oversight.

param(
    [Parameter(Mandatory = $true)]
    [string]$TaskDescription
)

# Function to print colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    
    switch ($Color) {
        "Red" { Write-Host $Message -ForegroundColor Red }
        "Green" { Write-Host $Message -ForegroundColor Green }
        "Yellow" { Write-Host $Message -ForegroundColor Yellow }
        "Blue" { Write-Host $Message -ForegroundColor Blue }
        "Cyan" { Write-Host $Message -ForegroundColor Cyan }
        default { Write-Host $Message }
    }
}

# Function to print header
function Write-Header {
    Write-Host ""
    Write-ColorOutput "🔍 PRE-TASK ASSESSMENT - GRUPO US VIBECODE SYSTEM V2.0" "Blue"
    Write-ColorOutput "=======================================================" "Blue"
    Write-Host ""
}

# Function to assess task complexity automatically
function Get-TaskComplexity {
    param([string]$Description)
    
    $autoComplexity = 5
    $keywordCount = 0
    
    # Define complexity keywords
    $keywords = @("complex", "integration", "implementation", "architecture", "system", "mcp", "server", "deployment", "migration", "refactor", "optimization")
    
    Write-ColorOutput "📊 AUTOMATIC COMPLEXITY ASSESSMENT" "Blue"
    Write-ColorOutput "====================================" "Blue"
    
    # Check for keywords
    foreach ($keyword in $keywords) {
        if ($Description -match $keyword) {
            $keywordCount++
            Write-ColorOutput "🏷️ Keyword detected: $keyword" "Yellow"
        }
    }
    
    # Calculate complexity based on keywords
    if ($keywordCount -gt 3) {
        $autoComplexity = 9
    }
    elseif ($keywordCount -gt 2) {
        $autoComplexity = 8
    }
    elseif ($keywordCount -gt 1) {
        $autoComplexity = 7
    }
    elseif ($keywordCount -gt 0) {
        $autoComplexity = 6
    }
    
    Write-Host ""
    Write-ColorOutput "📈 ASSESSMENT RESULTS:" "Blue"
    Write-ColorOutput "Keywords detected: $keywordCount" "Blue"
    Write-ColorOutput "Estimated complexity: $autoComplexity/10" "Blue"
    
    return @{
        Complexity   = $autoComplexity
        KeywordCount = $keywordCount
    }
}

# Function to check for multi-component tasks
function Get-ComponentCount {
    param([string]$Description)
    
    $componentCount = 1
    
    # Define component indicators
    $components = @("mcp", "server", "integration", "api", "database", "frontend", "backend", "auth", "deployment", "testing", "documentation")
    
    foreach ($component in $components) {
        if ($Description -match $component) {
            $componentCount++
        }
    }
    
    return $componentCount
}

# Function to determine if TaskMaster is required
function Test-TaskMasterRequirement {
    param(
        [int]$Complexity,
        [int]$Components,
        [bool]$HasKeywords,
        [string]$Description
    )
    
    Write-Host ""
    Write-ColorOutput "🎯 TASKMASTER REQUIREMENT ANALYSIS" "Blue"
    Write-ColorOutput "===================================" "Blue"
    
    $required = $false
    $reasons = @()
    
    # Check complexity threshold
    if ($Complexity -gt 7) {
        $required = $true
        $reasons += "High complexity ($Complexity/10)"
    }

    # Check component count
    if ($Components -gt 3) {
        $required = $true
        $reasons += "Multi-component task ($Components components)"
    }

    # Check for critical keywords
    if ($HasKeywords) {
        $required = $true
        $reasons += "Critical keywords detected"
    }

    # Check task length (rough estimate)
    $wordCount = ($Description -split '\s+').Count
    if ($wordCount -gt 20) {
        $required = $true
        $reasons += "Detailed task description ($wordCount words)"
    }
    
    if ($required) {
        Write-ColorOutput "🚨 TASKMASTER REQUIRED" "Red"
        Write-ColorOutput "Reasons:" "Yellow"
        foreach ($reason in $reasons) {
            Write-ColorOutput "  • $reason" "Yellow"
        }
    }
    else {
        Write-ColorOutput "ℹ️ TaskMaster optional for this task" "Green"
    }
    
    return $required
}

# Function to create TaskMaster task
function New-TaskMasterTask {
    param(
        [string]$Description,
        [int]$Complexity
    )
    
    Write-Host ""
    Write-ColorOutput "📝 CREATING TASKMASTER TASK" "Blue"
    Write-ColorOutput "============================" "Blue"
    
    # Enhanced task description with metadata
    $enhancedDescription = "$Description [Complexity: $Complexity/10] [Auto-created by pre-task-checklist]"
    
    Write-ColorOutput "Creating TaskMaster task..." "Yellow"
    
    try {
        # Execute task-master command
        $result = & task-master add-task --prompt="$enhancedDescription" --priority=high 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "✅ TaskMaster task created successfully" "Green"
            
            # Try to get the latest task ID
            try {
                $taskList = & task-master list --format=json 2>$null | ConvertFrom-Json
                if ($taskList -and $taskList.Count -gt 0) {
                    $taskId = $taskList[0].id
                    Write-ColorOutput "📋 Task ID: $taskId" "Green"
                    Write-ColorOutput "💡 Use 'task-master show $taskId' to view details" "Blue"
                    Write-ColorOutput "💡 Use 'task-master set-status --id=$taskId --status=in-progress' to start working" "Blue"
                }
            }
            catch {
                # Ignore JSON parsing errors
            }
            
            return $true
        }
        else {
            Write-ColorOutput "❌ Failed to create TaskMaster task" "Red"
            Write-ColorOutput "⚠️ Proceeding without TaskMaster (not recommended)" "Yellow"
            return $false
        }
    }
    catch {
        Write-ColorOutput "❌ Error creating TaskMaster task: $($_.Exception.Message)" "Red"
        Write-ColorOutput "⚠️ Proceeding without TaskMaster (not recommended)" "Yellow"
        return $false
    }
}

# Function to check if TaskMaster is accessible
function Test-TaskMasterAccessibility {
    Write-ColorOutput "🔧 CHECKING TASKMASTER ACCESSIBILITY" "Blue"
    Write-ColorOutput "=====================================" "Blue"
    
    try {
        $version = & task-master --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "✅ TaskMaster CLI accessible: $($version[0])" "Green"
            return $true
        }
        else {
            Write-ColorOutput "❌ TaskMaster CLI not responding" "Red"
            Write-ColorOutput "Install with: npm install -g task-master-ai" "Yellow"
            return $false
        }
    }
    catch {
        Write-ColorOutput "❌ TaskMaster CLI not found" "Red"
        Write-ColorOutput "Install with: npm install -g task-master-ai" "Yellow"
        return $false
    }
}

# Main execution
function Main {
    Write-Header
    Write-ColorOutput "Task: $TaskDescription" "Blue"
    Write-Host ""
    
    # Check TaskMaster accessibility first
    if (-not (Test-TaskMasterAccessibility)) {
        Write-ColorOutput "⚠️ TaskMaster not accessible. Skipping assessment." "Yellow"
        exit 1
    }
    
    Write-Host ""
    
    # Perform automatic assessments
    $assessment = Get-TaskComplexity -Description $TaskDescription
    $complexity = $assessment.Complexity
    $keywordCount = $assessment.KeywordCount
    
    $components = Get-ComponentCount -Description $TaskDescription
    
    # Check for critical keywords manually
    $hasKeywords = $TaskDescription -match "(complex|integration|implementation|architecture|system|deployment)"
    
    # Determine if TaskMaster is required
    $required = Test-TaskMasterRequirement -Complexity $complexity -Components $components -HasKeywords $hasKeywords -Description $TaskDescription
    
    Write-Host ""
    
    if ($required) {
        # Ask for user confirmation
        $response = Read-Host "Do you want to create a TaskMaster task now? (y/n)"
        
        if ($response -match "^[Yy]$") {
            if (New-TaskMasterTask -Description $TaskDescription -Complexity $complexity) {
                Write-Host ""
                Write-ColorOutput "🎉 READY TO PROCEED" "Green"
                Write-ColorOutput "TaskMaster task created. You can now start implementation." "Green"
            }
            else {
                Write-Host ""
                Write-ColorOutput "⚠️ PROCEEDING WITHOUT TASKMASTER" "Yellow"
                Write-ColorOutput "This is not recommended for complex tasks." "Yellow"
            }
        }
        else {
            Write-Host ""
            Write-ColorOutput "⚠️ PROCEEDING WITHOUT TASKMASTER" "Yellow"
            Write-ColorOutput "Task meets criteria but user declined TaskMaster creation." "Yellow"
        }
    }
    else {
        Write-Host ""
        Write-ColorOutput "✅ READY TO PROCEED" "Green"
        Write-ColorOutput "Task doesn't require TaskMaster tracking." "Green"
    }
    
    Write-Host ""
    Write-ColorOutput "📚 Remember to follow GRUPO US protocols:" "Blue"
    Write-ColorOutput "  • Use Sequential Thinking for complex decisions" "Blue"
    Write-ColorOutput "  • Document all changes in memory bank" "Blue"
    Write-ColorOutput "  • Test thoroughly before completion" "Blue"
    Write-ColorOutput "  • Update relevant .clinerules if needed" "Blue"
    Write-Host ""
}

# Execute main function
Main
