# GitLab MCP Automation Rules - GRUPO US VIBECODE SYSTEM V2.0

## 🎯 AUTOMATION TRIGGERS

### **Automatic Activation Conditions**
GitLab MCP automation is triggered when:

1. **Task Completion** (TaskMaster integration):
   - Task complexity > 7 (major tasks)
   - Tasks marked with priority "high" 
   - Tasks tagged as "deployment", "release", or "major"
   - Milestone completion in TaskMaster

2. **Manual Triggers**:
   - User requests sync with "sync gitlab" command
   - After completing large code changes
   - Before major deployments
   - During release preparation

3. **Scheduled Triggers**:
   - Daily sync for active projects
   - Weekly comprehensive sync
   - Pre-deployment validation

## 🔄 BILATERAL SYNCHRONIZATION WORKFLOW

### **Phase 1: Pre-Sync Validation**
```bash
# 1. Check GitLab connectivity
gitlab_mcp_test_connection()

# 2. Validate local repository state
git status --porcelain

# 3. Check for uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
    prompt_user "Uncommitted changes detected. Commit before sync? (y/n)"
fi

# 4. Backup current state
create_backup_branch "backup-$(date +%Y%m%d-%H%M%S)"
```

### **Phase 2: Push Operations (Local → GitLab)**
```bash
# 1. Push code changes
gitlab_push_files() {
    # Get changed files
    changed_files=$(git diff --name-only HEAD~1)
    
    # Use GitLab MCP push_files for batch operation
    gitlab_mcp_push_files "$changed_files" "Auto-sync from TaskMaster completion"
}

# 2. Update documentation
gitlab_sync_wiki() {
    # Sync README and docs to GitLab wiki
    gitlab_mcp_create_or_update_wiki_page "Project Documentation" "docs/README.md"
    gitlab_mcp_create_or_update_wiki_page "API Documentation" "docs/API.md"
}

# 3. Create/update issues
gitlab_sync_issues() {
    # Sync TaskMaster tasks as GitLab issues
    task-master list --status=pending | while read task; do
        gitlab_mcp_create_issue "$task.title" "$task.description" "$task.labels"
    done
}

# 4. Trigger CI/CD pipeline
gitlab_trigger_pipeline() {
    gitlab_mcp_create_pipeline "main" "Auto-triggered from sync"
}
```

### **Phase 3: Pull Operations (GitLab → Local)**
```bash
# 1. Fetch remote changes
gitlab_pull_changes() {
    # Get latest commits
    remote_commits=$(gitlab_mcp_get_repository_tree "main")
    
    # Check for conflicts
    if git merge-tree $(git merge-base HEAD origin/main) HEAD origin/main | grep -q "<<<<<<< "; then
        handle_merge_conflicts
    else
        git pull origin main
    fi
}

# 2. Sync issue updates
gitlab_sync_issue_updates() {
    # Get updated issues from GitLab
    gitlab_issues=$(gitlab_mcp_list_issues --state=all --updated_after="24h")
    
    # Update corresponding TaskMaster tasks
    echo "$gitlab_issues" | while read issue; do
        task-master update-task --id="$issue.id" --status="$issue.state"
    done
}

# 3. Process pipeline results
gitlab_process_pipeline_results() {
    # Get latest pipeline status
    pipeline_status=$(gitlab_mcp_list_pipelines --status=latest)
    
    if [[ "$pipeline_status" == "failed" ]]; then
        notify_user "GitLab pipeline failed. Check logs."
        gitlab_mcp_get_pipeline_job_output "$pipeline_id"
    fi
}
```

### **Phase 4: Conflict Resolution**
```bash
handle_merge_conflicts() {
    echo "🚨 MERGE CONFLICTS DETECTED"
    echo "Files with conflicts:"
    git diff --name-only --diff-filter=U
    
    prompt_user "How to resolve conflicts?"
    select option in "Manual resolution" "Favor local" "Favor remote" "Abort sync"; do
        case $option in
            "Manual resolution")
                echo "Opening merge tool..."
                git mergetool
                ;;
            "Favor local")
                git checkout --ours .
                git add .
                ;;
            "Favor remote")
                git checkout --theirs .
                git add .
                ;;
            "Abort sync")
                git merge --abort
                return 1
                ;;
        esac
        break
    done
}
```

## 🎯 TASKMASTER INTEGRATION

### **Task Completion Hook**
```bash
# Add to TaskMaster completion workflow
task_completion_hook() {
    local task_id=$1
    local complexity=$(task-master show $task_id | grep "Complexity:" | cut -d: -f2)
    
    if [[ $complexity -gt 7 ]] || [[ $(task-master show $task_id | grep -i "major\|deployment\|release") ]]; then
        echo "🔄 Major task completed. Sync with GitLab?"
        prompt_user "Synchronize changes with remote repository? (y/n)"
        
        if [[ $response == "y" ]]; then
            gitlab_bilateral_sync
        fi
    fi
}
```

