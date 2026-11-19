# Scenario check-off — implementation plan

Phases for [scenario-check-off.spec.md](./scenario-check-off.spec.md).

**Status values:** `Not started` · `Started` · `Reviewing` · `Awaiting sign-off` · `Done` · `Deferred` · `Blocked`

## Progress overview

| Phase | Status | Name | Tier | Close | Depends on | Combinable with |
| ----- | ---- | ------ | ---- | ----- | ---------- | --------------- |
| **1** | Done | Scenario ticks | Medium | automated | — | 2 |
| **2** | Done | Close labels | Medium | automated | — | 1 |

## Phase 1 — Scenario ticks

**Tracker phase:** n/a

**Goal:** New plans get a pass checkbox on each acceptance scenario, slim Done when without scenario-range lines, and validate enforces that shape only when a plan opts in.

**Covers:** G1 (scenario ticks), R1 (scenario tick), R2 (slim Done when), R3 (tick on verify), R4 (validate shape), D1 (scenario ticks), D4 (validate opt-in)

**Read first:**

- [scenario-check-off.spec.md › Scenario title tick](./scenario-check-off.spec.md#scenario-title-tick)
- [scenario-check-off.spec.md › Done when slim lines](./scenario-check-off.spec.md#done-when-slim-lines)
- [scenario-check-off.logic.md › R1 (scenario tick)](./scenario-check-off.logic.md#r1-scenario-tick)
- [scenario-check-off.logic.md › R2 (slim Done when)](./scenario-check-off.logic.md#r2-slim-done-when)
- [scenario-check-off.logic.md › R3 (tick on verify)](./scenario-check-off.logic.md#r3-tick-on-verify)
- [scenario-check-off.logic.md › R4 (validate shape)](./scenario-check-off.logic.md#r4-validate-shape)

**Tier:** Medium — opt-in validate rules plus multi-stage prose for one binding tick shape

**Close:** automated

**Not in this phase:** Close → label map, Tracker Phase label sync, README Close-label mentions

**Deliverables:**

- `skills/spec/templates/implementation-plan.md` — extend: scenario title checkbox sketch; Done when without scenario-range pass lines; keep Gates owner-only
- `skills/spec/stages/plan.md` — extend: require title ticks; slim Done when; drop guidance that puts human scenario IDs on their own Done when line
- `skills/spec/stages/implement.md` — extend: check automated scenario ticks on Gates pass; leave human scenario ticks unchecked until person accept
- `skills/spec/design-quality.md` — extend: Done when / journey-trace / Close examples match slim Done when and scenario ticks
- `skills/spec/scripts/validate` — extend: detect title-checkbox opt-in; require ticks on every scenario and ban Done when scenario-range / lone-id pass lines when opted in; keep Gates↔Check for plain and checkbox titles

**Approach** (advisory):

1. Update the template Acceptance scenarios seed to the contracts sketch (`- [ ] **A{{n}}.1 — …**`). Remove the Done when line that lists `A{{n}}.1–A{{n}}.x pass`.
2. In `plan.md` › What to write, mirror R1 (scenario tick) and R2 (slim Done when). Point authors at Gates for ownership. Do not add a Gates tick column.
3. In `implement.md` › Verify, Review gate, and Stop and resume / batched sign-off, set automated scenario title boxes when those Gates rows pass. On person accept, set human scenario ticks with the same human Gates rows (R3 (tick on verify)).
4. In `design-quality.md`, update Done when bad/good and any Close examples that still show range pass lines.
5. In `scripts/validate`, parse both `- [ ] **A…` and `- [x] **A…` (and `[X]`). Opt-in when any title checkbox appears (D4 (validate opt-in)). Plain-title-only plans stay valid under today's rules.
6. Do / do-not: do keep Gates↔Check matching; do not invent ticks on Gates; do not rewrite existing plans in other folders.

### Acceptance scenarios

- **A1.1 — Scenario title has a tick**
  - Journey: Tick scenarios without range hopping, step 1
  - Check: automated
  - Given the implementation-plan template after this phase
  - When an author starts a new plan from the seed
  - Then each acceptance scenario opens with a markdown checkbox on the title line, and Journey / Trace, Check, and Given / When / Then stay under it

- **A1.2 — Done when has no scenario ranges**
  - Journey: Tick scenarios without range hopping, step 4
  - Check: automated
  - Given the template and plan-stage guidance after this phase
  - When an author writes Done when for a new phase
  - Then Done when lists verify / stronger-command / regression lines only, with no `A2.1–A2.4 pass` or lone scenario-id pass lines

- **A1.3 — Automated tick on Gates pass**
  - Journey: Tick scenarios without range hopping, step 2
  - Check: automated
  - Given an automated scenario whose Gates row passed verify
  - When implement or review records that pass
  - Then that scenario's title checkbox is checked

- **A1.4 — Human tick waits for accept**
  - Journey: Tick scenarios without range hopping, step 3
  - Check: automated
  - Given a human scenario and a passing agent review only
  - When the phase is still awaiting person accept
  - Then that scenario's title checkbox stays unchecked until the person accepts that check

- **A1.5 — Validate opt-in**
  - Journey: —
  - Check: automated
  - Given one plan with any scenario title checkbox and another with only plain titles
  - When validate runs on each folder
  - Then the opted-in plan is reported for missing ticks or Done when scenario-range lines, and the plain-title plan is not failed for those opt-in rules alone

### Done when

- [x] `/bin/sh skills/spec/scripts/validate spec_docs/scenario-check-off/` passes
- [x] A1.1–A1.5 pass
- [x] Gates↔Check still matches for a plain-title plan and a checkbox-title plan (review cites validate or parser behaviour)

### Gates

| Check | Owner | Evidence |
| ----- | ----- | -------- |
| Medium verify command | automated | Close-out command result |
| A1.1, A1.2, A1.3, A1.4, A1.5 | automated | Close-out cites template, stages, validate |

**Ask-before:** —

### Close-out

- Verified: `/bin/sh skills/spec/scripts/validate spec_docs/scenario-check-off/` → pass (exit 0). A1.1 template seed uses `- [ ] **A…**` and dropped Done when range line. A1.2 plan.md / design-quality require slim Done when; no human-ID Done when lines. A1.3 implement Session checklist + Review gate set automated scenario title ticks on Gates pass. A1.4 human ticks stay unchecked until batched/named accept. A1.5 opt-in smoke: plain plan ignored range lines; checkbox plan reported missing tick + range/lone pass; Gates↔Check parsed both title shapes.
- Deviations: —
- Follow-ups: (added, phase 2, task, destination) fill-conventions Linear interview / write shape should ask for Close → label map so filled conventions keep the template bullet — `skills/spec/stages/fill-conventions.md`
- Blocked:

## Phase 2 — Close labels

**Tracker phase:** n/a

**Goal:** Tracker Phase create and update sync apply a conventions-mapped Close label and remove the opposite one, without inventing names when the map is unfilled.

**Covers:** G2 (close labels), R5 (close label map), R6 (label on sync), D2 (close label map), D3 (label on sync)

**Read first:**

- [scenario-check-off.spec.md › Close → label map](./scenario-check-off.spec.md#close--label-map)
- [scenario-check-off.logic.md › R5 (close label map)](./scenario-check-off.logic.md#r5-close-label-map)
- [scenario-check-off.logic.md › R6 (label on sync)](./scenario-check-off.logic.md#r6-label-on-sync)
- [scenario-check-off.logic.md › Apply Close label on sync](./scenario-check-off.logic.md#apply-close-label-on-sync)

**Tier:** Medium — label apply/remove on create and update with placeholder skip

**Close:** automated

**Not in this phase:** scenario title ticks, slim Done when, validate opt-in rules

**Deliverables:**

- `skills/spec/templates/spec-docs-readme.md` — extend: Close → label map placeholder next to Progress / phase-status maps
- `spec_docs/README.md` — extend: Close → label map under Project conventions (Documenting changes)
- `README.md` — extend: mention Close labels where status / Linear label docs already list maps (Documenting changes)
- `skills/spec/stages/linear-sync/tracker-phases.md` — extend: on create and update, set the mapped Close label and remove the other; skip and warn once when the map is missing or still a placeholder

**Approach** (advisory):

1. Add the conventions bullet: `Close → label map: {{human → …; automated → …}}` beside the existing Progress and Tracker Phase status maps in the README template seed.
2. Mirror that row in this repo's `spec_docs/README.md` › Project conventions. Keep body Close on the Tracker Phase description.
3. In `tracker-phases.md` › Create and Update, after other label/status work, resolve the unit's Close from the progress overview. Prefer `addLabels` / `removeLabels` (R6 (label on sync)).
4. Do / do-not: do read names or ids only from the map; do not hard-code Close label strings in the skill; do not invent labels when the map is a placeholder.

### Acceptance scenarios

- **A2.1 — Conventions map exists**
  - Journey: See Close on the Tracker Phase list, step 2
  - Check: automated
  - Given the README template seed after this phase
  - When an author fills Project conventions for Linear
  - Then a Close → label map with keys for `human` and `automated` sits next to the Progress and phase-status maps

- **A2.2 — Sync applies the matching label**
  - Journey: See Close on the Tracker Phase list, step 2
  - Check: automated
  - Given a filled Close → label map and write-back allowed
  - When Tracker Phase create or update sync runs for a unit
  - Then the skill sets the label for that unit's Close and removes the other Close label

- **A2.3 — Placeholder map skips label write**
  - Journey: See Close on the Tracker Phase list, step 2
  - Check: automated
  - Given a missing or placeholder Close → label map
  - When Tracker Phase sync would write labels
  - Then it warns once, skips the Close label write, and still writes body Close

### Done when

- [x] `/bin/sh skills/spec/scripts/validate spec_docs/scenario-check-off/` passes
- [x] A2.1–A2.3 pass
- [x] Project docs / other markdown updated per Documenting changes (README.md, spec_docs/README.md, template seed)

### Gates

| Check | Owner | Evidence |
| ----- | ----- | -------- |
| Medium verify command | automated | Close-out command result |
| A2.1, A2.2, A2.3 | automated | Close-out cites conventions, tracker-phases |
| Documenting changes | automated | Close-out cites README paths |

**Ask-before:** —

### Close-out

- Verified: same validate pass as phase 1. A2.1 template seed has Close → label map beside Progress / phase-status maps. A2.2 tracker-phases Create step 5 + Update step 2 + Apply Close labels section: add mapped Close label, remove the other. A2.3 placeholder / missing map → warn once, skip label write, body Close still written. Documenting changes: `README.md` Linear tip, `spec_docs/README.md` Work items bullet, `skills/spec/templates/spec-docs-readme.md` seed.
- Deviations: —
- Follow-ups: see phase 1 Follow-ups (fill-conventions Close map interview)
- Blocked:
