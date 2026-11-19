# Defer human gates — implementation plan

Phases for [defer-human-gates.spec.md](./defer-human-gates.spec.md).

**Status values:** `Not started` · `Started` · `Reviewing` · `Done` · `Deferred` · `Blocked`

## Progress overview

| Phase | Status | Name | Tier | Close | Depends on | Combinable with |
| ----- | ---- | ------ | ---- | ----- | ---------- | --------------- |
| **1** | Not started | Plan shape and guidance | Medium | automated | — | — |
| **2** | Not started | Implement status machine | High | automated | 1 | — |
| **3** | Not started | Validator checks | Medium | automated | 1 | 4 |
| **4** | Not started | Linear and docs | Low | automated | 1 | 3 |

## Phase 1 — Plan shape and guidance

**Tracker phase:** n/a

**Goal:** Plans can carry a Pre-flight section, `Awaiting sign-off` in the status list, and a needs-sign-off Depends on mark, with matching plan-stage and design-quality guidance.

**Covers:** G1 (pre-flight inputs), G2 (sign-off slot), R1 (pre-flight collect), R6 (sign-off defaults), D2 (status name), D3 (depends marker), D4 (marker syntax), D5 (pre-flight home)

**Read first:**

- [defer-human-gates.contracts.md › Phase status](./defer-human-gates.contracts.md#phase-status)
- [defer-human-gates.contracts.md › Pre-flight item](./defer-human-gates.contracts.md#pre-flight-item)
- [defer-human-gates.contracts.md › Needs-sign-off mark](./defer-human-gates.contracts.md#needs-sign-off-mark)
- [defer-human-gates.logic.md › R1 (pre-flight collect)](./defer-human-gates.logic.md#r1-pre-flight-collect)
- [defer-human-gates.logic.md › R6 (sign-off defaults)](./defer-human-gates.logic.md#r6-sign-off-defaults)

**Tier:** Medium — new plan-stage collect/record steps within an existing stage pattern

**Close:** automated

**Not in this phase:** `implement.md` status machine, validate script checks, Linear map, project README status lists

**Deliverables:**

- `skills/spec/templates/implementation-plan.md` — extend: add `Awaiting sign-off` to Status values; add top-level Pre-flight section seed before the progress overview; document Depends on needs-sign-off suffix
- `skills/spec/stages/plan.md` — extend: collect predictable Ask-before into Pre-flight; record answers before phase 1; point authors at marker and ordering guidance
- `skills/spec/design-quality.md` — extend: default needs-sign-off for migrations, stored data, auth, and secrets; unmarked for visual/copy; place human-checked work as late as Depends on allows

**Approach** (advisory):

1. Update the template Status values line and add a Pre-flight table seed matching the contracts sketch (`Item`, `Kind`, `Answer`, `Asked from`).
2. In `plan.md` › What to write, add a Pre-flight collect step: scan phase Ask-before and foreseeable global stops; write rows; stop for answers before treating the plan as ready to implement.
3. In `design-quality.md` › Phase close (and Phase sizing if needed), add the marker defaults and “human work late” guidance from R6 (sign-off defaults). Do not invent a new column — Depends on suffix only (D4 (marker syntax)).

### Acceptance scenarios

- **A1.1 — Pre-flight section on the template**
  - Journey: Pre-flight then implement past sign-off, step 1
  - Check: automated
  - Given the implementation-plan template after this phase
  - When an author starts a new plan from the seed
  - Then a top-level Pre-flight section exists before the progress overview, and Status values include `Awaiting sign-off`

- **A1.2 — Plan stage collects predictable inputs**
  - Journey: Pre-flight then implement past sign-off, step 1
  - Check: automated
  - Given a plan promote with at least one foreseeable Ask-before (new command, dependency, secret name, or branch/cloud consent)
  - When the plan stage finishes What to write
  - Then those items appear as Pre-flight rows and the stage requires answers before phase 1 may start

- **A1.3 — Marker defaults in design-quality**
  - Journey: Pre-flight then implement past sign-off, step 4
  - Check: automated
  - Given design-quality after this phase
  - When an author sets Depends on for a human-closed migration or auth phase versus a visual/copy phase
  - Then guidance defaults needs-sign-off for the former and unmarked awaiting for the latter, and prefers human-checked work late

### Done when

- [ ] `/bin/sh skills/spec/scripts/validate spec_docs/defer-human-gates/` passes
- [ ] A1.1–A1.3 pass (review can show the template section, plan.md collect step, and design-quality defaults from the repo)
- [ ] Existing plan Close / Gates / Tier guidance in design-quality still reads consistently with the new marker prose

### Gates

| Check | Owner | Evidence |
| ----- | ----- | -------- |
| Low/Medium verify command | automated | Close-out command result |
| A1.1, A1.2, A1.3 | automated | Close-out cites template, plan.md, design-quality lines |

**Ask-before:** —

### Close-out

- Verified:
- Deviations:
- Follow-ups:
- Blocked:

## Phase 2 — Implement status machine

**Tracker phase:** n/a

**Goal:** Serial implement uses `Awaiting sign-off`, frees the active slot, respects needs-sign-off and blocked dependents, batches sign-off, and cascade-reopens on reject.

**Covers:** G2 (sign-off slot), G3 (blocked dependents), G4 (batched sign-off), R2 (no re-ask), R3 (awaiting after review), R4 (active slot), R5 (depends default), R7 (blocked dependents), R8 (batched sign-off), R9 (cascade reopen), R10 (archive wait), R11 (secret names only), D1 (cascade reopen)

**Read first:**

- [defer-human-gates.logic.md › R2 (no re-ask)](./defer-human-gates.logic.md#r2-no-re-ask)
- [defer-human-gates.logic.md › R3 (awaiting after review)](./defer-human-gates.logic.md#r3-awaiting-after-review)
- [defer-human-gates.logic.md › R4 (active slot)](./defer-human-gates.logic.md#r4-active-slot)
- [defer-human-gates.logic.md › R5 (depends default)](./defer-human-gates.logic.md#r5-depends-default)
- [defer-human-gates.logic.md › R7 (blocked dependents)](./defer-human-gates.logic.md#r7-blocked-dependents)
- [defer-human-gates.logic.md › R8 (batched sign-off)](./defer-human-gates.logic.md#r8-batched-sign-off)
- [defer-human-gates.logic.md › R9 (cascade reopen)](./defer-human-gates.logic.md#r9-cascade-reopen)
- [defer-human-gates.logic.md › R10 (archive wait)](./defer-human-gates.logic.md#r10-archive-wait)
- [defer-human-gates.logic.md › States and transitions](./defer-human-gates.logic.md#states-and-transitions)
- [defer-human-gates.contracts.md › Phase status](./defer-human-gates.contracts.md#phase-status)

**Tier:** High — many interacting status, Depends on, and stop/resume rules across one runner

**Close:** automated

**Not in this phase:** plan template / design-quality prose (phase 1), validate checks (phase 3), Linear status.md map and project README lists (phase 4)

**Deliverables:**

- `skills/spec/stages/implement.md` — extend: Phase selection (Depends on + blocked + needs-sign-off); Serial SDD active-slot set; Phase status table + Reviewing/Awaiting wording; Review gate human path → `Awaiting sign-off`; Stop and resume (skip recorded pre-flight, batch sign-off, cascade reopen); Archive refuses while any `Awaiting sign-off`; secret name-only reminder where Ask-before records answers

**Approach** (advisory):

1. Replace “human Close stays Reviewing as the sole halt” with move to `Awaiting sign-off` after review pass (R3 (awaiting after review)). Keep `Reviewing` for the agent-review window only.
2. Active set stays `Started` / `Reviewing` / `Blocked` only (R4 (active slot)). Parse Depends on tokens as bare id or `<id> (needs sign-off)` (R5 (depends default)).
3. When the ready queue is empty and awaiting phases remain, one batch prompt (R8 (batched sign-off)). Reject → reopen that phase and every later phase that ran while it was awaiting (R9 (cascade reopen)).
4. Blocked phases stall only dependents (R7 (blocked dependents)). Archive waits for no awaiting left (R10 (archive wait)).
5. Do / do-not: do treat unmarked awaiting as Done for Depends on; do not start a phase that lists a blocked or needs-sign-off-awaiting target.

### Acceptance scenarios

- **A2.1 — Human close frees the slot**
  - Journey: Pre-flight then implement past sign-off, step 3
  - Check: automated
  - Given a unit with Close `human` that passed verify and agent review
  - When the parent applies the review pass
  - Then status is `Awaiting sign-off` and another ready unit may start under the one-active-unit rule

- **A2.2 — Independent work past awaiting**
  - Journey: Pre-flight then implement past sign-off, step 4
  - Check: automated
  - Given phase A is `Awaiting sign-off` unmarked in B’s Depends on
  - When the runner selects the next unit
  - Then B may start; a phase with `A (needs sign-off)` must not

- **A2.3 — Blocked stalls only dependents**
  - Journey: Blocked phase with independent work, step 2
  - Check: automated
  - Given phase A is `Blocked` and phase C does not depend on A
  - When the runner selects the next unit
  - Then C may start and dependents of A stay `Not started`

- **A2.4 — Batched sign-off when queue empty**
  - Journey: Pre-flight then implement past sign-off, step 5
  - Check: automated
  - Given two phases in `Awaiting sign-off` and no other ready phase
  - When the runner stops for person input
  - Then one prompt lists every pending human gate across those phases

- **A2.5 — Cascade reopen on reject**
  - Journey: Reject sign-off after cascade work, step 2
  - Check: automated
  - Given A is `Awaiting sign-off` and B finished while A was awaiting
  - When the person rejects A in the batch
  - Then A reopens and B reopens too

- **A2.6 — No re-ask of recorded pre-flight**
  - Journey: Pre-flight then implement past sign-off, step 2
  - Check: automated
  - Given Pre-flight answers recorded on the plan
  - When implement hits the same Ask-before mid-run
  - Then the runner does not re-ask; only an unpredicted input stops it

- **A2.7 — Archive waits on awaiting**
  - Journey: —
  - Check: automated
  - Given any phase still `Awaiting sign-off`
  - When the user asks to archive
  - Then archive refuses until every phase is `Done` or `Deferred`

### Done when

- [ ] `/bin/sh skills/spec/scripts/validate spec_docs/defer-human-gates/` passes
- [ ] A2.1–A2.7 pass (review can show the matching implement.md rules from the repo)
- [ ] Close `automated` path still becomes `Done` on review pass without entering `Awaiting sign-off`

### Gates

| Check | Owner | Evidence |
| ----- | ----- | -------- |
| High verify command | automated | Close-out command result |
| A2.1, A2.2, A2.3, A2.4, A2.5, A2.6, A2.7 | automated | Close-out cites implement.md sections |

**Ask-before:** —

### Close-out

- Verified:
- Deviations:
- Follow-ups:
- Blocked:

## Phase 3 — Validator checks

**Tracker phase:** n/a

**Goal:** `skills/spec/scripts/validate` reports all seven plan-shape checks from D6 (validator checks).

**Covers:** G1 (pre-flight inputs), G2 (sign-off slot), D6 (validator checks)

**Read first:**

- [defer-human-gates.contracts.md › Validate plan shape](./defer-human-gates.contracts.md#validate-plan-shape)
- [defer-human-gates.spec.md › D6 (validator checks)](./defer-human-gates.spec.md#d6-validator-checks--validate-reports-all-seven-plan-shape-checks-for-this-feature)

**Tier:** Medium — composing new mechanical checks inside the existing validate script

**Close:** automated

**Not in this phase:** implement runner behaviour, Linear write-back, README copy

**Deliverables:**

- `skills/spec/scripts/validate` — extend: unknown status (including `Awaiting sign-off`); malformed marker; missing Pre-flight when any Close is `human`; marker on unknown id; needs-sign-off on automated Close; empty Pre-flight shape when collectable Ask-before existed; unanswered Pre-flight when any phase is past `Not started`

**Approach** (advisory):

1. Extend the plan overview Status parse path to accept the new status and reject unknowns.
2. Tokenize Depends on cells: bare id or `<id> (needs sign-off)` only; emit malformed otherwise; resolve ids against overview phases.
3. Pre-flight: require the top-level section when any Close is `human`; require rows/answer fields when collectable Ask-before applies; require non-blank Answer when any phase status is past `Not started`.
4. Emit findings only; do not rewrite plans.

### Acceptance scenarios

- **A3.1 — Unknown status and malformed marker**
  - Journey: —
  - Check: automated
  - Given a plan with Status `Waiting` or Depends on `1 needs-sign-off` (wrong spelling)
  - When validate runs on that folder
  - Then it reports unknown status and malformed marker

- **A3.2 — Missing or empty Pre-flight**
  - Journey: Pre-flight then implement past sign-off, step 1
  - Check: automated
  - Given a plan with Close `human` and no Pre-flight section, or a section with no item rows when Ask-before was collectable
  - When validate runs
  - Then it reports the matching Pre-flight finding

- **A3.3 — Marker and unanswered guards**
  - Journey: —
  - Check: automated
  - Given needs-sign-off on an automated Close target, or blank Pre-flight answers while a phase is `Started`
  - When validate runs
  - Then it reports those findings and does not rewrite the plan

### Done when

- [ ] `/bin/sh skills/spec/scripts/validate spec_docs/defer-human-gates/` passes
- [ ] A3.1–A3.3 pass (exercise failing fixtures or equivalent review-observable emit paths, then confirm clean on this folder)
- [ ] Existing Close mismatch and Gates↔Check checks still pass on this folder

### Gates

| Check | Owner | Evidence |
| ----- | ----- | -------- |
| Medium verify command | automated | Close-out command result |
| A3.1, A3.2, A3.3 | automated | Close-out cites validate findings on fixtures or controlled inputs |

**Ask-before:** —

### Close-out

- Verified:
- Deviations:
- Follow-ups:
- Blocked:

## Phase 4 — Linear and docs

**Tracker phase:** n/a

**Goal:** Linear status mirroring and project docs list `Awaiting sign-off`, and archive treats it as open.

**Covers:** G5 (tracker archive), R10 (archive wait)

**Read first:**

- [defer-human-gates.contracts.md › Tracker Phase status map key](./defer-human-gates.contracts.md#tracker-phase-status-map-key)
- [defer-human-gates.contracts.md › Archive gate](./defer-human-gates.contracts.md#archive-gate)
- [defer-human-gates.logic.md › R10 (archive wait)](./defer-human-gates.logic.md#r10-archive-wait)

**Tier:** Low — decided map key and status-list edits with a nearby pattern

**Close:** automated

**Not in this phase:** implement Archive body (phase 2), validate Pre-flight checks (phase 3)

**Deliverables:**

- `skills/spec/stages/linear-sync/status.md` — extend: Phase status → Tracker Phase includes `Awaiting sign-off`; least-advanced ordering accounts for it; Archive gate treats it as open
- `spec_docs/README.md` — extend: phase status list includes `Awaiting sign-off`; Tracker Phase map placeholder includes the key when that bullet exists
- `skills/spec/templates/spec-docs-readme.md` — extend: same status list and map placeholder
- `README.md` — extend: update “one open unit” / human-halt wording if it still describes the old Reviewing halt (Documenting changes)

**Approach** (advisory):

1. In `status.md`, add the map key and treat `Awaiting sign-off` like other open statuses for archive; place it in least-advanced order after `Reviewing` and before `Done`.
2. Update both README status lists and the template seed map placeholder in one pass.
3. Skim root `README.md` for prose that says human Close holds the run in `Reviewing`; align with awaiting + batch without inventing a new Linear product story.

### Acceptance scenarios

- **A4.1 — Status map key**
  - Journey: —
  - Check: automated
  - Given `linear-sync/status.md` after this phase
  - When a Tracker Phase mirrors plan status `Awaiting sign-off`
  - Then the stage names that key and skips only under existing `n/a` / map-missing guards

- **A4.2 — Docs list the new status**
  - Journey: —
  - Check: automated
  - Given `spec_docs/README.md` and the spec-docs-readme template after this phase
  - When a reader looks up phase status values
  - Then both lists include `Awaiting sign-off`

- **A4.3 — Archive gate treats awaiting as open**
  - Journey: —
  - Check: automated
  - Given Archive gate prose in `status.md`
  - When any referenced Tracker Phase maps from `Awaiting sign-off`
  - Then archive must not complete the Tracker Spec until that phase is Done or Deferred

### Done when

- [ ] `/bin/sh skills/spec/scripts/validate spec_docs/defer-human-gates/` passes
- [ ] A4.1–A4.3 pass
- [ ] Project docs / other markdown updated per Documenting changes

### Gates

| Check | Owner | Evidence |
| ----- | ----- | -------- |
| Low verify command | automated | Close-out command result |
| A4.1, A4.2, A4.3 | automated | Close-out cites status.md and README lines |

**Ask-before:** —

### Close-out

- Verified:
- Deviations:
- Follow-ups:
- Blocked:
