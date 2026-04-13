# Common Issues in AI Rules Files

Use this resource for detailed diagnostic patterns and fixes for common rules file problems.

## Critical Issues

### 1. File Too Large

**Symptoms:**
- AI ignores some rules
- Inconsistent code generation
- AI seems to "forget" instructions

**Detection:** Check line count and character count of each file.

**Thresholds:**
- **Critical**: > 200 lines or > 6,000 characters
- **Warning**: 150-200 lines or 5,000-6,000 characters

**Impact:** Large files consume AI context window, leaving less room for understanding your actual code. The AI may ignore rules that appear later in the file.

**Fix:** Split into multiple focused files:
```
# Before: .builderrules (400 lines)

# After:
.builderrules (100 lines - core conventions)
.builder/rules/component-structure.mdc (80 lines)
.builder/rules/testing-standards.mdc (70 lines)
.builder/rules/api-patterns.mdc (80 lines)
.builder/rules/styling-guidelines.mdc (70 lines)
```

---

### 2. Too Many `alwaysApply` Rules

**Symptoms:**
- AI performance degradation
- Rules contradicting each other
- Context window exhaustion

**Detection:** Count files in `.builder/rules/` with `alwaysApply: true` in frontmatter.

**Threshold:** Maximum 3-5 files with `alwaysApply: true`

**Impact:** Every `alwaysApply: true` file is loaded for every request, consuming context that could be used for code understanding.

**Fix:** Convert to glob-scoped rules:
```yaml
# Before - applies to everything
---
description: Component rules
alwaysApply: true
---

# After - scoped to relevant files only
---
description: Component rules
alwaysApply: false
globs:
  - "src/components/**/*.tsx"
  - "src/app/**/components/**/*.tsx"
---
```

---

### 3. Missing Frontmatter

**Symptoms:**
- Rules not being applied correctly
- No scoping of rules
- Missing context for AI

**Detection:** Check if `.mdc` files start with `---` frontmatter block.

**Impact:** Without frontmatter, the AI doesn't know when to apply rules or what they're for.

**Fix:** Add proper frontmatter to every `.mdc` file:
```yaml
---
description: Clear, concise description of rule purpose
globs:
  - "pattern/to/match/**/*.tsx"
alwaysApply: false
---
```

---

### 4. Missing `description` Field

**Symptoms:**
- Unclear rule purpose
- Difficulty maintaining rules
- AI may misapply rules

**Detection:** Check frontmatter for `description:` field.

**Impact:** Both humans and AI need context about what each rule file covers.

**Fix:**
```yaml
# Before
---
globs:
  - "**/*.tsx"
---

# After
---
description: React component structure and organization patterns
globs:
  - "**/*.tsx"
---
```

---

### 5. Wrong File Naming

**Symptoms:**
- Rules not being detected
- Configuration errors
- Silent failures

**Detection:** Look for common naming mistakes.

**Common mistakes:**
| Wrong | Correct |
|-------|---------|
| `.builderrule` | `.builderrules` |
| `AGENTS.md` | `agents.md` |
| `.builder/rules/foo.md` | `.builder/rules/foo.mdc` |

**Fix:** Rename files to match conventions exactly.

---

## High Priority Issues

### 6. Vague Rules

**Symptoms:**
- Inconsistent code generation
- AI interprets rules differently each time
- Generated code doesn't match expectations

**Detection:** Look for patterns like:
- "Write good code"
- "Follow best practices"
- "Use clean architecture"
- "Be consistent"

**Impact:** Vague rules give AI no actionable guidance. The AI must guess what you mean, leading to inconsistent results.

**Fix:** Make specific and actionable:
```markdown
# Before - vague
Write clean, maintainable code.
Follow best practices for React.
Use good naming conventions.

# After - specific
## Component Structure
- Use functional components with TypeScript
- Define props interface above component
- Export component as default export
- Use named exports for types and utilities

## Naming Conventions
- Components: PascalCase (`UserProfile.tsx`)
- Hooks: camelCase with use prefix (`useAuth.ts`)
- Utils: camelCase (`formatDate.ts`)
- Constants: SCREAMING_SNAKE_CASE (`API_ENDPOINTS.ts`)
```

