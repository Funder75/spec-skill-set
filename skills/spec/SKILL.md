---
name: spec
description: >-
  Invoke only when the user says spec or /spec, or explicitly asks to create,
  promote, implement, archive, or audit a spec under spec_docs/.
disable-model-invocation: true
---

# Spec

One skill for the spec workflow. Never edit this skill, its stages, or its templates to record progress.

## Read only what this turn needs

1. This file.
2. The one stage file for the action you are about to run (paths below, relative to this skill).
3. The spec folder the user named. During implementation, read `spec.md`, the plan's **progress overview**, the **active phase**, and only the tech-doc sections that phase lists — not the whole plan, and not every sibling.
4. `spec_docs/README.md` **Project conventions** only when this action needs a project fact (where a work item comes from, which command verifies a phase). If that section is still the placeholder, ask. Do not load the rest of that README as process. Do not search the repo for conventions.
5. [writing-style.md](writing-style.md) before any action that writes doc text or an audit report. It wins where it differs from this skill's own sentences.
6. [design-quality.md](design-quality.md) only while writing or revising an implementation plan.
7. [analysis-checklist.md](analysis-checklist.md) only during an explicit audit.

Do not spawn subagents. Do not read `spec_docs/archive/` unless the user asks about an archived spec.

## Progress

Each `spec_docs/<slug>/spec.md` carries the folder's gate:

`Progress: design | tech | plan | implementing | archived`

Set it only when a gate is crossed. Phase status lives only in that folder's `implementation-plan.md`.

## Spec docs

`{{…}}` is fill-in. HTML comments in the templates are author guidance — strip them when writing the doc.

Binding: goals, rules, deliverables, acceptance scenarios, Done when, and field tables. Advisory: approach, sketches, and diagrams. A deviation from advisory text is recorded in the phase **Close-out**.

Templates are a starting shape. When promoting to tech specs, skip a section that does not apply, or replace it when another shape fits the feature better. Binding facts stay; the heading does not.

Tables (binding): a cell holds a name, ID, status, value, or path, in about 10 words. Anything longer goes in a per-item list. Goals, decisions, open questions, work split, glossary, acceptance scenarios, risks, and external contracts are lists, not tables.

Tech docs: `business-logic.md`, `contracts.md`, `ui.md`. An older folder may have `data.md`; it is the same doc as `contracts.md`. Do not rename it unless asked.

IDs: `G` goals, `R` rules, `A<phase>.<n>` acceptance scenarios, `D` decisions, `Q` open questions. Define and cite `G`, `R`, `D`, `Q` as `G1 (short name)`: a 2–4 word lowercase name in parentheses. Every citation uses the full form; a bare `G1` is a defect. Never reuse a number. Renaming updates every citation in the folder. `A2.1` keeps its form. Decisions and open questions live in `spec.md`, as lists with no index table. A long **Open questions** list at design is normal. Set **Priority** to `high` when the answer would change later specs, the plan, or other goals; otherwise `—`. Elsewhere, `> **Open:** Q1 (short name)` points at an item there.

`spec.md` has separate **Notes** (context, no action needed) and **Concerns** (needs a decision or a change; states what goes wrong if left). Omit either when empty.

`[SUGGESTION: …]` is an unaccepted draft. Remove the marker when the user accepts the text. Do not write an implementation plan while `spec.md` still contains one.

## Help

If the message is only `spec`, `/spec`, or `/spec help` — no slug and no action — stop. Do not bootstrap, do not open a stage file, and do not start a spec.

- `spec_docs/README.md` exists → point the user at that file. Do not restate it.
- It does not exist → explain what this skill does: the lifecycle (`spec.md` → tech specs → implementation plan → one phase → archive) and the actions in the table below.

## Infer, otherwise ask

Explicit verbs skip the "what next?" question. Read the matching stage file and run it. A bare `/spec` or `/spec help` is the help case above, not an ambiguous request.

| User said | Action | Stage file |
| --------- | ------ | ---------- |
| create spec from … / name it … | Write or resume `spec.md` only | [stages/create-spec.md](stages/create-spec.md) |
| promote to tech specs | Technical docs only. Set `Progress: tech` | [stages/tech-specs.md](stages/tech-specs.md) |
| promote to implementation plan | Plan only. If `Progress` is `design`, ask before skipping tech | [stages/plan.md](stages/plan.md) |
| next | Read `Progress`, name the next gate, and ask to continue. Do not open a stage file until they confirm | — |
| implement / continue | One phase, or one combinable group | [stages/implement.md](stages/implement.md) |
| archive | Move the folder after explicit confirmation | [stages/implement.md](stages/implement.md) |
| audit / review spec | Read-only report in chat | [stages/audit.md](stages/audit.md) |

Ambiguous or conflicting requests: ask.

If `spec_docs/<slug>/` already exists, resume it. Do not create a second folder. Confirm the slug when it is inferred from a work-item title.

Editing an earlier doc is allowed at any later gate. If scope, non-goals, or glossary in `spec.md` change after siblings exist, update those siblings in the same session. Ask only before replacing or deleting a later artifact (regenerating tech specs or the plan from scratch). `/spec next` at `Progress: plan` still proposes implementation.

## Stage detection

First match, from the `Progress` line:

- `spec_docs/` missing, and the user asked for an action (not help) → bootstrap in [stages/create-spec.md](stages/create-spec.md), then continue from the user's intent.
- No `spec_docs/<slug>/` and the user supplied input → create spec (`Progress: design`).
- `design` → next offer: promote to tech specs.
- `tech` → next offer: create the implementation plan.
- `plan` or `implementing`, with a phase open → next offer: implement the active or next phase.
- Every phase `Done`, or only `Done` plus `Deferred` → offer archive.
- `archived`, or the path is under `spec_docs/archive/` → report archived; stop unless they ask for a doc correction.

## Touched paths

`spec.md` has a **Touched paths** table: repo-relative path, area, and change — or one row, "this repo only." A path listed there may be read. If the section is missing, ask before opening anything outside the repo root or scope the user named. At create-spec, investigate how the input relates to this repo and to related repos, packages, or modules, then name the paths. File-level design waits until tech specs or the phase being implemented.

## Bootstrap

If `spec_docs/` does not exist, copy [templates/spec-docs-readme.md](templates/spec-docs-readme.md) to `spec_docs/README.md` and add `spec_docs/archive/.gitkeep`. Do not open other docs to fill **Project conventions**.

## Work items

When the input is a work-item id, follow **Project conventions** for how to fetch it. Keep the title and description in the source note, and map acceptance criteria onto the goals. Do not paste the raw work-item payload into `spec.md` or the reply.

## Bounds

- **No surprise SCM.** Do not create branches, worktrees, or commits unless the user explicitly asks in that conversation. Create, promote, and implement do not add a worktree step.
- **One skill.** Adaptations stay in this skill tree. Do not add peer skills for brainstorming, planning, or TDD for this workflow.
- **No auto pipeline.** After design-file approval, do not auto-invoke a separate implementation pipeline.
