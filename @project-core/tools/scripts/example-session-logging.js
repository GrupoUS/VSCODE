#!/usr/bin/env node

/**
 * EXAMPLE: How to log session data for New Task Automation Protocol monitoring
 * 
 * This script demonstrates how to programmatically log session data
 * for monitoring the New Task Automation Protocol effectiveness
 */

const NewTaskAutomationMonitor = require('./monitor-new-task-automation.js');

// Initialize monitor
const monitor = new NewTaskAutomationMonitor();

// Example: Log Session 1 (Current session - baseline)
console.log('📊 Logging Session 1 - Baseline Data...');

monitor.logSession({
  sessionNumber: 1,
  date: '2025-06-06',
  taskType: 'Protocol Implementation',
  complexity: 5,
  duration: '~45 minutes',
  contextUsage: 75,
  handoffTriggered: false,
  handoffSuccessful: null,
  userResponse: null,
  userSatisfaction: 10,
  reworkPercentage: 0,
  contextLossIncidents: 0,
  notes: 'Successfully implemented New Task Automation Protocol with 90% threshold. User explicitly requested 90% vs 80% for optimal workflow balance. Protocol created with comprehensive documentation and monitoring system.'
});

// Example: Log a hypothetical Session 2 with handoff
console.log('\n📊 Example: Logging hypothetical Session 2 with handoff...');

monitor.logSession({
  sessionNumber: 2,
  date: '2025-06-06',
  taskType: 'Complex Feature Implementation',
  complexity: 8,
  duration: '~90 minutes',
  contextUsage: 91,
  handoffTriggered: true,
  handoffSuccessful: true,
  userResponse: 'Yes, create new task',
  userSatisfaction: 9,
  reworkPercentage: 0,
  contextLossIncidents: 0,
  notes: 'First successful handoff at 91% context usage. User approved handoff immediately. All 8 context sections populated correctly. Seamless continuation in new session.'
});

// Example: Log a hypothetical Session 3 with declined handoff
console.log('\n📊 Example: Logging hypothetical Session 3 with declined handoff...');

monitor.logSession({
  sessionNumber: 3,
  date: '2025-06-06',
  taskType: 'Bug Investigation',
  complexity: 7,
  duration: '~60 minutes',
  contextUsage: 92,
  handoffTriggered: true,
  handoffSuccessful: false,
  userResponse: 'Continue in current session',
  userSatisfaction: 8,
  reworkPercentage: 5,
  contextLossIncidents: 1,
  notes: 'User declined handoff to finish debugging. Context overflow occurred at 98%, causing minor context loss. Emergency cleanup activated. User satisfied with option to decline.'
});

// Generate report after logging examples
console.log('\n📈 Generating monitoring report...');
monitor.displayDashboard();

console.log(`
🎯 MONITORING USAGE INSTRUCTIONS:

1. **Manual Session Logging:**
   const monitor = new NewTaskAutomationMonitor();
   monitor.logSession({
     sessionNumber: X,
     taskType: 'Task Description',
     complexity: 1-10,
     contextUsage: 0-100,
     userSatisfaction: 1-10,
     // ... other fields
   });

2. **Generate Reports:**
   npm run monitor:nta-report

3. **View Dashboard:**
   npm run monitor:new-task-automation

4. **Session Data Location:**
   memory-bank/new-task-automation-monitoring.md

📋 REQUIRED FIELDS:
- sessionNumber: Sequential session number
- taskType: Description of task performed
- complexity: 1-10 complexity rating
- contextUsage: 0-100 percentage of context used
- userSatisfaction: 1-10 satisfaction rating

📋 OPTIONAL FIELDS:
- handoffTriggered: boolean (default: false)
- handoffSuccessful: boolean (default: null)
- userResponse: string (user's response to handoff)
- reworkPercentage: 0-100 (default: 0)
- contextLossIncidents: number (default: 0)
- notes: string (additional observations)

🔄 NEXT STEPS:
1. Monitor real sessions for next 10 sessions
2. Log data after each session using this script
3. Generate reports every 2-3 sessions
4. Analyze patterns for Phase 2 optimization
`);
