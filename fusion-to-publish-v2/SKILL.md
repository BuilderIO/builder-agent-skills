---
name: fusion-to-publish-v2
description: >
  Register React components built in Builder.io for use in Publish's
  visual editor. Scaffolds catch-all routes, builder-registry, SDK configuration,
  and .builderrules. Maps TypeScript props to Builder input types and generates
  Builder.registerComponent() calls. Use when the user wants to register a
  component for Publish, set up Publish integration, make components available
  in the visual editor, do a Fusion-to-Publish or f2p setup, connect Fusion
  output to the headless CMS, bulk-register components from a directory, or
  make components draggable for non-developers — even if they don't mention
  "Publish" by name.
---

# Fusion to Publish (v2)

Bridge Builder.io Fusion (code generation) and Publish (visual CMS) by registering React components for the visual editor.

## What You'll Do

1. **Set up Publish integration** — scaffold the catch-all route, registry, SDK config, and .builderrules
2. **Register a component** — read TypeScript props, map to Builder input types, add to registry
3. **Bulk-register components** — scan a directory and register all components at once

## Quick Start: Detect Project State

Before starting any workflow, run this to understand the project's current state:

```bash
bash .builder/skills/fusion-to-publish-v2/scripts/detect-project.sh
```

This outputs the SDK version, Next.js version, app root, registry status, API key status, and catch-all route status. Use this to decide which scaffolding steps to skip.

If the script is not available, detect manually:
1. Check `package.json` for `@builder.io/react` (Gen1) or `@builder.io/sdk-react` (Gen2)
2. Check for `src/app/` or `app/` directory
3. Check if `builder-registry.ts` exists at the project root
4. Check `.env.local` for `NEXT_PUBLIC_BUILDER_API_KEY`

## Workflow 1: Set Up Publish Integration

Run this once per project. Each step is idempotent — skip what already exists.

### Prerequisites

- A Next.js App Router project (with `app/` or `src/app/`)
- A Builder.io Publish space with a public API key

### Steps

Run the detect script first (see Quick Start above). Then create only what is missing. If a file exists but differs from the expected pattern, show the user and ask how to proceed.

1. **Ensure SDK is installed.** Check `package.json` for `@builder.io/react`. If missing, install it along with `@builder.io/dev-tools`:
   ```bash
   npm install @builder.io/react @builder.io/dev-tools
   ```

2. **Configure the API key.** Check `.env.local` for `NEXT_PUBLIC_BUILDER_API_KEY`. If not found, check `.env`. If in `.env` but not `.env.local`, warn the user: "Your API key is in `.env`, which may be committed to version control. Consider moving it to `.env.local`." If not found anywhere, ask the user for their Builder.io public API key. Write it to `.env.local`. Ensure `.gitignore` includes `.env*.local`. Create `.env.example` with `NEXT_PUBLIC_BUILDER_API_KEY=your-builder-public-api-key`.

3. **Create `builder-registry.ts` at the project root.** See [references/scaffolding-templates.md](references/scaffolding-templates.md) for the exact template. Key points:
   - Must have `"use client"` directive
   - Initializes the client-side SDK via `@builder.io/react`
   - Uses a runtime guard for the API key (no `!` assertion)

4. **Create the catch-all route** at `app/[...page]/page.tsx` (or `src/app/[...page]/page.tsx`). This is a server component that fetches Builder content. See [references/scaffolding-templates.md](references/scaffolding-templates.md). Key points:
   - Uses `@builder.io/sdk` (NOT `@builder.io/react`) for server-side fetching
   - Has its own `builder.init()` — this is separate from the client-side init in the registry
   - Uses `[...page]` (required catch-all), NOT `[[...page]]` (optional), to preserve the user's homepage
   - Detect the Next.js version from `package.json` for the correct `params` pattern (Promise in 15+, direct in 14)

   Before creating, check for existing catch-all or dynamic routes (`[...page]`, `[[...page]]`, `[...slug]`). If found, show the user and ask how to proceed.

5. **Create `components/builder.tsx`** (the `RenderBuilderContent` wrapper). See [references/scaffolding-templates.md](references/scaffolding-templates.md). Key points:
   - Must have `"use client"` directive
   - Imports `@/builder-registry` as a side-effect (triggers all component registrations)
   - Accepts an optional `model` prop (defaults to `"page"`)

6. **Wrap `next.config`** with `@builder.io/dev-tools`. Check if already wrapped by searching for `@builder.io/dev-tools` or `BuilderDevTools`. If found, skip. If the file has `BuilderDevTools()(BuilderDevTools()(` (double wrapping), fix it. Handle `.ts`, `.js`, and `.mjs` variants.

7. **Create or update `.builderrules`** with component creation conventions. Adapt the template to match existing project conventions (e.g., Tailwind vs CSS Modules, `src/` vs root). See [references/scaffolding-templates.md](references/scaffolding-templates.md) for the default template.

