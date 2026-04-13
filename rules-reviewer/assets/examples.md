# AI Rules Examples: Good vs Bad

Reference examples for well-structured vs poorly-structured AI rules files.

---

## Example 1: Root Rules File

### Bad: Too Large and Verbose

```markdown
# .builderrules (450+ lines - TOO LONG)

# E-commerce Platform Configuration

## Introduction

Welcome to our e-commerce platform! This document contains all the rules
and guidelines that should be followed when writing code for this project.
It's very important that you read through this entire document carefully
before making any changes to the codebase, as it contains critical
information about our coding standards and practices.

## Technology Stack

We are using Next.js version 14 with the App Router for our frontend
framework. The reason we chose Next.js is because it provides excellent
server-side rendering capabilities and has a great developer experience.
We use TypeScript for all of our code because it helps catch bugs early
and provides better IDE support.

For styling, we use Tailwind CSS because it allows us to write styles
directly in our components without having to switch between files. We also
use a custom design system that provides pre-built components.

Our database is PostgreSQL and we use Prisma as our ORM because it provides
type-safe database queries and makes migrations easy to manage.

[... continues for 400+ more lines ...]
```

### Good: Concise and Focused

```markdown
# .builderrules (95 lines)

# Project: E-commerce Platform

## Technology Stack
- Framework: Next.js 14 (App Router)
- Language: TypeScript (strict mode)
- Styling: Tailwind CSS
- Database: PostgreSQL with Prisma
- Testing: Vitest + Testing Library

## Code Style
- Use ES modules (import/export)
- Functional components with hooks only
- TypeScript for all files (no .js)
- 2-space indentation

## File Organization
- Components: `src/components/{feature}/`
- Pages: `src/app/` (App Router)
- API routes: `src/app/api/`
- Utils: `src/lib/`
- Types: `src/types/`

## Naming Conventions
- Components: PascalCase (`UserProfile.tsx`)
- Hooks: camelCase with use prefix (`useAuth.ts`)
- Utils: camelCase (`formatDate.ts`)
- Constants: SCREAMING_SNAKE_CASE

## Commands
- `pnpm dev` - Start development server
- `pnpm build` - Build for production
- `pnpm test` - Run test suite
- `pnpm lint` - Run ESLint
- `pnpm typecheck` - TypeScript check
```

---

## Example 2: Component Rules (.mdc file)

### Bad: Missing Frontmatter, Too Verbose

```markdown
# component-structure.mdc (no frontmatter, 280 lines)

# Component Structure and Organization

This document describes how components should be structured in our project.
All developers should follow these guidelines when creating new components
or modifying existing ones. These rules have been established based on
our team's experience and industry best practices.

When you create a new component, you need to think about several things.
First, you need to decide where the component should be located in the
file structure. This depends on whether the component is reusable across
the entire application or specific to a certain feature.

For components that are reusable across the entire application, you should
place them in the src/components/ui directory. These are typically simple,
atomic components like buttons, inputs, and cards that don't have any
business logic and can be used anywhere.

For components that are specific to a certain feature, you should place
them in the src/components/features/{feature-name} directory. These
components typically contain business logic specific to that feature...

[... continues without any code examples ...]
```

### Good: Proper Frontmatter, Concise with Examples

```markdown
---
description: React component structure and organization patterns
globs:
  - "src/components/**/*.tsx"
  - "src/app/**/components/**/*.tsx"
alwaysApply: false
---

# Component Structure Rules

## File Location
- Shared components: `src/components/ui/`
- Feature components: `src/components/{feature}/`

## Component Pattern
```typescript
interface ComponentNameProps {
  // Props definition
}

export default function ComponentName({ ...props }: ComponentNameProps) {
  return (
    // JSX
  );
}
```

## Exports
- Default export: The component itself
- Named exports: Types and utilities
- Index file: `export { default as ComponentName } from './ComponentName'`

## Props
- Always use TypeScript interfaces
- Define interface above component
- Use descriptive prop names
- Document complex props with JSDoc

## File Size
- Components under 200 lines
- Split large components into sub-components
- Extract hooks to `hooks/` directory
```

---

## Example 3: Testing Rules

### Bad: alwaysApply Overuse, No Scoping

```markdown
---
description: Testing standards
alwaysApply: true  # BAD: applies to ALL files, even non-test files
---

# Testing Standards

All code must have tests. Write tests for everything. Use good testing
practices. Tests should be comprehensive and cover all edge cases...
```

### Good: Properly Scoped

