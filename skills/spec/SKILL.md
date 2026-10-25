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
3. The spec folder the user named. During implementation, read `<slug>.spec.md`, the plan's **progress overview**, the **active phase**, and only the tech-doc sections that phase lists — not the whole plan, and not every sibling.
4. `spec_docs/README.md` **Project conventions** only when this action needs a project fact (where a work item comes from, which command verifies a phase). If that section is still the placeholder, ask. Do not load the rest of that README as process. Do not search the repo for conventions.
5. [writing-style.md](writing-style.md) before any action that writes doc text or an audit report. It wins where it differs from this skill's own sentences.
6. [design-quality.md](design-quality.md) only while writing or revising an implementation plan.
7. [analysis-checklist.md](analysis-checklist.md) only during an explicit audit.

Subagents only for serial implement under [stages/implement.md](stages/implement.md) › Serial SDD. Create, promote, and audit MUST NOT spawn subagents. Do not read `spec_docs/archive/` unless the user asks about an archived spec.

## Progress

Each `spec_docs/<slug>/<slug>.spec.md` carries the folder's gate (G1 (slug prefix)):

`Progress: design | tech | plan | implementing | archived`

Set it only when a gate is crossed. Phase status lives only in that folder's `<slug>.plan.md` (G3 (plan extension)).

## Spec docs

`{{…}}` is fill-in. HTML comments in the templates are author guidance — strip them when writing the doc.

**D1 (role map) — emitted filenames under `spec_docs/<slug>/`** (G1 (slug prefix), G2 (short roles), R1 (filename pattern), R2 (short roles only)). Stages and helpers cite this map; do not invent a second table.

| Role | Emitted filename |
| ---- | ---------------- |
| Design overview | `<slug>.spec.md` |
| Business rules | `<slug>.logic.md` |
| Types / API / storage | `<slug>.contracts.md` |
| UI | `<slug>.ui.md` |
| Implementation plan | `<slug>.plan.md` |
| Legacy data (same doc as contracts) | `<slug>.data.md` — only when that folder already used `data.md` and a person renamed it |

New work creates, reads, and updates only these names (G4 (skill resolves), R3 (new names only)). Do not dual-read or dual-write bare basenames. Do not auto-rename existing bare folders (R4 (no auto migrate)). Template *seed* files under `templates/` keep unprefixed basenames (R6 (template seeds stay)); only emitted path text uses the map above (R7 (skill surface complete)).

Binding: goals, rules, deliverables, acceptance scenarios, Done when, and field tables. Advisory: approach, sketches, and diagrams. A deviation from advisory text is recorded in the phase **Close-out**.

Templates are a starting shape. When promoting to tech specs, skip a section that does not apply, or replace it when another shape fits the feature better. Binding facts stay; the heading does not.

Tables (binding): a cell holds a name, ID, status, value, or path, in about 10 words. Anything longer goes in a per-item list. Goals, decisions, open questions, work split, glossary, acceptance scenarios, risks, and external contracts are lists, not tables.

Tech docs (emitted): `<slug>.logic.md`, `<slug>.contracts.md`, `<slug>.ui.md`. An older folder may still have bare `data.md` until a person renames; do not rename it as a side effect. After a hand rename that sibling is `<slug>.data.md` (same doc as contracts).

IDs: `G` goals, `R` rules, `A<phase>.<n>` acceptance scenarios, `D` decisions, `Q` open questions. Define and cite `G`, `R`, `D`, `Q` as `G1 (short name)`: a 2–4 word lowercase name in parentheses. Every citation uses the full form; a bare `G1` is a defect. Never reuse a number. Renaming updates every citation in the folder. `A2.1` keeps its form. Decisions and open questions live in `<slug>.spec.md`, as lists with no index table. A long **Open questions** list at design is normal. Set **Priority** to `high` when the answer would change later specs, the plan, or other goals; otherwise `—`. Elsewhere, `> **Open:** Q1 (short name)` points at an item there.

`<slug>.spec.md` has separate **Notes** (context, no action needed) and **Concerns** (needs a decision or a change; states what goes wrong if left). Omit either when empty.

`[SUGGESTION: …]` is an unaccepted draft. Remove the marker when the user accepts the text. Do not write an implementation plan while `<slug>.spec.md` still contains one.

## Help

If the message is only `spec`, `/spec`, or `/spec help` — no slug and no action — stop. Do not bootstrap, do not open a stage file, and do not start a spec.