---

### 7. Verbose Rules

**Symptoms:**
- File exceeds size limits
- Key rules buried in prose
- AI may skip important points

**Detection:**
- Paragraphs instead of bullets
- Rules embedded in explanatory text
- Multiple sentences per rule

**Impact:** Verbose text wastes context space and makes rules harder for AI to parse.

**Fix:**
```markdown
# Before - verbose
When you are creating a new component, you should always make sure
that you are following the team's established patterns for component
creation, which includes making sure that the component is placed in
the correct directory structure, uses the proper naming conventions,
and follows all of the styling guidelines that have been established
by the team over the course of the project's development.

# After - concise
New components:
- Place in `src/components/{feature}/{ComponentName}.tsx`
- Use PascalCase for component names
- Follow established styling guidelines
```

---

### 8. Conflicting Rules

**Symptoms:**
- AI produces contradictory code
- Inconsistent patterns across generations
- AI seems "confused"

**Detection:** Review for conflicts like:
- Different naming conventions in different files
- Contradictory tech stack declarations
- Overlapping but inconsistent globs

**Example conflicts:**
```markdown
# In .builderrules
Use named exports for all components.

# In component-structure.mdc
Export components as default export.
```

**Fix:**
1. Review all rules files for consistency
2. Establish single source of truth for each concern
3. Use more specific globs to separate concerns
4. Document precedence if intentional overrides exist

---

## Medium Priority Issues

### 9. No Code Examples

**Symptoms:**
- AI interprets patterns differently
- Structural conventions not followed
- Format inconsistencies

**Detection:** Check if rule files contain code blocks.

**Impact:** Examples provide unambiguous reference. Without them, AI must guess at implementation details.

**Fix:**
```markdown
# Before - no example
Components should have prop validation using TypeScript interfaces.

# After - with example
Components should have prop validation using TypeScript interfaces:

\`\`\`typescript
interface UserCardProps {
  user: User;
  onSelect?: (userId: string) => void;
}

export function UserCard({ user, onSelect }: UserCardProps) {
  // ...
}
\`\`\`
```

---

### 10. Overly Broad Globs

**Symptoms:**
- Rules applied to wrong files
- Unnecessary context consumption
- Conflicting rules on same files

**Detection:**
```yaml
# Too broad
globs:
  - "**/*"
  - "**/*.ts"

# Better - scoped
globs:
  - "src/components/**/*.tsx"
```

**Fix:** Make globs as specific as possible:
- Target specific directories
- Target specific file extensions
- Exclude test files if not relevant
- Exclude generated files

---

### 11. Duplicate Information

**Symptoms:**
- Same rules in multiple files
- Inconsistency when one copy is updated
- Wasted context space

**Detection:** Compare content across files for duplicates.

**Impact:** Duplication wastes context and creates maintenance burden. Updates may miss copies.

**Fix:**
1. Identify duplicate content
2. Keep in most appropriate location
3. Remove from other locations
4. If needed in multiple contexts, reference rather than duplicate

---

## Severity Reference

| Severity | Action Required | Examples |
|----------|-----------------|----------|
| **Critical** | Fix immediately | File > 200 lines, > 5 alwaysApply, wrong file names |
| **High** | Fix soon | Missing frontmatter, vague rules, missing description |
| **Medium** | Plan to fix | Verbose rules, no examples, broad globs |
| **Low** | Consider fixing | Minor organization issues, style inconsistencies |

---

## Issues Checklist

Use this checklist when reviewing rules files:

- [ ] No file exceeds 200 lines
- [ ] No file exceeds 6,000 characters
- [ ] 5 or fewer files have `alwaysApply: true`
- [ ] All `.mdc` files have frontmatter
- [ ] All frontmatter has `description` field
- [ ] File names are correct (`.builderrules`, `agents.md`, `*.mdc`)
- [ ] No vague/generic rules
- [ ] Rules use bullets, not paragraphs
- [ ] No conflicting rules across files
- [ ] Globs are appropriately scoped
- [ ] No duplicate content across files
