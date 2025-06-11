# TaskMaster + GitLab MCP Integration Rules - GRUPO US VIBECODE SYSTEM V2.0

## 🎯 INTEGRATION OVERVIEW

This document defines the integration patterns between TaskMaster AI CLI and GitLab MCP server, enabling automated bilateral synchronization and enhanced project management capabilities.

## 🔄 AUTOMATIC TRIGGERS

### **Task Completion Triggers**
```bash
# Automatically triggered when:
task_completion_check() {
    local task_id=$1
    local complexity=$(task-master show $task_id --format=json | jq '.complexity // 0')
    local priority=$(task-master show $task_id --format=json | jq -r '.priority // "medium"')
    local tags=$(task-master show $task_id --format=json | jq -r '.tags[]? // empty')

    # Enhanced trigger conditions for GitLab sync
    local should_sync=false

    # Complexity > 7 (major tasks) - triggers gitlab_sync
    if [[ $complexity -gt 7 ]]; then
        echo "🎯 High complexity task ($complexity) completed - triggering GitLab sync"
        should_sync=true
    fi

    # High priority tasks
    if [[ "$priority" == "high" ]]; then
        echo "⚡ High priority task completed - triggering GitLab sync"
        should_sync=true
    fi

    # Specific tags that require sync
    if echo "$tags" | grep -E "(deployment|release|major|milestone|production|hotfix)" >/dev/null; then
        echo "🏷️ Critical tag detected - triggering GitLab sync"
        should_sync=true
    fi

    # Task duration > 4 hours (major effort)
    local duration=$(task-master show $task_id --format=json | jq '.duration // 0')
    if [[ $duration -gt 14400 ]]; then  # 4 hours in seconds
        echo "⏱️ Long-duration task completed - triggering GitLab sync"
        should_sync=true
    fi

    if [[ "$should_sync" == "true" ]]; then
        gitlab_sync_prompt "$task_id"
        gitlab_sync "$task_id"  # Main sync function
    else
        echo "ℹ️ Task completed but doesn't meet GitLab sync criteria"
    fi
}
```

### **Milestone Integration**
```bash
# Sync TaskMaster milestones with GitLab
taskmaster_gitlab_milestone_sync() {
    # Get TaskMaster milestones
    local tm_milestones=$(task-master list --group-by=milestone)
    
    # Create corresponding GitLab milestones
    echo "$tm_milestones" | while read milestone; do
        gitlab_mcp_create_milestone \
            --title="$milestone.title" \
            --description="$milestone.description" \
            --due_date="$milestone.due_date"
    done
}
```

## 🚀 BILATERAL SYNCHRONIZATION WORKFLOWS

### **Workflow 1: Code + Documentation Sync**
```bash
gitlab_code_docs_sync() {
    echo "🔄 Starting Code + Documentation Sync"
    
    # Phase 1: Validate environment
    if ! validate_sync_environment; then
        echo "❌ Environment validation failed"
        return 1
    fi
    
    # Phase 2: Create backup
    create_sync_backup
    
    # Phase 3: Push operations
    echo "📤 Pushing local changes..."
    
    # Get changed files since last sync
    local changed_files=$(git diff --name-only HEAD~1)
    
    if [[ -n "$changed_files" ]]; then
        # Use GitLab MCP for batch file push
        gitlab_mcp_push_files \
            --files="$changed_files" \
            --commit_message="Auto-sync: TaskMaster task completion" \
            --branch="main"
    fi
    
    # Phase 4: Documentation sync
    echo "📚 Syncing documentation..."
    sync_documentation_to_wiki
    
    # Phase 5: Pull operations
    echo "📥 Pulling remote changes..."
    gitlab_pull_and_merge
    
    # Phase 6: Pipeline trigger
    echo "🚀 Triggering CI/CD pipeline..."
    gitlab_mcp_create_pipeline --ref="main" --source="api"
    
    echo "✅ Sync completed successfully"
}
```

