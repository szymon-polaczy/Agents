# /refactor
Refactor code following AGENT.md principles for simplicity and maintainability.

## Refactoring Menu:

### 1. Early Return Conversion
* Convert nested if-else to guard clauses
* Flatten promise chains
* Reduce indentation to max 3 levels
* Eliminate else blocks after returns

### 2. Defensive Programming Enhancement  
* Add input validation
* Add null/undefined checks
* Safe property access
* Error boundary addition
* Try-catch wrapping for external calls

### 3. Deduplication (3+ Rule)
* Extract code appearing 3+ times
* Create helper functions (>3 lines)
* Consolidate similar logic
* Remove redundant implementations

### 4. Complete Rewrites
* Replace patch-work solutions
* Reimplement overly complex functions
* Modernize legacy code
* Untangle spaghetti code

### 5. Simplification
* Remove unnecessary abstractions
* Convert OOP to functions where simpler
* Inline single-use helpers (<3 lines)
* Remove premature optimizations

### 6. File Organization
* Consolidate related code
* Simplify before splitting
* Keep under 750 lines
* Group by feature, not type

## Process:
1. **Analyze first** - identify what needs refactoring
2. **Preserve functionality** - no behavior changes
3. **One pattern at a time** - incremental improvements
4. **Test if exists** - ensure nothing breaks
5. **Complete TODO items** - no new TODOs added

## Refactoring Strategies:

### Quick Fix (≤3 lines)
```php
// BEFORE: Missing validation
function process($data) {
    $id = $data['id'];
    return doWork($id);
}

// AFTER: Add defensive check
function process($data) {
    if (!isset($data['id'])) return ['error' => 'ID required'];
    $id = intval($data['id']);
    return doWork($id);
}
Complete Rewrite
javascript// BEFORE: Nested nightmare
function handleUser(user) {
    if (user) {
        if (user.active) {
            if (user.permissions) {
                if (user.permissions.includes('admin')) {
                    return processAdmin(user);
                } else {
                    return processUser(user);
                }
            } else {
                return {error: 'No permissions'};
            }
        } else {
            return {error: 'User inactive'};
        }
    } else {
        return {error: 'No user'};
    }
}

// AFTER: Early returns
function handleUser(user) {
    if (!user) return {error: 'No user'};
    if (!user.active) return {error: 'User inactive'};
    if (!user.permissions) return {error: 'No permissions'};
    
    return user.permissions.includes('admin') 
        ? processAdmin(user) 
        : processUser(user);
}
Output Format:
markdown## Refactoring Plan
- Strategy: [Quick Fix / Complete Rewrite]
- Files affected: X
- Estimated changes: X locations

## Changes Applied:

### [Filename.ext]

**Issue**: Nested conditionals (5 levels)
**Solution**: Early returns pattern

<BEFORE>
[original code]
</BEFORE>

<AFTER>
[refactored code]
</AFTER>

**Benefits**:
- Reduced nesting from 5 to 2 levels
- Improved readability
- Easier to add new conditions

## Summary:
- Functions simplified: X
- Nesting reduced: X locations
- Defensive checks added: X
- Duplications removed: X
- Lines saved: X

## Next Steps:
1. Review changes
2. Run existing tests
3. Consider caching for [specific functions]
4. Monitor performance improvements