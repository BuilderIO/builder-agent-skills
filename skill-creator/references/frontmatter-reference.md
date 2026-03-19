# Frontmatter Reference

Complete documentation for SKILL.md frontmatter fields.

## Core Fields

### `name`

- **Required:** Recommended (defaults to directory name if omitted)
- **Constraints:** Lowercase letters, numbers, hyphens only. Max 64 characters. No consecutive hyphens (`--`). No leading/trailing hyphens. Must match the parent directory name.
- **Example:** `name: pdf-processor`

### `description`

- **Required:** Yes
- **Max length:** 1024 characters
- **Purpose:** The primary trigger mechanism. The AI scans all skill descriptions at session start to decide which skills to load when a request matches. This is a trigger definition for the AI, not a human-readable summary.

**How to write effective descriptions:**

Use the **WHAT + WHEN** pattern:

```yaml
description: >
  [WHAT it does]. Use when [WHEN to trigger], [more trigger
  contexts], even if [near-miss scenario].
```

See the main SKILL.md for detailed good/bad examples.

## Additional Fields

The [Agent Skills Open Standard](https://agentskills.io/specification) defines additional fields that skill-aware AI tools can use:

| Field | Description |
|-------|-------------|
| `license` | License name or reference (e.g., `Apache-2.0`) |
| `compatibility` | Environment requirements (max 500 chars). E.g., "Requires Node.js 18+" |
| `metadata` | Arbitrary key-value pairs for additional properties |
| `allowed-tools` | Tools the AI can use without permission prompts when the skill is active |
| `argument-hint` | Hint shown during autocomplete (e.g., `[issue-number]`) |
| `disable-model-invocation` | When `true`, the AI cannot auto-load this skill — user must invoke manually. Use for workflows with side effects like deploy or publish. |
| `user-invocable` | When `false`, hides the skill from the slash menu. The AI loads it automatically when relevant. Use for background knowledge. |
| `model` | Preferred model when this skill is active (e.g., `haiku`, `sonnet`, `opus`) |
| `context` | Set to `fork` to run in an isolated subagent context |
| `agent` | Subagent type when `context: fork` is set (`Explore`, `Plan`, `general-purpose`) |
| `hooks` | Lifecycle hooks that activate only while the skill is running |

### Invocation Control

The `disable-model-invocation` and `user-invocable` fields control how a skill is loaded:

| Frontmatter | User can invoke | AI can invoke | When loaded |
|-------------|----------------|---------------|-------------|
| (default) | Yes | Yes | Description always in context; full body loads when invoked |
| `disable-model-invocation: true` | Yes | No | Loads only on manual invoke |
| `user-invocable: false` | No | Yes | Description always in context; loads when AI deems relevant |

### allowed-tools with MCP Servers

When referencing MCP server tools, use the `mcp__servername__toolname` pattern:

```yaml
allowed-tools: mcp__supabase__query, mcp__builder_cms__search_content
```

MCP servers are configured in `mcp.json` at the project root.

### On-Demand Hooks

Skills can register hooks that activate only while the skill is running:

```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/safety-check.sh"
```

Use for safety guardrails (blocking destructive commands, restricting edits) that should only apply during specific workflows.

## String Substitution Variables

These variables are replaced with actual values when the skill is invoked:

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | All arguments passed via `/name args here`. If not present in content, arguments are appended automatically. |
| `$ARGUMENTS[N]` or `$N` | Specific argument by 0-based index. `$0` is the first argument. |

**Example:**

```yaml
---
name: fix-issue
description: Fix a GitHub issue by number
argument-hint: "[issue-number]"
---

Fix issue #$0 following our project's coding standards and test requirements.
```
