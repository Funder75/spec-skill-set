# Reduce spec bloat — implementation plan

Phases for [reduce-spec-bloat.spec.md](./reduce-spec-bloat.spec.md).

**Status values:** `Not started` · `Started` · `Reviewing` · `Done` · `Deferred` · `Blocked`

## Progress overview

| Phase | Status | Name | Tier | Depends on | Combinable with |
| ----- | ---- | ------ | ---- | ---------- | --------------- |
| **1** | Done | Explore and skip-folder | Medium | — | — |
| **2** | Done | Lite skim and one approval | Medium | — | 3 |
| **3** | Done | Tech sibling bar | Low | — | 2 |

## Phase 1 — Explore and skip-folder

**Tracker phase:** n/a

**Goal:** Authors can run `/spec explore` and leave create without a folder when the ask is below lite.

**Covers:** G1 (explore exit), R1 (explore route), R2 (explore read only), R3 (explore seeds create), R4 (below lite skip)

**Read first:**

- [reduce-spec-bloat.spec.md › R1 (explore route)](./reduce-spec-bloat.spec.md#r1-explore-route)
- [reduce-spec-bloat.spec.md › R2 (explore read only)](./reduce-spec-bloat.spec.md#r2-explore-read-only)
- [reduce-spec-bloat.spec.md › R3 (explore seeds create)](./reduce-spec-bloat.spec.md#r3-explore-seeds-create)
- [reduce-spec-bloat.spec.md › R4 (below lite skip)](./reduce-spec-bloat.spec.md#r4-below-lite-skip)
- [reduce-spec-bloat.spec.md › Explore workflow](./reduce-spec-bloat.spec.md#explore-workflow)

**Tier:** Medium — new stage plus create-spec handoff; wording mistakes only show when someone runs explore

**Not in this phase:** Lite omit rules, one-approval Stop, tech sibling bar, README lite-skim tips

**Deliverables:**

- `skills/spec/stages/explore.md` — new, because: explore is its own read-only stage file (R1 (explore route))
- `skills/spec/SKILL.md` — extend: Infer table row, Help, and stage-detection notes for explore
- `skills/spec/stages/create-spec.md` — extend: Depth round offers no folder; Investigate / Analysis accept explore seeds
- `spec_docs/todos.md` — extend: remove the loose explore write-up absorbed by G1 (explore exit)

**Approach** (advisory):

1. Copy the shape of `skills/spec/stages/audit.md` (read-only, stop without writes). Encode R2 (explore read only): restate ask, optional 2–3 approaches, exactly one outcome triad, no `spec_docs/` writes, same untrusted-content rule as create Investigate.
2. Add an Infer-table row in `skills/spec/SKILL.md` for `/spec explore` and clear equivalents → `stages/explore.md`. Name explore in Help. Do not invent a second Depth.
3. In `skills/spec/stages/create-spec.md` › Depth round: when heuristics prefer lite, also offer **no folder** and say the ask may not need `spec_docs/` (R4 (below lite skip)). User may still insist on a folder.
4. Document the seed handoff: when explore ends with a folder outcome, create-spec Investigate / Analysis reuse those findings (R3 (explore seeds create)) instead of starting blank.
5. Remove the absorbed explore rough-shape block from `spec_docs/todos.md`.

### Acceptance scenarios

- **A1.1 — Explore routes and stays read-only**
  - Journey: —
  - Given the Spec skill is loaded and the user says `/spec explore` with an ask
  - When the agent runs the explore stage
  - Then it opens `stages/explore.md`, ends with exactly one of the three outcomes, and creates or edits nothing under `spec_docs/`

- **A1.2 — Below-lite Depth round offers no folder**
  - Journey: —
  - Given create-spec Depth round and heuristics prefer lite
  - When the agent presents the Depth choice
  - Then it also offers **no folder** and says the ask may not need a `spec_docs/` folder; the user may still pick a Depth and continue

- **A1.3 — Folder outcome seeds create**
  - Journey: —
  - Given explore ended with "spec at Depth X and slug Y" and the user continues to create
  - When create-spec runs Investigate and Analysis
  - Then it reuses the explore findings instead of re-deriving them from scratch

### Done when

- [x] Verify tiers Low/Medium are n/a (no command in Project conventions)
- [x] A1.1–A1.3 pass
- [x] Existing create / promote / implement routes in `SKILL.md` still resolve to the same stage files

### Close-out

- Verified: Project conventions › Verify tiers Low/Medium are `n/a` (no command). Manual checklist: A1.1 — Infer routes `/spec explore` → `stages/explore.md`; stage is read-only (no `spec_docs/` writes; untrusted-content same as Investigate); exactly one outcome triad. A1.2 — Depth round when heuristics prefer lite also offers **no folder** and says the ask may not need `spec_docs/`. A1.3 — Investigate / Analysis reuse explore seeds on folder outcome. Existing Infer rows for create / promote-to-tech / promote-to-plan / implement still point at `create-spec.md`, `tech-specs.md`, `plan.md`, `implement.md`.
- Deviations: none
- Follow-ups: none for this phase (README explore pointers remain phase 3 / R11)

## Phase 2 — Lite skim and one approval

**Tracker phase:** n/a

**Goal:** Lite create emits a short human skim and one approval, then implement, while still writing the thin plan file.

**Covers:** G2 (lite skim), G3 (one approval), R5 (lite omit empty), R6 (lite constraints), R7 (lite skim path), R8 (one lite approval), D1 (plan stays)

**Read first:**

- [reduce-spec-bloat.spec.md › R5 (lite omit empty)](./reduce-spec-bloat.spec.md#r5-lite-omit-empty)
- [reduce-spec-bloat.spec.md › R6 (lite constraints)](./reduce-spec-bloat.spec.md#r6-lite-constraints)
- [reduce-spec-bloat.spec.md › R7 (lite skim path)](./reduce-spec-bloat.spec.md#r7-lite-skim-path)
- [reduce-spec-bloat.spec.md › R8 (one lite approval)](./reduce-spec-bloat.spec.md#r8-one-lite-approval)
- [reduce-spec-bloat.spec.md › Lite create stop](./reduce-spec-bloat.spec.md#lite-create-stop)

**Tier:** Medium — several Stop / Write rules with the R8 (one lite approval) exception path

**Not in this phase:** Explore stage, Depth no-folder offer, tech sibling emit bar

**Deliverables:**

- `skills/spec/stages/create-spec.md` — extend: Write omit/Constraints rules for lite; Chat design approval and Stop match R8 (one lite approval)
- `skills/spec/templates/spec.md` — extend: author guidance for lite omit and Constraints (no `n/a` padding)

**Approach** (advisory):

1. In `create-spec.md` › Write, replace the lite path that keeps every Constraints row with `n/a`. For Depth lite: omit empty optional sections listed in R5 (lite omit empty); Constraints list only lines that apply (R6 (lite constraints)). Do not invent filler for omitted sections.
2. Keep doc index and other agent scaffolding the skill requires. Binding behaviour stays in the spec or as a **Q** item (R7 (lite skim path)).
3. Chat design approval for lite: one packet approval covers design and readiness to write both `<slug>.spec.md` and the thin plan (already partly true — align Stop with R8).
4. Rewrite **Stop** › Depth lite: after both files exist, when the plan is a single Low (or clearly Low) phase with **Close** `automated`, next offer is implement — do not ask humans to re-read the plan as a second design gate. If multi-phase, Tier above Low, or **Close** `human`, still present the plan once before implement.
5. Update `templates/spec.md` HTML author comments so lite authors see the omit and Constraints rules. Strip nothing that standard/full still need.

Do:

- Thin plan file still written (D1 (plan stays)).

Do not:

- Embed the plan in `<slug>.spec.md`.
- Drop **Close** / **Gates** from the thin plan template path.

### Acceptance scenarios

- **A2.1 — Lite omits empty sections and Constraints padding**
  - Journey: —
  - Given Depth is lite and Notes, Glossary, and similar optionals have nothing to say
  - When create-spec writes `<slug>.spec.md`
  - Then those empty sections are absent, Constraints has no `n/a` padding rows, and create did not invent filler prose for them

- **A2.2 — One approval then implement for simple lite**
  - Journey: —
  - Given one chat approval already covered the lite packet, and the thin plan is a single Low phase with **Close** `automated`
  - When create finishes writing both files
  - Then the next offer is implement, and the agent does not require a separate human "review the plan" gate

- **A2.3 — Harder lite plan still reviewed once**
  - Journey: —
  - Given a lite thin plan that is multi-phase, above Low, or **Close** `human`
  - When create finishes
  - Then the plan is presented for review once before implement

### Done when

- [x] Verify tiers Medium is n/a (no command in Project conventions)
- [x] A2.1–A2.3 pass
- [x] Standard and full create Stop / Write paths still require design review before promote

### Close-out

- Verified: Project conventions › Verify tiers Medium is `n/a`. Manual checklist: A2.1 — create-spec Write lite omits empty optionals (R5) and Constraints lists only applying lines with no `n/a` padding (R6); template author comments match. A2.2 — Chat design approval one packet; Stop simple lite (single Low + Close automated) next offer is implement without a second plan-review gate (R8). A2.3 — harder lite (multi-phase / above Low / Close human) presents the plan once before implement. Standard/full Stop still asks design review before promote; thin plan still written (D1).
- Deviations: none
- Follow-ups: none

## Phase 3 — Tech sibling bar

**Tracker phase:** n/a

**Goal:** Promote emits tech siblings only when the sibling bar is met; restatement folds back; humans see explore and lite skim in the READMEs.

**Covers:** G4 (tech bar), R9 (sibling emit bar), R10 (restatement defect), R11 (docs pointers)

**Read first:**

- [reduce-spec-bloat.spec.md › R9 (sibling emit bar)](./reduce-spec-bloat.spec.md#r9-sibling-emit-bar)
- [reduce-spec-bloat.spec.md › R10 (restatement defect)](./reduce-spec-bloat.spec.md#r10-restatement-defect)
- [reduce-spec-bloat.spec.md › R11 (docs pointers)](./reduce-spec-bloat.spec.md#r11-docs-pointers)

**Tier:** Low — bar text is already decided; apply it to existing promote wording

**Not in this phase:** Explore stage behaviour, lite create Stop / omit rules

**Deliverables:**

- `skills/spec/stages/tech-specs.md` — extend: hard emit bar (R9 (sibling emit bar)); restatement is a fold-back defect (R10 (restatement defect))
- `README.md` — extend: name explore and the lite skim / one-approval path
- `spec_docs/README.md` — extend: Depth / how-to notes for explore and lite skim; must not contradict the stages

**Approach** (advisory):

1. In `tech-specs.md` › What to write / Standard fold (and full sibling path): emit `<slug>.logic.md`, `<slug>.contracts.md`, or `<slug>.ui.md` only when the default bar in R9 (sibling emit bar) is met, unless Project conventions override. Otherwise fold or `not needed`.
2. Keep `Created because:` on each emitted sibling, naming the bar it met.
3. Treat a sibling that mostly restates goals, journeys, or non-goals as a defect: fold back (R10 (restatement defect)).
4. Add short pointers in `README.md` and `spec_docs/README.md` for explore and lite skim / one approval (R11 (docs pointers)). Point at the skill stages; do not invent a second process.

### Acceptance scenarios

- **A3.1 — Sibling omitted when bar not met**
  - Journey: —
  - Given a promote where logic has fewer than about three rules, no multi-step workflow, and no non-obvious transitions
  - When tech-specs runs
  - Then it does not emit `<slug>.logic.md`; the concern is folded or `not needed`

- **A3.2 — Restatement folds back**
  - Journey: —
  - Given a draft sibling body that mostly repeats goals, journeys, or non-goals
  - When the agent applies the promote rules
  - Then that sibling is folded back or dropped, not left as a file

- **A3.3 — READMEs name the shorter path**
  - Journey: —
  - Given `README.md` and `spec_docs/README.md` after this phase
  - When a human skims them for how to run small work
  - Then both name explore and the lite skim / one-approval path without contradicting the skill stages

### Done when

- [x] Verify tiers Low is n/a (no command in Project conventions)
- [x] A3.1–A3.3 pass
- [x] Full Depth can still emit siblings when the bar is met, with `Created because:`

### Close-out

- Verified: Project conventions › Verify tiers Low is `n/a`. Manual checklist: A3.1 — tech-specs Sibling emit bar requires ~3+ rules / multi-step / non-obvious transitions for logic; otherwise fold or `not needed`. A3.2 — restatement of goals/journeys/non-goals is a fold-back defect (R10). A3.3 — README and `spec_docs/README.md` name explore and the lite skim / one-approval path without a second process. Full Depth still emits when the bar is met; `Created because:` must name the bar (R9).
- Deviations: none
- Follow-ups: none
