#!/bin/bash
# detect-project.sh — Detect project state for Fusion-to-Publish skill
# Usage: bash .builder/skills/fusion-to-publish-v2/scripts/detect-project.sh

echo "=== Fusion-to-Publish: Project State ==="
echo ""

# SDK detection
if command -v node &>/dev/null && [ -f package.json ]; then
  SDK=$(node -e "
    const p = JSON.parse(require('fs').readFileSync('package.json', 'utf8'));
    const d = p.dependencies || {};
    if (d['@builder.io/react']) console.log('@builder.io/react (Gen1) ' + d['@builder.io/react']);
    else if (d['@builder.io/sdk-react']) console.log('@builder.io/sdk-react (Gen2) ' + d['@builder.io/sdk-react']);
    else console.log('NOT INSTALLED');
  " 2>/dev/null)
  echo "Builder SDK: $SDK"

  NEXT=$(node -e "
    const p = JSON.parse(require('fs').readFileSync('package.json', 'utf8'));
    console.log(p.dependencies?.next || 'not found');
  " 2>/dev/null)
  echo "Next.js: $NEXT"
else
  echo "Builder SDK: cannot detect (no node or package.json)"
  echo "Next.js: cannot detect"
fi

# App root detection
if [ -d "src/app" ]; then
  echo "App root: src/app/"
elif [ -d "app" ]; then
  echo "App root: app/"
else
  echo "App root: NOT FOUND"
fi

# Registry detection
if [ -f "builder-registry.ts" ]; then
  COUNT=$(grep -c "registerComponent" builder-registry.ts 2>/dev/null || echo "0")
  echo "Registry: builder-registry.ts ($COUNT components registered)"
elif [ -f "src/builder-registry.ts" ]; then
  COUNT=$(grep -c "registerComponent" src/builder-registry.ts 2>/dev/null || echo "0")
  echo "Registry: src/builder-registry.ts ($COUNT components registered)"
else
  echo "Registry: NOT FOUND"
fi

# Catch-all route detection
CATCHALL=""
for path in "app/[...page]/page.tsx" "src/app/[...page]/page.tsx" "app/[[...page]]/page.tsx" "src/app/[[...page]]/page.tsx"; do
  if [ -f "$path" ]; then
    CATCHALL="$path"
    break
  fi
done
if [ -n "$CATCHALL" ]; then
  echo "Catch-all route: $CATCHALL"
else
  echo "Catch-all route: NOT FOUND"
fi

# API key detection
if grep -q "NEXT_PUBLIC_BUILDER_API_KEY" .env.local 2>/dev/null; then
  echo "API key: configured (.env.local)"
elif grep -q "NEXT_PUBLIC_BUILDER_API_KEY" .env 2>/dev/null; then
  echo "API key: configured (.env) — WARNING: may be committed to version control"
else
  echo "API key: NOT CONFIGURED"
fi

# Dev-tools wrapper detection
DEVTOOLS="no"
for cfg in next.config.ts next.config.js next.config.mjs; do
  if [ -f "$cfg" ] && grep -q "BuilderDevTools\|@builder.io/dev-tools" "$cfg" 2>/dev/null; then
    DEVTOOLS="yes ($cfg)"
    # Check for double wrapping
    if grep -q "BuilderDevTools()(BuilderDevTools()" "$cfg" 2>/dev/null; then
      DEVTOOLS="yes ($cfg) — WARNING: double-wrapped!"
    fi
    break
  fi
done
echo "Dev-tools wrapper: $DEVTOOLS"

# RenderBuilderContent detection
if [ -f "components/builder.tsx" ] || [ -f "src/components/builder.tsx" ]; then
  echo "RenderBuilderContent: found"
else
  echo "RenderBuilderContent: NOT FOUND"
fi

# .builderrules detection
if [ -f ".builderrules" ]; then
  echo ".builderrules: found"
else
  echo ".builderrules: NOT FOUND"
fi

echo ""
echo "=== Summary ==="
MISSING=0
[ "$SDK" = "NOT INSTALLED" ] && echo "  - Need to install Builder SDK" && MISSING=$((MISSING+1))
[ ! -f "builder-registry.ts" ] && [ ! -f "src/builder-registry.ts" ] && echo "  - Need to create builder-registry.ts" && MISSING=$((MISSING+1))
[ -z "$CATCHALL" ] && echo "  - Need to create catch-all route" && MISSING=$((MISSING+1))
if ! grep -q "NEXT_PUBLIC_BUILDER_API_KEY" .env.local 2>/dev/null && ! grep -q "NEXT_PUBLIC_BUILDER_API_KEY" .env 2>/dev/null; then
  echo "  - Need to configure API key" && MISSING=$((MISSING+1))
fi
[ "$DEVTOOLS" = "no" ] && echo "  - Need to wrap next.config with BuilderDevTools" && MISSING=$((MISSING+1))

if [ $MISSING -eq 0 ]; then
  echo "  All scaffolding is in place. Ready to register components."
else
  echo "  $MISSING scaffolding step(s) needed. Run Workflow 1."
fi
