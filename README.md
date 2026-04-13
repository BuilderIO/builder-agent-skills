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
| [rules-reviewer](./rules-reviewer/)               | Review, fix, and create Builder.io Fusion rules files (`.builderrules`, `.mdc`, `agents.md`)   |
| [import-prototype](./import-prototype/)           | Import a Builder.io prototype into the current project using the Builder dev-tools CLI          |

## Installation
You can install skills by asking Builder to `run npx builder-doctor` which will give you an option to install a skill. You can also quickly add a specific skill by asking:
- `npx builder-doctor install-skill skill-creator`
- `npx builder-doctor install-skill fusion-to-publish`
- `npx builder-doctor install-skill rules-reviewer`
- `npx builder-doctor install-skill import-prototype`


## Skill Creator
Create new skills, improve existing skills, and understand skill best practices for Builder.io

Ask Builder to `run npx builder-doctor install-skill skill-creator` and it will be installed in your project. Or you can run locally with:
```bash
npx builder-doctor install-skill skill-creator
```

### Creating Your Own Skills

1. Install the **skill-creator** skill into your Builder.io project (see Installation above)
2. Open your project in Builder and say "I want to create a skill that does X"
3. The skill-creator will guide you through the process

## Rule Reviewer
Review, fix, and create Builder.io Fusion rules files (`.builderrules`, `.mdc`, `agents.md`).

Ask Builder to `run npx builder-doctor install-skill rules-reviewer` and it will be installed in your project. Or you can run locally with:
```bash
npx builder-doctor install-skill rules-reviewer
```

### Reviewing rules

Ask Builder to `Review my rules` after installing this skill. You can also ask `run npx builder-doctor rules` which will check for common issues with rule files.

## Import Prototype
Import a Builder.io prototype into the current project using the Builder dev-tools CLI.

Ask Builder to run `npx builder-doctor install-skill import-prototype` and it will be installed in your project. 

Or you can run locally into GitHub CoPilot with:
```bash
run npx --yes builder-doctor install-skill import-prototype --agent github
```

Or you can run locally into Claude Code with:
```bash
run npx --yes builder-doctor install-skill import-prototype --agent claude
```

### Using the skill

Share a `https://builder.io/app/projects/...` URL with Builder and say what you want to import (e.g. "import the hero section" or "import the full page design"). The skill will run the Builder dev-tools CLI to pull the prototype into your project.

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

## Contributing

Have a skill that could help other Builder.io users? Open a PR:

1. Create a directory with your skill name (lowercase, hyphenated)
2. Add a `SKILL.md` with valid frontmatter (`name` and `description`)
3. Follow the [skill writing best practices](./skill-creator/SKILL.md)
4. Keep SKILL.md under 500 lines; use `references/` for detailed docs