### After Scaffolding

Tell the user: "Publish integration is set up. Deploy your app to a public URL (Vercel, Netlify, etc.) — Builder's visual editor cannot work with localhost. Then use this skill to register components."

## Workflow 2: Register a Component

When the user wants to register a component for Publish's visual editor.

### Prerequisites

Verify scaffolding is complete: `builder-registry.ts` exists, the catch-all route exists, SDK is installed. If anything is missing, offer to run Workflow 1 first.

### Steps

1. **Read the component file.** Find the exported props interface or type. If the type is imported from another file, follow the import to resolve it. Skip React-internal types (`ReactNode`, `CSSProperties`, `MouseEventHandler`, `HTMLAttributes`, etc.).

2. **Map props to Builder inputs.** Use the type mapping in [references/sdk-reference.md](references/sdk-reference.md). Key rules:
   - Evaluate TypeScript type first, then apply name heuristics only for plain `string` props
   - String literal unions (`'a' | 'b'`) → `type: "text"` with `enum` array (NOT `type: "enum"`)
   - `list` inputs MUST have `defaultValue: []`
   - `object` inputs MUST have `defaultValue: {}`
   - `children: ReactNode` → skip the prop, add `canHaveChildren: true` to the registration
   - Generate `friendlyName` from PascalCase props (`backgroundColor` → `"Background Color"`)
   - Generate `helperText` for non-obvious inputs
   - Use `advanced: true` for typically-defaulted props (`className`, `id`)

3. **Generate the registration.** Add a `Builder.registerComponent()` call to `builder-registry.ts` using `dynamic(() => import(...))` with the correct relative path from the registry file (or use the `@/` alias). See [references/examples.md](references/examples.md) for complete examples.

4. **Optionally update the showcase page.** If `app/page.tsx` has a "Component Showcase" pattern, add the component with sample data. If the homepage is not a showcase page, skip this step.

5. **Log the registration.** Append an entry to `registration-log.json` in this skill's directory (see Registration History below).

6. **Guide verification.** Tell the user:
   - Deploy the updated app
   - Open Builder.io → Publish space → Visual Editor
   - Check the Insert tab → Custom Components → look for the registered component
   - Drag it onto the canvas and verify inputs appear correctly
   - If the component doesn't appear: check that `builder-registry.ts` is imported in `components/builder.tsx`, the dynamic import path is correct, and the app is deployed

## Workflow 3: Bulk Register Components

Scan a directory and register all unregistered components. **Use parallel sub-agents** to analyze multiple components simultaneously.

### Step 1: Scan

Run the scan script to identify what needs registration:
```bash
bash .builder/skills/fusion-to-publish-v2/scripts/scan-components.sh components builder-registry.ts
```
If the script is not available, scan manually: find `.tsx`/`.jsx` files, skip `*.test.*`, `*.spec.*`, `*.stories.*`, `*.story.*`, `*.mock.*`, `*.d.ts`, and barrel files.

### Step 2: Analyze in parallel (sub-agents)

For each UNREGISTERED component from the scan, **spawn a sub-agent** to analyze it independently. All sub-agents run in parallel.

Each sub-agent receives:
- The component file path
- The type mapping rules from [references/sdk-reference.md](references/sdk-reference.md)
- The examples from [references/examples.md](references/examples.md)

Each sub-agent does:
1. Read the component file
2. Parse the exported props interface (follow imports if needed)
3. Map each prop to a Builder input using the type mapping rules
4. Generate the complete `Builder.registerComponent()` code block
5. Return the registration code and a summary (component name, input count, any warnings)

**Example sub-agent dispatch:**
```
For each unregistered component, spawn a sub-agent:

Sub-agent 1: "Read components/HeroSection/HeroSection.tsx.
  Parse its props interface.
  Map props to Builder inputs using the type mapping in references/sdk-reference.md.
  Generate a Builder.registerComponent() call.
  Return the complete registration code block."

Sub-agent 2: "Read components/PricingCard/PricingCard.tsx. [same instructions]"

Sub-agent 3: "Read components/TestimonialGrid/TestimonialGrid.tsx. [same instructions]"

All sub-agents run in parallel.
```

### Step 3: Assemble registrations (serial)

After all sub-agents complete, collect their registration code blocks and:

1. **Review each registration** for correctness (check for warnings from sub-agents)
2. **Add all registrations to `builder-registry.ts`** — append them sequentially. Add the `import dynamic from "next/dynamic"` at the top if not already present.
3. **Log each registration** to `registration-log.json`

This step must be serial because all registrations write to the same file.

### Step 4: Report results

Summarize: how many registered, skipped (already registered), and failed (with reasons from sub-agents).

