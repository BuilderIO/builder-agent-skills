---
name: create-instructions
disable-model-invocation: true
description: Creates AGENTS.md with concise instructions if needed.
---

# create-instructions

Analyze the project's coding conventions and produce a concise `AGENTS.md`.

## Steps

1. **Check for existing AGENTS.md** — if one already exists at the project root, stop and tell the user it already exists. Do not overwrite it.

2. **Explore the codebase** — read a representative sample of source files (not config files) to identify patterns. Look at:
   - How files and types are named
   - How state management is handled
   - Error handling patterns
   - Testing conventions
   - Any custom abstractions or wrappers used instead of primitives
   - Patterns that deviate from the language/framework defaults
   - If a folder convention is used what that convention is

3. **Write AGENTS.md** — create it at the project root with these rules:
   - At most 20 instructions
   - Each instruction is a single line (no multi-line bullets)
   - Only include things that are **unique to this project** and **non-obvious**
   - Do NOT list the project's directory structure
   - Do NOT include anything that is standard practice for the language or framework
   - Do NOT include things a competent developer would infer automatically (e.g. "use Swift", "follow MVC")
   - Focus on: project-specific patterns, naming conventions that deviate from defaults, custom abstractions the AI must use, gotchas specific to this codebase

## Output Format

```markdown
# Project Coding Conventions

- <single line instruction>
- <single line instruction>
...
```

## Gotchas

- Don't pad the list to hit 20. Fewer sharp instructions beat 20 generic ones.
- Avoid restating what the language/framework already enforces.
- If you cannot find enough unique conventions to fill even 5 lines, say so and write what you found.
