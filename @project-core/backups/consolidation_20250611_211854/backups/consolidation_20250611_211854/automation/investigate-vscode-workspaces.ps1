# VS CODE WORKSPACE INVESTIGATION - GRUPO US VIBECODE SYSTEM V3.1
# Investigates VS Code workspaces and locates Augment memory files

param(
    [string]$VSCodeWorkspaceRoot = "C:\Users\Admin\AppData\Roaming\Code\User\workspaceStorage",
    [switch]$CreateMissingFile = $false,
    [switch]$DetailedAnalysis = $true
)

Write-Host "🔍 VS CODE WORKSPACE INVESTIGATION" -ForegroundColor Cyan
Write-Host "Root Path: $VSCodeWorkspaceRoot" -ForegroundColor Gray
Write-Host ""

# Check if VS Code workspace storage exists
if (-not (Test-Path $VSCodeWorkspaceRoot)) {
    Write-Host "❌ ERROR: VS Code workspace storage not found!" -ForegroundColor Red
    Write-Host "Path: $VSCodeWorkspaceRoot" -ForegroundColor Red
    Write-Host ""
    Write-Host "Possible causes:" -ForegroundColor Yellow
    Write-Host "1. VS Code not installed" -ForegroundColor White
    Write-Host "2. VS Code never opened" -ForegroundColor White
    Write-Host "3. Different user profile" -ForegroundColor White
    exit 1
}

Write-Host "✅ VS Code workspace storage found" -ForegroundColor Green
Write-Host ""

# Get all workspace directories
$workspaces = Get-ChildItem $VSCodeWorkspaceRoot -Directory -ErrorAction SilentlyContinue

if ($workspaces.Count -eq 0) {
    Write-Host "⚠️ WARNING: No workspaces found in VS Code storage" -ForegroundColor Yellow
    exit 1
}

Write-Host "📂 WORKSPACE ANALYSIS:" -ForegroundColor Yellow
Write-Host "Total workspaces found: $($workspaces.Count)" -ForegroundColor White
Write-Host ""

$augmentWorkspaces = @()
$targetWorkspaceId = "f93728a73b8802154d6c1bd441b921c0"

foreach ($workspace in $workspaces) {
    $workspaceId = $workspace.Name
    $augmentPath = Join-Path $workspace.FullName "Augment.vscode-augment"
    $memoryFile = Join-Path $augmentPath "Augment-Memories"
    
    Write-Host "Workspace ID: $workspaceId" -ForegroundColor Cyan
    
    if (Test-Path $augmentPath) {
        Write-Host "  ✅ Augment folder found" -ForegroundColor Green
        
        if (Test-Path $memoryFile) {
            $fileSize = (Get-Item $memoryFile).Length
            $lastModified = (Get-Item $memoryFile).LastWriteTime
            Write-Host "  ✅ Memory file found ($([math]::Round($fileSize/1024, 2)) KB)" -ForegroundColor Green
            Write-Host "  📅 Last modified: $lastModified" -ForegroundColor White
            
            $augmentWorkspaces += @{
                WorkspaceId = $workspaceId
                Path = $memoryFile
                Size = $fileSize
                LastModified = $lastModified
                IsTarget = ($workspaceId -eq $targetWorkspaceId)
            }
        } else {
            Write-Host "  ❌ Memory file not found" -ForegroundColor Red
        }
    } else {
        Write-Host "  ❌ No Augment folder" -ForegroundColor Red
    }
    
    if ($DetailedAnalysis) {
        # Check for workspace.json or other identifying files
        $workspaceJson = Join-Path $workspace.FullName "workspace.json"
        if (Test-Path $workspaceJson) {
            try {
                $workspaceData = Get-Content $workspaceJson -Raw | ConvertFrom-Json
                if ($workspaceData.folder) {
                    Write-Host "  📁 Workspace folder: $($workspaceData.folder)" -ForegroundColor Gray
                }
            } catch {
                Write-Host "  ⚠️ Could not parse workspace.json" -ForegroundColor Yellow
            }
        }
    }
    
    Write-Host ""
}

# Summary of findings
Write-Host "📊 INVESTIGATION SUMMARY:" -ForegroundColor Magenta
Write-Host ""

