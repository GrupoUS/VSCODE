#!/bin/bash

# Pre-Task Checklist Script
# GRUPO US VIBECODE SYSTEM V2.0
# 
# This script enforces TaskMaster integration for complex tasks
# and prevents protocol violations like the GitLab MCP integration oversight.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to print header
print_header() {
    echo ""
    print_status $BLUE "🔍 PRE-TASK ASSESSMENT - GRUPO US VIBECODE SYSTEM V2.0"
    print_status $BLUE "======================================================="
    echo ""
}

# Function to assess task complexity automatically
assess_complexity() {
    local task_description="$1"
    local auto_complexity=5
    local keyword_count=0
    
    # Define complexity keywords
    local keywords=("complex" "integration" "implementation" "architecture" "system" "mcp" "server" "deployment" "migration" "refactor" "optimization")
    
    print_status $BLUE "📊 AUTOMATIC COMPLEXITY ASSESSMENT"
    print_status $BLUE "===================================="
    
    # Check for keywords
    for keyword in "${keywords[@]}"; do
        if echo "$task_description" | grep -qi "$keyword"; then
            ((keyword_count++))
            print_status $YELLOW "🏷️ Keyword detected: $keyword"
        fi
    done
    
    # Calculate complexity based on keywords
    if [[ $keyword_count -gt 3 ]]; then
        auto_complexity=9
    elif [[ $keyword_count -gt 2 ]]; then
        auto_complexity=8
    elif [[ $keyword_count -gt 1 ]]; then
        auto_complexity=7
    elif [[ $keyword_count -gt 0 ]]; then
        auto_complexity=6
    fi
    
    echo ""
    print_status $BLUE "📈 ASSESSMENT RESULTS:"
    print_status $BLUE "Keywords detected: $keyword_count"
    print_status $BLUE "Estimated complexity: $auto_complexity/10"
    
    echo $auto_complexity
}

# Function to check for multi-component tasks
assess_components() {
    local task_description="$1"
    local component_count=1
    
    # Define component indicators
    local components=("mcp" "server" "integration" "api" "database" "frontend" "backend" "auth" "deployment" "testing" "documentation")
    
    for component in "${components[@]}"; do
        if echo "$task_description" | grep -qi "$component"; then
            ((component_count++))
        fi
    done
    
    echo $component_count
}

# Function to determine if TaskMaster is required
determine_taskmaster_requirement() {
    local complexity=$1
    local components=$2
    local has_keywords=$3
    local task_description="$4"
    
    print_status $BLUE ""
    print_status $BLUE "🎯 TASKMASTER REQUIREMENT ANALYSIS"
    print_status $BLUE "==================================="
    
    local required=false
    local reasons=()
    
    # Check complexity threshold
    if [[ $complexity -gt 7 ]]; then
        required=true
        reasons+=("High complexity ($complexity/10)")
    fi
    
    # Check component count
    if [[ $components -gt 3 ]]; then
        required=true
        reasons+=("Multi-component task ($components components)")
    fi
    
    # Check for critical keywords
    if [[ $has_keywords == "true" ]]; then
        required=true
        reasons+=("Critical keywords detected")
    fi
    
    # Check task length (rough estimate)
    local word_count=$(echo "$task_description" | wc -w)
    if [[ $word_count -gt 20 ]]; then
        required=true
        reasons+=("Detailed task description ($word_count words)")
    fi
    
    if [[ $required == "true" ]]; then
        print_status $RED "🚨 TASKMASTER REQUIRED"
        print_status $YELLOW "Reasons:"
        for reason in "${reasons[@]}"; do
            print_status $YELLOW "  • $reason"
        done
    else
        print_status $GREEN "ℹ️ TaskMaster optional for this task"
    fi
    
    echo $required
}