```markdown
---
description: Testing standards and patterns for unit and integration tests
globs:
  - "**/*.test.ts"
  - "**/*.test.tsx"
  - "**/*.spec.ts"
  - "src/__tests__/**/*"
alwaysApply: false
---

# Testing Standards

## Test Location
Co-locate with source: `Component.tsx` → `Component.test.tsx`

## Test Structure
```typescript
import { render, screen, userEvent } from '@/test/utils';
import { ComponentName } from './ComponentName';

describe('ComponentName', () => {
  it('renders correctly', () => {
    render(<ComponentName />);
    expect(screen.getByRole('button')).toBeInTheDocument();
  });

  it('handles user interaction', async () => {
    const onClick = vi.fn();
    render(<ComponentName onClick={onClick} />);
    await userEvent.click(screen.getByRole('button'));
    expect(onClick).toHaveBeenCalled();
  });
});
```

## Requirements
- Test behavior, not implementation
- Mock external APIs with msw
- Minimum 80% coverage for new code
- All user interactions must be tested
```

---

## Example 4: API Patterns

### Bad: Vague and Unhelpful

```markdown
---
description: API rules
globs:
  - "**/*"  # BAD: too broad
alwaysApply: true  # BAD: unnecessary for API-specific rules
---

# API Rules

Use good API design. Follow REST conventions. Handle errors properly.
Make sure your endpoints are secure and performant.
```

### Good: Specific with Examples

```markdown
---
description: API route patterns and conventions
globs:
  - "src/app/api/**/*.ts"
  - "src/pages/api/**/*.ts"
alwaysApply: false
---

# API Route Patterns

## REST Conventions
| Method | Path | Purpose |
|--------|------|---------|
| GET | `/api/users` | List users |
| GET | `/api/users/:id` | Get user |
| POST | `/api/users` | Create user |
| PUT | `/api/users/:id` | Update user |
| DELETE | `/api/users/:id` | Delete user |

## Response Format
```typescript
// Success
return NextResponse.json({ data: result }, { status: 200 });

// Error
return NextResponse.json(
  { error: { code: 'NOT_FOUND', message: 'User not found' } },
  { status: 404 }
);
```

## Error Handling
- Always use try/catch
- Return appropriate HTTP status codes
- Include error codes for client handling
- Log errors server-side

## Validation
- Validate all inputs with Zod
- Return 400 for validation errors
- Include field-level error details
```

---

## Example 5: Styling Rules

### Bad: Contradictory and Incomplete

```markdown
# styling.mdc (no frontmatter)

Use Tailwind CSS for styling.
Don't use inline styles.
Use CSS modules when needed.  # Contradicts Tailwind-only approach
Custom CSS is fine for complex layouts.  # Vague, contradicts above
```

### Good: Clear and Consistent

```markdown
---
description: Tailwind CSS styling conventions and design tokens
globs:
  - "src/components/**/*.tsx"
  - "src/app/**/*.tsx"
alwaysApply: false
---

# Styling Guidelines

## Approach
Use Tailwind CSS exclusively. No CSS modules or custom stylesheets.

## Spacing
Use Tailwind spacing scale:
- `p-2` (8px), `p-4` (16px), `p-6` (24px)
- Never use arbitrary values like `p-[13px]`

## Colors
Use semantic color classes:
- `text-primary`, `bg-surface`, `border-muted`
- `text-success`, `text-error`, `text-warning`
- Never use arbitrary colors like `text-[#ff0000]`

## Responsive Design
Mobile-first approach:
```html
<div class="p-4 md:p-6 lg:p-8">
  <h1 class="text-lg md:text-xl lg:text-2xl">Title</h1>
</div>
```

## Component Styling Pattern
```tsx
<button className={cn(
  "px-4 py-2 rounded-lg font-medium",
  "bg-primary text-white",
  "hover:bg-primary/90 focus:ring-2",
  disabled && "opacity-50 cursor-not-allowed"
)}>
  Click me
</button>
```

## Do NOT
- Use inline `style` props
- Create custom CSS files
- Use arbitrary Tailwind values
- Override design system colors
```

---

## Summary: Good Rules Checklist

| Aspect | Guideline |
|--------|-----------|
| **File size** | < 150 lines preferred, never > 200 |
| **Frontmatter** | Always include description + globs |
| **alwaysApply** | Use sparingly (max 3-5 files total) |
| **Globs** | Specific patterns, not `**/*` |
| **Content** | Specific, actionable, not vague |
| **Format** | Bullets over paragraphs |
| **Examples** | Include code blocks |
| **Organization** | Clear headers and sections |
| **Consistency** | No contradictions across files |