if ($augmentWorkspaces.Count -eq 0) {
    Write-Host "❌ No Augment memory files found in any workspace" -ForegroundColor Red
    Write-Host ""
    Write-Host "Recommendations:" -ForegroundColor Yellow
    Write-Host "1. Open VS Code and use Augment to create memory file" -ForegroundColor White
    Write-Host "2. Check if Augment extension is installed in VS Code" -ForegroundColor White
    Write-Host "3. Verify VS Code user profile" -ForegroundColor White
} else {
    Write-Host "✅ Found $($augmentWorkspaces.Count) workspace(s) with Augment memory files:" -ForegroundColor Green
    Write-Host ""
    
    foreach ($workspace in $augmentWorkspaces) {
        $status = if ($workspace.IsTarget) { "🎯 TARGET" } else { "📁 FOUND" }
        Write-Host "$status Workspace: $($workspace.WorkspaceId)" -ForegroundColor $(if($workspace.IsTarget){'Green'}else{'White'})
        Write-Host "   Path: $($workspace.Path)" -ForegroundColor Gray
        Write-Host "   Size: $([math]::Round($workspace.Size/1024, 2)) KB" -ForegroundColor Gray
        Write-Host "   Modified: $($workspace.LastModified)" -ForegroundColor Gray
        Write-Host ""
    }
    
    # Find the most recent or target workspace
    $targetWorkspace = $augmentWorkspaces | Where-Object { $_.IsTarget }
    $mostRecentWorkspace = $augmentWorkspaces | Sort-Object LastModified -Descending | Select-Object -First 1
    
    if ($targetWorkspace) {
        Write-Host "🎯 TARGET WORKSPACE FOUND:" -ForegroundColor Green
        Write-Host "Workspace ID: $($targetWorkspace.WorkspaceId)" -ForegroundColor White
        Write-Host "Memory File: $($targetWorkspace.Path)" -ForegroundColor White
        Write-Host "Status: ✅ MATCHES EXPECTED CONFIGURATION" -ForegroundColor Green
    } else {
        Write-Host "⚠️ TARGET WORKSPACE NOT FOUND" -ForegroundColor Yellow
        Write-Host "Expected ID: $targetWorkspaceId" -ForegroundColor Gray
        Write-Host ""
        Write-Host "🔄 MOST RECENT WORKSPACE:" -ForegroundColor Cyan
        Write-Host "Workspace ID: $($mostRecentWorkspace.WorkspaceId)" -ForegroundColor White
        Write-Host "Memory File: $($mostRecentWorkspace.Path)" -ForegroundColor White
        Write-Host "Last Modified: $($mostRecentWorkspace.LastModified)" -ForegroundColor White
        Write-Host ""
        Write-Host "RECOMMENDATION: Update configuration to use most recent workspace" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "🔧 NEXT STEPS:" -ForegroundColor Magenta

if ($augmentWorkspaces.Count -eq 0) {
    Write-Host "1. Install/activate Augment extension in VS Code" -ForegroundColor White
    Write-Host "2. Open a project in VS Code to create workspace" -ForegroundColor White
    Write-Host "3. Use Augment to generate memory file" -ForegroundColor White
    Write-Host "4. Re-run this investigation" -ForegroundColor White
} elseif (-not $targetWorkspace) {
    Write-Host "1. Update Cursor configuration to use most recent workspace" -ForegroundColor White
    Write-Host "2. Validate unified memory system functionality" -ForegroundColor White
    Write-Host "3. Test synchronization between VS Code and Cursor" -ForegroundColor White
} else {
    Write-Host "1. Validate that target workspace is accessible" -ForegroundColor White
    Write-Host "2. Test unified memory system functionality" -ForegroundColor White
    Write-Host "3. Confirm synchronization is working" -ForegroundColor White
}

Write-Host ""
Write-Host "✅ INVESTIGATION COMPLETE!" -ForegroundColor Green

# Return results for further processing
return @{
    TotalWorkspaces = $workspaces.Count
    AugmentWorkspaces = $augmentWorkspaces
    TargetFound = ($targetWorkspace -ne $null)
    MostRecent = $mostRecentWorkspace
    Recommendation = if ($targetWorkspace) { "TARGET_FOUND" } elseif ($augmentWorkspaces.Count -gt 0) { "UPDATE_CONFIG" } else { "CREATE_WORKSPACE" }
}
