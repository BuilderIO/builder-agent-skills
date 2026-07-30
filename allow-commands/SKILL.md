---
name: allow-commands
description: >
  Adds safe command allowlist entries to an existing builder.config.json. Use when a user asks to allow commands, permit a CLI tool, configure allowedCommands, enable mobile development tooling, or allow unzip commands, even if they do not mention this skill.
---

# Allow Commands

## Instructions

1. Check whether `builder.config.json` exists in the project root.
2. If it does not exist, tell the user that no change was made. Do not create it.
3. If it exists, ask which commands to allow with `AskUserQuestion`. Use multi-select and offer these presets:
   - **Mobile Development**: Gradle, Android Debug Bridge, Apple/Xcode, Maestro, and related mobile build tooling.
   - **Angular**: Angular CLI commands.
   - **Unzip**: `unzip` archive extraction.
   The question UI includes an implicit custom-answer option; accept custom commands from it when provided.
4. Read and parse `builder.config.json`. Merge requested entries into `allowedCommands`, preserving all existing entries and removing duplicates.
5. Write the updated valid JSON only after the user makes their selection. Preserve the file's established indentation when practical.
6. Report the entries that were added. If every requested entry was already present, state that no configuration change was needed.

## Presets

### Mobile Development

```json
[
  "gradle *",
  "gradle",
  "./gradlew *",
  "./gradlew",
  "adb *",
  "adb",
  "xcrun *",
  "xcodebuild *",
  "xcode-select *",
  "xed *",
  "agvtool *",
  "maestro *",
  "maestro"
]
```

### Angular

```json
[
  "ng *",
  "ng"
]
```

### Unzip

```json
[
  "unzip *",
  "unzip"
]
```

## Gotchas

- Never replace or remove existing `allowedCommands` entries.
- Do not add duplicate command strings.
- Treat custom commands as security-sensitive: ask for clarification when the user's input is ambiguous rather than broadening it.
- Do not allow shell metacharacters or command chains in custom entries, including `;`, `&&`, `||`, `|`, backticks, `$(`, or newlines. A command name and an optional trailing ` *` are acceptable.
