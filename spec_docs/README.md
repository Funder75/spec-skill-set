# Spec docs

Planning documents for this repo. One folder per feature spec. The spec workflow skill reads **Project conventions** below when it needs a project fact. It does not use the rest of this file as its process.

| Path | Role |
| ---- | ---- |
| `<slug>/` | Active spec. Start at `spec.md` |
| `<slug>/spec.md` | Scope, gates, and the coarse work split. The `Progress` line is the gate |
| `<slug>/implementation-plan.md` | Phases and the only phase status. Added after technical specs are reviewed |
| `archive/<slug>/` | Finished specs |

## How to use

Work moves through three reviewed documents, then implementation:

1. **Spec design** — `spec.md` only (`Progress: design`). Iterate here.
2. **Technical specs** — `business-logic.md`, `contracts.md`, and `ui.md` when that concern needs its own file. Older folders may have `data.md`; it is the same doc as `contracts.md`. Otherwise the notes stay in `spec.md` under **Technical notes** (`Progress: tech`).
3. **Implementation plan** — phases, Done when, and phase status (`Progress: plan`).
4. **Implement** one phase at a time (`Progress: implementing`). When the work is done, move the folder to `archive/` (`Progress: archived`).

`Progress` in `spec.md` is the gate: `design`, `tech`, `plan`, `implementing`, or `archived`. Phase status (`Not started` through `Done`, plus `Deferred` and `Blocked`) lives only in `implementation-plan.md`.

Invoke the user-level **spec** skill (`/spec`) and say what to do. Examples: create a spec from a note or a work item, promote to tech specs, promote to an implementation plan, implement the next phase, archive.

Do not edit the skill to record progress.

## Reading these docs

| Marker | Meaning |
| ------ | ------- |
| `[SUGGESTION: …]` | A draft. It is not accepted until the marker is removed |
| `> **Open:** Q1 (name)` | Points at an open question in that spec's `spec.md` |
| `(advisory)` | A hint. The implementer may deviate, and records the deviation in the phase **Close-out** |

Binding, and what a review checks against: goals, rules, deliverables, acceptance scenarios, Done when, and field tables. Approach, sketches, and diagrams are advisory.

IDs carry a short name, for example `G1 (writing style)`:

- **G** — goal and its acceptance criteria, in `spec.md`.
- **R** — rule, in `business-logic.md` or in **Technical notes**.
- **D** — decision, in `spec.md`.
- **Q** — open question, in `spec.md`. **Blocks** names what cannot proceed.
- **A2.1** — acceptance scenario 1 of phase 2. No name.
- **C1 / W1 / O1** — critical, warning, and optimization findings in an audit report. No name.

To find every citation of an ID, search for the ID and the opening parenthesis, for example `G1 (`. A plain `G1` search also hits `G10`.

Phase status: `Not started`, `Started`, `Reviewing`, `Done`, `Deferred`, `Blocked`.

**Tier** rates how hard a phase is to implement (Low / Medium / High) so the implementer can choose effort. It also selects the default verify row under **Project conventions**.

## Project conventions

<!--
The skill reads this section when it needs a project fact. If a subsection is still {{…}}, the skill asks.
-->

### Work items

This repo has no work-item system. Specs come from chat or free text. If a future id scheme appears, keep title, description, and acceptance criteria, and map each criterion to a goal **Source** line (for example `WI AC2`).

### Verify tiers

This repo is skill and plugin markdown. There is no app build. Run verify from the repo root. Commands are checks the implementer performs and records under phase **Close-out**.

| Tier | Verify |
| ---- | ------ |
| Low | Diff each deliverable path against the phase **Done when** and scenarios; confirm no `{{…}}` or HTML author comments remain in touched skill files |
| Medium | Low, plus `rg` that each cited rule and goal ID (full form) appears in the named stage or template |
| High | Medium, plus a dry read of the stage as an agent would: walk the ordered sections and confirm the chat-gate or Approach rules cannot be skipped |

No install or test runner is required for these checks.

### Complexity hotspots

- **Create-spec chat gate** — Ordered clarify → approach → approval → write; mistakes pass a file diff and only show up in a live `/spec create` session.
- **Plan Approach contract** — Guiding vs pasteable is judgmental; weak feedback until someone runs promote.

### Stack notes for spec docs

This plugin does not ship an application UI or data layer. Specs that only change skill text set tech rows to `not needed` or fold notes. When a feature later needs app-facing tech docs:

- **UI library:** n/a in this repo
- **Data access:** n/a in this repo
- **Validation:** n/a in this repo
- **Errors:** n/a in this repo
- **i18n:** none

### Other commands

| Task | Command | Notes |
| ---- | ------- | ----- |
| Reload local plugin | Copy repo to `~/.cursor/plugins/local/spec-skill-set`, then Reload Window | Required after skill edits for Cursor to pick them up |
