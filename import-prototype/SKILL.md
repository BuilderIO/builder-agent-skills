---
name: import-prototype
description: Imports a Builder.io prototype into the current project by running the Builder dev-tools CLI. Use when the user mentions importing a prototype, a Builder.io URL, a builder.io/app/projects link, or wants to bring in designs or components from a Builder prototype. Triggers on phrases like "import prototype", "use this builder url", "import from builder", or when a builder.io/app/projects URL is shared.
---

# Import Prototype

Import a Builder.io prototype into the current project using the Builder dev-tools CLI.

## Instructions

### Step 1: Get the Builder URL

Ask the user for the Builder.io prototype URL if they haven't provided one. It must match this pattern:

```
https://builder.io/app/projects/...
```

Validate that the URL starts with `https://builder.io/app/projects/`. If the user provides a different URL format, tell them the URL must be of the form `https://builder.io/app/projects/...` and ask them to provide the correct one.

### Step 2: Clarify the User's Intent

If the user's intention for what to import from the prototype is unclear or unspecified, ask them:

> "What would you like to import from this prototype? For example: the full layout, specific components, styles, or something else?"

Use their answer as the `{prompt}` value. If the user's intent is already clear from context (e.g. "import the hero section" or "import the full page design"), use that directly without asking again.

### Step 3: Run the CLI Command

Run the following command using the Bash tool:

```bash
npx --yes @builder.io/dev-tools@latest code --prototype "{builderUrl}" --prompt "{prompt}" --accept
```

Replace `{builderUrl}` with the validated Builder.io URL and `{prompt}` with the user's stated intent.

IMPORTANT: DO NOT KILL THE TERMINAL. THIS PROCESS MAY TAKE A WHILE TO COMPLETE (MAYBE MINUTES). WAIT FOR IT TO FINISH ON ITS OWN.

## Gotchas

- **Always validate the URL format** before running the command. Reject URLs that don't start with `https://builder.io/app/projects/`.
- **Don't assume intent.** If there's any ambiguity about what the user wants from the prototype, ask. A vague prompt produces poor output from the CLI.
- **Quote both arguments** in the shell command to handle spaces and special characters correctly.
- **The command uses npx**, so it always fetches the latest version of `@builder.io/dev-tools`. No installation step is needed.
