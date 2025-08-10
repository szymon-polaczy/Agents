## Core Philosophy

Write code that is **simple, defensive, and maintainable**. Optimize for readability over cleverness. No premature abstractions. Code should be self-documenting and understandable without jumping between files.

---

## Fundamental Rules

### Code Structure

- **Early returns ALWAYS** - minimize nesting (max 3 levels)
- **Functions <50 lines** - single responsibility
- **One file first** - keep everything together until 750 lines
- **No OOP by default** - use functions and simple data structures
- **OOP only when it genuinely simplifies** (clear domain entities)

### Implementation Approach

- **Initial**: Write everything in ONE file, procedural, let it duplicate
- **Problem solving**: Either fix in ≤3 lines OR rewrite completely - NO PATCHES
- **Refactoring**: Only after complete, look in RELATED files (not entire project)
- **Deduplication**: Extract only when code appears 3+ times
- **TODO list**: Keep one during complex implementations, complete before finishing

### Naming & Style

- **Descriptive names**: `userAuthenticationToken` not `token`
- **Full words**: `configuration` not `config`
- **Boolean prefixes**: `isActive`, `hasPermission`, `canEdit`
- **Comments ONLY when necessary** - code should self-explain
- **NO TODO comments** - do it now (exception: >100 line systems)

### Helper Functions

- **Only extract if >3 lines OR used 3+ times**
- **Never extract <3 lines for single use**
- **Keep in same file until absolutely necessary**

---

## Defensive Programming

### Check Everything - Assume Nothing

php

```php
// PHP - Validate everything
function processData($data) {
    if (!$data || !is_array($data)) {
        return ['error' => 'Invalid data'];
    }
    
    // Safe array access with validation
    $userId = isset($data['user_id']) ? intval($data['user_id']) : 0;
    if (!$userId) {
        return ['error' => 'User ID required'];
    }
    
    // Check object before accessing
    $user = get_user_by('id', $userId);
    if (!$user || !is_object($user)) {
        return ['error' => 'User not found'];
    }
    
    // Safe property access
    $email = property_exists($user, 'email') ? $user->email : '';
    
    // Process with confidence everything exists
    return processVerifiedData($user, $email);
}
```

go

```go
// Go - Handle all errors explicitly
func ProcessRequest(data map[string]interface{}) (*Result, error) {
    if data == nil {
        return nil, fmt.Errorf("data cannot be nil")
    }
    
    // Type check everything
    userID, ok := data["user_id"].(string)
    if !ok || userID == "" {
        return nil, fmt.Errorf("valid user_id required")
    }
    
    // Never ignore errors
    user, err := GetUser(userID)
    if err != nil {
        return nil, fmt.Errorf("failed to get user: %w", err)
    }
    if user == nil {
        return nil, fmt.Errorf("user not found")
    }
    
    return &Result{UserID: user.ID}, nil
}
```

javascript

```javascript
// JS - Defensive at every step
function processUserData(data) {
    if (!data || typeof data !== 'object') {
        return { error: 'Invalid data' };
    }
    
    // Multiple fallbacks for safety
    const userId = data.userId || data.user_id || null;
    if (!userId) {
        return { error: 'User ID required' };
    }
    
    // Safe nested access
    const email = data.user?.email || data.email || '';
    
    // Defensive array handling
    const permissions = Array.isArray(data.permissions) ? data.permissions : [];
    
    try {
        const result = processUser(userId, email, permissions);
        return { success: true, data: result };
    } catch (error) {
        return { error: error.message || 'Processing failed' };
    }
}
```

---

## Language Specifics

### PHP/WordPress

- Check functions exist: `if (function_exists('wp_mail'))`
- Sanitize inputs: `sanitize_text_field()`, `intval()`
- Escape outputs: `esc_html()`, `esc_attr()`
- Use nonces for forms
- Prefer WP functions over raw PHP
- Handle `WP_Error` objects properly

### Golang

- Check every error: `if err != nil`
- Wrap errors with context: `fmt.Errorf("context: %w", err)`
- Use defer for cleanup
- No naked returns
- Validate nil pointers before use
- Prefer early returns

### JavaScript

- Check undefined/null explicitly
- Use optional chaining with fallbacks: `obj?.prop || default`
- Try-catch external calls
- Validate API responses structure
- Handle promise rejections
- Avoid implicit type coercion

---

## Performance & UX

### Quick Wins

- **Cache expensive operations** with clear invalidation
- **Paginate large datasets**
- **Identify N+1 queries** and batch them
- **Add loading states** for better UX
- **Use semantic HTML** for accessibility
- **Provide clear error messages** with next steps

### Caching Example

php

```php
function getCachedData($key) {
    $cached = wp_cache_get($key, 'my_cache_group');
    if ($cached !== false) return $cached;
    
    $data = expensiveOperation();
    wp_cache_set($key, $data, 'my_cache_group', HOUR_IN_SECONDS);
    
    // Provide manual clear
    add_action('clear_my_cache', function() use ($key) {
        wp_cache_delete($key, 'my_cache_group');
    });
    
    return $data;
}
```

---

## Anti-Patterns to Avoid

- **Premature abstractions** - wait for real patterns
- **Nested conditionals** - use early returns
- **Patch fixes** - rewrite properly or leave alone
- **Unnecessary OOP** - prefer functions
- **Magic numbers** - use named constants
- **Over-commenting** - good code needs few comments
- **File splitting too early** - keep together until 750 lines

---

## AI Instructions

### When Writing Code

1. Start in ONE file, simple procedural code
2. Use early returns religiously
3. Check every input, handle every error
4. Keep TODO list for complex work
5. No abstractions until pattern emerges 3+ times

### When Refactoring

1. Only refactor in explicit refactoring phase
2. Search RELATED files only (same feature/module)
3. Either ≤3 line fix OR complete rewrite
4. Show before/after comparisons
5. Simplify before splitting files

### When Reviewing

1. Flag deep nesting - suggest early returns
2. Point out missing defensive checks
3. Identify patch-work fixes
4. Suggest complete rewrites over complex patches
5. Check for undefined/null errors

### Remember

- **Boring is better** - proven over cutting-edge
- **Defensive always** - assume nothing works
- **Future-proof** - next developer (human or AI) should understand instantly
- **Working > Perfect** - ship it, then improve it