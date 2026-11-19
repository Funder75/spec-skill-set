# Agent visual checks — implementation plan

Phases for [agent-visual-checks.spec.md](./agent-visual-checks.spec.md).

**Status values:** `Not started` · `Started` · `Reviewing` · `Awaiting sign-off` · `Done` · `Deferred` · `Blocked`

## Progress overview

| Phase | Status | Name | Tier | Close | Depends on | Combinable with |
| ----- | ---- | ------ | ---- | ----- | ---------- | --------------- |
| **1** | Done | Owner agent and evidence | Medium | automated | — | — |

## Phase 1 — Owner agent and evidence

**Tracker phase:** n/a

**Goal:** Check and Gates accept owner `agent` for observable checks, Close treats it as automated, implement requires Close-out evidence, high-risk stays human, and validate accepts the new owner.

**Covers:** G1 (agent evidence), G2 (reject evidence), G3 (human stays), R1 (agent owner), R2 (agent close), R3 (high risk human), R4 (evidence required), R5 (tools fallback), R6 (reject scope), R7 (review), D1 (agent close), D2 (evidence shape), D3 (tools fallback), D4 (reject scope)

**Read first:**

- [agent-visual-checks.spec.md › Technical notes › Rules](./agent-visual-checks.spec.md#rules)
- [agent-visual-checks.spec.md › Technical notes › Contracts](./agent-visual-checks.spec.md#contracts)
- [agent-visual-checks.spec.md › Decisions](./agent-visual-checks.spec.md#decisions)

**Tier:** Medium — several interacting Close and Gates rules across design-quality, plan, implement, and validate

**Close:** automated

**Not in this phase:** Retagging plans in other repos; a third Close value; scenario-check-off; forcing pure-agent phases through Awaiting sign-off

**Deliverables:**

- `skills/spec/design-quality.md` — extend: owner `agent`; visual/copy may use `agent` when observable; high-risk stays human; Close treats `agent` as automated
- `skills/spec/stages/plan.md` — extend: when to write Check/Gates `agent`; keep Close two-valued
- `skills/spec/templates/implementation-plan.md` — extend: Check and Gates allow `agent`
- `skills/spec/stages/implement.md` — extend: run agent gates with evidence; review requires it; tools fallback; batch may reject agent evidence when Close is human
- `skills/spec/scripts/validate` — extend: accept `agent` on Check/Gates; Close still only `automated` or `human`
- `skills/spec/templates/spec-docs-readme.md` — extend: mention `agent` where Gates owners are listed
- `spec_docs/README.md` — extend: same owner wording where Gates owners are described

**Approach** (advisory):

1. In design-quality Phase close, add owner `agent`, teach visual/copy → `agent` when the agent can observe, keep auth/secrets/stored-data/migration as `human`, and compute Close with `agent` counting as automated.
2. Mirror the vocabulary in the plan template and plan stage write guidance.
3. In implement, require Close-out evidence for passed `agent` rows, block pass when tools are missing (R5 (tools fallback)), treat evidenced `agent` like automated in review, and allow batch reject of that evidence only when Close is `human` (R6 (reject scope)).
4. Teach validate the third owner without expanding Close beyond two values.
5. Update the two README seeds so human and agent docs agree.

### Acceptance scenarios

- **A1.1 — Author sets agent owner**
  - Journey: Agent evidences a visual check, step 1
  - Check: automated
  - Given design-quality and the plan template after this phase
  - When an author writes a layout scenario Check and Gates owner
  - Then owner `agent` is allowed for that observable check

- **A1.2 — Close treats agent as automated**
  - Journey: Agent evidences a visual check, step 3
  - Check: automated
  - Given a phase whose Gates owners are only `agent` and `automated`
  - When Close is computed from those owners
  - Then Close is `automated` and the phase needs no person stop after verify and review

- **A1.3 — Evidence required to pass**
  - Journey: Agent evidences a visual check, step 2
  - Check: automated
  - Given an `agent` Gates row with no Close-out note and ref
  - When implement review runs
  - Then that row must not pass (R4 (evidence required), R7 (review))

- **A1.4 — Missing tools block pass**
  - Journey: Agent evidences a visual check, Goes wrong when
  - Check: automated
  - Given required observation tools are unavailable
  - When the agent would mark the `agent` row passed
  - Then it must stop and ask, or retag the row `human` and record that under Close-out (R5 (tools fallback))

- **A1.5 — Batch can reject agent evidence**
  - Journey: Person rejects agent evidence in a human batch, step 2
  - Check: automated
  - Given Close `human` because another Gates row is `human`, plus an evidenced `agent` row at Awaiting sign-off
  - When the person rejects that agent evidence
  - Then that phase reopens under existing cascade-reopen rules

- **A1.6 — High-risk stays human**
  - Journey: High-risk checks stay human, step 2
  - Check: automated
  - Given guidance and validate after this phase
  - When an author considers Check/Gates for auth, secrets, stored-data, or migration
  - Then those checks stay `human` and `agent` is not recommended (R3 (high risk human))

### Done when

- [x] Tier verify passes (Project conventions in `spec_docs/README.md`)
- [x] A1.1, A1.2, A1.3, A1.4, A1.5, A1.6 pass
- [x] Close remains only `automated` or `human` in design-quality, plan, implement, and validate
- [x] Auth, secrets, stored-data, and migration still use owner `human`

### Gates

| Check | Owner | Evidence |
| ----- | ----- | -------- |
| `/bin/sh skills/spec/scripts/validate spec_docs/agent-visual-checks/` | automated | Close-out command result |
| A1.1, A1.2, A1.3, A1.4, A1.5, A1.6 | automated | Close-out |

**Ask-before:** —

### Close-out

- Verified: pass — `/bin/sh skills/spec/scripts/validate spec_docs/agent-visual-checks/` exit 0; also `spec_docs/epic-child-state/` exit 0. A1.1 design-quality/plan/template allow Check/Gates `agent`. A1.2 Close treats `agent` as automated (two Close values only). A1.3–A1.4 implement requires Close-out evidence and tools fallback. A1.5 batch may reject agent evidence when Close human; cascade reopen. A1.6 high-risk stays human in design-quality and plan guidance; validate accepts `agent` owners and rejects non-`automated`/`human` Close.
- Deviations: none
- Follow-ups: none
- Blocked:
