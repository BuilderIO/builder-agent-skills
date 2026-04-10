# Example Skills

Complete, copy-paste-ready skills at different complexity levels. Use these as starting points.

## Example 1: Simple Skill — React Component Conventions

A basic knowledge skill. Single SKILL.md, no supporting files.

```
.builder/skills/react-conventions/SKILL.md
```

```yaml
---
name: react-conventions
description: React component conventions and patterns for this project. Use when creating new React components, refactoring existing ones, or when asking about component architecture, hooks patterns, or state management in this codebase.
---

# React Conventions

## Component Structure

Use functional components with hooks. No class components.

Place components in `src/components/` organized by feature, not type.

## Naming

- Components: PascalCase (`UserProfile.tsx`)
- Hooks: camelCase with `use` prefix (`useAuth.ts`)
- Utils: camelCase (`formatDate.ts`)

## State Management

Use React Query for server state and Zustand for client state.
Do not use Redux or Context for state that React Query handles.

## Gotchas

- Always use `key` props on mapped elements — use stable IDs, never array indices
- Avoid creating new object/array literals in JSX props — they cause unnecessary re-renders
- Use `useCallback` for event handlers passed to memoized children
```

**Why this works:** Focused on what the AI wouldn't know (your project's specific conventions). Doesn't explain what React is or how hooks work. Has a Gotchas section.

---

## Example 2: Workflow Skill — Deploy to Staging

A deploy workflow skill. The description makes it clear this involves deployment so users invoke it intentionally.

```
.builder/skills/deploy-staging/SKILL.md
```

```yaml
---
name: deploy-staging
description: >
  Deploy the current branch to the staging environment. Runs tests,
  builds the app, and pushes to staging infrastructure. Use when the
  user wants to deploy to staging, push to staging, or test changes
  in the staging environment.
---

# Deploy to Staging

## Workflow

1. Run the full test suite: `npm test`
2. If tests fail, stop and report failures. Do not deploy broken code.
3. Build the production bundle: `npm run build`
4. Deploy to staging: `aws s3 sync dist/ s3://staging-bucket/`
5. Invalidate the CDN cache: `aws cloudfront create-invalidation --distribution-id $CF_DIST_ID --paths "/*"`
6. Verify the deployment by checking `https://staging.example.com`

## Gotchas

- Always run tests first. A previous engineer deployed untested code that took down staging for a day.
- The CloudFront invalidation takes 5-10 minutes. Don't panic if changes aren't visible immediately.
- If the S3 sync fails with permission errors, check that the AWS credentials in `.env` haven't expired.

## Rollback

If something goes wrong:
```bash
aws s3 sync s3://staging-backup/ s3://staging-bucket/
```
```

**Why this works:** Description clearly communicates this is a deploy action. Has clear rollback instructions. Gotchas capture real incidents.

---

## Example 3: Knowledge Skill — API Patterns

Project-specific knowledge that the AI should reference when working with your API.

```
.builder/skills/api-patterns/SKILL.md
```

```yaml
---
name: api-patterns
description: >
  Internal API conventions, authentication patterns, and endpoint
  structure for this project. Use when writing API routes, creating
  new endpoints, working with authentication, or modifying request
  handlers.
---

# API Patterns

## Authentication

All API routes use JWT bearer tokens. The middleware at `src/middleware/auth.ts`
handles validation. Do not implement custom auth logic in route handlers.

Token refresh is handled client-side by `src/lib/api-client.ts`. Never store
tokens in localStorage — use httpOnly cookies.

## Route Structure

```
src/api/
├── routes/
│   ├── users.ts       # /api/users/*
│   ├── projects.ts    # /api/projects/*
│   └── billing.ts     # /api/billing/*
├── middleware/
│   ├── auth.ts
│   └── rate-limit.ts
└── validators/
    └── schemas.ts     # Zod schemas for request validation
```

## Conventions

- All endpoints return `{ data, error, meta }` shape
- Use Zod schemas from `validators/schemas.ts` for request validation
- Pagination uses cursor-based pagination, not offset
- Rate limiting is configured per-route in `middleware/rate-limit.ts`

## Gotchas

- The billing routes use a DIFFERENT auth middleware (`billing-auth.ts`) that also checks Stripe webhook signatures. Don't use the standard `auth.ts` for billing routes.
- The `projects.ts` route has a N+1 query on the `members` relation. Always use `.include({ members: true })` when fetching projects.
- PUT endpoints are idempotent but POST endpoints are not. Use PUT for updates.
```

**Why this works:** Focused entirely on project-specific knowledge. The Gotchas section captures real footguns that would cause bugs.

---

## Example 4: Complex Skill with Progressive Disclosure

A data analysis skill with reference files, scripts, and a config pattern.

```
.builder/skills/analytics/
├── SKILL.md
├── config.json
├── references/
│   └── event-schema.md
└── scripts/
    └── query-helpers.py
```

**SKILL.md:**

```yaml
---
name: analytics
description: >
  Query and analyze product analytics data. Use when the user asks
  about metrics, funnels, user behavior, conversion rates, retention,
  or wants to explore event data, even if they don't mention
  "analytics" explicitly.
---

# Analytics

Query product analytics using our event data pipeline.

## Setup

If `config.json` does not exist in this skill directory, ask the user for:
- `database_url`: Connection string for the analytics database
- `default_date_range`: Default lookback period (e.g., "30d")

Save their answers to `config.json`.

## Quick Start

Use the helper functions in `scripts/query-helpers.py` to query data.
These handle connection pooling, date parsing, and common aggregations.

For the full event schema (event names, properties, types), see
[references/event-schema.md](references/event-schema.md).

## Common Queries

### Funnel Analysis
Join `signup_started` → `signup_completed` → `first_action` events.
The canonical user ID is in the `user_id` property (not `anonymous_id`).

### Retention
Use the `cohort_retention()` function from `scripts/query-helpers.py`.
It groups users by signup week and tracks return visits.

## Gotchas

- The `page_view` event fires on BOTH client and server renders. Filter by `context.source = 'client'` to avoid double-counting.
- Revenue events store amounts in CENTS, not dollars. Divide by 100 for display.
- The `anonymous_id` → `user_id` mapping is in the `identity_stitching` table, not the events table.
```

**Why this works:** Uses progressive disclosure — SKILL.md stays lean, detailed schema lives in a reference file, reusable query functions live in a script. The config.json pattern handles per-user database credentials. Gotchas capture data-specific footguns that would cause wrong numbers.
