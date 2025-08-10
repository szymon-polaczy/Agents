# /analyze

Perform code analysis based on AGENT.md principles focusing on maintainability and defensive programming.

## Analysis Menu:

### 1. Defensive Programming Audit

- Missing input validations
- Unchecked null/undefined references
- Error handling gaps
- Unsafe array/object access
- Missing type checks
- Potential runtime errors

### 2. Code Structure Review

- Nesting depth violations (>3 levels)
- Functions exceeding 50 lines
- Early return opportunities
- Complex conditionals that need simplification
- File size check (approaching 750 lines)

### 3. Duplication Detection

- Code repeated 3+ times across RELATED files
- Similar patterns that could be extracted
- Helper function opportunities (>3 lines)
- Unnecessary abstractions (<3 lines, single use)

### 4. Performance Bottlenecks

- N+1 query problems
- Missing caching opportunities
- Expensive operations in loops
- Unnecessary API calls
- Large dataset handling without pagination

### 5. Patch-Work Identification

- Band-aid fixes that need complete rewrites
- Complex workarounds
- Technical debt from quick fixes
- Areas violating the "3-line fix or rewrite" rule

### 6. Naming & Readability

- Non-descriptive variable names
- Abbreviated words that should be full
- Missing boolean prefixes
- Comments that indicate unclear code
- TODO comments that should be completed

## Process:

1. Scan code following AGENT.md principles
2. Focus on practical, actionable issues
3. Prioritize by impact on maintainability
4. Identify candidates for complete rewrite vs quick fix
5. Check related files only (not entire project)

## Output Format:

markdown

```markdown
## Summary
- Files analyzed: X
- Critical issues: X
- Quick fixes available: X  
- Rewrites recommended: X

## Critical Issues (Fix Immediately)
1. **[Issue Type]**: [File:Line]
   - Problem: [Description]
   - Fix: [≤3 lines] OR Rewrite needed
   - Example fix:
   ```[language]
   // code
```

## Defensive Programming Gaps

- [ ]  Missing validation in processUser() line 45
- [ ]  Unchecked array access in getData() line 78
- [ ]  No error handling for API call line 123

## Refactoring Opportunities

- **Extract duplication**: `validateEmail()` appears 4 times
- **Reduce nesting**: `handleRequest()` has 5 levels (max: 3)
- **Split function**: `processOrder()` is 85 lines (max: 50)

## Performance Improvements

- Add caching to `getUserData()` - called 10x per request
- Batch database queries in `loadProducts()` - N+1 detected
- Paginate results in `searchItems()` - returns 1000+ items

## Recommended Actions

1. **Immediate** (≤3 line fixes):
    - Add null check line 45
    - Add early return line 67
2. **Rewrite Completely**:
    - `complexProcessor()` - too patched, needs fresh approach
    - `nestedHandler()` - 6 levels deep, unmaintainable