# Function to create TaskMaster task
create_taskmaster_task() {
    local task_description="$1"
    local complexity=$2
    
    print_status $BLUE ""
    print_status $BLUE "📝 CREATING TASKMASTER TASK"
    print_status $BLUE "============================"
    
    # Enhanced task description with metadata
    local enhanced_description="$task_description [Complexity: $complexity/10] [Auto-created by pre-task-checklist]"
    
    print_status $YELLOW "Creating TaskMaster task..."
    
    if task-master add-task --prompt="$enhanced_description" --priority=high; then
        print_status $GREEN "✅ TaskMaster task created successfully"
        
        # Get the latest task ID
        local task_id=$(task-master list --format=json 2>/dev/null | jq -r '.[0].id' 2>/dev/null || echo "unknown")
        
        if [[ "$task_id" != "unknown" && "$task_id" != "null" ]]; then
            print_status $GREEN "📋 Task ID: $task_id"
            print_status $BLUE "💡 Use 'task-master show $task_id' to view details"
            print_status $BLUE "💡 Use 'task-master set-status --id=$task_id --status=in-progress' to start working"
        fi
        
        return 0
    else
        print_status $RED "❌ Failed to create TaskMaster task"
        print_status $YELLOW "⚠️ Proceeding without TaskMaster (not recommended)"
        return 1
    fi
}

# Function to check if TaskMaster is accessible
check_taskmaster_accessibility() {
    print_status $BLUE "🔧 CHECKING TASKMASTER ACCESSIBILITY"
    print_status $BLUE "====================================="
    
    if command -v task-master >/dev/null 2>&1; then
        local version=$(task-master --version 2>/dev/null | head -1 || echo "unknown")
        print_status $GREEN "✅ TaskMaster CLI accessible: $version"
        return 0
    else
        print_status $RED "❌ TaskMaster CLI not found"
        print_status $YELLOW "Install with: npm install -g task-master-ai"
        return 1
    fi
}

# Main function
main() {
    local task_description="$1"
    
    # Check if task description is provided
    if [[ -z "$task_description" ]]; then
        print_header
        print_status $RED "❌ Error: Task description required"
        echo ""
        print_status $BLUE "Usage: $0 \"Your task description here\""
        echo ""
        print_status $BLUE "Example: $0 \"Implement GitLab MCP integration with bilateral synchronization\""
        exit 1
    fi
    
    print_header
    print_status $BLUE "Task: $task_description"
    echo ""
    
    # Check TaskMaster accessibility first
    if ! check_taskmaster_accessibility; then
        print_status $YELLOW "⚠️ TaskMaster not accessible. Skipping assessment."
        exit 1
    fi
    
    echo ""
    
    # Perform automatic assessments
    local complexity=$(assess_complexity "$task_description")
    local components=$(assess_components "$task_description")
    
    # Check for critical keywords manually
    local has_keywords="false"
    if echo "$task_description" | grep -qi -E "(complex|integration|implementation|architecture|system|deployment)"; then
        has_keywords="true"
    fi
    
    # Determine if TaskMaster is required
    local required=$(determine_taskmaster_requirement $complexity $components $has_keywords "$task_description")
    
    echo ""
    
    if [[ $required == "true" ]]; then
        # Ask for user confirmation
        print_status $YELLOW "Do you want to create a TaskMaster task now? (y/n): "
        read -r response
        
        if [[ $response =~ ^[Yy]$ ]]; then
            if create_taskmaster_task "$task_description" $complexity; then
                print_status $GREEN ""
                print_status $GREEN "🎉 READY TO PROCEED"
                print_status $GREEN "TaskMaster task created. You can now start implementation."
            else
                print_status $YELLOW ""
                print_status $YELLOW "⚠️ PROCEEDING WITHOUT TASKMASTER"
                print_status $YELLOW "This is not recommended for complex tasks."
            fi
        else
            print_status $YELLOW ""
            print_status $YELLOW "⚠️ PROCEEDING WITHOUT TASKMASTER"
            print_status $YELLOW "Task meets criteria but user declined TaskMaster creation."
        fi
    else
        print_status $GREEN ""
        print_status $GREEN "✅ READY TO PROCEED"
        print_status $GREEN "Task doesn't require TaskMaster tracking."
    fi
    
    echo ""
    print_status $BLUE "📚 Remember to follow GRUPO US protocols:"
    print_status $BLUE "  • Use Sequential Thinking for complex decisions"
    print_status $BLUE "  • Document all changes in memory bank"
    print_status $BLUE "  • Test thoroughly before completion"
    print_status $BLUE "  • Update relevant .clinerules if needed"
    echo ""
}

# Run main function with all arguments
main "$*"
