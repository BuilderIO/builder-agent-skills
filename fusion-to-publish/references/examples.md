# Component Registration Examples

Complete end-to-end examples showing a TypeScript component and its Builder registration.

## Example 1: Simple Component (text + number)

### Component

```tsx
// components/PricingCard/PricingCard.tsx
export interface PricingCardProps {
  title: string;
  price: number;
  description?: string;
  highlighted?: boolean;
}

export default function PricingCard({
  title,
  price,
  description,
  highlighted = false,
}: PricingCardProps) {
  return (
    <div className={highlighted ? "card highlighted" : "card"}>
      <h3>{title}</h3>
      <p className="price">${price}/mo</p>
      {description && <p>{description}</p>}
    </div>
  );
}
```

### Registration

```tsx
// In builder-registry.ts
import dynamic from "next/dynamic";

Builder.registerComponent(
  dynamic(() => import("./components/PricingCard/PricingCard")),
  {
    name: "PricingCard",
    inputs: [
      {
        name: "title",
        type: "text",
        friendlyName: "Title",
        required: true,
        defaultValue: "Starter Plan",
      },
      {
        name: "price",
        type: "number",
        friendlyName: "Price",
        required: true,
        defaultValue: 29,
        helperText: "Monthly price in dollars",
      },
      {
        name: "description",
        type: "longText",
        friendlyName: "Description",
        helperText: "Short description of the plan",
      },
      {
        name: "highlighted",
        type: "boolean",
        friendlyName: "Highlighted",
        defaultValue: false,
        helperText: "Add a highlight border to this card",
      },
    ],
  }
);
```

**Why `description` maps to `longText`:** The prop name "description" matches the name heuristic for longer text content. For a single-line label, `text` would be used instead.

---

## Example 2: Rich Component (enum, images, colors)

### Component

```tsx
// components/HeroBanner/HeroBanner.tsx
export interface HeroBannerProps {
  heading: string;
  subheading?: string;
  variant: "light" | "dark" | "gradient";
  backgroundImage?: string;
  overlayColor?: string;
  ctaText?: string;
  ctaUrl?: string;
}

export default function HeroBanner({
  heading,
  subheading,
  variant = "light",
  backgroundImage,
  overlayColor,
  ctaText,
  ctaUrl,
}: HeroBannerProps) {
  return (
    <section className={`hero hero--${variant}`}>
      {backgroundImage && <img src={backgroundImage} alt="" />}
      <div style={{ backgroundColor: overlayColor }}>
        <h1>{heading}</h1>
        {subheading && <p>{subheading}</p>}
        {ctaText && <a href={ctaUrl}>{ctaText}</a>}
      </div>
    </section>
  );
}
```

### Registration

```tsx
Builder.registerComponent(
  dynamic(() => import("./components/HeroBanner/HeroBanner")),
  {
    name: "HeroBanner",
    inputs: [
      {
        name: "heading",
        type: "text",
        friendlyName: "Heading",
        required: true,
        defaultValue: "Welcome to Our Site",
      },
      {
        name: "subheading",
        type: "text",
        friendlyName: "Subheading",
      },
      {
        name: "variant",
        type: "text",
        friendlyName: "Variant",
        enum: [
          { label: "Light", value: "light" },
          { label: "Dark", value: "dark" },
          { label: "Gradient", value: "gradient" },
        ],
        defaultValue: "light",
        helperText: "Visual theme for the hero section",
      },
      {
        name: "backgroundImage",
        type: "file",
        friendlyName: "Background Image",
        allowedFileTypes: ["jpeg", "jpg", "png", "webp"],
      },
      {
        name: "overlayColor",
        type: "color",
        friendlyName: "Overlay Color",
        helperText: "Semi-transparent color over the background image",
      },
      {
        name: "ctaText",
        type: "text",
        friendlyName: "CTA Text",
        defaultValue: "Get Started",
      },
      {
        name: "ctaUrl",
        type: "url",
        friendlyName: "CTA URL",
      },
    ],
  }
);
```

**Key patterns:**
- `variant: "light" | "dark" | "gradient"` → `type: "text"` with `enum` array (NOT `type: "enum"`)
- `backgroundImage` → `type: "file"` (name heuristic: contains "image")
- `overlayColor` → `type: "color"` (name heuristic: contains "color")
- `ctaUrl` → `type: "url"` (name heuristic: contains "url")

---

## Example 3: Complex Component (list/object with subFields)

### Component