- `spec_docs/README.md` exists → point the user at that file. Do not restate it.
- It does not exist → explain what this skill does: the lifecycle (`<slug>.spec.md` → tech specs → `<slug>.plan.md` → one phase → archive) and the actions in the table below.

## Infer, otherwise ask

Explicit verbs skip the "what next?" question. Read the matching stage file and run it. A bare `/spec` or `/spec help` is the help case above, not an ambiguous request.

| User said | Action | Stage file |
| --------- | ------ | ---------- |
| create spec from … / name it … | Write or resume `<slug>.spec.md` only | [stages/create-spec.md](stages/create-spec.md) |
| promote to tech specs | Technical docs only. Set `Progress: tech` | [stages/tech-specs.md](stages/tech-specs.md) |
| promote to implementation plan | Plan only. If `Progress` is `design`, ask before skipping tech | [stages/plan.md](stages/plan.md) |
| next | Read `Progress`, name the next gate, and ask to continue. Do not open a stage file until they confirm | — |
| implement / continue | One phase, or one combinable group | [stages/implement.md](stages/implement.md) |
| archive | Move the folder after explicit confirmation | [stages/implement.md](stages/implement.md) |
| audit / review spec | Read-only report in chat | [stages/audit.md](stages/audit.md) |
| `linear sync` / `sync with linear` / `sync to linear` / create or repair Linear tracker links | Explicit Linear create/repair (not a freeform stage name) | [stages/linear-sync.md](stages/linear-sync.md) |

Match intent, not exact word order: any clear ask to sync this slug with Linear routes to that stage. Do not treat “sync with Linear” as an unknown named stage.

Ambiguous or conflicting requests: ask.

If `spec_docs/<slug>/` already exists, resume it. Do not create a second folder. Confirm the slug when it is inferred from a work-item title.

Editing an earlier doc is allowed at any later gate. If scope, non-goals, or glossary in `<slug>.spec.md` change after siblings exist, update those siblings in the same session. Ask only before replacing or deleting a later artifact (regenerating tech specs or the plan from scratch). `/spec next` at `Progress: plan` still proposes implementation.

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

`<slug>.spec.md` has a **Touched paths** table: repo-relative path, area, and change — or one row, "this repo only." A path listed there may be read. If the section is missing, ask before opening anything outside the repo root or scope the user named. At create-spec, investigate how the input relates to this repo and to related repos, packages, or modules, then name the paths. File-level design waits until tech specs or the phase being implemented.

## Bootstrap

If `spec_docs/` does not exist:

1. Copy [templates/spec-docs-readme.md](templates/spec-docs-readme.md) to `spec_docs/README.md` and add `spec_docs/archive/.gitkeep`.
2. Ask in chat whether to fill **Project conventions** now. Say the interview covers work items (tracker), verify tiers, complexity hotspots, stack notes, and other commands — one explained question at a time, and any answer may stay a placeholder. Complete this ask (and any opt-in interview) before Investigate, Clarify, or other stage work from the original `/spec` intent.
3. On explicit no, ignore, or a reply that continues the original action with no yes and no convention answers: leave the README unchanged and resume the original intent. Do not search the repo to fill conventions.
4. On explicit yes, or a reply that already answers interview questions: treat as opt-in. Run [stages/fill-conventions.md](stages/fill-conventions.md). Do not invent a second fill path. Then resume the original intent.

## Work items

When the input is a work-item id, follow **Project conventions** for how to fetch it. Keep the title and description in the source note, and map acceptance criteria onto the goals. Do not paste the raw work-item payload into `<slug>.spec.md` or the reply. After create-spec sets frontmatter `work_item`, link-back and other Linear writes follow [stages/linear-sync.md](stages/linear-sync.md) — do not invent a second sync doctrine (R20 (routing entry)). Durable Linear foreign keys (`work_item`, `tracker_spec_url`, `document_id`, `document_url`) live in `<slug>.spec.md` YAML frontmatter only; `Progress` and `Depends on` stay in the body.

## Bounds

- **No surprise SCM.** Do not create branches, worktrees, or commits unless the user explicitly asks in that conversation. Create, promote, and implement do not add a worktree step. Asking for an implementation branch does not imply a worktree, and the reverse does not hold. Default is the shared checkout. Cloud consent is a chat ask, or implied when the run already is a Cursor Cloud Agent; extra branches, worktrees, or commits still need an ask.
- **One skill.** Adaptations stay in this skill tree. Do not add peer skills for brainstorming, planning, or TDD for this workflow.
- **No auto pipeline.** After design-file approval, do not auto-invoke a separate implementation pipeline.
