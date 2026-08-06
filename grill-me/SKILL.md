---
name: grill-me
description: >
  Relentlessly interviews the user to sharpen a plan, design, decision, or idea while
  building the project's domain glossary and recording durable architectural decisions.
  Use when the user asks to be grilled, challenged, interviewed, stress-tested, or wants
  to resolve a design through structured questioning with domain-modeling documentation.
disable-model-invocation: true
---

# Grill Me

Relentlessly interview the user until you share a precise understanding of the proposal. Walk each branch of the decision tree, resolve dependencies one at a time, challenge the domain language, and capture resolved terminology and durable decisions as they crystallize.

## Interview rules

- Use `AskUserQuestion` for every interview question.
- Ask exactly one question per invocation and wait for the answer before continuing.
- Present 2–4 concrete choices. Put your recommended answer first and label it `(Recommended)`.
- Do not add an “Other” choice; the tool supplies it automatically.
- Explain the material trade-off in each option rather than offering cosmetic variations.
- Resolve foundational decisions before dependent ones.
- If a fact can be discovered from the repository, tools, or connected services, look it up instead of asking. Decisions remain the user's: recommend an answer, ask, and wait.
- Do not implement the proposal until the user explicitly confirms that shared understanding has been reached.

Updating domain documentation during the interview is allowed and expected; it is not implementation of the proposal.

## Start the session

1. Read the relevant code and existing documentation before asking questions.
2. If `CONTEXT-MAP.md` exists, read it and identify the bounded context involved.
3. Otherwise, read the root `CONTEXT.md` if it exists.
4. Summarize the proposal and the most important unresolved decision briefly.
5. Begin with the highest-leverage question whose answer constrains the most later choices.

## Grill the proposal

Probe until each relevant branch is resolved. Adapt the questioning to the subject, including:

- goal, users, and success criteria
- scope and explicit non-goals
- domain boundaries, ownership, and invariants
- lifecycle, states, transitions, and failure modes
- permissions, privacy, security, and abuse cases
- data sources, integrations, consistency, and recovery
- compatibility, migration, rollout, and reversibility
- operational constraints and observability
- alternatives rejected and consequences accepted

Use concrete scenarios to expose ambiguity. Prefer “What happens when two payments arrive after cancellation?” over “How are edge cases handled?” Invent counterexamples that test boundaries between concepts.

When the user's answer creates a new dependency or contradiction, follow that branch before moving on. Periodically state the shared understanding in a few sentences, then continue with the largest remaining uncertainty.

## Maintain the domain model

### Sharpen language

- Challenge vague or overloaded terms and propose one precise canonical term.
- If the user uses language that conflicts with `CONTEXT.md`, call out the conflict immediately and ask which meaning is authoritative.
- Distinguish concepts that the proposal incorrectly treats as synonyms.
- Cross-check factual claims against the code. Surface contradictions between the described model and current behavior.

### Choose the context

Most repositories use one root `CONTEXT.md`. If `CONTEXT-MAP.md` exists, use it to locate the relevant context-specific `CONTEXT.md` and ADR directory. If multiple contexts may own the concept and ownership cannot be inferred, resolve that as an interview decision.

Create documentation lazily:

- Create `CONTEXT.md` only when the first domain term is resolved.
- Create an ADR directory only when the first qualifying ADR is accepted.
- Do not create placeholder files or empty sections.

### Update the glossary immediately

Write each resolved domain term to the relevant `CONTEXT.md` as soon as it becomes stable; do not batch glossary edits until the end.

`CONTEXT.md` is only a domain glossary. Keep implementation details, requirements, plans, and architectural decisions out of it.

Use this shape:

```md
# {Context Name}

{One or two sentences describing the context and why it exists.}

## Language

**{Canonical term}**:
{A one- or two-sentence definition of what it is.}
_Avoid_: {ambiguous synonym}, {deprecated synonym}
```

Glossary rules:

- Pick one canonical word when several words describe the same concept.
- Define what the concept is, not what its implementation does.
- Keep definitions to one or two sentences.
- Include only project-specific domain concepts, not general programming terms.
- Add `_Avoid_` only when naming alternatives are genuinely likely to cause confusion.
- Group terms under subheadings only when natural clusters emerge.

For a multi-context repository, keep `CONTEXT-MAP.md` focused on context locations, ownership, and relationships. Do not duplicate each context's glossary in the map.

## Record architectural decisions sparingly

An ADR is appropriate only when all three conditions hold:

1. The decision is meaningfully hard to reverse.
2. A future reader would find the result surprising without its rationale.
3. The choice reflects a real trade-off between credible alternatives.

If any condition is missing, do not create an ADR. When all are present, make recording it a discrete interview decision rather than silently assuming consent.

Place system-wide ADRs in `docs/adr/`. In a multi-context repository, place context-specific ADRs in that context's established ADR directory. Scan the target directory for the highest number and increment it, using a filename such as `0003-short-decision-slug.md`.

Whenever you save an ADR, ensure its repository-relative path is ignored by Git. Check the root `.gitignore` first: if an existing pattern already ignores the ADR, leave it unchanged; otherwise create `.gitignore` if needed and append the exact ADR path without duplicating entries.

Keep the default ADR concise:

```md
# {Short decision title}

{One to three sentences stating the context, decision, and reason.}
```

Add status, considered options, or consequences only when they preserve information a future reader genuinely needs.

## Completion

Continue until the important branches are resolved and the proposal can be stated without ambiguous terms or hidden decisions. Then:

1. Summarize the agreed goal, scope, domain language, major decisions, constraints, and unresolved risks.
2. Point out the glossary and ADR changes made during the session.
3. Ask one final `AskUserQuestion`: whether shared understanding has been reached.
4. Only after explicit confirmation may implementation begin.

## Gotchas

- Do not ask the user for repository facts that can be inspected.
- Do not ask compound or multi-part questions.
- Do not mistake agreement with your recommendation for agreement on the whole proposal.
- Do not turn `CONTEXT.md` into a specification or implementation plan.
- Do not create ADRs for routine, obvious, or easily reversible choices.
- Do not let documentation updates silently expand the implementation scope.
- Do not stop at the happy path; probe lifecycle boundaries, partial failure, concurrency, and ownership where relevant.