### **Workflow 2: Issue and Task Synchronization**
```bash
gitlab_issue_task_sync() {
    echo "🎯 Starting Issue + Task Synchronization"
    
    # Sync TaskMaster tasks to GitLab issues
    task-master list --status=pending --format=json | jq -r '.[]' | while read task; do
        local task_id=$(echo "$task" | jq -r '.id')
        local title=$(echo "$task" | jq -r '.title')
        local description=$(echo "$task" | jq -r '.description')
        local labels=$(echo "$task" | jq -r '.tags | join(",")')
        
        # Check if issue already exists
        local existing_issue=$(gitlab_mcp_list_issues --search="$title" --state=opened)
        
        if [[ -z "$existing_issue" ]]; then
            # Create new GitLab issue
            gitlab_mcp_create_issue \
                --title="$title" \
                --description="$description" \
                --labels="$labels,taskmaster-sync"
        fi
    done
    
    # Sync GitLab issues back to TaskMaster
    gitlab_mcp_list_issues --state=all --labels="taskmaster-sync" | while read issue; do
        local issue_id=$(echo "$issue" | jq -r '.iid')
        local state=$(echo "$issue" | jq -r '.state')
        local title=$(echo "$issue" | jq -r '.title')
        
        # Update corresponding TaskMaster task
        local tm_task_id=$(task-master list --search="$title" --format=json | jq -r '.[0].id')
        
        if [[ -n "$tm_task_id" ]]; then
            case "$state" in
                "closed")
                    task-master set-status --id="$tm_task_id" --status=done
                    ;;
                "opened")
                    task-master set-status --id="$tm_task_id" --status=in-progress
                    ;;
            esac
        fi
    done
    
    echo "✅ Issue synchronization completed"
}
```

### **Workflow 3: Pipeline Integration**
```bash
gitlab_pipeline_integration() {
    echo "🚀 Starting Pipeline Integration"
    
    # Get current task context
    local current_task=$(task-master next --format=json)
    local task_type=$(echo "$current_task" | jq -r '.type')
    
    # Determine pipeline strategy based on task type
    case "$task_type" in
        "deployment")
            gitlab_mcp_create_pipeline --ref="main" --variables='{"DEPLOY_ENV":"production"}'
            ;;
        "testing")
            gitlab_mcp_create_pipeline --ref="develop" --variables='{"RUN_TESTS":"true"}'
            ;;
        "development")
            gitlab_mcp_create_pipeline --ref="feature/$(echo $current_task | jq -r '.id')"
            ;;
    esac
    
    # Monitor pipeline status
    monitor_pipeline_completion
}
```

## 🛡️ SAFETY AND VALIDATION

### **Pre-Sync Validation**
```bash
validate_sync_environment() {
    echo "🔍 Validating sync environment..."
    
    # Check GitLab connectivity
    if ! gitlab_mcp_test_connection; then
        echo "❌ GitLab connection failed"
        return 1
    fi
    
    # Check TaskMaster status
    if ! task-master list >/dev/null 2>&1; then
        echo "❌ TaskMaster not accessible"
        return 1
    fi
    
    # Check for uncommitted changes
    if [[ -n $(git status --porcelain) ]]; then
        echo "⚠️ Uncommitted changes detected"
        prompt_user "Commit changes before sync? (y/n)"
        if [[ $response == "y" ]]; then
            git add .
            git commit -m "Pre-sync commit: $(date)"
        fi
    fi
    
    # Check for large files
    local large_files=$(find . -size +50M -not -path "./.git/*" -not -path "./node_modules/*")
    if [[ -n "$large_files" ]]; then
        echo "⚠️ Large files detected:"
        echo "$large_files"
        prompt_user "Continue with large files? (y/n)"
        if [[ $response != "y" ]]; then
            return 1
        fi
    fi
    
    echo "✅ Environment validation passed"
    return 0
}
```

### **Conflict Resolution with Sequential Thinking**
```bash
resolve_sync_conflicts() {
    local conflict_files=$1
    
    echo "🤔 Complex conflict detected. Using Sequential Thinking..."
    
    # Use Sequential Thinking for complex conflict resolution
    use_sequential_thinking \
        "Analyzing GitLab sync conflicts. Files affected: $conflict_files. Need to determine best resolution strategy considering: code integrity, team collaboration, deployment impact, and data safety."
    
    # Based on Sequential Thinking analysis, provide resolution options
    echo "🔧 Conflict Resolution Options:"
    echo "1. Manual resolution (recommended for complex conflicts)"
    echo "2. Favor local changes (use when local is authoritative)"
    echo "3. Favor remote changes (use when remote is authoritative)"
    echo "4. Create merge request for team review"
    echo "5. Abort sync and seek team consultation"
    
    read -p "Choose resolution strategy (1-5): " strategy
    
    case $strategy in
        1) manual_conflict_resolution ;;
        2) git checkout --ours . && git add . ;;
        3) git checkout --theirs . && git add . ;;
        4) create_conflict_merge_request ;;
        5) abort_sync_with_notification ;;
    esac
}
```

