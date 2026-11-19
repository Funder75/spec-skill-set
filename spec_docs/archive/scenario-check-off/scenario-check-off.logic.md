# Scenario check-off — business logic

> Created because: six distinct rules plus tick and Close-label workflows with non-obvious owner splits

Rules for **scenario-check-off**. [scenario-check-off.spec.md](./scenario-check-off.spec.md) owns scope, non-goals, glossary, and decisions; cite them in full form (`see D1 (scenario ticks)`).

## TL;DR

- Each acceptance scenario carries its own pass checkbox; Done when drops scenario-range lines.
- Gates stays owner and evidence only; human scenario ticks wait for person accept.
- Tracker Phase sync mirrors Close onto conventions-mapped labels without inventing names.

## Rules

### R1 (scenario tick)

**Lands in:** `skills/spec/templates/implementation-plan.md` › Acceptance scenarios · `skills/spec/stages/plan.md` › What to write

- Every acceptance scenario in a plan MUST open with a markdown checkbox on the scenario title line.
- The unchecked form is `- [ ] **A{{n}}.m — {{title}}**`. The checked form uses `[x]` or `[X]` in the same place.
- Journey or Trace, Check, and Given / When / Then stay under that line as today.
- Gates MUST NOT gain a tick or Pass column (see D1 (scenario ticks)).

> **Preserve:** Scenario **Check** (`automated` / `human`) and Gates as the owner record stay required.

### R2 (slim Done when)

**Lands in:** `skills/spec/templates/implementation-plan.md` › Done when · `skills/spec/stages/plan.md` · `skills/spec/design-quality.md` › Done when

- Done when MUST NOT list scenario-range pass lines such as `A2.1–A2.4 pass` or a lone scenario-id pass line.
- Done when MUST still list the tier verify line, any stronger command this phase needs, and phase-specific regressions.
- Plan-stage guidance that put human scenario IDs on their own Done when line MUST be removed; those IDs live on the scenario tick instead.

> **Preserve:** Who runs each check remains Gates, not Done when.

### R3 (tick on verify)

**Lands in:** `skills/spec/stages/implement.md` › Verify · Review gate · Stop and resume

- When an automated Gates row for a scenario passes, implement or review MUST set that scenario's title checkbox to checked.
- Human scenario ticks MUST stay unchecked until the person accepts that check (batched or named), matching Close / Gates rules from `defer-human-gates`.
- The agent MUST NOT treat a human scenario as passed because the review subagent was satisfied.

> **Preserve:** Automated Gates rows still run at verify; human Gates rows stay unchecked until accept.

### R4 (validate shape)

**Lands in:** `skills/spec/scripts/validate`

- Validate MUST detect the scenario-title checkbox shape from R1 (scenario tick).
- When any scenario in the plan uses a title checkbox, validate MUST report every scenario that lacks one, and MUST report Done when lines that are only a scenario-range or scenario-id pass claim (see D4 (validate opt-in)).
- When every scenario still uses a plain title (no title checkbox), validate MUST NOT require ticks and MUST NOT ban those Done when lines for opt-in reasons alone.
- Gates↔Check matching MUST keep working with both plain and checkbox title lines.

### R5 (close label map)

**Lands in:** `skills/spec/templates/spec-docs-readme.md` › Work items · `spec_docs/README.md` › Project conventions · `README.md` when status docs list labels

- Project conventions MUST gain a Close → label map with keys for Close `human` and Close `automated`.
- The README template seed MUST include the same placeholder map next to the Progress and Tracker Phase status maps.
- Sync MUST read label names or ids only from that map. It MUST NOT hard-code Close label names in the skill (see D2 (close label map)).

### R6 (label on sync)

**Lands in:** `skills/spec/stages/linear-sync/tracker-phases.md` › Create · Update

- On every Tracker Phase create or update sync, when write-back is allowed, the skill MUST set the label for the unit's current Close and remove the other Close label.
- Prefer `addLabels` / `removeLabels` over a full label replace.
- Close MUST remain in the Tracker Phase body; the label is the glanceable signal (see D3 (label on sync)).
- When the Close → label map is missing or still a placeholder, warn once and skip the Close label write. Do not invent label names.

> **Preserve:** Existing Progress and phase-status label maps, body Close field, and conventions-gate skip behaviour stay.

## Actors and entry points

| Entry point | User action | System response | Handled by |
| ----------- | ----------- | --------------- | ---------- |
| Plan write | Author promotes to plan | Scenarios get title ticks; Done when is slim | `stages/plan.md` |
| Implement verify | Agent runs automated Gates | Matching scenario ticks checked | `stages/implement.md` |
| Sign-off | Person accepts human gates | Human scenario ticks checked; phase Done | `stages/implement.md` › batched / named |
| Tracker Phase sync | Create or update unit | Close label applied; opposite removed | `linear-sync/tracker-phases.md` |

## Workflows

### Tick scenarios in review

1. Reviewer opens the phase's acceptance scenarios — plan file › Acceptance scenarios.
2. Automated scenarios that already passed show checked title boxes — set under R3 (tick on verify).
3. Reviewer ticks each human scenario when accepting that check — same accept path as human Gates.
4. Done when shows verify and regression lines only — R2 (slim Done when).

### Apply Close label on sync

1. Plan or implement sync builds or refreshes a Tracker Phase — `tracker-phases.md` › Create or Update.
2. Sync reads Close from the progress overview for the unit.
3. Sync resolves the mapped label for that Close value — R5 (close label map).
4. Sync adds that label and removes the other Close label — R6 (label on sync).
5. If the map is unusable, warn once and leave labels unchanged — R6 (label on sync).

## States and transitions

| From | Event | Guard | To | Side effect |
| ---- | ----- | ----- | -- | ----------- |
| Scenario tick unchecked | Automated Gates pass | Check is automated | Checked | Close-out records the pass |
| Scenario tick unchecked | Person accepts human gate | Check is human | Checked | Same accept as Gates human row |
| Scenario tick checked | Person rejects awaiting phase | Cascade reopen | Unchecked | Later work reopens per defer-human-gates |
| Tracker Phase labels | Create or update sync | Map filled; write-back allowed | Matching Close label only | Opposite Close label removed |
| Tracker Phase labels | Create or update sync | Map missing or placeholder | Unchanged | Warn once; body Close still written |

## Conditions and error cases

| Rule | Condition | Behaviour | Handled by | User message |
| ---- | --------- | --------- | ---------- | ------------ |
| R4 (validate shape) | Scenario title has no checkbox | Emit finding | `scripts/validate` | Plan path + scenario id |
| R4 (validate shape) | Done when has scenario-range pass line | Emit finding | `scripts/validate` | Plan path + line cue |
| R6 (label on sync) | Close map placeholder or missing | Skip Close label write | `tracker-phases.md` | Warn once in chat |
| R3 (tick on verify) | Human scenario; review subagent pass only | Leave tick unchecked | `implement.md` | — |

## Interactions with existing domain

- **Close / Gates / Awaiting sign-off** (`defer-human-gates`, `design-quality.md` › Phase close): Tick rules reuse the same automated vs human split and batched sign-off. This feature does not change status names.
- **Tracker Phase body Close** (`tracker-phases.md` › Tracker Phase body): Body field stays; labels are additive.
- **Progress and phase status maps** (Project conventions): Close → label map follows the same placeholder and skip-if-unfilled pattern.
