# Serial subagent implement — implementation plan

Phases for [spec.md](./spec.md).

**Status values:** `Not started` · `Started` · `Reviewing` · `Done` · `Deferred` · `Blocked`

## Progress overview

| Phase | Status | Name | Tier | Depends on | Combinable with |
| ----- | ------ | ---- | ---- | ---------- | --------------- |
| **1** | Done | Policy and parent path | High | — | — |
| **2** | Done | Phase brief and cloud checklist | Medium | 1 | 3 |
| **3** | Done | Review gate and write-back | High | 2 | 2 |

## Phase 1 — Policy and parent path

**Goal:** Multi-phase implement may use serial SDD; one-phase stays in the parent; parallel and surprise SCM stay forbidden.

**Covers:** G1 (serial implementers), G6 (scm consent), R1 (serial default), R2 (one active unit), R3 (fresh context), R4 (parent path), R9 (scm consent), R10 (subagent policy)

**Read first:**

- [business-logic.md › R1 (serial default)](./business-logic.md#r1-serial-default)
- [business-logic.md › R2 (one active unit)](./business-logic.md#r2-one-active-unit)
- [business-logic.md › R3 (fresh context)](./business-logic.md#r3-fresh-context)
- [business-logic.md › R4 (parent path)](./business-logic.md#r4-parent-path)
- [business-logic.md › R9 (scm consent)](./business-logic.md#r9-scm-consent)
- [business-logic.md › R10 (subagent policy)](./business-logic.md#r10-subagent-policy)
- [business-logic.md › Actors and entry points](./business-logic.md#actors-and-entry-points)

**Tier:** High — implement-only subagent exception is a skill contract agents rely on; soft wording invites parallel or surprise SCM

**Not in this phase:** Phase brief field list (phase 2); review gate, fix loop, or Done-timing rules (phase 3)

**Deliverables:**

- `skills/spec/SKILL.md` — extend: replace blanket "Do not spawn subagents" with an implement-only serial SDD exception; keep other stages forbidden; keep Bounds no-surprise-SCM
- `skills/spec/stages/implement.md` — extend: when more than one dispatch unit remains, default to serial SDD; one-phase / single combinable unit stays in the parent; restate one active unit and Depends on; name cloud / implementation branch / worktree as distinct Ask-before items

**Approach** (advisory):

1. In `skills/spec/SKILL.md`, replace the blanket ban with R10 (subagent policy): serial implement subagents only; create / promote / audit stay forbidden.
2. Point implement at the new Serial SDD section in `stages/implement.md`; do not invent peer skills.
3. In `stages/implement.md`, add a short Serial SDD / Phase selection block: multi-unit → serial fresh implementer; single unit → parent path; parallel MUST NOT.
4. Under Ask before / Bounds, spell out G6 (scm consent): chat consent; branch ≠ worktree; cloud implied only when already in cloud; default shared checkout.
5. Leave Phase brief and Review gate headings as stubs or "see later phase" only if needed so phase 2–3 have a clear insert point — do not fill their binding rules yet.

### Acceptance scenarios

- **A1.1 — Multi-phase uses serial SDD**
  - Journey: Multi-phase serial implement, step 2
  - Given a plan with more than one dispatch unit left and the user asks implement / continue
  - When the parent starts the next legal unit
  - Then it dispatches a fresh implementer for that unit and does not keep implementing the next unit in the same bloated parent session

- **A1.2 — Parallel rejected**
  - Journey: Multi-phase serial implement, goes-wrong (parallel)
  - Given serial SDD applies
  - When the user or agent asks for parallel implementers
  - Then the skill refuses; only one implementer may run

- **A1.3 — One-phase stays in parent**
  - Journey: One-phase or single combinable unit, steps 1–2
  - Given the plan is one phase or already one combinable unit
  - When the user asks implement
  - Then the parent implements in the current session (or one cloud paste) with no serial multi-agent ceremony

- **A1.4 — SCM ask is named**
  - Journey: Optional cloud phase with the same brief, goes-wrong (extra worktree)
  - Given default serial SDD on the shared checkout
  - When the user has not asked for a worktree (or asked only for cloud / branch)
  - Then the agent does not create a worktree; asking for branch does not imply worktree

- **A1.5 — Other stages still forbid subagents**
  - Journey: —
  - Given create, promote, or audit
  - When that stage runs
  - Then it MUST NOT spawn subagents under this exception

### Done when

- [x] Tier verify passes (High row in Project conventions)
- [x] A1.1–A1.5 pass
- [x] Bounds still forbid branch / worktree / commit unless the user asked in chat
- [x] Prefer-one-active-spec and progress-overview order gate wording remain intact

### Close-out

- Verified: Diff of `skills/spec/SKILL.md` and `stages/implement.md` against Done when; no `{{…}}` or author HTML in those files. `rg` for Serial SDD, parallel MUST NOT, spawn ban for create/promote/audit, branch≠worktree, Prefer one active, Depends on. High dry-read: Preconditions → Phase selection → Serial SDD → Session → Ask before cannot skip multi-unit dispatch or SCM ask. Scenarios: A1.1 multi→fresh dispatch; A1.2 parallel refused; A1.3 one-phase parent path; A1.4 worktree not implied by branch/cloud; A1.5 other stages still forbidden via SKILL line.
- Deviations: Skill text states behaviors without embedding G/R ID citations (IDs live in the plan/tech docs). Phase brief / Review gate left as a single stub sentence, not empty headings.
- Follow-ups: —

## Phase 2 — Phase brief and cloud checklist

**Goal:** Each dispatch unit gets a chat-only phase brief; cloud adds the env checklist; the worker need not read the full plan.

**Covers:** G2 (phase brief), G7 (cloud ready brief), R5 (phase brief)

**Read first:**

- [business-logic.md › R5 (phase brief)](./business-logic.md#r5-phase-brief)
- [contracts.md › Phase brief](./contracts.md#phase-brief)
- [contracts.md › Env checklist](./contracts.md#env-checklist)
- [contracts.md › Build phase brief](./contracts.md#build-phase-brief)
- [contracts.md › Select next unit](./contracts.md#select-next-unit)

**Tier:** Medium — field tables are specified; wiring into the stage flow and cloud companion still needs local judgment

**Not in this phase:** Required review subagent, fix loop, or parent Done marking (phase 3); SKILL policy rewrite (phase 1)

**Deliverables:**

- `skills/spec/stages/implement.md` — extend: Phase brief section with the binding fields from contracts; stop-after-this-unit required; no durable brief file; cloud companion env checklist when opted in or already in cloud
- `skills/spec/templates/implementation-plan.md` — extend only if needed: clarify that Goal, Read first, deliverables, Done when, tier, and Ask-before feed the brief (no new columns)

**Approach** (advisory):

1. Add **Phase brief** under Serial SDD in `stages/implement.md`: copy the required field list from contracts; state chat-only / paste (D7 (brief medium)).
2. Require **stop after this unit** so the worker does not start phase N+1.
3. Add **Env checklist** as required companion text for cloud; omit for local subagent unless useful.
4. Tell the parent to build the brief from the active phase packet and **Read first** only — not the whole plan.
5. Touch the plan template only if a one-line author hint prevents missing Ask-before or scoped paths.

### Acceptance scenarios

- **A2.1 — Brief has required fields**
  - Journey: Multi-phase serial implement, step 2
  - Given the parent is about to dispatch an implementer
  - When it builds the phase brief
  - Then the brief includes slug, phase id(s), unit name, goals (full G forms), Read first, deliverables, Done when, tier, Ask-before, scoped paths, and stop-after-this-unit

- **A2.2 — No durable brief file**
  - Journey: Multi-phase serial implement, step 2
  - Given a local serial dispatch
  - When the parent hands off the unit
  - Then the brief is chat-only (or paste text); no new file under the spec folder

- **A2.3 — Worker need not read the full plan**
  - Journey: Multi-phase serial implement, step 2
  - Given the brief and the linked Read first sections
  - When the implementer works the unit
  - Then the stage does not require reading unrelated phases or the whole plan

- **A2.4 — Cloud gets env checklist**
  - Journey: Optional cloud phase with the same brief, steps 1–2
  - Given the user opted into cloud or the run already is cloud
  - When the parent prepares the unit
  - Then it supplies the same phase brief plus the env checklist (verify runnable, secrets/MCP, repo hooks only, status write-back, stop after this unit)

### Done when

- [x] Tier verify passes (Medium row in Project conventions)
- [x] A2.1–A2.4 pass
- [x] Local path does not invent a project-level cloud opt-in in `spec_docs/README.md`

### Close-out

- Verified: Diffed deliverables against Done when and A2.1–A2.4. No leftover `{{…}}` or HTML author comments in the stage file. Ran `rg` for brief fields, stop-after-this-unit, chat-only / no durable file, Env checklist, and no README cloud opt-in. A2.1–A2.4 covered. Marked progress overview `Reviewing` (not `Done`) so the parent can review before phase 3 exists.
- Deviations: None from Approach. Added one template author hint that Goal, Read first, Deliverables, Done when, Tier, and Ask-before feed the brief.
- Follow-ups: Phase 3 owns Review gate, Stop and resume, and the worker→`Reviewing` (not `Done`) write-back rule in the stage.

## Phase 3 — Review gate and write-back

**Goal:** Worker marks `Reviewing` with Close-out; one review agent runs; parent marks `Done` or leaves human/`Blocked` gates; runner stop/resume matches the journeys.

**Covers:** G3 (review agent), G4 (stop resume), G5 (status writeback), R6 (worker writeback), R7 (required review), R8 (stop resume), D8 (review fail), D9 (done timing), D10 (fix budget)

**Read first:**

- [business-logic.md › R6 (worker writeback)](./business-logic.md#r6-worker-writeback)
- [business-logic.md › R7 (required review)](./business-logic.md#r7-required-review)
- [business-logic.md › R8 (stop resume)](./business-logic.md#r8-stop-resume)
- [business-logic.md › Multi-phase serial implement](./business-logic.md#multi-phase-serial-implement)
- [business-logic.md › Resume after human review](./business-logic.md#resume-after-human-review)
- [business-logic.md › States and transitions](./business-logic.md#states-and-transitions)
- [contracts.md › Review packet](./contracts.md#review-packet)
- [contracts.md › Run unit review](./contracts.md#run-unit-review)
- [spec.md › D8 (review fail)](./spec.md#d8-review-fail)
- [spec.md › D9 (done timing)](./spec.md#d9-done-timing)

**Tier:** High — parent/worker/reviewer status lifecycle, fix budget, and halt rules; mistakes pass a file diff until a live multi-phase run

**Not in this phase:** Policy exception wording (phase 1); brief field list (phase 2); dual-reviewer loop; Linear kickoff

**Deliverables:**

- `skills/spec/stages/implement.md` — extend: Session checklist and Phase status so the worker MUST update the plan to `Reviewing` (not `Done`); add Review gate (one review subagent, Review packet, pass/fail); add Stop and resume (auto-continue agent-closable; halt on human/`Blocked`/person Ask-before; same entry to resume)
- `skills/spec/design-quality.md` — extend only if needed: one-line note that multi-phase implement expects a brief-sized phase packet (Read first + Done when) for the orchestrator

**Approach** (advisory):

1. Update Session checklist / Phase status: worker → `Reviewing` + Close-out after verify; MUST NOT mark `Done`; report-only is incomplete.
2. Add **Review gate**: parent runs exactly one review subagent with the Review packet; dual-reviewer MUST NOT.
3. On fail: one autofix re-dispatch per D10 (fix budget); if still failing, `Blocked` with findings in Close-out / Follow-ups.
4. On pass + agent-closable: parent marks `Done` and continues to the next ready unit without asking "should I continue?"
5. On pass + human still required: leave `Reviewing` and halt. Person Ask-before also halts; no invented rulings.
6. Resume: same implement / continue entry; finish the open unit first, then next ready unit.

### Acceptance scenarios

- **A3.1 — Worker marks Reviewing, not Done**
  - Journey: Multi-phase serial implement, step 3
  - Given the implementer finished verify for the unit
  - When it updates the plan
  - Then status is `Reviewing`, Done-when checkboxes and Close-out are filled, and status is not `Done`

- **A3.2 — Required review before Done**
  - Journey: Multi-phase serial implement, step 4
  - Given the worker marked `Reviewing`
  - When the parent continues the unit
  - Then it runs exactly one review subagent before marking `Done` or escalating

- **A3.3 — Agent-closable auto-continues**
  - Journey: Multi-phase serial implement, step 5
  - Given review passed and the unit is agent-closable
  - When the parent closes the unit
  - Then it marks `Done` and starts the next ready unit without asking whether to continue

- **A3.4 — Human gate halts**
  - Journey: Multi-phase serial implement, step 6
  - Given review passed but human sign-off is still required
  - When the parent finishes the agent review
  - Then `Reviewing` stays, the runner halts, and the next unit does not start

- **A3.5 — Fix then Blocked**
  - Journey: Multi-phase serial implement, step 6 (review fail)
  - Given the review failed
  - When the fix budget from D10 (fix budget) is applied and findings remain
  - Then the parent re-dispatches once for fix, then marks `Blocked` with findings if still failing

- **A3.6 — Resume same unit**
  - Journey: Resume after human review, steps 1–3
  - Given a unit is `Reviewing` or person-blocked and the human has finished
  - When the user says implement / continue
  - Then the parent continues that same unit first, then picks the next ready unit

### Done when

- [x] Tier verify passes (High row in Project conventions)
- [x] A3.1–A3.6 pass
- [x] Phase status table still allows only one Started / Reviewing / Blocked unit
- [x] The old "leave next phase Not started until the user asks" line is replaced or scoped so agent-closable auto-continue is allowed under serial SDD

### Close-out

- Verified: High approach — status lifecycle must not Done-before-review, must auto-continue agent-closable units, and must halt on human/`Blocked`/person Ask-before, without dual reviewers or inventing Ask-before rulings. Handled via Session checklist / Phase status (worker → `Reviewing` only), Review gate (one reviewer + D10 (fix budget) then `Blocked`), and Stop and resume (auto-continue vs halt; resume same unit). Diffed `stages/implement.md` and `design-quality.md`; no `{{…}}` or author HTML. Medium `rg` found R6–R8, D8–D10, Review gate, and Stop and resume. High dry-read: Session checklist → Phase status → Review gate → Stop and resume cannot skip Done-before-review, dual-reviewer, or "wait for user between phases". Failure modes: A3.1 worker → `Reviewing` not `Done` + report-only incomplete; A3.2 exactly one review before Done; A3.3 agent-closable auto-continue without "should I continue?"; A3.4 human sign-off leaves `Reviewing` and halts; A3.5 one D10 re-dispatch then `Blocked` with findings; A3.6 resume finishes the open unit first. One active unit retained; old "leave next phase Not started until the user asks" scoped for serial auto-continue.
- Deviations: None.
- Follow-ups: None for this unit. Dual-reviewer loop and Linear kickoff stay out of scope.

## Risks

- **Auto-continue vs "wait for user".** Today's implement stage halts between phases. Phase 3 must rewrite that line or serial SDD will contradict itself. Mitigation: treat R8 (stop resume) as binding; update the old sentence in the same edit.

## Decisions

### D10 (fix budget) — One autofix re-dispatch, then Blocked

- **Date:** 25 Oct 2026 · **Area:** review gate
- **Why:** D8 (review fail) requires a bound; one cheap re-dispatch covers most agent misses without burning seats on a loop.
- **Rejected:** Unlimited retries; zero autofix (immediate Blocked); two or more re-dispatches in v1.
