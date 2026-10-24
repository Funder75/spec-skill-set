# Create spec

Write or resume `spec_docs/<slug>/spec.md` only. Do not create technical specs or an implementation plan in this action.

## Bootstrap

If `spec_docs/` does not exist:

1. Copy [templates/spec-docs-readme.md](../templates/spec-docs-readme.md) to `spec_docs/README.md`.
2. Add empty `spec_docs/archive/.gitkeep`.
3. Do not search the repo to fill **Project conventions**.

## Input

Read the whole input before asking or writing. Free text, every referenced document, or a work-item id. Nothing is stored in an inbox. `spec.md` keeps a short **Source** note (where it came from).

For a work-item id, read **Work items** under **Project conventions** in `spec_docs/README.md`. If that subsection is still the placeholder, ask how to fetch it. Store title, description, and acceptance criteria only. Map each acceptance criterion to a goal's **Source** line (for example `WI AC2`, or the id scheme this repo uses). A criterion with no goal is a gap: ask, or record a **Q** item. Do not paste the raw work-item payload into `spec.md`.

## Investigate

Find what the input means in this repo before shaping the spec.

1. Restate it in project terms: which behaviour, surface, and user moment it changes.
2. In this repo, open the modules, routes, and types that already own that behaviour.
3. Follow real dependencies into related repos, packages, or shared libraries this code already imports. Read only what the input depends on. Do not tour unrelated codebases.
4. Note current behaviour, gaps, and constraints the spec must respect. Cite modules you actually opened.

Record the paths this spec will change in the **Touched paths** table, with the area and the change. Cite modules you opened in **Problem and current behaviour**.

## Analysis

Before writing, work out how the input becomes a review-ready `spec.md`. Cover:

- What the input already decides, and what it leaves open.
- How today's code constrains v1: existing flows, APIs, and persistence.
- Scope and non-goals implied by the input and by what the code already does.
- The user journeys: who starts where, the steps from their side, the end state, and what goes wrong.
- Edge cases each goal must handle.
- A coarse work split: ordered slices, the goals each one covers, and the main surface of each.
- Decisions that still need a person, versus assumptions safe to record.

Write the analysis in the working turn, specific enough that each section of `spec.md` can be filled from the input and the code you opened. If a section cannot, add a **Q** item and point at it with `> **Open:** Q1 (short name)` instead of inventing it. Do not paste the analysis into `spec.md` as its own section. Do not invent file-level deliverables.

## Slug

Kebab-case, two to four words, unique under `spec_docs/` (not under `archive/`). If `spec_docs/<slug>/` already exists, resume that folder. Do not create a parallel folder or wipe content without asking. Confirm the slug when it is inferred from a work-item title.

## Clarify before writing

Skip questions already answered in the input or chat. Do not create files until the user has answered, or explicitly says to proceed with assumptions (record those in **Open questions**).

Must ask unless already answered: v1 scope, explicit out-of-scope, folder slug, persistence impact (in-memory vs stored vs external API).

Ask if unclear: primary surface, dependencies, whether any tech doc will be needed later, milestone for a real user test.

Default assumptions when the user skips Q&A: v1 is the smallest shippable slice; no new packages without asking; follow patterns already in the touched code.

## Write spec.md

Create `spec_docs/<slug>/` and write `spec.md` from [templates/spec.md](../templates/spec.md), filled to review-ready quality. Set `Progress: design`.

Follow [writing-style.md](../writing-style.md).

The spec is semi-technical: what changes, why, v1 scope, non-goals, user journeys, edge cases, constraints, touched paths, and a coarse **Work split** (ordered slices, the goals each covers, and the main surface). No file-level deliverables, Done when, or acceptance scenarios — those belong to the implementation plan. No code sketches, per-field type tables, or component props — those belong to the tech docs.

Make it elaborate. Iteration happens here; the tech docs translate behaviour already accepted. Every behaviour a reviewer must accept is decided here or is a **Q** item. A thin `spec.md` that leaves behaviour to be discovered at promote is a defect. Length is fine; keep it skimmable with the TL;DR bullets, **In short:** lines, and short table cells.

**User journeys** is required. Cover every user-facing goal in at least one journey. When the feature has no user-facing flow, write one line: n/a, and why.

Replace every `{{…}}` placeholder. Strip every HTML comment. Number goals `G1 (short name)`…. Use `[SUGGESTION: …]` for a concrete draft the user can accept, and remove the marker when they accept it. Record a settled choice under **Decisions**. Record a decision that needs a person under **Open questions**, and point at it from the text with `> **Open:** Q1 (short name)`. A long question list is normal at this gate. Set **Priority** to `high` when the answer would change the tech specs, the plan, or other goals; leave it `—` otherwise.

**Notes** hold context that needs no action. **Concerns** hold items that need a decision or a change, each with what goes wrong if left.

Omit **Glossary**, **Capabilities**, **Decisions**, **Open questions**, **Notes**, **Concerns**, and **Technical notes** when they would be empty. **Constraints** stays: write `n/a` on a line that does not apply. Nothing in **Non-goals** may be built in this spec.

## Stop

Present the spec and ask the user to review it. Iterate on `spec.md` alone until they promote. Do not add sibling docs during this loop.
