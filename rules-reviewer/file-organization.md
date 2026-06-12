# File Organization for AI Rules

Use this resource when restructuring rules across multiple files for better AI performance.

## Builder.io File Structure

```
your-project/
├── .builderrules                    # Project-wide, high-level rules only
├── .builderignore                   # Files to exclude from AI context
├── agents.md                        # AI agent configuration
└── .builder/
    └── rules/
        ├── component-structure.mdc  # Component organization rules
        ├── styling-guidelines.mdc   # CSS/styling conventions
        ├── testing-standards.mdc    # Testing requirements
        └── api-patterns.mdc         # API design patterns
```

## File Purposes

### Root `.builderrules`

**Purpose:** High-level, project-wide conventions

**Should contain:**
- Technology stack declaration
- Cross-cutting concerns that apply everywhere
- Core code style rules
- Essential commands (dev, build, test, lint)

**Target size:** 100-150 lines maximum

**Example structure:**
```markdown
# Project: [Name]

## Technology Stack
- Framework: [...]
- Language: [...]
- Styling: [...]

## Code Style
- [Essential rule 1]
- [Essential rule 2]

## File Organization
- Components: `src/components/`
- Utils: `src/lib/`

## Commands
- `npm run dev` - Start development
- `npm run build` - Build production
- `npm run test` - Run tests
```

### `.builder/rules/*.mdc` Files

**Purpose:** Specific, focused rules scoped to file patterns

**Should contain:**
- One concern per file
- Detailed patterns for specific file types
- Examples relevant to that concern
- Scoped with `globs` patterns

**Target size:** 100-150 lines per file

**Naming convention:** `{concern}.mdc`
- `component-structure.mdc`
- `testing-standards.mdc`
- `api-patterns.mdc`
- `styling-guidelines.mdc`
- `state-management.mdc`
- `database-patterns.mdc`

### `agents.md`

**Purpose:** AI agent configuration and context

**Should contain:**
- Project overview for AI context
- References to other rule files
- Agent-specific instructions
- Task delegation patterns

**Target size:** 150-200 lines

## Rule Precedence

Rules in nested directories take precedence over parent directories:

```
.builderrules (lowest priority - project-wide)
└── src/
    └── .builderrules (higher priority - src-specific)
        └── components/
            └── .builderrules (highest priority - component-specific)
```

**Precedence order (highest to lowest):**
1. `.builderrules` in current directory
2. `.builder/rules/*.mdc` with matching globs
3. Parent directory `.builderrules`
4. Root `.builderrules`

## Splitting Large Files

### Before: One Large File (400+ lines)

```markdown
# .builderrules (400 lines)
- Technology stack
- Code style
- Component patterns
- Testing requirements
- API conventions
- State management
- Styling guidelines
- Git workflow
```

### After: Multiple Focused Files

```
.builderrules (100 lines)
├── Technology stack
├── Code style essentials
├── File organization
└── Commands

.builder/rules/component-structure.mdc (80 lines)
├── Component patterns
├── Props conventions
├── File naming
└── Export patterns

.builder/rules/testing-standards.mdc (70 lines)
├── Test file location
├── Testing patterns
├── Coverage requirements
└── Mock conventions

.builder/rules/api-patterns.mdc (80 lines)
├── Route conventions
├── Error handling
├── Response formats
└── Authentication patterns

.builder/rules/styling-guidelines.mdc (70 lines)
├── Tailwind conventions
├── Design tokens
├── Component styling
└── Responsive patterns
```

## Glob Pattern Examples

### Component Rules
```yaml
globs:
  - "src/components/**/*.tsx"
  - "src/app/**/components/**/*.tsx"
```

### Test Rules
```yaml
globs:
  - "**/*.test.ts"
  - "**/*.test.tsx"
  - "**/*.spec.ts"
  - "src/__tests__/**/*"
```

### API Route Rules
```yaml
globs:
  - "src/app/api/**/*.ts"
  - "src/pages/api/**/*.ts"
```

### Style Rules
```yaml
globs:
  - "**/*.css"
  - "**/*.scss"
  - "src/styles/**/*"
```

### Configuration Rules
```yaml
globs:
  - "*.config.ts"
  - "*.config.js"
  - ".env*"
```

## Monorepo Considerations

For monorepos, consider this structure:

```
monorepo/
├── .builderrules                    # Repo-wide conventions
├── apps/
│   ├── web/
│   │   └── .builderrules            # Web app specific
│   └── api/
│       └── .builderrules            # API specific
└── packages/
    ├── ui/
    │   └── .builderrules            # UI library specific
    └── utils/
        └── .builderrules            # Utils specific
```

