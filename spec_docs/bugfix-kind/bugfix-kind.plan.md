# Bugfix kind — implementation plan

Phases for [bugfix-kind.spec.md](./bugfix-kind.spec.md).

**Status values:** `Not started` · `Started` · `Reviewing` · `Done` · `Deferred` · `Blocked`

## Progress overview

| Phase | Status | Name | Tier | Close | Depends on | Combinable with |
| ----- | ---- | ------ | ---- | ----- | ---------- | --------------- |
| **1** | Not started | Kind and create shape | Medium | human | — | — |
| **2** | Not started | Plan and audit evidence | Medium | human | 1 | — |

## Phase 1 — Kind and create shape

**Tracker phase:** n/a

**Goal:** New specs carry Kind; create can set bugfix explicitly or via one recommend ask; bugfix Write uses behaviour lists and Root cause instead of journeys and Work split.

**Covers:** G1 (kind line), G2 (bugfix shape), R1 (kind body line), R2 (explicit kind flag), R3 (infer confirm), R4 (feature default), R5 (bugfix design shape), D5 (bug heuristic)

**Read first:**

- [bugfix-kind.spec.md › R1 (kind body line)](./bugfix-kind.spec.md#r1-kind-body-line)
- [bugfix-kind.spec.md › R2 (explicit kind flag)](./bugfix-kind.spec.md#r2-explicit-kind-flag)
- [bugfix-kind.spec.md › R3 (infer confirm)](./bugfix-kind.spec.md#r3-infer-confirm)
- [bugfix-kind.spec.md › R4 (feature default)](./bugfix-kind.spec.md#r4-feature-default)
- [bugfix-kind.spec.md › R5 (bugfix design shape)](./bugfix-kind.spec.md#r5-bugfix-design-shape)
- [bugfix-kind.spec.md › Kind resolution (create)](./bugfix-kind.spec.md#kind-resolution-create)
- [bugfix-kind.spec.md › Kind body line](./bugfix-kind.spec.md#kind-body-line)
- [bugfix-kind.spec.md › Bugfix design sections](./bugfix-kind.spec.md#bugfix-design-sections)
- [bugfix-kind.spec.md › Help / invoke docs](./bugfix-kind.spec.md#help--invoke-docs)
- [bugfix-kind.spec.md › D5 (bug heuristic)](./bugfix-kind.spec.md#d5-bug-heuristic)

**Tier:** Medium — Kind resolution and Write branch across several rules; mistakes only show when someone runs create

**Close:** human

**Not in this phase:** Plan Trace / regression Close-out, implement Close-out evidence, audit and design-quality Kind branch

**Deliverables:**

- `skills/spec/SKILL.md` — extend: document Kind next to Progress / Depth; Infer create row accepts `as bugfix` / `as feature` (alone or with a Depth)
- `skills/spec/stages/create-spec.md` — extend: Kind resolution (explicit, D5 (bug heuristic) recommend, feature default); Write branches on Kind for journeys / Work split vs behaviour lists and Root cause; lite thin-plan path still writes Kind
- `skills/spec/templates/spec.md` — extend: Kind body line; conditional author guidance for bugfix sections vs journeys / Work split
- `skills/spec/templates/spec-docs-readme.md` — extend: mention Kind and `create … as bugfix`; note lite is recommended for many bugs, not required
- `spec_docs/README.md` — extend: Kind note in the how-to / body-line docs (same session if that surface is already open)

**Approach** (advisory):

1. In `skills/spec/SKILL.md`, add Kind beside Progress / Depth docs. Extend the create Infer row so `as bugfix` and `as feature` parse like Depth flags. Help text SHOULD recommend lite for many bugs (D4 (any depth)), not require it.
2. In `create-spec.md`, settle Kind before or with Depth round: explicit flag skips the recommend ask; unset + D5 (bug heuristic) cues → one recommend; else default `feature` (R2–R4). Do not rewrite older folders only to add Kind (R1 (kind body line)).
3. In Write and `templates/spec.md`, emit `Kind: feature | bugfix` on every new `<slug>.spec.md`. For bugfix: omit **User journeys** and **Work split**; emit the three behaviour lists and **Root cause** under Problem (R5 (bugfix design shape)). Feature (and missing Kind on older folders) keeps today's journeys and Work split.
4. Update `templates/spec-docs-readme.md` (and `spec_docs/README.md` when touching conventions docs) per Help / invoke docs.

Do:

- Cite only Investigate-opened modules in Root cause guidance.

Do not:

- Auto-migrate older folders to add Kind.
- Add mandatory behaviour lists to feature create.
- Touch plan.md, implement.md, analysis-checklist, or design-quality yet.

### Acceptance scenarios

- **A1.1 — Explicit bugfix create uses the bugfix shape**
  - Journey: Explicit bugfix create, steps 1–3
  - Check: human
  - Given the author says `create … as bugfix` (optionally with a Depth)
  - When create finishes Write
  - Then Kind is `bugfix`, the recommend ask did not run, and the packet has the three behaviour lists and Root cause with no User journeys or Work split

- **A1.2 — Infer recommend uses keyword cues once**
  - Journey: Infer bugfix, steps 1–2
  - Check: human
  - Given Kind is unset and the input has a D5 (bug heuristic) cue such as bug, fix, regression, broken, fails when, or stack trace
  - When create runs Kind resolution
  - Then it recommends `Kind: bugfix` once and waits; decline leaves Kind as `feature`

- **A1.3 — Feature create stays on the feature path**
  - Journey: Feature create unchanged, steps 1–2
  - Check: human
  - Given ordinary feature input with no D5 (bug heuristic) cues and no Kind flag
  - When create finishes Write
  - Then Kind is `feature` with no Kind round, and User journeys plus Work split remain as today

### Done when

- [ ] Verify tiers Medium is n/a (no command in Project conventions)
- [ ] A1.1–A1.3 pass
- [ ] Older folders without Kind still treated as feature; create does not mass-rewrite them
- [ ] Depth round and Progress gates behave as before for feature work

### Gates

| Check | Owner | Evidence |
| ----- | ----- | -------- |
| Verify (n/a) | automated | Close-out notes n/a |
| A1.1–A1.3 | human | Close-out checklist |
| Older folders / feature regression | human | Close-out note |

**Ask-before:** —

### Close-out

- Verified:
- Deviations:
- Follow-ups:
- Blocked:

## Phase 2 — Plan and audit evidence

**Tracker phase:** n/a

**Goal:** Bugfix plans map scenarios 1:1 to behaviour-list items, mark a regression scenario, require red-before-green in Close-out, and audit / design-quality stop failing bugfix folders for missing journeys or Work split.

**Covers:** G3 (plan evidence), R6 (plan list trace), R7 (red before green), R8 (audit kind branch)

**Read first:**

- [bugfix-kind.spec.md › R6 (plan list trace)](./bugfix-kind.spec.md#r6-plan-list-trace)
- [bugfix-kind.spec.md › R7 (red before green)](./bugfix-kind.spec.md#r7-red-before-green)
- [bugfix-kind.spec.md › R8 (audit kind branch)](./bugfix-kind.spec.md#r8-audit-kind-branch)
- [bugfix-kind.spec.md › Scenario Trace and Close-out](./bugfix-kind.spec.md#scenario-trace-and-close-out)

**Tier:** Medium — Kind branch in plan, implement, and audit helpers; weak feedback until someone promotes a bugfix folder

**Close:** human

**Not in this phase:** Kind body line, create infer/Write shape, template Kind header (phase 1)

**Deliverables:**

- `skills/spec/stages/plan.md` — extend: bugfix scenario Trace maps to behaviour lists; note regression mark; red-before-green Close-out requirement; lite thin-plan path follows the same Trace rules
- `skills/spec/templates/implementation-plan.md` — extend: Trace field guidance for bugfix; Regression mark; Close-out evidence shape for the regression scenario
- `skills/spec/stages/implement.md` — extend: Reviewing / Done Close-out must record red-before-green for the regression scenario
- `skills/spec/stages/create-spec.md` — extend: lite thin-plan Write uses list Trace when Kind is bugfix (if not already covered in phase 1)
- `skills/spec/analysis-checklist.md` — extend: for explicit `Kind: bugfix`, check behaviour lists and red-before-green instead of journey / Work split defects; missing Kind keeps today's checks
- `skills/spec/design-quality.md` — extend: Journey trace / Ready checklist accepts behaviour-list Trace for bugfix

**Approach** (advisory):

1. In `plan.md` and `templates/implementation-plan.md`, for bugfix folders require 1:1 Trace to a behaviour-list item (R6 (plan list trace)). Keep journey Trace for feature / missing Kind. Require at least one scenario marked Regression.
2. Document Close-out evidence shape: red failed without the fix; green passed with it (R7 (red before green)). Evidence may be a command, manual repro, or equivalent. Do not force TDD for every phase.
3. In `implement.md`, when Reviewing/Done and a regression scenario exists, refuse green-only Close-out for that scenario.
4. Branch `analysis-checklist.md` Journeys, Journey trace, and Work split vs phases for explicit bugfix Kind (R8 (audit kind branch)). Update `design-quality.md` Journey trace the same way.

Do:

- Missing Kind → keep feature journey / Work split audit rules.

Do not:

- Introduce a verdict enum.
- Change Linear write-back doctrine.

### Acceptance scenarios

- **A2.1 — Bugfix plan scenarios map to behaviour lists**
  - Journey: Bugfix plan and close-out, step 1
  - Check: human
  - Given a folder with `Kind: bugfix` ready for plan (or lite thin plan)
  - When the plan is written
  - Then each acceptance scenario Traces to one behaviour-list item, and at least one scenario is marked Regression

- **A2.2 — Regression Close-out needs red-before-green**
  - Journey: Bugfix plan and close-out, steps 2–3
  - Check: human
  - Given a bugfix phase reaches Reviewing or Done with a regression scenario
  - When Close-out is filled
  - Then it records that the check failed without the fix and passed with it (command, manual repro, or equivalent)

- **A2.3 — Audit does not fail bugfix for missing journeys**
  - Journey: —
  - Check: human
  - Given a folder with explicit `Kind: bugfix` and the three behaviour lists, and no User journeys or Work split
  - When audit / design-quality run
  - Then missing journeys or Work split are not defects; missing list Trace or missing red-before-green on a Done regression scenario are

### Done when

- [ ] Verify tiers Medium is n/a (no command in Project conventions)
- [ ] A2.1–A2.3 pass
- [ ] Feature / missing-Kind plan and audit paths still require journey Trace and Work split checks as today
- [ ] Global TDD policy unchanged except the single regression Close-out rule

### Gates

| Check | Owner | Evidence |
| ----- | ----- | -------- |
| Verify (n/a) | automated | Close-out notes n/a |
| A2.1–A2.3 | human | Close-out checklist |
| Feature / missing-Kind regression | human | Close-out note |

**Ask-before:** —

### Close-out

- Verified:
- Deviations:
- Follow-ups:
- Blocked:

## Risks

- **Infer false positives.** D5 (bug heuristic) is narrow, but "fix" can appear in feature asks. Mitigation: one-shot recommend with decline → feature (R3 (infer confirm)).
