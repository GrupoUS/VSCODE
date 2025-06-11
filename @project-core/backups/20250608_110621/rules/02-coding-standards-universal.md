# 🎯 UNIVERSAL CODING STANDARDS - GRUPO US VIBECODE SYSTEM V2.0

## 📋 OVERVIEW

Universal coding principles and standards that apply to all projects across the GRUPO US ecosystem, regardless of technology stack. These standards ensure consistency, quality, and maintainability across all development activities.

## 🏗️ CORE PHILOSOPHY

### **1. Code Quality Principles**
- **Readability & Clarity**: Write clear, concise, and self-documenting code
- **Modularity over Duplication (DRY)**: Decompose complex systems into smaller, reusable units
- **Component-Based Architecture**: Structure UIs as component trees
- **SOLID Principles**: Adhere to SOLID principles for scalable, maintainable systems
- **Descriptive Naming**: Use clear, descriptive names for variables, functions, and components
- **Dependency Injection**: Favor dependency injection for loose coupling
- **Semantic HTML**: Use semantic HTML elements for accessibility and SEO
- **No Placeholders**: Implement complete functionality - NO TODOs or placeholders

### **2. Error Handling & State Management**
- **Robust Error Handling**: Always anticipate and handle potential errors gracefully
  - Use `try-catch` blocks for expected exceptions
  - Create custom exception classes for domain-specific errors
- **Comprehensive Logging**: Implement proper error logging for monitoring and debugging
- **Loading & Error States**: All data-fetching components must handle and display loading/error states

### **3. Data Fetching Optimization (Chunking Principle)**

**Context**: AI tools have limited context windows. Processing large datasets at once can cause errors and execution failures.

**Directive**: NEVER request entire large datasets at once. Always use **partial, filtered, and truncated** approaches.

#### **Warning Signs (When to suspect large data):**
- Task involves analyzing "all X" (users, products, logs)
- Data source is known to be massive (complex Figma files)
- Tool doesn't offer obvious filters or pagination
- Task description is vague about data scope

#### **Mandatory Strategies:**

**Specific ID/Node Searches:**
- **Figma**: Always prioritize specific `nodeId` searches over entire files
  - ✅ **Good**: `get_figma_data` with `nodeId` parameter
  - ❌ **Bad**: `get_figma_data` without `nodeId`

**Database Pagination & Limits:**
- **Supabase**: Always apply `LIMIT` and `OFFSET` for chunked data retrieval
  - ✅ **Good**: `SELECT * FROM users LIMIT 10 OFFSET 20;`
  - ❌ **Bad**: `SELECT * FROM users;`

**Strict Filtering:**
- Use specific `WHERE` clauses and filters
- **Supabase Logs**: Use `filters`, `search`, `hours_ago`, `limit` parameters
  - ✅ **Good**: Filtered log retrieval with specific criteria
  - ❌ **Bad**: Unfiltered log retrieval

**Partial File Reading:**
- For large files, analyze structure/metadata first
- Use precise regex for relevant sections only

**Scope Confirmation:**
- Include scope confirmation in planning phase
- Example: "To analyze error logs, I'll retrieve last 50 error events from the past hour. Is this sufficient?"

#### **Pre-Data-Fetch Checklist:**
1. Do I really need ALL this data?
2. Is there a specific ID or filter I can use?
3. Does the tool offer pagination/limit options?
4. Can I restrict by date or type?
5. Is the scope clear and confirmed by user?

## 🔒 SECURITY STANDARDS

### **Data Protection:**
- NEVER commit `.env` files or sensitive data
- ALWAYS use environment variables for secrets
- VALIDATE and sanitize all user inputs
- IMPLEMENT rate limiting and security headers
- Use HTTPS in production environments
- Follow principle of least privilege

### **Authentication & Authorization:**
- Implement proper authentication flows
- Use secure session management
- Validate permissions on every request
- Implement proper logout functionality

## ⚡ PERFORMANCE STANDARDS

### **Optimization Requirements:**
- Optimize for performance from development start
- Use lazy loading when appropriate
- Minimize bundle sizes and assets
- Implement strategic caching
- Monitor and measure performance regularly

### **Resource Management:**
- Efficient memory usage
- Proper cleanup of resources
- Optimized database queries
- Compressed assets and images

## ♿ ACCESSIBILITY (A11Y) STANDARDS

### **Mandatory Requirements:**
- Use semantic HTML elements (`<main>`, `<article>`, `<nav>`)
- Implement proper `aria-*` attributes
- Ensure keyboard navigation support
- Maintain appropriate color contrast ratios
- Provide alternative text for images and visual elements
- Support screen readers and assistive technologies

## 🧪 TESTING STANDARDS

### **Testing Requirements:**
- Write tests for critical functionality
- Maintain adequate test coverage
- Use unit, integration, and end-to-end tests appropriately
- Keep tests simple and focused
- Test error conditions and edge cases

### **Test Types:**
- **Unit Tests**: Individual functions and components
- **Integration Tests**: Component interactions
- **End-to-End Tests**: Complete user workflows
- **Performance Tests**: Load and stress testing

## 📚 DOCUMENTATION STANDARDS

### **Code Documentation:**
- Write self-documenting code with clear naming
- Add comments for complex business logic
- Document API endpoints and data structures
- Maintain up-to-date README files

### **Technical Documentation:**
- Architecture decisions and rationale
- Setup and deployment instructions
- API documentation with examples
- Troubleshooting guides

## 🔄 VERSION CONTROL STANDARDS

### **Git Workflow:**
```bash
# Feature branch mandatory
git checkout -b feature/descriptive-name

# Semantic commits
git commit -m "feat: add new functionality"
git commit -m "fix: resolve component X bug"
git commit -m "docs: update API documentation"
git commit -m "refactor: improve code structure"
```

### **Commit Standards:**
- Use conventional commit format
- Write clear, descriptive commit messages
- Make atomic commits (one logical change per commit)
- Reference issues/tickets when applicable

## 🎯 CODE REVIEW STANDARDS

### **Review Checklist:**
- [ ] Code follows established patterns
- [ ] Error handling implemented
- [ ] Tests written and passing
- [ ] Documentation updated
- [ ] Security considerations addressed
- [ ] Performance implications considered
- [ ] Accessibility requirements met

### **Review Process:**
- All code must be reviewed before merging
- Address all review comments
- Ensure CI/CD pipeline passes
- Validate functionality in staging environment

## 📊 QUALITY METRICS

### **Code Quality Targets:**
- **Test Coverage**: > 80% for critical paths
- **Code Complexity**: Keep cyclomatic complexity low
- **Performance**: Meet defined performance benchmarks
- **Security**: Zero high-severity vulnerabilities
- **Accessibility**: WCAG 2.1 AA compliance

### **Monitoring:**
- Continuous integration checks
- Automated quality gates
- Regular code quality reviews
- Performance monitoring in production

---

**These universal standards ensure consistent, high-quality development across all GRUPO US projects and technology stacks.**