If a sub-agent fails to analyze a component (e.g., complex types that can't be resolved), report the failure but don't block other registrations.

## Registration History

After each successful registration, append an entry to `registration-log.json` in this skill's directory:

```json
{
  "registrations": [
    {
      "component": "HeroSection",
      "file": "components/HeroSection/HeroSection.tsx",
      "registeredAt": "2026-03-19T20:30:00Z",
      "inputCount": 5,
      "notes": "Container with canHaveChildren"
    }
  ]
}
```

Before registering a component, check this log. If a component was previously registered but is no longer in `builder-registry.ts`, note this for the user — it may have been intentionally removed.

## Gotchas

These are the most common failure modes. Check here first when debugging.

1. **`list` and `object` inputs require `defaultValue`.** Without `defaultValue: []` (list) or `defaultValue: {}` (object), Builder errors when adding the component to a page. Non-obvious and causes "component won't load" debugging.

2. **`enum` requires `type: "text"` with an `enum` array.** There is no `type: "enum"` in Builder. Using it causes the input to silently not render.

3. **Two separate `builder.init()` calls are correct.** The catch-all route uses `@builder.io/sdk` (server-side), and `builder-registry.ts` uses `@builder.io/react` (client-side). These are different packages. Both need initialization. Do NOT "fix" this by removing one.

4. **API key must be in the deployment environment.** `.env.local` works locally but is not deployed. Users must add `NEXT_PUBLIC_BUILDER_API_KEY` in their hosting platform's environment settings. This is the #1 "it doesn't work in production" cause.

5. **Side-effect import path must be correct.** `import "@/builder-registry"` in `components/builder.tsx` is what triggers component registrations. If this path is wrong, the build succeeds but no custom components appear in the editor. Verify this import first when debugging missing components.

6. **Dynamic import path is relative to `builder-registry.ts`.** If the registry is at the project root and the component is at `components/Hero/Hero.tsx`, the import must be `./components/Hero/Hero`. Wrong paths cause the component to register but render blank.

7. **Double `BuilderDevTools` wrapping.** The f2p template has a bug: `BuilderDevTools()(BuilderDevTools()(nextConfig))`. Always check for existing wrapping before adding it.

8. **Next.js 15+ `params` is a Promise.** Must be awaited. Next.js 14 uses params directly. Check the version in `package.json`.

9. **`[...page]` does not handle the root path `/`.** If the user needs Builder to manage the homepage, they need to add Builder content fetching to `app/page.tsx` separately, or switch to `[[...page]]` and remove `app/page.tsx`.

10. **CSP headers may block the visual editor.** Builder's editor loads the deployed site in an iframe. If the app sets `X-Frame-Options` or CSP `frame-ancestors`, it must allow `https://*.builder.io`.

## When to Use What

| Need | Tool | Why |
|------|------|-----|
| Register components for Publish visual editor | **This skill** | Automates TypeScript → Builder input mapping and scaffolding |
| Help the AI understand your design system | **Component Indexing** (`npx @builder.io/dev-tools index-repo`) | Different purpose: improves code generation, not Publish registration |
| Project-wide coding conventions | **AGENTS.md** | Always loaded, good for conventions all AI tools should follow |
| Directory-scoped rules | **.builderrules** or **.builder/rules/** | Proximity-based, Builder-specific |
| Register components manually | **@builder.io/dev-tools UI** | Visual registration without this skill |

## Anti-Patterns

- **Never use `type: "enum"`.** Use `type: "text"` with an `enum` array.
- **Never skip `defaultValue` on list/object inputs.** Builder will error.
- **Never use `[[...page]]` if the user has a homepage.** It conflicts with `app/page.tsx`.
- **Never write API keys to `.env`** (only `.env.local`).
- **Never wrap `BuilderDevTools()` twice.**
- **Never register event handlers, CSSProperties, or HTML attributes as Builder inputs.**
- **Never remove either `builder.init()` call.** Server and client inits serve different purposes.

## Audit Checklist

After registering a component, verify:

- [ ] `builder-registry.ts` has `"use client"` directive
- [ ] Dynamic import path resolves to the correct component file
- [ ] All `list` inputs have `defaultValue: []`
- [ ] All `object` inputs have `defaultValue: {}`
- [ ] Enum props use `type: "text"` with `enum` array
- [ ] No event handlers, CSSProperties, or HTML attributes in inputs
- [ ] `children` prop is handled via `canHaveChildren: true`, not as an input
- [ ] Required props have `required: true`
- [ ] API key is set in both `.env.local` and deployment environment

## Scripts

This skill includes helper scripts in `scripts/`:

- **`detect-project.sh`** — Detects project structure, SDK version, scaffolding status. Run at the start of any workflow.
- **`scan-components.sh`** — Scans a directory for React components and checks registration status. Used in Workflow 3.

## Reference Files

For complete SDK API reference and type mapping table, see [references/sdk-reference.md](references/sdk-reference.md).

For exact scaffolding file templates, see [references/scaffolding-templates.md](references/scaffolding-templates.md).

For end-to-end component registration examples, see [references/examples.md](references/examples.md).