## 📊 MONITORING AND REPORTING

### **Sync Status Reporting**
```bash
generate_sync_report() {
    local sync_id=$1
    local report_file="reports/gitlab-sync-$sync_id-$(date +%Y%m%d-%H%M%S).md"
    
    cat > "$report_file" << EOF
# GitLab Sync Report - $sync_id

## Sync Summary
- **Date**: $(date)
- **Task ID**: $(task-master next --format=json | jq -r '.id')
- **Complexity**: $(task-master next --format=json | jq -r '.complexity')
- **Status**: $sync_status

## Operations Performed
- **Files Pushed**: $files_pushed_count
- **Issues Synced**: $issues_synced_count
- **Pipeline Triggered**: $pipeline_triggered
- **Wiki Updated**: $wiki_updated

## Results
- **Success Rate**: $success_rate%
- **Conflicts Resolved**: $conflicts_resolved
- **Errors**: $error_count

## Next Actions
$next_actions

EOF

    echo "📊 Sync report generated: $report_file"
}
```

### **Performance Metrics**
```bash
track_sync_metrics() {
    local start_time=$(date +%s)
    
    # Perform sync operations
    gitlab_bilateral_sync
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Log metrics
    echo "$(date),gitlab_sync,$duration,$files_count,$success_rate" >> metrics/sync_performance.csv
    
    # Update TaskMaster with sync completion
    task-master add-task \
        --prompt="GitLab sync completed in ${duration}s" \
        --type=system \
        --priority=low \
        --status=done
}
```

## 🎯 USER INTERACTION PATTERNS

### **Sync Confirmation Dialog**
```bash
gitlab_sync_confirmation() {
    local task_info=$(task-master show $1 --format=json)
    local task_title=$(echo "$task_info" | jq -r '.title')
    local complexity=$(echo "$task_info" | jq -r '.complexity')
    
    echo "🔄 GitLab Bilateral Synchronization Request"
    echo "=========================================="
    echo "Task: $task_title"
    echo "Complexity: $complexity/10"
    echo ""
    echo "Planned Operations:"
    echo "  📤 Push local changes to GitLab"
    echo "  📥 Pull remote updates to local"
    echo "  📚 Sync documentation to wiki"
    echo "  🎯 Update issues and milestones"
    echo "  🚀 Trigger CI/CD pipeline"
    echo ""
    echo "Estimated time: 2-5 minutes"
    echo "Risk level: Low (backup will be created)"
    echo ""
    
    read -p "Proceed with synchronization? (y/n): " response
    
    if [[ $response == "y" ]]; then
        gitlab_bilateral_sync
    else
        echo "Sync cancelled by user"
        task-master add-task \
            --prompt="GitLab sync cancelled for task: $task_title" \
            --type=note \
            --priority=low
    fi
}
```

## 🔧 CONFIGURATION MANAGEMENT

### **Dynamic Configuration**
```bash
# GitLab MCP configuration based on project context
configure_gitlab_mcp_for_project() {
    local project_type=$(detect_project_type)
    
    case "$project_type" in
        "saas-clinicas")
            export USE_GITLAB_WIKI=true
            export USE_MILESTONE=true
            export USE_PIPELINE=true
            export GITLAB_READ_ONLY_MODE=false
            ;;
        "saas-financeiro")
            export USE_GITLAB_WIKI=true
            export USE_MILESTONE=true
            export USE_PIPELINE=true
            export GITLAB_READ_ONLY_MODE=false
            ;;
        "development")
            export USE_GITLAB_WIKI=false
            export USE_MILESTONE=false
            export USE_PIPELINE=true
            export GITLAB_READ_ONLY_MODE=false
            ;;
    esac
    
    echo "✅ GitLab MCP configured for: $project_type"
}
```

---

*These integration rules provide seamless coordination between TaskMaster AI CLI and GitLab MCP, enabling automated workflows while maintaining safety and user control.*
