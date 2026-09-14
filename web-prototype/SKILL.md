---
name: web-prototype
description: Translate a source application into a faithful web prototype through discovery, design and logic capture, gap planning, iterative implementation, and evidence-based review.
disable-model-invocation: true
---

# Web Prototype

Replicate a non-web source application in an existing web prototype. Keep durable process files beside this `SKILL.md` so later runs can resume the work and improve the translation.

## Phase 1: Establish the source and prototype

Complete this phase before changing application code.

### Load saved preferences

Look for `preferences.md` in this skill directory. If it exists, read it and verify that the recorded paths still exist and match their recorded project types. Use valid saved preferences instead of repeating discovery.

### Identify source candidates

Search the repository for non-web application projects whose interface and behavior could be replicated. Candidates include:

- Xcode projects and workspaces, Swift packages, and SwiftUI or UIKit applications
- Android Gradle projects using Jetpack Compose or Android Views
- Other desktop or native application frameworks

The source is the specific project or subdirectory that acts as the product source of truth. Do not select generated files, build output, dependencies, or the entire repository when a narrower application directory is available.

### Identify prototype candidates

Search the repository for projects built with a web framework. Detect them from manifests and framework configuration such as `package.json`, `angular.json`, Next.js, Nuxt, Vite, SvelteKit, or similar files.

The prototype is the specific web project or subdirectory where the source experience will be replicated. Exclude static documentation, dependency directories, generated output, and unrelated websites.

### Confirm and save the pairing

Verify that the source uses a non-web framework and the prototype uses a web framework. If there is exactly one credible source and one credible prototype, select them. If multiple candidates exist, briefly explain each candidate and ask the user which pairing to use. Never guess between multiple applications.

Create or update `preferences.md` in this skill directory with confirmed repository-relative paths:

```markdown
# Web Prototype Preferences

- Source: `<repository-relative path>`
- Source framework: `<native framework or platform>`
- Prototype: `<repository-relative path>`
- Prototype framework: `<web framework>`
```

Replace stale values when the user confirms a different pairing.

## Phase 2: Capture the source

Inspect the complete source and compare its available experiences with the prototype. Do not infer coverage from filenames alone: read implementations, trace navigation and state, and run the source when the environment permits.

### Capture design

Create or update `design.md` in this skill directory as the canonical inventory of everything visual in the source. Preserve concrete file or symbol references so each finding is traceable. Capture at least:

- Every screen, page, modal, sheet, overlay, empty state, loading state, error state, and meaningful state variation
- Every reusable component and its variants, properties, interaction states, content rules, and composition
- Navigation hierarchy, routes, tabs, deep links, back behavior, and the transitions between destinations
- Layout, spacing, sizing, alignment, responsive and adaptive behavior, safe areas, scrolling, and layering
- Typography, colors, gradients, borders, radii, shadows, opacity, icons, imagery, and other assets
- Design tokens, including their source definitions, semantic purpose, values, and component usage
- Animations, gestures, micro-interactions, durations, easing, sequencing, and page transitions
- Visual feedback for input, focus, hover, pressed, selected, disabled, validation, success, and failure states
- Accessibility behavior that affects the experience, including labels, focus order, contrast, text scaling, and reduced motion

Describe observable behavior and relationships rather than copying framework-specific implementation details. Clearly mark anything that could not be inspected or verified.

### Capture business logic

Create or update `logic.md` in this skill directory as the canonical inventory of source behavior. Preserve concrete file or symbol references and capture at least:

- User journeys, use cases, and the conditions that govern each flow
- Domain entities, state models, defaults, derived values, calculations, and formatting rules
- Input constraints, validation, eligibility rules, permissions, and feature availability
- State transitions, side effects, persistence, caching, synchronization, and recovery behavior
- API contracts, external data dependencies, authentication and authorization boundaries
- Loading, empty, success, failure, retry, timeout, and offline behavior
- Analytics or event behavior when it changes product logic or is required for parity

Separate business requirements from native-framework plumbing. Record uncertain or unreachable behavior explicitly instead of inventing it.

## Phase 3: Build the work queue

Compare every entry in `design.md` and `logic.md` with the current prototype. Create or update `work.md` in this skill directory as a thorough list of only the outstanding translation work.

Organize the list by page or user journey, then by design and logic. Every work item must include:

- A concise, independently implementable outcome
- Its related `design.md` or `logic.md` section and source reference
- What the prototype currently does, including partial implementations
- What must change to reach parity
- Acceptance criteria that can be observed or tested
- Dependencies on other work items
- The planned mock for external services, remote data, or authentication when applicable

Cover all components, pages, routes, states, responsive behavior, tokens, assets, animations, transitions, and business rules. Split broad items until progress can be reported meaningfully. Do not include completed work, speculative enhancements, native-only platform chrome, or unrelated refactoring.

Before implementation, confirm that every captured design and logic requirement is either already satisfied or represented by an item in `work.md`.

## Phase 4: Implement iteratively

Read `learning.md` before planning or changing code. Apply relevant prior learnings throughout implementation.

Work through `work.md` in dependency order, one coherent item at a time:

1. Tell the user which specific item is starting and what outcome it will produce.
2. Implement it in the prototype using the web project's existing framework and conventions.
3. Report meaningful progress when the item spans multiple changes or when direction changes.
4. Verify visual behavior in the browser across relevant viewport sizes, routes, interactions, states, animations, and transitions.
5. Verify translated business logic with focused tests and observable prototype flows.
6. Use deterministic mock data and local mock authentication for external services and identity boundaries. The prototype must not depend on production credentials or live user data. Preserve the source contracts and state variations so the real integration boundary remains understandable.
7. Iterate until the acceptance criteria are met. Remove the item from `work.md` only after implementation and verification are complete.

If implementation reveals missing or incorrect source knowledge, update `design.md` or `logic.md`, add the resulting gaps to `work.md`, and continue from the corrected documents.

Create or update `learning.md` in this skill directory whenever the work reveals a reusable lesson. Record durable facts such as effective translation patterns, repository conventions, source-to-web mapping decisions, testing techniques, mock strategies, and pitfalls. Do not use it as a chronological activity log. Never store secrets, credentials, or personal data.

Make prototype changes only inside the recorded prototype project unless the user explicitly requests otherwise. Do not modify the source while translating it.

## Phase 5: Review parity

Perform a final source-to-prototype review after the work queue appears complete. Use `design.md`, `logic.md`, `learning.md`, and the source itself as evidence rather than relying on memory.

### Review visual parity

Walk every captured route and state in the browser. Confirm that the prototype accurately represents the source's components, pages, content hierarchy, layouts, responsive behavior, design tokens, assets, visual states, animations, gestures, and transitions. Compare at representative viewport sizes and exercise navigation rather than reviewing isolated screenshots only.

### Review logic parity

Demonstrate each captured journey and business rule through tests, deterministic fixtures, or visible prototype controls and states. Confirm calculations, validation, state transitions, persistence behavior, errors, retries, and conditional flows. Verify that external data and authentication are intentionally mocked while preserving the expected contracts and user-visible outcomes.

### Close or reopen work

Reconcile every section of `design.md` and `logic.md` against the prototype. Add any discovered gap back to `work.md` and return to Phase 4. Remove verified items from `work.md`; do not retain completed checklist entries.

The process is complete only when `work.md` has no outstanding items, every design and logic requirement has review evidence, the prototype works in the browser, and relevant automated tests pass. Report any environment limitation that prevented direct verification instead of claiming completion.