**Key principle:** Keep shared conventions at root, app-specific at app level.

## Common Patterns by Project Type

### Next.js App
```
.builderrules
.builder/rules/
├── app-router-conventions.mdc    # Next.js App Router patterns
├── server-components.mdc         # Server vs Client rules
├── api-routes.mdc                # API route patterns
└── data-fetching.mdc             # React Query / fetch patterns
```

### React SPA
```
.builderrules
.builder/rules/
├── component-structure.mdc
├── state-management.mdc          # Redux/Zustand patterns
├── routing-conventions.mdc       # React Router patterns
└── testing-standards.mdc
```

### Node.js API
```
.builderrules
.builder/rules/
├── controller-patterns.mdc
├── service-layer.mdc
├── database-patterns.mdc
├── error-handling.mdc
└── validation-schemas.mdc
```

---

## Migrating Agent-Rules `.md` Files to `.mdc`

Plain `.md` files that contain coding guidelines should be converted to properly scoped `.mdc` files. During migration, apply content minimization: strip anything the agent already knows from its training data and keep only project-specific information.

### Identifying What to Keep vs Cut

**Keep** (project-specific, agent can't infer):
- Exact folder paths and file naming patterns for this project
- Which existing hooks/components/utils to reuse
- Library choices and versions specific to this project
- Non-obvious constraints or architectural decisions
- Custom conventions that differ from framework defaults

**Cut** (generic, agent already knows):
- Framework basics ("use functional components", "React hooks rules")
- Language features ("use TypeScript for type safety")
- Generic best practices ("handle errors", "DRY principle")
- Explanatory paragraphs about why a pattern exists (keep the rule, not the rationale)
- Enforcement language ("MUST", "CRITICAL", "NON-NEGOTIABLE") — state the rule concisely instead

### Migration Example

```markdown
# Before: CODING_STANDARDS.md (400 lines — plain .md, verbose, mostly generic)

## TYPES LAYER
**Rule**: Define ALL TypeScript interfaces & types here FIRST.
This is critical because it ensures type safety across the codebase.
TypeScript interfaces should be well-defined and reusable...

✅ CORRECT:
export interface IUser {
  id: string;
  name: string;
}

❌ WRONG: Types defined in component file
```

```yaml
# After: .builder/rules/type-conventions.mdc (~20 lines — specific, scoped)
---
description: TypeScript type and interface conventions
globs:
  - "src/types/**/*.ts"
alwaysApply: false
---

## Type Conventions
- All shared interfaces in `src/types/{domain}.types.ts`
- Use `I` prefix for interfaces: `IUser`, `IOrder`
- Export from `src/types/index.ts` barrel
- No implementation code in type files
```

The 400-line file becomes ~20 lines of genuinely useful guidance. The agent knows TypeScript — it doesn't need to be told what an interface is.

### Step-by-Step Migration

1. **Read the source `.md` file** — identify all distinct concerns (components, hooks, API, styles, etc.)
2. **For each concern**, create `.builder/rules/{concern}.mdc`
3. **Add frontmatter** — `description`, `globs` scoped to relevant file patterns, `alwaysApply: false`
4. **Migrate rules** — for each rule, ask "would a senior dev working with this framework already know this?" If yes, cut it
5. **Verify size** — each `.mdc` file should be under 100 lines after minimization
6. **Handle the source file** — either delete it (if rules are now in `.mdc`) or repurpose it as human-facing documentation with a note that machine-readable rules are in `.builder/rules/`

---

## Migration Strategy

When restructuring existing rules:

### 1. Audit Current State

Identify all rules files in the project:
- `.builderrules` (root and nested)
- `.builder/rules/*.mdc`
- `agents.md`

Check each file's size (lines and characters).

### 2. Categorize Content

Read through existing rules and categorize:
- **Core** (keep in root): Tech stack, essential style
- **Component** (split out): Component patterns
- **Testing** (split out): Test conventions
- **API** (split out): API patterns
- **Styling** (split out): CSS/styling rules

### 3. Create New Structure

1. Create `.builder/rules/` directory
2. Create focused `.mdc` files with frontmatter
3. Move content to appropriate files
4. Trim root file to essentials
5. Add proper `globs` patterns

### 4. Validate

- Check no file exceeds 200 lines
- Verify `alwaysApply: true` count is 5 or fewer
- Test AI behavior with new structure
- Iterate based on AI performance
