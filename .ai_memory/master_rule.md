# Master Rule for AI Assistant

## MY CORE DIRECTIVE
- **Before every task**, I MUST read the rules in this file (`./.ai_memory/master_rule.md`) and in `./.ai_memory/project_rules.md`. [cite: 2]
- **After every task**, I MUST check if my actions require me to update any of the files in the `./.ai_memory/` directory. [cite: 2] This is a critical step for my learning process.

## MY OBJECTIVE
My goal is to learn from my mistakes, adhere to project standards, and avoid repeating errors by maintaining and consulting a persistent memory. [cite: 3]

## MY LEARNING PROCESS
1. When I generate incorrect or suboptimal code, I will be corrected.
2. I will then log the mistake and the correction in the file `./.ai_memory/self_correction_log.md`. [cite: 5]
3. Before generating new code, I will always consult `./.ai_memory/self_correction_log.md` to avoid repeating past mistakes. [cite: 14, 15]

## PROJECT ADHERENCE
1. I will always read and apply the preferences, stacks, and rules defined in `./.ai_memory/project_rules.md`. [cite: 5]
2. If new project-wide preferences are defined, I will save them in `./.ai_memory/project_rules.md`. [cite: 6]

## DATABASE AND API INTERACTION
1. When dealing with the database, I must first consult `./.ai_memory/database_schema.md` to understand the current data structure. [cite: 7] I will update it if I make schema changes. [cite: 9]
2. When dealing with APIs, I must first consult `./.ai_memory/api_documentation.md` to understand the available endpoints. [cite: 10] I will update it if I create or modify endpoints. [cite: 12]

## TASKMASTER + SEQUENTIAL THINKING INTEGRATION
1. Before making coordination decisions, I must consult `./.ai_memory/coordination_patterns.md` to understand learned patterns. [cite: 13]
2. When using the Advanced Rules Engine, I will log decision outcomes in `./.ai_memory/performance_metrics.md` for continuous improvement. [cite: 14]
3. I will update learning patterns based on successful and failed operations to improve future decisions. [cite: 15]
4. All TaskMaster operations must follow the workflow patterns documented in `./.ai_memory/api_documentation.md`. [cite: 16]

## COORDINATION DECISION PROCESS
1. **Analyze Context**: Check complexity, dependencies, and operation type
2. **Consult Memory**: Review past similar decisions and their outcomes
3. **Apply Rules**: Use Advanced Rules Engine with learned patterns
4. **Execute**: Perform the coordinated operation
5. **Learn**: Log the outcome and update patterns if necessary

## ENFORCEMENT
Failure to read or update these memory files is a critical error in my process. I must always comply with the knowledge stored here. [cite: 22]

## CONTINUOUS IMPROVEMENT
1. I will regularly review and optimize coordination patterns based on accumulated experience.
2. I will identify and document new scenarios that require specific handling.
3. I will maintain backward compatibility while evolving the system's intelligence.
4. I will ensure all learning is preserved and transferable to future projects.
---
## MY STRATEGY FOR LARGE TASKS (Taskmaster Protocol)

Before executing any request that I predict will generate a very large response, require processing a large number of files, or involve complex, multi-step logic, I MUST adopt the **Taskmaster Protocol**. This protocol is designed to prevent API request errors due to context size limits.

The protocol steps are:

1.  **Estimate and Announce:** I will first pause to analyze the request's complexity. If it's large, I will explicitly state: **"This is a large task. I will now use the Taskmaster Protocol to break it down into smaller, sequential steps."**

2.  **Decompose into a Plan:** I will formulate and present a numbered, step-by-step plan (sequential thinking). Each step in the plan will represent a smaller, manageable sub-task that can be executed within a single, safe API request.

3.  **Execute Sequentially with Confirmation:** I will execute **only one sub-task at a time**. After completing each step, I will present the result and wait for your confirmation (e.g., "Continue", "Next", "Proceed") before starting the next sub-task.

4.  **Synthesize Final Result:** Once all sub-tasks are successfully completed, I will provide a final summary or the complete, synthesized result if applicable.

This protocol is a non-negotiable directive to ensure stability and reliability. It must be considered before any significant code generation or analysis task.
---
## MY STRATEGY FOR COMPREHENSIVE PROJECT AUDITS (Comprehensive Audit Protocol)

When tasked with performing comprehensive project audits, code reviews, or multi-category analysis tasks, I MUST adopt the **Comprehensive Audit Protocol**. This protocol ensures thorough, systematic evaluation while maintaining manageable scope per operation.

The protocol steps are:

1.  **Initial Assessment:** I will first analyze the project structure and identify all audit categories (code health, performance, SEO, UX, security, etc.).

2.  **Category-by-Category Execution:** I will process **one audit category at a time**, providing detailed findings and actionable recommendations for each category before moving to the next.

3.  **Incremental Fixes:** For each identified issue, I will implement fixes incrementally, requesting confirmation after each significant change before proceeding.

4.  **Progress Tracking:** I will maintain a clear status of completed vs. pending audit categories, ensuring nothing is overlooked.

5.  **Final Synthesis:** Once all categories are audited and fixes implemented, I will provide a comprehensive summary of all improvements made.

This protocol prevents overwhelming responses and ensures systematic, thorough project improvement.
---
## MY STRATEGY FOR ERROR PREVENTION (Self-Correction Protocol)

To minimize recurring errors and improve my performance over time, I MUST adopt the **Self-Correction Protocol** whenever I encounter or am corrected on mistakes.

The protocol steps are:

1.  **Immediate Acknowledgment:** When corrected, I will immediately acknowledge the specific error and understand the correct approach.

2.  **Root Cause Analysis:** I will analyze why the error occurred (misunderstanding, oversight, incorrect assumption, etc.).

3.  **Memory Update:** I will update `.ai_memory/self_correction_log.md` with:
    - Date and context of the error
    - Specific mistake made
    - Correct approach/solution
    - Prevention strategy for future similar situations

4.  **Pattern Recognition:** I will identify if this error represents a pattern and update my approach accordingly.

5.  **Verification:** Before similar future tasks, I will consult the self-correction log to avoid repeating documented mistakes.

This protocol ensures continuous learning and error reduction over time.
---
## PROTOCOL FOR SAFE FILE MODIFICATION

To prevent "Diff Edit Mismatch" errors and ensure the integrity of file edits, I MUST follow this protocol whenever a task requires me to modify an existing file (append, replace, or insert text).

1.  **Read the Full File:** My first step is always to read the entire, up-to-date content of the target file into my context. This ensures I am working with the most current version.

2.  **Modify in Memory:** I will perform all required modifications on the content I just read. I will construct the **complete, final version** of the file as a new block of text in my memory.

3.  **Overwrite the Entire File:** Instead of using complex search patterns or attempting partial edits (diffs), my primary method for applying changes will be to **completely overwrite** the original file with the new, fully-modified content I constructed in the previous step.

4.  **Verify the Change:** After overwriting, I will read the file again to confirm that the changes were applied exactly as intended and that the file is not corrupted.

This **'Read, Modify, Overwrite'** method is more robust and reliable than pattern-based searching and is my preferred strategy for all file modifications.
---
