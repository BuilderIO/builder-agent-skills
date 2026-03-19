#!/bin/bash
# scan-components.sh — Scan a directory for React components and check registration status
# Usage: bash .builder/skills/fusion-to-publish-v2/scripts/scan-components.sh [directory] [registry-file]

DIR="${1:-components}"
REGISTRY="${2:-builder-registry.ts}"

if [ ! -d "$DIR" ]; then
  echo "Directory not found: $DIR"
  echo "Usage: scan-components.sh [components-directory] [builder-registry-file]"
  exit 1
fi

echo "=== Component Scan: $DIR ==="
echo "Registry: $REGISTRY"
echo ""

TOTAL=0
REGISTERED=0
UNREGISTERED=0

for file in $(find "$DIR" -name "*.tsx" -o -name "*.jsx" | grep -v '\.test\.' | grep -v '\.spec\.' | grep -v '\.stories\.' | grep -v '\.story\.' | grep -v '\.mock\.' | grep -v '\.d\.ts' | sort); do
  # Skip barrel files (index files that only re-export)
  BASENAME=$(basename "$file")
  if [ "$BASENAME" = "index.tsx" ] || [ "$BASENAME" = "index.jsx" ]; then
    # Check if it's a real component or just a barrel
    if ! grep -qE "export (default )?(function|const) [A-Z]" "$file" 2>/dev/null; then
      continue
    fi
  fi

  # Check if it exports a function component (PascalCase)
  if grep -qE "export (default )?(function|const) [A-Z]" "$file" 2>/dev/null; then
    COMPONENT_NAME=$(grep -oE "export (default )?(function|const) [A-Z][a-zA-Z]+" "$file" | head -1 | grep -oE "[A-Z][a-zA-Z]+$")

    if [ -z "$COMPONENT_NAME" ]; then
      continue
    fi

    TOTAL=$((TOTAL+1))

    # Check if already registered
    if [ -f "$REGISTRY" ] && grep -q "name: [\"']${COMPONENT_NAME}[\"']" "$REGISTRY" 2>/dev/null; then
      STATUS="REGISTERED"
      REGISTERED=$((REGISTERED+1))
      echo "[$STATUS] $COMPONENT_NAME"
      echo "  File: $file"
    else
      STATUS="UNREGISTERED"
      UNREGISTERED=$((UNREGISTERED+1))
      echo "[$STATUS] $COMPONENT_NAME"
      echo "  File: $file"

      # Show the props interface for unregistered components
      PROPS=$(grep -A 30 "export interface.*Props" "$file" 2>/dev/null | sed '/^}/q')
      if [ -n "$PROPS" ]; then
        echo "  Props:"
        echo "$PROPS" | sed 's/^/    /'
      else
        # Try type alias
        PROPS=$(grep -A 30 "export type.*Props" "$file" 2>/dev/null | sed '/^}/q')
        if [ -n "$PROPS" ]; then
          echo "  Props:"
          echo "$PROPS" | sed 's/^/    /'
        else
          echo "  Props: (not found — check component file manually)"
        fi
      fi
    fi
    echo ""
  fi
done

echo "=== Summary ==="
echo "Total components: $TOTAL"
echo "Already registered: $REGISTERED"
echo "Need registration: $UNREGISTERED"

if [ $UNREGISTERED -eq 0 ] && [ $TOTAL -gt 0 ]; then
  echo "All components are registered."
elif [ $TOTAL -eq 0 ]; then
  echo "No components found in $DIR."
fi
