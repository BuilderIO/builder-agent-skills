# Builder.io SDK Reference for Component Registration

## Builder.registerComponent() API (Gen1)

```tsx
import { Builder } from "@builder.io/react";
import dynamic from "next/dynamic";

Builder.registerComponent(
  dynamic(() => import("./components/MyComponent/MyComponent")),
  {
    name: "MyComponent",          // Required: unique identifier in the editor
    inputs: [...],                // Input definitions (see below)
    image: "https://...",         // Icon URL in the editor's insert menu
    canHaveChildren: false,       // Enable child element support
    defaultChildren: [],          // Initial child elements when dropped
    defaultStyles: {},            // CSS styles applied by default
    noWrap: false,                // Render without wrapper div (component must spread props.attributes)
    models: ["page"],             // Restrict to specific content models
    hideFromInsertMenu: false,    // Hide from editor (for deprecation)
    childRequirements: {},        // Restrict which children are valid
    requiresParent: {},           // Restrict which parents are valid
  }
);
```

## Input Types

Each entry in the `inputs` array defines a control in Publish's visual editor.

### Input Properties

| Property | Type | Required | Description |
|---|---|---|---|
| `name` | `string` | Yes | Prop name passed to the component |
| `type` | `string` | Yes | Editor control type (see table below) |
| `friendlyName` | `string` | No | Display label in the editor |
| `defaultValue` | `any` | **Yes for list/object** | Initial value. MUST be `[]` for list, `{}` for object |
| `required` | `boolean` | No | Mark as mandatory |
| `helperText` | `string` | No | Description shown below the input |
| `subFields` | `Input[]` | For list/object | Nested field definitions |
| `enum` | `string[]` or `{label, value}[]` | For dropdowns | Options for text inputs |
| `min` / `max` / `step` | `number` | No | Constraints for number inputs |
| `advanced` | `boolean` | No | Place under "show more" section |
| `showIf` | `string` | No | JS expression to conditionally show |
| `localized` | `boolean` | No | Enable translation support |
| `allowedFileTypes` | `string[]` | For file | Restrict file types (e.g., `["jpeg", "png"]`) |
| `model` | `string` | For reference | Restrict reference to specific model |

### Available Input Types

| Type | Description | Value Returned |
|---|---|---|
| `text` / `string` | Single-line text. Add `enum` for dropdown. | `string` |
| `longText` | Multi-line textarea | `string` |
| `richText` | Rich text WYSIWYG editor | HTML `string` |
| `number` | Numeric input with stepper | `number` |
| `boolean` | Toggle switch | `boolean` |
| `color` | Color picker | hex/rgba `string` |
| `file` | File upload (returns URL) | URL `string` |
| `url` | URL input | `string` |
| `email` | Email input | `string` |
| `date` | Date picker | ISO date `string` |
| `list` | Repeating items. **Requires `subFields` and `defaultValue: []`** | `array` |
| `object` | Nested group. **Requires `subFields` and `defaultValue: {}`** | `object` |
| `reference` | Content entry picker | reference object |
| `tags` | Tag/chip input | `string[]` |
| `code` | Code editor | `string` |
| `json` | JSON editor | `object` |

**There is no `type: "enum"`.** For dropdown selection, use `type: "text"` with an `enum` array.

## TypeScript to Builder Input Type Mapping

When mapping a component's TypeScript props to Builder inputs, evaluate in this order:

### Step 1: Check the TypeScript type

| TypeScript Type | Builder Input | Notes |
|---|---|---|
| `string` | `text` | Apply name heuristics in Step 2 |
| `number` | `number` | |
| `boolean` | `boolean` | |
| `'a' \| 'b' \| 'c'` (string literal union) | `text` with `enum` | Extract members as enum values. Use first as `defaultValue`. |
| `number \| string` (mixed union) | `text` | Fallback to text |
| `string[]` | `tags` | |
| `T[]` / `Array<T>` | `list` with `subFields` | Recurse into T. MUST add `defaultValue: []` |
| `{ key: Type }` / interface | `object` with `subFields` | Recurse into properties. MUST add `defaultValue: {}` |
| `Date` | `date` | |
| `React.ReactNode` / `children` | **Skip** | Add `canHaveChildren: true` to registration instead |
| `React.CSSProperties` | **Skip** | Don't expose raw CSS |
| `React.MouseEventHandler` etc. | **Skip** | Event handlers not relevant in Publish |
| `HTMLAttributes<*>` | **Skip** | Filter out inherited HTML props |
| `any` / `unknown` | `text` | Warn the user |
| Custom imported type | Follow the import, resolve the type, then map | |

### Step 2: Name heuristics (only for plain `string` props)

Only apply these if Step 1 resolved to plain `string` (not a union, not a specific type):

| Prop name contains | Map to | Example |
|---|---|---|
| `color`, `backgroundColor`, `borderColor` | `color` | `textColor: string` → `color` |
| `image`, `src`, `backgroundImage`, `avatar`, `logo`, `thumbnail` | `file` with `allowedFileTypes: ["jpeg", "jpg", "png", "svg", "webp"]` | `heroImage: string` → `file` |
| `url`, `href`, `link` | `url` | `ctaUrl: string` → `url` |
| `description`, `body`, `content`, `bio`, `summary` | `longText` | `description: string` → `longText` |
| `html`, `richContent` | `richText` | `bodyHtml: string` → `richText` |

**Never apply name heuristics to union types.** The union values carry more semantic information than the prop name. `colorScheme: 'light' | 'dark'` is an enum, not a color picker.

### Step 3: Additional mapping rules

- Optional prop (`name?: Type`) → `required: false`
- Required prop (`name: Type`) → `required: true`
- Destructured default (`{ name = 'default' }`) → `defaultValue: 'default'`
- Generate `friendlyName` from PascalCase: `backgroundColor` → `"Background Color"`
- Generate `helperText` for non-obvious inputs (5-10 words describing what it controls)
- Use `advanced: true` for `className`, `id`, `style`, `aria-*` props
- If the component renders a semantic root element (`<section>`, `<header>`, `<nav>`), consider `noWrap: true` on the registration. When using `noWrap`, the component must spread `{...props.attributes}` on its root element.

## SDK Packages (Important Distinction)

| Package | Use For | Import |
|---|---|---|
| `@builder.io/react` | Client-side: component registration, `BuilderComponent`, `useIsPreviewing` | `builder-registry.ts`, `components/builder.tsx` |
| `@builder.io/sdk` | Server-side: content fetching, `builder.get()` | `app/[...page]/page.tsx` |
| `@builder.io/dev-tools` | Build tool: wraps `next.config` for visual editing integration | `next.config.ts` |

Both `@builder.io/react` and `@builder.io/sdk` need their own `builder.init()` call. They are separate SDK entry points.

## External Documentation

- [Custom Components Setup](https://www.builder.io/c/docs/custom-components-setup)
- [Input Types Reference](https://www.builder.io/c/docs/custom-components-input-types)
- [Component Interface](https://github.com/BuilderIO/builder/blob/main/packages/core/docs/interfaces/Component.md)
- [Input Interface](https://github.com/BuilderIO/builder/blob/main/packages/core/docs/interfaces/Input.md)
