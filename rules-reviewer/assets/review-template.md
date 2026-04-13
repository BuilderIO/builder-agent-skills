# Review Output Template

Use this template structure when presenting AI rules review results.

---

## Standard Review Format

```markdown
# AI Rules Review

## Summary
- **Files analyzed**: X
- **Total lines**: Y
- **Critical issues**: Z
- **Warnings**: W

## File Analysis

### [filename]
- **Size**: X lines / Y chars [OK/WARNING/CRITICAL]
- **Frontmatter**: [Present/Missing/Incomplete]
- **alwaysApply**: [true/false]
- **Issues found**:
  - Issue 1
  - Issue 2
- **Recommendations**:
  - Recommendation 1
  - Recommendation 2

## Global Issues

### Issue: [Name]
**Impact**: [Description of how this affects AI]
**Fix**: [Specific action to take]

## Recommended Actions

### Immediate (Critical)
1. [Action 1]
2. [Action 2]

### Soon (High Priority)
1. [Action 1]

### Consider (Medium Priority)
1. [Action 1]

## Suggested Restructure

[If files need significant reorganization, provide a proposed file structure]
```

---

## Positive Review Format

Use when rules are well-structured with no significant issues:

```markdown
# AI Rules Review

## Summary
- **Files analyzed**: X
- **Total lines**: Y
- **Status**: Good

## Highlights

Your rules files follow best practices:
- File sizes within limits
- Proper frontmatter on .mdc files
- Good use of glob scoping
- Clear, actionable rules

## Minor Suggestions (Optional)

[Any small improvements that could be made, but aren't required]

## No Action Required

Your current rules structure is effective. Continue monitoring AI behavior and update rules as needed based on actual generation issues.
```

---

## Size Thresholds Reference

| Status | Lines | Characters |
|--------|-------|------------|
| **OK** | < 150 | < 5,000 |
| **WARNING** | 150-200 | 5,000-6,000 |
| **CRITICAL** | > 200 | > 6,000 |