```tsx
// components/TestimonialGrid/TestimonialGrid.tsx
export interface Testimonial {
  quote: string;
  author: string;
  avatar?: string;
  rating: number;
  company?: {
    name: string;
    logo?: string;
  };
}

export interface TestimonialGridProps {
  title: string;
  testimonials: Testimonial[];
  columns?: number;
}

export default function TestimonialGrid({
  title,
  testimonials,
  columns = 3,
}: TestimonialGridProps) {
  return (
    <section>
      <h2>{title}</h2>
      <div style={{ display: "grid", gridTemplateColumns: `repeat(${columns}, 1fr)` }}>
        {testimonials.map((t, i) => (
          <div key={i}>
            <p>{t.quote}</p>
            <div>
              {t.avatar && <img src={t.avatar} alt={t.author} />}
              <strong>{t.author}</strong>
              {t.company && <span>{t.company.name}</span>}
            </div>
            <div>{"★".repeat(t.rating)}</div>
          </div>
        ))}
      </div>
    </section>
  );
}
```

### Registration

```tsx
Builder.registerComponent(
  dynamic(() => import("./components/TestimonialGrid/TestimonialGrid")),
  {
    name: "TestimonialGrid",
    inputs: [
      {
        name: "title",
        type: "text",
        friendlyName: "Title",
        required: true,
        defaultValue: "What Our Customers Say",
      },
      {
        name: "testimonials",
        type: "list",
        friendlyName: "Testimonials",
        defaultValue: [
          {
            quote: "Amazing product!",
            author: "Jane Smith",
            rating: 5,
            company: { name: "Acme Corp" },
          },
        ],
        subFields: [
          { name: "quote", type: "longText", required: true },
          { name: "author", type: "text", required: true },
          {
            name: "avatar",
            type: "file",
            allowedFileTypes: ["jpeg", "jpg", "png", "webp"],
          },
          { name: "rating", type: "number", min: 1, max: 5, defaultValue: 5 },
          {
            name: "company",
            type: "object",
            defaultValue: {},
            subFields: [
              { name: "name", type: "text" },
              {
                name: "logo",
                type: "file",
                allowedFileTypes: ["svg", "png"],
              },
            ],
          },
        ],
      },
      {
        name: "columns",
        type: "number",
        friendlyName: "Columns",
        defaultValue: 3,
        min: 1,
        max: 6,
        helperText: "Number of columns in the grid",
      },
    ],
  }
);
```

**Critical patterns:**
- `testimonials: Testimonial[]` → `type: "list"` with `defaultValue: [...]` (MUST have defaultValue)
- Nested `company: { name, logo }` → `type: "object"` with `defaultValue: {}` (MUST have defaultValue)
- `rating: number` with `min: 1, max: 5` constraints
- `quote` → `longText` (name heuristic for longer content)

---

## Example 4: Container Component (children + noWrap)

### Component

```tsx
// components/ContentSection/ContentSection.tsx
import { ReactNode } from "react";

export interface ContentSectionProps {
  title?: string;
  backgroundColor?: string;
  maxWidth?: "narrow" | "medium" | "wide" | "full";
  children: ReactNode;
}

export default function ContentSection({
  title,
  backgroundColor,
  maxWidth = "medium",
  children,
  ...props
}: ContentSectionProps & { attributes?: Record<string, unknown> }) {
  const widthMap = { narrow: "640px", medium: "960px", wide: "1200px", full: "100%" };

  return (
    <section
      style={{ backgroundColor, maxWidth: widthMap[maxWidth], margin: "0 auto" }}
      {...(props as any).attributes}
    >
      {title && <h2>{title}</h2>}
      {children}
    </section>
  );
}
```

### Registration

```tsx
Builder.registerComponent(
  dynamic(() => import("./components/ContentSection/ContentSection")),
  {
    name: "ContentSection",
    canHaveChildren: true,
    noWrap: true,
    inputs: [
      {
        name: "title",
        type: "text",
        friendlyName: "Section Title",
      },
      {
        name: "backgroundColor",
        type: "color",
        friendlyName: "Background Color",
      },
      {
        name: "maxWidth",
        type: "text",
        friendlyName: "Max Width",
        enum: [
          { label: "Narrow (640px)", value: "narrow" },
          { label: "Medium (960px)", value: "medium" },
          { label: "Wide (1200px)", value: "wide" },
          { label: "Full Width", value: "full" },
        ],
        defaultValue: "medium",
      },
    ],
  }
);
```

**Key patterns:**
- `children: ReactNode` → NOT added as an input. Instead, `canHaveChildren: true` is added to the registration. This lets users drag other blocks inside this component in the editor.
- `noWrap: true` → The component renders a `<section>` (semantic element). Without `noWrap`, Builder adds a wrapper `<div>` that breaks the semantic HTML. When using `noWrap`, the component MUST spread `{...props.attributes}` on its root element.
- `backgroundColor` → `type: "color"` (name heuristic: contains "color")
- `maxWidth: "narrow" | "medium" | "wide" | "full"` → `type: "text"` with `enum` (union takes precedence over name heuristic)
