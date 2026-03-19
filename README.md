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

## Installation

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
└── README.md
```

## Contributing

Have a skill that could help other Builder.io users? Open a PR:

1. Create a directory with your skill name (lowercase, hyphenated)
2. Add a `SKILL.md` with valid frontmatter (`name` and `description`)
3. Follow the [skill writing best practices](./skill-creator/SKILL.md)
4. Keep SKILL.md under 500 lines; use `references/` for detailed docs
