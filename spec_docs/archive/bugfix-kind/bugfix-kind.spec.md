---
work_item: n/a
tracker_spec_url: n/a
document_id: n/a
document_url: n/a
---

# Bugfix kind

**Progress:** archived
**Depth:** standard
**Depends on:** —

## TL;DR

- **What:** Add a bugfix Kind so bug specs drop feature journeys and Work split
- **Why:** Bugs are forced through the feature skeleton, which pads small fixes
- **v1 includes:** Kind line, infer-or-explicit create, three behaviour lists, Root cause, plan 1:1 + red-before-green
- **v1 excludes:** Verdict enum, peer skill, auto-migrate, reduce-spec-bloat work, lite-only force

## Doc index

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file (`bugfix-kind.spec.md`) | Scope, goals, journeys, constraints, work split | yes |
| bugfix-kind.logic.md | Rules, workflows, state transitions | folded → [Technical notes › Rules](#rules) |
| bugfix-kind.contracts.md | Types, API contracts, state ownership, storage | folded → [Technical notes › Contracts](#contracts) |
| bugfix-kind.ui.md | Layout, interaction, states, copy | not needed |
| [bugfix-kind.plan.md](./bugfix-kind.plan.md) | Phases and phase status | yes |

## Source

> `spec_docs/todos.md` › "Bugfix kind" (lines on Kind, three behaviour lists, Root cause, plan mapping, red-before-green). Borrowed flavour from Kiro / Spec Kit bug flows; verdict enum left out of v1. Chat: Depth standard; approach infer + confirm; exclusions accepted.

## Problem and current behaviour

**In short:** Every create uses the feature shape. Bug fixes get journeys and Work split they do not need, and plans do not require proof the regression was red before green.

- **One shape for bugs and features.** Create always fills User journeys and Work split. There is no Kind body line.
- **No bugfix invoke path.** Routing knows `as lite|standard|full` only. Saying `as bugfix` does nothing.
- **Plan traces journeys.** Acceptance scenarios name journey steps. Close-out has no red-before-green requirement for a regression scenario.
- **Audit assumes journeys.** Checklist and design-quality treat missing journeys / Work split as defects for every folder.

| Path | What it does today |
| ---- | ------------------ |
| `skills/spec/SKILL.md` | Routes create; Depth only; no Kind |
| `skills/spec/stages/create-spec.md` | Writes journeys and Work split for every Kind |
| `skills/spec/templates/spec.md` | Depth line; required journeys and Work split |
| `skills/spec/stages/plan.md` | Journey-linked scenarios; no TDD unless conventions |
| `skills/spec/templates/implementation-plan.md` | Journey field on scenarios; blank Close-out |
| `skills/spec/analysis-checklist.md` | Journeys and Work split vs phases checks |
| `skills/spec/design-quality.md` | Journey trace on acceptance scenarios |

## Goals and acceptance criteria

### G1 (kind line) — Specs carry Kind; create can set bugfix

Source: todos › Kind line and `create … as bugfix`

- Every new `<slug>.spec.md` has a body line `Kind: feature | bugfix` next to Progress / Depth.
- Missing Kind on an older folder means `feature`. Create MUST NOT rewrite older folders only to add Kind.
- User may set Kind with `create … as bugfix` (alone or with a Depth). Any Depth is allowed; lite is recommended in help text, not required.
- When Kind is unset and the input looks like a bug under D5 (bug heuristic), create recommends bugfix once and waits for yes or no. Explicit `as bugfix` or `as feature` skips that ask.
- When Kind is unset and the input does not look like a bug, Kind defaults to `feature` with no Kind round.

### G2 (bugfix shape) — Bugfix specs use behaviour lists and Root cause

Source: todos › three lists and Root cause

- For `Kind: bugfix`, create replaces **User journeys** and **Work split** with three binding lists:
  - **Current behaviour** — "When … the system …"
  - **Expected behaviour** — "When … the system shall …"
  - **Unchanged behaviour** — "When … the system shall continue to …"
- Under **Problem and current behaviour**, bugfix adds **Root cause** that cites modules actually opened in Investigate.
- For `Kind: feature` (or missing Kind), journeys and Work split stay as today.
- Feature create MUST NOT gain mandatory behaviour lists.

### G3 (plan evidence) — Plan scenarios map to the lists; regression proves red-before-green

Source: todos › plan mapping and Close-out evidence

- For bugfix folders, each acceptance scenario maps one-to-one onto an item from the three behaviour lists (not journey steps). Trace field names the list and item, or an equivalent clear form.
- At least one scenario is the regression that proves the fix. Its **Close-out** MUST record red-before-green evidence: the check failed without the fix and passed with it.
- That evidence is for that regression scenario only. It does not require TDD for every phase. `plan.md` › "Require TDD unless Project conventions say so" still holds.
- Audit and design-quality checks for bugfix folders use the three lists and the red-before-green Close-out rule instead of journey / Work split defects.

## Non-goals

- A `verified` / `partial` / `failed` assess verdict enum (later, if ever).
- A peer bugfix skill or second workflow tree (rejected; see D1 (one skill)).
- Auto-migrating older folders to add `Kind:` (missing stays `feature`).
- Work owned by `reduce-spec-bloat` (explore exit, lite skim cuts, tech sibling bar, and so on).
- Forcing `Kind: bugfix` to Depth lite only.
- Changing Linear write-back doctrine.

## Users and context

- **Primary user:** Spec authors fixing a defect with `/spec`
- **When:** Create from a bug report, failing test, or "broken when …" note; then plan and implement
- **Who may do this:** Anyone who can invoke the Spec skill

## User journeys

### Explicit bugfix create

Starting point: Author has a clear bug and says `create … as bugfix` (optionally with a Depth).

1. Create skips the Kind recommend ask.
2. After Depth and clarify, the design packet uses behaviour lists and Root cause, not journeys or Work split.
3. Author approves; `<slug>.spec.md` is written with `Kind: bugfix`.

End state: Folder at `Progress: design` (or further per Depth) with the bugfix shape.

Goes wrong when:

- Author wanted feature shape — they must say so or edit Kind; G1 (kind line) keeps explicit override.
- Root cause cites unopened modules — Investigate rules still require opened paths only.

Covers: G1 (kind line), G2 (bugfix shape)

### Infer bugfix

Starting point: Author describes a bug without saying `as bugfix`.

1. Create detects bug-like input and recommends `Kind: bugfix` once.
2. Author accepts or declines.
3. Rest of create follows the chosen Kind.

End state: Kind is settled before Write; no silent default to bugfix on ambiguous input without the recommend step.

Goes wrong when:

- Input is ambiguous — decline keeps `feature`; author can still set Kind later by asking to edit.
- Author said `as feature` — no recommend ask.

Covers: G1 (kind line)

### Feature create unchanged

Starting point: Author creates ordinary feature work without bug cues.

1. Kind defaults to `feature` with no Kind round.
2. Spec uses journeys and Work split as today.

End state: Feature folders look as they do now, plus an explicit `Kind: feature` on new writes.

Goes wrong when:

- Infer falsely fires — author declines; G1 (kind line) keeps the one-shot confirm.

Covers: G1 (kind line), G2 (bugfix shape)

### Bugfix plan and close-out

Starting point: Bugfix folder is ready for an implementation plan (or lite thin plan).

1. Plan writes acceptance scenarios that each point at one behaviour-list item.
2. One scenario is marked as the regression check.
3. On implement Reviewing/Done, Close-out records that the regression failed without the fix and passed with it.

End state: Phase can close only when that evidence is present for the regression scenario.

Goes wrong when:

- No automated test exists — Close-out still records how red-before-green was shown (command, manual repro, or equivalent); inventing green-only is a defect under G3 (plan evidence).

Covers: G3 (plan evidence)

## Constraints

- **Preserve:** Depth values and round; Progress gates; one-skill bound; plan body as phase-status authority; missing Kind = feature for older folders; global TDD policy unless Project conventions say otherwise
- **i18n:** n/a
- **Accessibility:** n/a
- **Security:** Untrusted-content rules for create Investigate stay in force
- **Performance:** n/a

## Notes

- **Separate from bloat.** `reduce-spec-bloat` non-goals still defer Bugfix kind here. Do not fold this folder into that plan.
- **Borrowed, not copied.** Kiro / Spec Kit inspired the three lists and verify-before-done flavour. v1 does not import their verdict enum.

## Concerns

- **Infer false positives.** If the heuristic is too broad, every create gets an extra ask. Mitigated by D5 (bug heuristic) and always allowing decline (G1 (kind line)).

## Proposed solution

Add a **Kind** body line beside Depth. Teach create routing and Write to branch on Kind. For bugfix, template and create-spec swap journeys and Work split for the three binding behaviour lists and require Root cause under Problem. Teach plan (and lite thin plan) to trace scenarios to those lists and to require red-before-green in Close-out for the regression scenario. Update audit and design-quality so bugfix folders are not failed for missing journeys or Work split. Keep feature Kind (and missing Kind) on the existing path.

### Capabilities (v1)

- **Kind line.** `feature` | `bugfix` with missing → feature.
- **Infer + confirm.** One recommend ask on bug-like input when Kind unset.
- **Bugfix design shape.** Three lists + Root cause.
- **Regression evidence.** Close-out red-before-green for one mapped scenario.

## Touched paths

| Path | Area | Change |
| ---- | ---- | ------ |
| `skills/spec/SKILL.md` | skill | Route `as bugfix`; document Kind |
| `skills/spec/stages/create-spec.md` | skill | Infer/confirm; bugfix Write rules |
| `skills/spec/templates/spec.md` | templates | Kind line; conditional sections |
| `skills/spec/stages/plan.md` | skill | List mapping; red-before-green note |
| `skills/spec/templates/implementation-plan.md` | templates | Trace field; Close-out guidance |
| `skills/spec/stages/implement.md` | skill | Close-out evidence for regression |
| `skills/spec/analysis-checklist.md` | skill | Bugfix checks vs journeys |
| `skills/spec/design-quality.md` | skill | Bugfix scenario trace |
| `skills/spec/templates/spec-docs-readme.md` | templates | Mention Kind / bugfix invoke |
| `spec_docs/README.md` | docs | Kind note when conventions docs update |

## Work split

1. **Kind and create routing.** Covers G1 (kind line). Outcome: Kind line exists; `as bugfix` and infer+confirm work; feature default preserved. Main surface: SKILL and create-spec.
2. **Bugfix design shape.** Covers G2 (bugfix shape). Outcome: template and create Write emit lists + Root cause for bugfix only. Main surface: spec template and create-spec Write.
3. **Plan and audit evidence.** Covers G3 (plan evidence). Outcome: scenarios map to lists; regression Close-out needs red-before-green; checklist/design-quality agree. Main surface: plan, implement, templates, audit helpers.

## Glossary

- **Kind:** Body line on `<slug>.spec.md`: `feature` or `bugfix`. Missing means `feature`.
- **Behaviour list:** One of Current, Expected, or Unchanged behaviour on a bugfix spec.
- **Red-before-green evidence:** Record that the regression check failed without the fix and passed with it, written in phase Close-out.

## Technical notes (folded)

Depth is standard, so rules and document contracts stay here. No UI surface.

### Rules

**In short:** Create sets Kind, Write branches the design shape, and plan / audit require list traces plus red-before-green on the regression scenario.

#### R1 (kind body line)

**Lands in:** `skills/spec/templates/spec.md` › Progress / Depth header; `skills/spec/stages/create-spec.md` › Write; `skills/spec/SKILL.md` › Progress / Depth docs

- Every new `<slug>.spec.md` MUST include `Kind: feature | bugfix` next to Progress and Depth.
- Missing Kind on an older folder MUST be treated as `feature`.
- Create MUST NOT rewrite older folders only to add Kind.

> **Preserve:** Existing folders without Kind keep working as feature.

#### R2 (explicit kind flag)

**Lands in:** `skills/spec/SKILL.md` › Infer table / create row; `skills/spec/stages/create-spec.md` › before or with Depth round

- Create MUST accept `as bugfix` and `as feature` (alone or with a Depth).
- Explicit Kind MUST skip the recommend ask.
- Any Depth remains allowed with bugfix; help text SHOULD recommend lite, not require it (see D4 (any depth)).

#### R3 (infer confirm)

**Lands in:** `skills/spec/stages/create-spec.md` › after Analysis / with Depth round

- When Kind is unset and the input looks like a bug under D5 (bug heuristic), create MUST recommend `Kind: bugfix` once and wait for yes or no.
- Decline MUST leave Kind as `feature`.
- Create MUST NOT silently default unset Kind to bugfix.

#### R4 (feature default)

**Lands in:** `skills/spec/stages/create-spec.md` › Kind resolution

- When Kind is unset and the input does not look like a bug, Kind MUST default to `feature` with no Kind round.

#### R5 (bugfix design shape)

**Lands in:** `skills/spec/templates/spec.md` › conditional sections; `skills/spec/stages/create-spec.md` › Write

- For `Kind: bugfix`, Write MUST omit **User journeys** and **Work split**.
- Write MUST emit three binding lists: **Current behaviour**, **Expected behaviour**, **Unchanged behaviour**, each as "When … the system …" items (Expected / Unchanged use "shall" / "shall continue to").
- Under **Problem and current behaviour**, Write MUST add **Root cause** that cites only modules opened in Investigate.
- Feature create MUST NOT gain mandatory behaviour lists.

#### R6 (plan list trace)

**Lands in:** `skills/spec/stages/plan.md` › acceptance scenarios; `skills/spec/templates/implementation-plan.md` › scenario Trace; lite thin-plan path in create-spec

- For bugfix folders, each acceptance scenario MUST map one-to-one onto one item from the three behaviour lists.
- The Trace field MUST name the list and item (or an equivalent clear form). Journey-step traces MUST NOT be required for bugfix.
- At least one scenario MUST be marked as the regression that proves the fix.

#### R7 (red before green)

**Lands in:** `skills/spec/stages/implement.md` › Close-out / Reviewing; `skills/spec/templates/implementation-plan.md` › Close-out guidance; `skills/spec/stages/plan.md` › note

- The regression scenario's **Close-out** MUST record red-before-green evidence: the check failed without the fix and passed with it.
- Evidence MAY be an automated command, a manual repro, or equivalent. Inventing green-only MUST be treated as a defect.
- This rule applies to that regression scenario only. It MUST NOT force TDD for every phase. `plan.md` › "Require TDD unless Project conventions say so" still holds.

#### R8 (audit kind branch)

**Lands in:** `skills/spec/analysis-checklist.md`; `skills/spec/design-quality.md`

- For `Kind: bugfix` (explicit), audit and design-quality MUST check the three behaviour lists and the red-before-green Close-out rule instead of flagging missing journeys or Work split.
- Missing Kind MUST keep today's journey / Work split checks (treat as feature).

### Kind resolution (create)

1. Parse explicit `as bugfix` / `as feature` from the invoke — `skills/spec/SKILL.md` › create row; `skills/spec/stages/create-spec.md`.
2. If unset and bug-like under D5 (bug heuristic) → one recommend ask (R3 (infer confirm)); else default feature (R4 (feature default)).
3. After Depth and Clarify, Write uses the settled Kind (R5 (bugfix design shape) or feature path).

### Contracts

**In short:** Kind is a body line. Bugfix replaces journey sections with named lists. Plans use a Trace field and Close-out evidence shape.

#### Kind body line

**Lands in:** `skills/spec/templates/spec.md` header block

| Field | Values | Required on new writes | Missing means |
| ----- | ------ | ---------------------- | ------------- |
| Kind | `feature` \| `bugfix` | yes | `feature` |

Sketch (advisory):

```md
**Progress:** design
**Depth:** standard
**Kind:** bugfix
**Depends on:** —
```

#### Bugfix design sections

**Lands in:** `skills/spec/templates/spec.md` (conditional); create Write

| Section | Binding contents |
| ------- | ---------------- |
| Current behaviour | List of "When … the system …" |
| Expected behaviour | List of "When … the system shall …" |
| Unchanged behaviour | List of "When … the system shall continue to …" |
| Root cause | Cite opened Investigate modules only |

For bugfix, **User journeys** and **Work split** are absent (not n/a stubs).

#### Scenario Trace and Close-out

**Lands in:** `skills/spec/templates/implementation-plan.md`

| Piece | Feature (or missing Kind) | Bugfix |
| ----- | ------------------------- | ------- |
| Scenario trace | Journey title + step, or `Journey: —` | Behaviour list + item (1:1) |
| Regression mark | optional | at least one scenario marked regression |
| Close-out (regression) | verify as today | MUST include red-before-green evidence |

Sketch (advisory) for a bugfix scenario:

```md
- **A1.1 — Save keeps draft title**
  - Trace: Expected behaviour › "When the user saves, the system shall keep the draft title"
  - Regression: yes
  - Check: automated
  - Given …
  - When …
  - Then …
```

Close-out evidence line (advisory shape): red: named command or repro failed; green: same check passed after the fix.

#### Help / invoke docs

**Lands in:** `skills/spec/templates/spec-docs-readme.md`; `spec_docs/README.md` when that doc is next updated for conventions

- Mention `Kind` and `create … as bugfix`.
- SHOULD note lite is recommended for many bugs, not required.

## Decisions

### D1 (one skill) — Bugfix stays inside the Spec skill

- **Date:** 2026-10-27 · **Area:** process
- **Why:** Bounds forbid peer skills for this workflow. Kind + conditional sections are enough.
- **Rejected:** A separate bugfix skill or stage tree

### D2 (infer confirm) — Unset Kind on bug-like input gets one recommend ask

- **Date:** 2026-10-27 · **Area:** create
- **Why:** Authors often omit `as bugfix`; a single confirm catches them without a Kind round on every feature.
- **Rejected:** Explicit-only Kind; always-ask Kind round

### D3 (no verdict) — v1 omits verified / partial / failed

- **Date:** 2026-10-27 · **Area:** scope
- **Why:** Todo bullets define Kind, lists, Root cause, and red-before-green. The verdict enum is inspiration only.
- **Rejected:** Ship assess verdict in v1

### D4 (any depth) — Bugfix may use any Depth; lite is recommended only

- **Date:** 2026-10-27 · **Area:** create
- **Why:** Some bugs still need standard or full gates. Forcing lite would fight Depth heuristics.
- **Rejected:** bugfix implies lite

### D5 (bug heuristic) — Infer uses keyword / intent cues only

- **Date:** 2026-10-27 · **Area:** create
- **Why:** Narrow cues keep the recommend ask rare. Authors can still say `as bugfix` when words are missing.
- **Chosen:** Keyword / intent cues only — for example bug, fix, regression, broken, fails when, stack trace
- **Rejected:** Failing test or error log alone without those cues; broader "when … does X instead of Y" behaviour-delta matching
