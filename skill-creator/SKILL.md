---
name: skill-creator
description: >
  Create new skills, improve existing skills, and understand skill best practices
  for Builder.io Fusion. Use when the user wants to create a skill, build a slash
  command, automate a workflow, add custom AI instructions, create reusable AI
  behaviors, or asks how to extend Fusion's capabilities in their project. Also use
  when the user wants to improve, audit, or troubleshoot an existing skill's
  triggering or behavior.
---

# Skill Creator for Builder.io Fusion

Create and improve skills that extend what Builder.io Fusion can do in your project.

## What You'll Do

Help the user through one of these workflows:

1. **Create a new skill** — capture intent, scaffold the directory, write the SKILL.md
2. **Improve an existing skill** — read it, diagnose issues, rewrite
3. **Choose the right tool** — help decide between a skill, AGENTS.md, or .builderrules

## Creating a New Skill

### Step 1: Capture Intent

Ask these questions to understand what the user needs. Adapt your language to the user's technical level — if they're non-technical, skip jargon and make decisions for them.

1. **What should this skill do?** What task or knowledge should it provide?
2. **When should it trigger?** What would someone say or ask that should activate this skill?
3. **What's the output?** Files, code, a report, a workflow sequence?
4. **Does it need user-specific setup?** (e.g., API keys, channel names, team preferences) → use the config.json pattern

### Step 2: Choose the Right Tool

Before creating a skill, confirm it's the right choice:

| What you need | Use this | Why |
|---------------|----------|-----|
| Any reusable AI instruction or workflow | **Skill** (`.builder/skills/<name>/SKILL.md`) | Loads only when needed — keeps context lean. Supports bundled files, scripts, and progressive disclosure. |
| Background knowledge + supporting files | **Skill** | Reference docs and scripts alongside instructions, loaded on demand |
| Instructions the AI should always have | `AGENTS.md` or `.builderrules` | Always loaded into context, like a system prompt. Good for essential project-wide conventions. |
| Quick directory-scoped rules | `.builderrules` or `.builder/rules/*.mdc` | Lightweight, always-loaded rules scoped to a specific directory |
| Style rules a linter can enforce | Linter config (ESLint, Prettier, etc.) | Don't burn AI context on mechanical checks |

**Skills are the recommended default.** Unlike AGENTS.md and .builderrules which are always loaded into the AI's context (consuming tokens every session), skills only load when relevant. This means you can have many skills without bloating the AI's context window. Reserve AGENTS.md for the small set of instructions the AI truly needs in every single conversation.

### Step 3: Scaffold the Skill

Create the skill directory at `.builder/skills/<name>/SKILL.md`:

```
project/
└── .builder/
    └── skills/
        └── <skill-name>/
            └── SKILL.md
```

**Before writing any files:**
- If `.builder/` or `.builder/skills/` doesn't exist, create the directories
- If a skill already exists at the target path, read it first and ask the user: update the existing skill, or pick a different name?

**Naming rules:**
- Lowercase letters, numbers, and hyphens only (e.g., `pdf-processor`, `deploy-staging`)
- No consecutive hyphens, no leading/trailing hyphens
- Max 64 characters
- The directory name is the skill's identifier
- Nested paths use directories: `.builder/skills/office/word/SKILL.md`, not `office-word`
- Avoid names that collide with Builder.io directories: `rules`, `config`, `settings`

### Step 4: Write the SKILL.md

Every SKILL.md has two parts: YAML frontmatter and a markdown body.

#### Frontmatter

At minimum, include `name` and `description`:

```yaml
---
name: my-skill
description: >
  What the skill does AND when to use it. Include trigger
  keywords and phrases. This is what the AI reads to decide
  whether to load the skill.
---
```

For complete field documentation, see [references/frontmatter-reference.md](references/frontmatter-reference.md).

#### Writing the Description (Critical)

The description is the single most important line in your skill. It determines whether the AI loads your skill at the right time. Get this wrong and the skill never triggers; get it right and it activates reliably.

**Use the WHAT + WHEN pattern.** Every description needs both:
- **WHAT** the skill does
- **WHEN** to use it (specific trigger contexts)

**Bad:**
```yaml
description: Helps with documents
# Too vague — the AI has no activation signal

description: Extract text from PDF files
# Only says WHAT, not WHEN — the AI must guess when to trigger

description: Use when the user says "create a PDF"
# Too narrow — misses related phrasings
```

**Good:**
```yaml
description: >
  Extract text and tables from PDF files, fill forms, merge
  documents. Use when working with PDF files or when the user
  mentions PDFs, forms, document extraction, or .pdf files.

description: >
  Generate commit messages by analyzing git diffs. Use when the
  user asks for help writing commit messages, reviewing staged
  changes, or preparing code for commit, even if they don't
  explicitly ask for a "commit message."
```

**Tips for reliable triggering:**
- Write in third person ("Processes files" not "I help you process files")
- Include file extensions, domain terms, and informal synonyms
- Add "even if they don't explicitly ask for X" for near-miss triggers
- Keep under 1024 characters
- The description is for the AI model, not for humans — think of it as a trigger definition
- AI agents tend to **undertrigger** skills, so err on the side of being specific about when to activate

#### Writing the Body

The markdown body is the skill's instructions. Keep it under 500 lines. Structure it clearly:

```markdown
# Skill Title

## Quick Start
Immediate, actionable guidance.

## Instructions
Step-by-step procedures.

## Gotchas
Common failure points and how to avoid them.

## Examples
Concrete input/output pairs.
```

