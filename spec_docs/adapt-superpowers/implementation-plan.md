# Adapt Superpowers — implementation plan

Phases for [spec.md](./spec.md).

**Status values:** `Not started` · `Started` · `Reviewing` · `Done` · `Deferred` · `Blocked`

## Progress overview

| Phase | Status | Name | Tier | Depends on | Combinable with |
| ----- | ------ | ---- | ---- | ---------- | --------------- |
| **1** | Not started | Create-spec chat gate | High | — | — |
| **2** | Not started | UI depth at design | Medium | 1 | 3 |
| **3** | Not started | Plan contracts and bounds | Medium | — | 2 |

## Phase 1 — Create-spec chat gate

**Goal:** Create-spec finishes dialogue and chat approval before writing `spec.md`, then self-reviews before the file-review ask.

**Covers:** G1 (chat dialogue), G2 (chat approval), G3 (self review), R1 (one question), R2 (approach round), R3 (sectional approval), R4 (assumptions path), R5 (self review)

**Read first:**

- [business-logic.md › R1 (one question)](./business-logic.md#r1-one-question)
- [business-logic.md › R2 (approach round)](./business-logic.md#r2-approach-round)
- [business-logic.md › R3 (sectional approval)](./business-logic.md#r3-sectional-approval)
- [business-logic.md › R4 (assumptions path)](./business-logic.md#r4-assumptions-path)
- [business-logic.md › R5 (self review)](./business-logic.md#r5-self-review)
- [business-logic.md › Create-spec chat gate](./business-logic.md#create-spec-chat-gate)
- [business-logic.md › States and transitions](./business-logic.md#states-and-transitions)

**Tier:** High — multi-step chat-gate ordering with skip and assumptions paths; weak feedback until a live create session

**Not in this phase:** UI-primary screen depth (phase 2); plan Approach rules (phase 3); SCM bounds beyond a one-line pointer if create-spec already needs it

**Deliverables:**

- `skills/spec/stages/create-spec.md` — extend: insert Approach round and Chat design approval between Clarify and Write; hold file write until approval or assumptions path; add self-review checklist before the Stop review ask
- `skills/spec/stages/create-spec.md` — extend: keep must-ask topics and skip-answered rules; record assumptions as Open questions or Decisions when the user proceeds early

**Approach** (advisory):

1. In `skills/spec/stages/create-spec.md`, keep Investigate → Analysis → Clarify as today.
2. After Clarify, add **Approach round**: real fork → two or three options plus recommendation; no fork → skip (see D3 (skip empty approaches)).
3. Add **Chat design approval**: short sections scaled to complexity; ask after sections; do not open Write until approved or R4 (assumptions path).
4. **Do:** state the gate in MUST / MUST NOT lines the agent can follow.
5. **Do not:** write a pasteable full `spec.md` body inside the stage file.
6. Under Stop, run the R5 (self review) checklist, fix cheap failures, then ask for file review.

### Acceptance scenarios

- **A1.1 — One question at a time**
  - Journey: Create a design with dialogue, step 2
  - Given create-spec has finished Investigate and Analysis, and a must-ask answer is still missing
  - When the agent continues the create action
  - Then it asks exactly one clarifying question and does not create `spec.md` in that turn

- **A1.2 — Approach round when there is a fork**
  - Journey: Create a design with dialogue, step 3
  - Given clarifications are complete and the feature has a real design fork
  - When the agent continues before writing the file
  - Then it proposes two or three approaches with trade-offs and a recommendation

- **A1.3 — Skip empty approaches**
  - Journey: Create a design with dialogue, step 3 (skip path)
  - Given clarifications are complete and there is no meaningful fork
  - When the agent continues before writing the file
  - Then it skips the approach round and does not invent fake options

- **A1.4 — Chat approval before the file**
  - Journey: Create a design with dialogue, step 4
  - Given approaches are done or skipped
  - When the agent presents the design
  - Then it uses short chat sections, asks for approval, and does not write `spec.md` until the user approves (or takes the assumptions path)

- **A1.5 — Assumptions path**
  - Journey: Create a design with dialogue, goes-wrong path (proceed with assumptions)
  - Given the user says to proceed with assumptions before every question is answered
  - When the agent writes `spec.md`
  - Then unsettled items are recorded as Open questions or Decisions, and only then does the file exist

- **A1.6 — Self-review before file-review ask**
  - Journey: Create a design with dialogue, steps 5–6
  - Given `spec.md` was just written
  - When the agent is about to ask for file review
  - Then it has checked placeholders, contradictions, scope leaks into non-goals, and bare ID citations, and fixed cheap failures or named them in the ask

### Done when

- [ ] Tier verify passes (High row in Project conventions)
- [ ] A1.1–A1.6 pass
- [ ] Clarify still skips answers already in the input or chat
- [ ] Progress gates and slug rules in create-spec are unchanged

### Close-out

- Verified:
- Deviations:
- Follow-ups:

## Phase 2 — UI depth at design

**Goal:** UI-primary designs carry screen depth in `spec.md` at create time; props stay deferred to `ui.md`.

**Covers:** G4 (ui depth), R6 (ui depth)

**Read first:**

- [business-logic.md › R6 (ui depth)](./business-logic.md#r6-ui-depth)
- [spec.md › D8 (ui trigger)](./spec.md#d8-ui-trigger)

**Tier:** Medium — local design choices for template prompts and create-spec Write rules within a known stage pattern

**Not in this phase:** Chat-gate ordering (phase 1); plan Approach (phase 3)

**Deliverables:**

- `skills/spec/stages/create-spec.md` — extend: Write spec.md requires layout regions, main interactions, empty and error states, and glance versus control when both exist, for UI-primary features; forbid component props in the design file
- `skills/spec/templates/spec.md` — extend: optional UI-primary prompts under User journeys (or a short adjacent include block) so authors see what screen depth means

**Approach** (advisory):

1. Add a short detector sentence in create-spec matching D8 (ui trigger): UI-primary when any goal needs a user-visible change, including copy-only.
2. In Write spec.md, add a MUST list for UI-primary screen depth matching R6 (ui depth).
3. In `skills/spec/templates/spec.md`, add author prompts (HTML comments or short stub bullets) for layout, interactions, and empty/error — not component props.
4. **Do:** keep non-UI journeys as `n/a` with a reason.
5. **Do not:** paste wireframes or prop tables into the design template.

### Acceptance scenarios

- **A2.1 — Screen depth in the design**
  - Journey: Create a UI-primary design, step 2
  - Given the feature is UI-primary per D8 (ui trigger)
  - When create-spec writes `spec.md`
  - Then the design covers layout regions, main interactions, and empty or error states (and glance versus control when both exist)

- **A2.2 — Props stay out of the design**
  - Journey: Create a UI-primary design, step 3
  - Given a UI-primary create has finished chat approval
  - When the agent writes `spec.md`
  - Then component props and wireframes are absent from that file

- **A2.3 — Non-UI journeys unchanged**
  - Journey: —
  - Given the feature is not UI-primary
  - When create-spec writes journeys
  - Then journeys may remain `n/a` with a reason, as today

### Done when

- [ ] Tier verify passes (Medium row in Project conventions)
- [ ] A2.1–A2.3 pass
- [ ] create-spec states the D8 (ui trigger) detector
- [ ] Phase 1 chat-gate behaviour still holds

### Close-out

- Verified:
- Deviations:
- Follow-ups:

## Phase 3 — Plan contracts and bounds

**Goal:** Plan Approach guides with examples and forbids pasteable full code; stages state no surprise SCM and no new peer skills.

**Covers:** G5 (plan contracts), G6 (no scm), G7 (one skill), R7 (plan guiding), R8 (no pasteables), R9 (no scm), R10 (one skill)

**Read first:**

- [business-logic.md › R7 (plan guiding)](./business-logic.md#r7-plan-guiding)
- [business-logic.md › R8 (no pasteables)](./business-logic.md#r8-no-pasteables)
- [business-logic.md › R9 (no scm)](./business-logic.md#r9-no-scm)
- [business-logic.md › R10 (one skill)](./business-logic.md#r10-one-skill)
- [business-logic.md › Promote plan as guided contract](./business-logic.md#promote-plan-as-guided-contract)

**Tier:** Medium — composing Approach and bound rules across stage files with judgmental pasteable-vs-guiding examples

**Not in this phase:** Create-spec dialogue or UI depth; packaging or session hooks

**Deliverables:**

- `skills/spec/stages/plan.md` — extend: Approach must include guiding code, do/do-not examples, and code-design notes when shape would otherwise be ambiguous; forbid pasteable full implementations; keep phase size outcome-based; TDD only if Project conventions require it
- `skills/spec/design-quality.md` — extend: Ready to implement / Bad vs good examples for guided Approach vs pasteable full code
- `skills/spec/SKILL.md` — extend: state no branches, worktrees, or commits unless the user asks; adaptations stay in this skill tree; no auto-invoke of a separate implementation pipeline after design approval
- `skills/spec/stages/implement.md` — extend: restate no SCM unless asked (branches and worktrees, not only commit / push / PR)
- `skills/spec/stages/create-spec.md` — extend: brief no-SCM line if missing after phase 1
- `skills/spec/stages/plan.md` — extend: brief no-SCM line for the promote action
- `README.md` — extend: note that adapt-superpowers dialogue and plan-contract behaviour is in the skill (replace the “reserved / not yet” line)

**Approach** (advisory):

1. In plan.md **What to write**, redefine Approach: paths and order plus guiding snippets when ambiguous.
2. Add an explicit MUST NOT for pasteable full file bodies in Approach.
3. In design-quality.md, add one Bad vs good pair: paths-only vs guiding; pasteable full module vs short signature sketch.
4. In SKILL.md and implement.md, mirror D6 (no scm) and D1 (one skill) / D7 (no hooks) in short binding lines.
5. **Do:** keep Approach advisory and Done when binding.
6. **Do not:** require TDD or micro-step phases as the skill default.

### Acceptance scenarios

- **A3.1 — Guided Approach on promote**
  - Journey: Promote to an implementation plan, step 2
  - Given tech docs are reviewed and the user asks for a plan
  - When the agent writes `implementation-plan.md`
  - Then Approach cites paths and order, and where shape would be ambiguous it includes guiding snippets or do/do-not examples

- **A3.2 — No pasteable full implementations**
  - Journey: Promote to an implementation plan, step 3
  - Given the agent is filling Approach
  - When the plan is complete
  - Then Approach has no full implementation blocks meant to be pasted into the repo without further design

- **A3.3 — Outcome-sized phases**
  - Journey: Promote to an implementation plan, goes-wrong path (micro-steps)
  - Given the agent is splitting work
  - When phases are written
  - Then the default unit is outcome-sized phases, not 2–5 minute micro-steps

- **A3.4 — No surprise SCM**
  - Journey: Implement without surprise SCM, step 2
  - Given the user asked to implement a phase and did not ask for git writes
  - When the agent finishes the phase
  - Then it has not created a branch, worktree, or commit

- **A3.5 — Still one skill**
  - Journey: Implement without surprise SCM, step 1 (bounds)
  - Given adaptations from this spec are applied
  - When the skill tree is inspected
  - Then no new peer skills for brainstorming, planning, or TDD were added for this design

### Done when

- [ ] Tier verify passes (Medium row in Project conventions)
- [ ] A3.1–A3.5 pass
- [ ] Existing implement “Ask before commit / push / PR” still holds and now covers branches and worktrees
- [ ] README no longer says adapt-superpowers behaviour is only reserved / not in the repo

### Close-out

- Verified:
- Deviations:
- Follow-ups:

## Risks

- **UI breadth from D8 (ui trigger).** Copy-only goals still trigger screen-depth MUSTS. Mitigation: scale layout detail to the change; still name empty or error states when they apply.