### **Sequential Thinking Integration**
```bash
# Use Sequential Thinking for complex sync decisions
gitlab_complex_sync_decision() {
    # Trigger Sequential Thinking for complex scenarios
    use_sequential_thinking "Analyzing GitLab sync requirements for complex task completion. Factors: code changes, documentation updates, CI/CD implications, team coordination needs."
}
```

## 🛡️ SAFETY MEASURES

### **Backup Strategy**
```bash
create_sync_backup() {
    local backup_name="gitlab-sync-backup-$(date +%Y%m%d-%H%M%S)"
    
    # Create local backup branch
    git checkout -b "$backup_name"
    git checkout main
    
    # Export current state
    git archive --format=tar.gz --output="backups/$backup_name.tar.gz" HEAD
    
    echo "✅ Backup created: $backup_name"
}
```

### **Validation Checks**
```bash
validate_sync_safety() {
    # Check for uncommitted changes
    if [[ -n $(git status --porcelain) ]]; then
        echo "⚠️ Uncommitted changes detected"
        return 1
    fi
    
    # Check GitLab connectivity
    if ! gitlab_mcp_test_connection; then
        echo "❌ GitLab connection failed"
        return 1
    fi
    
    # Check for large files
    large_files=$(find . -size +50M -not -path "./.git/*")
    if [[ -n $large_files ]]; then
        echo "⚠️ Large files detected: $large_files"
        prompt_user "Continue with large files? (y/n)"
    fi
    
    return 0
}
```

### **Rollback Capabilities**
```bash
gitlab_sync_rollback() {
    local backup_branch=$1
    
    echo "🔄 Rolling back to: $backup_branch"
    
    # Restore from backup
    git checkout "$backup_branch"
    git checkout -b "rollback-$(date +%Y%m%d-%H%M%S)"
    git checkout main
    git reset --hard "$backup_branch"
    
    echo "✅ Rollback completed"
}
```

## 📋 USER PROMPTS AND CONFIRMATIONS

### **Sync Confirmation Dialog**
```bash
gitlab_sync_prompt() {
    echo "🔄 GitLab Bilateral Synchronization"
    echo "=================================="
    echo "Task: $(task-master show $task_id | head -1)"
    echo "Complexity: $complexity"
    echo ""
    echo "Sync operations to perform:"
    echo "  📤 Push: Local changes to GitLab"
    echo "  📥 Pull: Remote changes to local"
    echo "  📚 Wiki: Documentation updates"
    echo "  🎯 Issues: Task synchronization"
    echo "  🚀 Pipeline: CI/CD trigger"
    echo ""
    
    prompt_user "Proceed with synchronization? (y/n)"
}
```

### **Conflict Resolution Dialog**
```bash
conflict_resolution_prompt() {
    echo "🚨 SYNCHRONIZATION CONFLICTS"
    echo "============================="
    echo "Conflicts detected in:"
    git diff --name-only --diff-filter=U | while read file; do
        echo "  ⚠️ $file"
    done
    echo ""
    echo "Resolution options:"
    echo "  1. Manual resolution (recommended)"
    echo "  2. Favor local changes"
    echo "  3. Favor remote changes"
    echo "  4. Abort synchronization"
    echo ""
    
    read -p "Choose option (1-4): " choice
}
```

## 🎯 INTEGRATION WITH EXISTING SYSTEMS

### **GitHub Compatibility**
```bash
# Ensure GitLab sync doesn't conflict with GitHub
github_gitlab_coordination() {
    # Check if GitHub sync is in progress
    if [[ -f ".github_sync_lock" ]]; then
        echo "⏳ GitHub sync in progress. Waiting..."
        wait_for_github_sync_completion
    fi
    
    # Create GitLab sync lock
    touch ".gitlab_sync_lock"
    
    # Perform GitLab operations
    gitlab_bilateral_sync
    
    # Remove lock
    rm ".gitlab_sync_lock"
}
```

### **MCP Initialization Protocol Update**
```bash
# Add to MCP initialization checklist
gitlab_mcp_status_check() {
    echo "🔍 GitLab MCP Status Check"
    
    # Test GitLab connectivity
    if gitlab_mcp_test_connection; then
        echo "✅ GitLab MCP: CONNECTED"
    else
        echo "❌ GitLab MCP: CONNECTION FAILED"
        return 1
    fi
    
    # Verify environment variables
    if [[ -n "$GITLAB_PERSONAL_ACCESS_TOKEN" ]]; then
        echo "✅ GitLab Token: CONFIGURED"
    else
        echo "❌ GitLab Token: MISSING"
        return 1
    fi
    
    return 0
}
```

---

*These automation rules provide comprehensive bilateral synchronization between local development and GitLab, integrated with TaskMaster workflows and following GRUPO US safety standards.*