**Writing principles:**

- **Don't state the obvious.** The AI already knows how to code. Focus on what pushes it out of its default behavior — your project's quirks, conventions, and gotchas.
- **Build a Gotchas section.** This is the highest-signal content in any skill. Capture failure points as you discover them. Update over time. A good Gotchas section is worth more than pages of instructions.
- **Avoid railroading.** Skills are reused across many situations. Give the AI information and flexibility, not rigid step-by-step scripts. Let it adapt.
- **Explain why, not just what.** "Use UTC timestamps because the aggregation pipeline assumes UTC" beats "Always use UTC timestamps."
- **Start small, iterate.** Most successful skills began as a few lines and one gotcha. They got better as the AI hit edge cases. Don't try to write the perfect skill on the first pass.

### Step 5: Add Supporting Files (If Needed)

A skill is a folder, not just a markdown file. Use the file system for progressive disclosure:

```
my-skill/
├── SKILL.md              # Required — main instructions (<500 lines)
├── references/            # Detailed docs, loaded on demand
│   └── api-docs.md
├── scripts/               # Executable helpers
│   └── validate.sh
└── assets/                # Templates, static files
    └── template.html
```

**Progressive disclosure works in three levels:**

| Level | What loads | When | Size |
|-------|-----------|------|------|
| Metadata | `name` + `description` | Always in context | ~100 tokens |
| Instructions | Full SKILL.md body | When skill triggers | <500 lines |
| Resources | Reference files, scripts | When the AI needs them | Unlimited |

**Rules:**
- Keep SKILL.md under 500 lines. If approaching 400, split detailed content to reference files.
- Link references from SKILL.md: "For API details, see [references/api-docs.md](references/api-docs.md)."
- Keep references one level deep. Don't have reference files that point to other reference files — the AI may only partially read deeply nested content.
- Include templates in `assets/` if your skill generates files with a consistent format.
- Include reusable scripts in `scripts/` so the AI composes rather than reconstructs boilerplate.

### Step 6: Advanced Patterns

#### Config.json for User-Specific Setup

If your skill needs context that varies per user (API keys, channel names, team settings):

```
my-skill/
├── SKILL.md
└── config.json
```

In SKILL.md, instruct: "If `config.json` does not exist in this skill directory, ask the user for [required settings] and save them to `config.json` before proceeding."

#### Memory and Data Storage

Skills can maintain state:
- Append-only log files (e.g., `standups.log` for a standup skill)
- JSON data files
- Even SQLite databases

This lets the AI reference its own history across sessions.

#### Composing Skills

Reference other skills by name in your instructions. The AI will invoke them if they're installed. Example: "Use the `/deploy` skill to push changes after verification."

### Step 7: Test the Skill

After creating the skill:

1. **Start a new session.** Skills load at session start, so start a fresh session to pick up the new skill.
2. **Try substantive prompts.** Test with multi-step or specialized prompts that match your description — the more specific your prompt, the better the skill triggers.
3. **Try 2-3 phrasings.** Test with different ways someone might request what the skill does.
4. **Check the gotchas.** Deliberately try scenarios where the AI previously failed.

If the skill doesn't trigger, the description probably needs work. Revisit the WHAT + WHEN pattern and add more trigger terms.

## Improving an Existing Skill

When the user wants to improve a skill:

1. **Read the current SKILL.md** — understand its purpose and structure
2. **Diagnose the issue:**
   - Not triggering? → Description needs WHAT + WHEN improvement
   - Triggering at wrong times? → Description is too broad, narrow the WHEN
   - Producing bad output? → Instructions need gotchas or constraints
   - Too slow or consuming too much context? → Split into progressive disclosure
3. **Preserve the name and directory** — don't rename unless the user asks
4. **Show the changes** — explain what you changed and why before writing

## Audit Checklist

Use this checklist to verify a skill's quality:

- [ ] **Frontmatter:** Valid YAML with `name` and `description`
- [ ] **Description:** Uses WHAT + WHEN pattern, under 1024 chars
- [ ] **Description:** Includes specific trigger terms and contexts
- [ ] **Naming:** Directory name is lowercase-hyphenated, matches `name` field
- [ ] **Size:** SKILL.md is under 500 lines
- [ ] **Gotchas:** Has a Gotchas section (or notes to build one over time)
- [ ] **Progressive disclosure:** Reference files are one level deep from SKILL.md
- [ ] **No obvious knowledge:** Doesn't explain things the AI already knows
- [ ] **Flexibility:** Instructions give the AI room to adapt, not rigid scripts
- [ ] **Path:** Lives at `.builder/skills/<name>/SKILL.md`

## Anti-Patterns to Avoid

- **Vague descriptions** — "Helps with code" tells the AI nothing about when to trigger
- **Deep reference nesting** — SKILL.md → A.md → B.md breaks; keep references one level deep
- **Over-explaining the obvious** — Don't teach the AI what a REST API is. Focus on YOUR specifics.
- **Railroading** — Overly rigid step-by-step scripts break when the situation varies. Give context and let the AI adapt.
- **Too many options without defaults** — "Use library X, Y, or Z" forces an arbitrary choice. Pick one and note alternatives.
- **XML tags in the body** — Use standard markdown headings, not `<section>` tags
- **Style rules that belong in linters** — Semicolons, spacing, import order → ESLint/Prettier config, not a skill

## Reference Files

For detailed field documentation, see [references/frontmatter-reference.md](references/frontmatter-reference.md).

For complete example skills at different complexity levels, see [references/examples.md](references/examples.md).
