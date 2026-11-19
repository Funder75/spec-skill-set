---
work_item: n/a
tracker_spec_url: n/a
epic: fewer-human-stops
---

# Scenario check-off

**Progress:** archived
**Depth:** standard
**Kind:** feature
**Depends on:** defer-human-gates

## TL;DR

- **What:** Give each acceptance scenario its own tick, and add Close labels to Linear Tracker Phases.
- **Why:** Done when points at scenario ranges, so a reviewer jumps back and forth to tick them, and Linear does not show who closes a phase.
- **v1 includes:** A per-scenario check state in the plan template, a simpler Done when that no longer repeats scenario ranges, and `human` / `automated` Close labels on Tracker Phases.
- **v1 excludes:** Changes to how scenarios are written (Given / When / Then stays).

## Doc index

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file (`scenario-check-off.spec.md`) | Scope, goals, journeys, constraints, work split | yes |
| [scenario-check-off.logic.md](./scenario-check-off.logic.md) | Rules, workflows, state transitions | yes |
| scenario-check-off.contracts.md | Types, API contracts, state ownership, storage | folded → [Technical notes › Contracts](#contracts) |
| scenario-check-off.ui.md | Layout, interaction, states, copy | not needed |
| [scenario-check-off.plan.md](./scenario-check-off.plan.md) | Phases and phase status | yes |

## Source

> `spec_docs/fewer-human-stops/fewer-human-stops.epic.md` › S2 (scenario check-off). Depth standard, Kind feature. Tick-on-scenario, Close convention map, and sync-on-Tracker-Phase-update approved in chat 2026-11-19.

## Problem and current behaviour

**In short:** Reviewers tick Done when lines that restate scenario ranges, while scenarios themselves have no check state. Linear shows Close only in the Tracker Phase body, not as a filterable label.

- **Range checkboxes.** Done when lists lines such as "A2.1–A2.4 pass", and Gates repeats the same ranges as the owner record.
- **No tick on the scenario.** The acceptance scenario block is prose only (title, Journey or Trace, Check, Given / When / Then).
- **Close in body only.** Tracker Phase description includes Close (`skills/spec/stages/linear-sync/tracker-phases.md` › Tracker Phase body), but create/update does not set a Close label.
- **Other labels are mapped.** Progress and phase status already use Project conventions maps; Close does not.

| Path | What it does today |
| ---- | ------------------ |
| `skills/spec/templates/implementation-plan.md` | Scenario blocks without ticks; Done when repeats ranges |
| `skills/spec/stages/plan.md` | Writes Done when with scenario IDs; Gates owns who runs checks |
| `skills/spec/stages/implement.md` | Ticks Done when / Gates; leaves human rows unchecked until accept |
| `skills/spec/design-quality.md` | Close and Gates rules; scenario Check must appear in Gates |
| `skills/spec/scripts/validate` | Gates↔Check matching; no per-scenario tick shape |
| `skills/spec/stages/linear-sync/tracker-phases.md` | Close in body; labels prefer add/remove; no Close map |
| `skills/spec/templates/spec-docs-readme.md` | Progress and phase status maps; no Close → label map |

## Goals and acceptance criteria

### G1 (scenario ticks) — A reviewer ticks each scenario where it is written

Source: fewer-human-stops › S2 (scenario check-off)

- Each acceptance scenario in the plan has its own check state next to that scenario.
- Done when no longer lists scenario-range lines such as "A2.1–A2.4 pass".
- Done when still lists the tier verify line, any stronger command, and phase-specific regressions.
- Gates stays the owner record (who runs each check and what evidence means). It does not gain a tick column.
- Implement and review still mark automated scenario ticks when those checks pass, and leave human scenario ticks unchecked until the person accepts (batched or named), matching existing Close / Gates rules from `defer-human-gates`.

### G2 (close labels) — Each Linear Tracker Phase shows whether a person must close it

Source: fewer-human-stops › S2 (scenario check-off)

- Project conventions gain a Close → label map (same pattern as Progress and Tracker Phase status maps).
- On every Tracker Phase create or update sync, the skill sets the label for the phase's current Close and removes the other Close label.
- Close remains in the Tracker Phase body; the label is the glanceable / filterable signal.
- Label values must stay consistent with Close and status rules from S1 (deferred sign-off) (`automated` vs `human`, including `Awaiting sign-off`).

## Non-goals

- Changing Given / When / Then (or Journey / Trace / Check) scenario writing.
- Agent-observed Gates owners (later; epic S3 (agent visual checks)).
- Putting ticks in the Gates table (rejected; see D1 (scenario ticks)).
- Hard-coding Close label names in the skill instead of Project conventions (rejected; see D2 (close label map)).
- Rewriting existing plans in other repos to add scenario ticks.
- Parallel implementers.

## Users and context

- **Primary user:** Spec authors and reviewers running plan write and `/spec` implement
- **When:** While reading or closing a phase packet, and when scanning Tracker Phases in Linear
- **Who may do this:** Anyone who can edit the plan or accept human gates; Linear sync when write-back is allowed

## User journeys

### Tick scenarios without range hopping

Starting point: A phase is in review or awaiting sign-off. The reviewer opens the plan at that phase's acceptance scenarios.

1. Reviewer reads each scenario where it is written.
2. For each automated scenario that passed, the tick is already set (or the agent sets it during verify).
3. For each human scenario, the reviewer ticks it when they accept that check.
4. Done when shows verify and regression lines only — no scenario-range checklist to reconcile.

End state: Every scenario's pass state is visible on the scenario itself. Gates still answers who owns each check.

Goes wrong when:

- A human scenario is ticked without person accept — must not happen (G1 (scenario ticks)).
- Done when still requires jumping to scenario ranges — violates G1 (scenario ticks).

Covers: G1 (scenario ticks)

### See Close on the Tracker Phase list

Starting point: A Linear-linked plan has Tracker Phases. The author opens Linear's issue list or board filtered by label.

1. Plan stage or implement syncs a Tracker Phase (create or update).
2. Sync applies the Close label from the conventions map and removes the opposite Close label.
3. Author filters or glances at labels to see which phases need a person.

End state: Close is visible as a label without opening every issue body.

Goes wrong when:

- Close changes in the plan but an update sync leaves the old label — violates D3 (label on sync).
- Conventions map is still a placeholder and sync invents label names — must ask or skip label write, not invent (G2 (close labels)).

Covers: G2 (close labels)

## Constraints

- **Preserve:** Gates as owner/evidence authority; scenario Check `automated` / `human`; Close `automated` / `human` and `Awaiting sign-off` behaviour from `defer-human-gates`; Given / When / Then scenario shape; plan body as phase-status authority; prefer `addLabels` / `removeLabels` over full label replace
- **i18n:** n/a
- **Accessibility:** n/a
- **Security:** Do not put secrets in plan ticks, Close-out, or Linear labels or bodies
- **Performance:** n/a

## Notes

- **Depends on archived sibling.** `defer-human-gates` is archived; this child still depends on its status and Gates shape so Close labels and tick rules stay aligned.
- **Body Close stays.** G2 (close labels) adds labels; it does not remove the Close line from the Tracker Phase description.

## Concerns

- **Placeholder Close map.** If Project conventions leave the Close → label map unfilled, sync must not invent label ids. If left: Tracker Phases keep body Close only and G2 (close labels) is unmet until conventions are filled.

## Proposed solution

**In short:** Put a checkbox on each acceptance scenario, strip scenario ranges from Done when, keep Gates as the owner table, and mirror Close onto Linear labels via a conventions map on every Tracker Phase sync.

Plan template and plan-stage guidance add a check state on each scenario block. Done when keeps verify, stronger-command, and regression lines only. Implement and review tick automated scenarios when those checks pass; human scenario ticks wait for person accept under existing batched / named sign-off. Design-quality and validate learn the new Done when shape and still require every scenario Check to appear in Gates. Project conventions (and the README template seed) gain a Close → label map. Tracker Phase create and update apply the mapped label and remove the other Close label, without changing the body Close field.

### Capabilities (v1)

- **Per-scenario tick.** Check state lives on the scenario block.
- **Slim Done when.** No scenario-range pass lines.
- **Gates owner-only.** Who runs the check; no tick column.
- **Close label map.** Conventions own the Linear label names.
- **Sync apply.** Every Tracker Phase create/update sets the matching Close label.

## Touched paths

| Path | Area | Change |
| ---- | ---- | ------ |
| `skills/spec/templates/implementation-plan.md` | template | Scenario tick; Done when without ranges |
| `skills/spec/stages/plan.md` | plan | Guidance for ticks and slim Done when |
| `skills/spec/stages/implement.md` | implement | Tick scenarios; human ticks wait for accept |
| `skills/spec/design-quality.md` | guidance | Done when / Gates / tick rules |
| `skills/spec/scripts/validate` | validate | Scenario tick shape; Done when range ban |
| `skills/spec/stages/linear-sync/tracker-phases.md` | Linear | Apply Close labels on create/update |
| `skills/spec/templates/spec-docs-readme.md` | docs | Close → label map placeholder |
| `spec_docs/README.md` | docs | Close → label map in conventions |
| `README.md` | docs | Mention Close labels if status docs list them |

## Work split

1. **Plan tick shape.** Covers G1 (scenario ticks). Outcome: template and plan/design-quality/implement prose for per-scenario ticks and slim Done when; Gates stays owner-only. Main surface: plan template and stages.
2. **Validate.** Covers mechanical checks for G1 (scenario ticks). Outcome: validate reports missing scenario ticks and leftover Done when scenario-range lines when those rules are required. Main surface: validate script.
3. **Close labels.** Covers G2 (close labels). Outcome: conventions map, Tracker Phase sync applies/removes labels, docs updated. Main surface: linear-sync tracker-phases and Project conventions.

## Glossary

- **Scenario tick:** Check state on an acceptance scenario block showing whether that scenario has passed.
- **Close label:** Linear label on a Tracker Phase that mirrors plan Close (`human` or `automated`) via the Project conventions map.
- **Slim Done when:** Done when without scenario-range pass lines; verify and regression lines remain.

## Decisions

### D1 (scenario ticks) — Tick lives on the scenario; Gates stays owner-only

- **Date:** 2026-11-19 · **Area:** plan template
- **Why:** Reviewers read the scenario text to judge it; ticking there removes range hopping. Gates already answers who runs the check.
- **Rejected:** Ticks only in Gates; ticks on both scenario and Gates

### D2 (close label map) — Close labels come from a Project conventions map

- **Date:** 2026-11-19 · **Area:** Linear / conventions
- **Why:** Matches Progress and phase status maps; each repo can name its own Linear labels.
- **Rejected:** Hard-coded skill label names; optional override-only defaults without a conventions row

### D3 (label on sync) — Every Tracker Phase create or update applies Close labels

- **Date:** 2026-11-19 · **Area:** linear-sync
- **Why:** Same hook as other Tracker Phase fields; Close changes cannot leave stale labels after a routine update.
- **Rejected:** Update labels only when Close changes; set labels only on create plus explicit repair

### D4 (validate opt-in) — Strict tick rules only after a plan opts in

- **Date:** 2026-11-19 · **Area:** validate
- **Why:** Old plans keep plain scenario titles; forcing ticks everywhere would break them. Opt-in when any title checkbox appears keeps migration local.
- **Rejected:** Always require ticks on every plan (A); always require after ship with only a migration note (C)

## Technical notes (folded)

### Contracts

**In short:** Binding shapes for the scenario checkbox and the Close → label map. Paths are advisory.

#### Scenario title tick

| Field | Shape | Owner |
| ----- | ----- | ----- |
| Pass checkbox | `- [ ]` / `- [x]` on the scenario title line | Plan markdown |
| Scenario id | `A{{phase}}.{{n}}` inside the bold title | Unchanged |
| Check | `automated` or `human` under the title | Unchanged |

Sketch (advisory):

```markdown
- [ ] **A2.1 — Reviewer ticks on the scenario**
  - Journey: Tick scenarios without range hopping, step 1
  - Check: human
  - Given …
  - When …
  - Then …
```

Validate MUST parse both unchecked and checked title lines (see R4 (validate shape)).

#### Close → label map

| Key | Value | Notes |
| --- | ----- | ----- |
| Close `human` | Linear label name or id | From Project conventions |
| Close `automated` | Linear label name or id | From Project conventions |

Lands in: `skills/spec/templates/spec-docs-readme.md` › Work items (new bullet next to Progress / phase status maps), and `spec_docs/README.md` › Project conventions when this repo fills Linear maps.

Placeholder form (advisory):

- **Close → label map:** human → (label name or id); automated → (label name or id). Unfilled until Project conventions name both.

Sync reads only this map (see R5 (close label map), R6 (label on sync)). Unfilled → skip Close label write.

#### Done when slim lines

| Allowed | Banned |
| ------- | ------ |
| Tier verify checkbox | `A2.1–A2.4 pass` style lines |
| Stronger command checkbox | Lone `A2.3 pass` / human-id Done when lines |
| Phase-specific regression checkbox | — |

When any scenario in the plan uses a title checkbox, validate MUST require ticks on every scenario and MUST ban Done when scenario-range / lone-id pass lines (see D4 (validate opt-in)). Plain-title-only plans stay valid.
