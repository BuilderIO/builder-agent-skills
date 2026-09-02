# Builder Agent Skills

Ready-to-use skills for [Builder.io](https://www.builder.io) that extend what the AI can do in your projects.

## What Are Skills?

Skills are folders containing a `SKILL.md` file that teach the AI new capabilities — workflows, conventions, knowledge, and tools specific to your project. They live at `.builder/skills/` in your project directory.

## Available Skills

| Skill                                           | Description                                                                                    |
| ----------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| [skill-creator](./skill-creator/)               | Create new skills, improve existing skills, and understand skill best practices for Builder.io |
| [fusion-to-publish](./fusion-to-publish/)       | Register Fusion-built React components for use in Builder.io Publish's visual editor           |
| [fusion-to-publish-v2](./fusion-to-publish-v2/) | Same as above + helper scripts for project detection, component scanning, and registration log |
| [android-native](./android-native/)               | Build and run the Android app on an emulator or physical device using Gradle, `adb`, and `native-run` |
| [ios-native](./ios-native/)                       | Build and run the iOS app on a simulator or physical device using `xcodebuild` and `native-run` |
| [rules-reviewer](./rules-reviewer/)               | Review, fix, and create Builder.io Fusion rules files (`.builderrules`, `.mdc`, `agents.md`)   |
| [import-prototype](./import-prototype/)           | Import a Builder.io prototype into the current project using the Builder dev-tools CLI          |
| [create-instructions](./create-instructions/)     | Analyze the project's coding conventions and produce a concise `AGENTS.md`                     |
| [mobile-testing](./mobile-testing/)               | Install Maestro, run end-to-end tests, and create new test flows for iOS and Android apps       |
| [hallmark](./hallmark/)                           | Anti-AI-slop design skill for building UI, auditing designs, redesigning pages, and extracting design DNA from screenshots or URLs |
| [agent-browser](./agent-browser/)                 | Browser automation CLI for AI agents — navigate pages, fill forms, click buttons, take screenshots, scrape data, and test web apps |
| [playwright](./playwright/)                       | Browser automation and Playwright test authoring via `playwright-cli` — interact with live pages, generate tests, debug failures, and run spec-driven workflows |
| [unzip](./unzip/)                                 | Unzip or extract a zip file in the project using `npx extract-zip`                                                                |
| [allow-commands](./allow-commands/)                 | Safely add command allowlist entries to an existing `builder.config.json` without removing existing entries                       |
| [grill-me](./grill-me/)                             | Stress-test plans and decisions through structured interviews while maintaining domain language and durable decisions             |
| [stop-slop](./stop-slop/)                           | Remove predictable AI writing patterns from prose                                                                   |

## Installation
You can quickly add a specific skill by asking:
- `npx skills add BuilderIO/builder-agent-skills --skill skill-creator`
- `npx skills add BuilderIO/builder-agent-skills --skill fusion-to-publish`
- `npx skills add BuilderIO/builder-agent-skills --skill rules-reviewer`
- `npx skills add BuilderIO/builder-agent-skills --skill import-prototype`
- `npx skills add BuilderIO/builder-agent-skills --skill android-native`
- `npx skills add BuilderIO/builder-agent-skills --skill ios-native`
- `npx skills add BuilderIO/builder-agent-skills --skill create-instructions`
- `npx skills add BuilderIO/builder-agent-skills --skill mobile-testing`
- `npx skills add BuilderIO/builder-agent-skills --skill hallmark`
- `npx skills add BuilderIO/builder-agent-skills --skill agent-browser`
- `npx skills add BuilderIO/builder-agent-skills --skill playwright`
- `npx skills add BuilderIO/builder-agent-skills --skill unzip`
- `npx skills add BuilderIO/builder-agent-skills --skill allow-commands`
- `npx skills add BuilderIO/builder-agent-skills --skill grill-me`
- `npx skills add BuilderIO/builder-agent-skills --skill stop-slop`


## Skill Creator
Create new skills, improve existing skills, and understand skill best practices for Builder.io

Ask Builder to run `npx skills add BuilderIO/builder-agent-skills --skill skill-creator` and it will be installed in your project. Or you can run locally with:
```bash
npx skills add BuilderIO/builder-agent-skills --skill skill-creator
```

### Creating Your Own Skills

1. Install the **skill-creator** skill into your Builder.io project (see Installation above)
2. Open your project in Builder and say "I want to create a skill that does X"
3. The skill-creator will guide you through the process

## Rule Reviewer
Review, fix, and create Builder.io Fusion rules files (`.builderrules`, `.mdc`, `agents.md`).

Ask Builder to run `npx skills add BuilderIO/builder-agent-skills --skill rules-reviewer` and it will be installed in your project. Or you can run locally with:
```bash
npx skills add BuilderIO/builder-agent-skills --skill rules-reviewer
```

### Reviewing rules

Ask Builder to `Review my rules` after installing this skill. You can also ask `run npx builder-doctor rules` which will check for common issues with rule files.

## Import Prototype
Import a Builder.io prototype into the current project using the Builder dev-tools CLI.

Ask Builder to run `npx skills add BuilderIO/builder-agent-skills --skill import-prototype` and it will be installed in your project.

### Using the skill

Share a `https://builder.io/app/projects/...` URL with Builder and say what you want to import (e.g. "import the hero section" or "import the full page design"). The skill will run the Builder dev-tools CLI to pull the prototype into your project.

## Fusion to Publish
Register Fusion-built React components for use in Builder.io Publish's visual editor.

Ask Builder to run `npx skills add BuilderIO/builder-agent-skills --skill fusion-to-publish` and it will be installed in your project. Or you can run locally with:
```bash
npx skills add BuilderIO/builder-agent-skills --skill fusion-to-publish
```

### Using the skill

After installing, ask Builder to register your Fusion components for Publish. The skill guides project detection, registry scaffolding, and component registration.

## Fusion to Publish V2
Enhanced Fusion-to-Publish flow with helper scripts for project detection, component scanning, and registration logging.

Ask Builder to run `npx skills add BuilderIO/builder-agent-skills --skill fusion-to-publish-v2` and it will be installed in your project. Or you can run locally with:
```bash
npx skills add BuilderIO/builder-agent-skills --skill fusion-to-publish-v2
```

### Using the skill

Ask Builder to run the V2 Fusion-to-Publish workflow. This version uses script helpers to detect project setup and scan components before registration.

## Mobile Testing
Run end-to-end UI tests on iOS and Android using Maestro. Covers installing Maestro, building apps, booting simulators/emulators, running existing flows, and authoring new ones.

Ask Builder to run `npx skills add BuilderIO/builder-agent-skills --skill mobile-testing` and it will be installed in your project. Or you can run locally with:
```bash
npx skills add BuilderIO/builder-agent-skills --skill mobile-testing
```

### Using the skill

Make sure [Maestro](https://maestro.dev/) is installed by running:
```
curl -Ls "https://get.maestro.mobile.dev" | bash
```

After installing, ask Builder to test your mobile app (e.g. "run the smoke test on iOS" or "write a Maestro flow for the login screen"). The skill handles Maestro installation, simulator/emulator setup, running flows from `maestro/`, and reporting pass/fail results with screenshot and log paths.

## Create Instructions
Analyze the project's coding conventions and produce a concise `AGENTS.md` at the project root.

Ask Builder to run `npx skills add BuilderIO/builder-agent-skills --skill create-instructions` and it will be installed in your project. Or you can run locally with:
```bash
npx skills add BuilderIO/builder-agent-skills --skill create-instructions
```

### Using the skill

After installing, ask Builder "@create-instructions". The skill will explore your codebase, identify project-specific patterns, and write a concise `AGENTS.md` with up to 20 non-obvious, project-specific conventions. It will not overwrite an existing `AGENTS.md`.

## Android Native
Build and run the Android app on an emulator or physical device using Gradle, `adb`, and `native-run`.

Ask Builder to run `npx skills add BuilderIO/builder-agent-skills --skill android-native` and it will be installed in your project. Or you can run locally with:
```bash
npx skills add BuilderIO/builder-agent-skills --skill android-native
```

### Using the skill

Ask Builder to build and launch your Android app. The skill helps with Gradle build/run commands and device or emulator targeting.

## iOS Native
Build and run the iOS app on a simulator or physical device using `xcodebuild` and `native-run`.

Ask Builder to run `npx skills add BuilderIO/builder-agent-skills --skill ios-native` and it will be installed in your project. Or you can run locally with:
```bash
npx skills add BuilderIO/builder-agent-skills --skill ios-native
```

### Using the skill

Ask Builder to build and launch your iOS app. The skill helps with simulator/device selection and `xcodebuild` command flows.

## Hallmark
An anti-AI-slop design skill for building UI, auditing existing designs, redesigning pages, and extracting design DNA from screenshots or URLs.

Ask Builder to run `npx skills add BuilderIO/builder-agent-skills --skill hallmark` and it will be installed in your project. Or you can run locally with:
```bash
npx skills add BuilderIO/builder-agent-skills --skill hallmark
```

### Using the skill

After installing, describe what you want to build. Hallmark will ask three questions (audience, use case, tone) before generating anything. You can also use the explicit verbs:
- `hallmark audit <target>` — score existing UI against the anti-pattern list; returns a punch list, no edits
- `hallmark redesign <target>` — keep copy and brand, replace the structural/visual layer
- `hallmark study <screenshot | URL>` — extract design DNA (macrostructure, type-pairing, colour anchor)

Hallmark enforces structural variety across builds — two pages from different briefs will feel like different sites, not colour-swaps of the same template.

## Playwright
Browser automation and Playwright test authoring using `playwright-cli`. Drive a live browser interactively, generate Playwright TypeScript from every action, run and debug tests, and work through a full plan → generate → heal spec-driven workflow.

Ask Builder to run `npx skills add BuilderIO/builder-agent-skills --skill playwright` and it will be installed in your project. Or you can run locally with:
```bash
npx skills add BuilderIO/builder-agent-skills --skill playwright
```

### Using the skill

After installing, ask Builder to automate a browser task, write or debug a Playwright test, or run the spec-driven workflow. Key capabilities include:
- Interactive browser control with accessibility snapshots
- Automatic Playwright TypeScript code generation from actions
- Running and debugging tests with `--debug=cli` and live attach
- Network mocking, storage management, tracing, and video recording
- Spec-driven plan → generate → heal test authoring

## Agent Browser
Fast browser automation CLI for AI agents. Automate Chrome/Chromium via CDP with accessibility-tree snapshots for reliable element interaction.

Ask Builder to run `npx skills add BuilderIO/builder-agent-skills --skill agent-browser` and it will be installed in your project. Or you can run locally with:
```bash
npx skills add BuilderIO/builder-agent-skills --skill agent-browser
```

### Using the skill

First install the CLI:
```bash
npm i -g agent-browser && agent-browser install
```

After installing the skill, ask Builder to automate any browser task — navigating pages, filling forms, clicking buttons, taking screenshots, scraping data, or running exploratory QA. The skill also supports Electron desktop apps (VS Code, Slack, Discord, Figma), Slack workspace automation, and cloud browsers via AWS Bedrock AgentCore.

Load specialized sub-skills from the CLI for specific use cases:
```bash
agent-browser skills get core             # workflows, common patterns, troubleshooting
agent-browser skills get electron          # Electron desktop apps
agent-browser skills get slack             # Slack workspace automation
agent-browser skills get dogfood           # Exploratory testing / QA / bug hunts
agent-browser skills get vercel-sandbox    # agent-browser inside Vercel Sandbox microVMs
agent-browser skills get agentcore         # AWS Bedrock AgentCore cloud browsers
```

## Unzip
Unzip or extract a zip file in the project using `npx extract-zip`.

Ask Builder to run `npx skills add BuilderIO/builder-agent-skills --skill unzip` and it will be installed in your project. Or you can run locally with:
```bash
npx skills add BuilderIO/builder-agent-skills --skill unzip
```

### Using the skill

After installing, ask Builder to unzip a file (e.g. "unzip the file" or "extract the archive"). The skill finds the most recently modified `.zip` file and extracts it to the project root, automatically handling base64-encoded zips, installing dependencies if needed, and restarting the dev server.

## Allow Commands
Safely add command allowlist entries to an existing `builder.config.json` while preserving its current configuration.

Ask Builder to run `npx skills add BuilderIO/builder-agent-skills --skill allow-commands` and it will be installed in your project. Or you can run locally with:
```bash
npx skills add BuilderIO/builder-agent-skills --skill allow-commands
```

### Using the skill

After installing, ask Builder to allow commands for mobile development, Angular, unzip, or a specific CLI. The skill asks you to select the commands, validates custom entries, and merges them into `allowedCommands` without duplicates. It only updates an existing `builder.config.json`; it does not create one.

## Grill Me
Stress-test a plan, design, decision, or idea through a structured interview that sharpens domain language and records durable architectural decisions when appropriate.

Ask Builder to run `npx skills add BuilderIO/builder-agent-skills --skill grill-me` and it will be installed in your project. Or you can run locally with:
```bash
npx skills add BuilderIO/builder-agent-skills --skill grill-me
```

### Using the skill

After installing, explicitly ask Builder to grill, challenge, interview, or stress-test you about a proposal. The skill inspects the project first, then asks one high-leverage question at a time until the goal, scope, constraints, terminology, and important trade-offs are clear. It can maintain a project `CONTEXT.md` glossary and, with your agreement, concise architecture decision records; it does not begin implementation until you confirm shared understanding.

## Stop Slop
Remove predictable AI writing patterns from prose.

Ask Builder to run `npx skills add BuilderIO/builder-agent-skills --skill stop-slop` and it will be installed in your project. Or you can run locally with:
```bash
npx skills add BuilderIO/builder-agent-skills --skill stop-slop
```

### Using the skill

After installing, ask Builder to draft, edit, or review prose with stop-slop. It removes filler, formulaic structures, passive voice, vague language, and other common AI tells while using ASD-STE100 Simplified Technical English.

## Orchestrator
Breaks a large coding task into the smallest independent subtasks and delegates each one to a `worker` subagent. The orchestrator plans, delegates, tracks progress with the task tool, and verifies every result — it never writes or modifies code itself. Workers do the implementation, while the orchestrator coordinates parallel work, manages dependencies, and reports a final summary. Use it when a request is large enough to benefit from being split into focused, independently executable pieces of work.

Install with:
```bash
npx builder-doctor install-plugin orchestrator
```

In this [demonstration video](https://www.loom.com/share/0766156ef0ca49198b9c767cb7b361b7) comparing a typical flow to an orchestrated flow.

Using an orchestrator with a worker that uses a cheaper model reduces the cost ~30%

| Metric         | Non Orchestrated | Orchestrated |
| -------------- | ---------------- | ------------ |
| Total Messages | 24               | 19           |
| Total Cost     | $1.3724          | $0.9885      |
| Total Credits  | 34.324c          | 24.722c      |
| Total Time     | 419.31s          | 252.97s      |
| Avg. Latency   | 2.16s            | 1.74s        |
| Total Files    | 5                | 5            |
| Total LoC      | 941              | 781          |
| Errors         | 0                | 0            |

### Using the plugin

After installing, ask Builder to orchestrate a multi-part task (e.g. "build out the dashboard with separate components for the chart, filters, and table"). The orchestrator splits the work into subtasks, delegates them to workers, and verifies each result before reporting back.

## Manual Installation

Copy any skill directory into your project's `.builder/skills/` folder:

```bash
# Clone the repo
git clone https://github.com/BuilderIO/builder-agent-skills.git /tmp/builder-agent-skills

# Copy the skill you want (example: skill-creator)
mkdir -p .builder/skills
cp -r /tmp/builder-agent-skills/skill-creator .builder/skills/skill-creator

# Clean up
rm -rf /tmp/builder-agent-skills
```

Or copy a single skill directly:

```bash
mkdir -p .builder/skills/skill-creator
curl -sL https://raw.githubusercontent.com/BuilderIO/builder-agent-skills/main/skill-creator/SKILL.md \
  -o .builder/skills/skill-creator/SKILL.md
```

After installing, start a new session for the skill to load.

## Creating Your Own Skills

1. Install the **skill-creator** skill into your Builder.io project (see Installation above)
2. Open your project in Builder and say "I want to create a skill that does X"
3. The skill-creator will guide you through the process


## Project Structure

```
builder-agent-skills/
├── skill-creator/           # Skill for creating new skills
│   ├── SKILL.md
│   └── references/
│       ├── frontmatter-reference.md
│       └── examples.md
├── fusion-to-publish/       # Fusion → Publish component registration
│   ├── SKILL.md
│   └── references/
│       ├── sdk-reference.md
│       ├── scaffolding-templates.md
│       └── examples.md
├── fusion-to-publish-v2/    # Enhanced version with scripts and registration log
│   ├── SKILL.md
│   ├── references/
│   │   ├── sdk-reference.md
│   │   ├── scaffolding-templates.md
│   │   └── examples.md
│   └── scripts/
│       ├── detect-project.sh
│       └── scan-components.sh
├── android-native/          # Build and run Android app
│   └── SKILL.md
├── ios-native/              # Build and run iOS app
│   └── SKILL.md
├── create-instructions/     # Generate AGENTS.md from project conventions
│   └── SKILL.md
├── mobile-testing/          # End-to-end UI testing with Maestro for iOS and Android
│   └── SKILL.md
├── hallmark/                # Anti-AI-slop design skill for UI generation and auditing
│   └── SKILL.md
├── agent-browser/           # Browser automation CLI for AI agents
│   └── SKILL.md
├── playwright/              # Browser automation and Playwright test authoring
│   ├── SKILL.md
│   └── references/
│       ├── playwright-tests.md
│       ├── spec-driven-testing.md
│       ├── test-generation.md
│       ├── request-mocking.md
│       ├── storage-state.md
│       ├── session-management.md
│       ├── tracing.md
│       ├── video-recording.md
│       ├── running-code.md
│       └── element-attributes.md
├── unzip/                   # Unzip or extract a zip file
│   └── SKILL.md
├── allow-commands/          # Safely update command allowlists
│   └── SKILL.md
├── grill-me/                # Structured interviews for plans and decisions
│   └── SKILL.md
├── stop-slop/               # Remove AI writing patterns from prose
│   ├── SKILL.md
│   └── references/
│       ├── examples.md
│       ├── phrases.md
│       └── structures.md
└── README.md
```

## Contributing

Have a skill that could help other Builder.io users? Open a PR:

1. Create a directory with your skill name (lowercase, hyphenated)
2. Add a `SKILL.md` with valid frontmatter (`name` and `description`)
3. Follow the [skill writing best practices](./skill-creator/SKILL.md)
4. Keep SKILL.md under 500 lines; use `references/` for detailed docs
