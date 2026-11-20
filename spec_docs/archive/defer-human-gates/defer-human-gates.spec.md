---
work_item: n/a
tracker_spec_url: n/a
epic: fewer-human-stops
---

# Defer human gates

**Progress:** archived
**Depth:** full
**Kind:** feature
**Depends on:** —

## TL;DR

- **What:** Collect predictable person inputs before phase 1, and let phases waiting on a person stop holding up independent phases.
- **Why:** One human-closed phase or one blocked phase currently halts the whole run.
- **v1 includes:** A pre-flight input list, an `Awaiting sign-off` status, a "needs sign-off" dependency marker, batched sign-off, independent work past a blocked phase, plan guidance, and Linear status support.
- **v1 excludes:** Per-scenario check-off and agent-observed checks, which are separate specs.

## Doc index

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file (`defer-human-gates.spec.md`) | Scope, goals, journeys, constraints, work split | yes |
| [defer-human-gates.logic.md](./defer-human-gates.logic.md) | Rules, workflows, state transitions | yes |
| [defer-human-gates.contracts.md](./defer-human-gates.contracts.md) | Types, API contracts, state ownership, storage | yes |
| defer-human-gates.ui.md | Layout, interaction, states, copy | not needed |
| [defer-human-gates.plan.md](./defer-human-gates.plan.md) | Phases and phase status | yes |

## Source

> `spec_docs/fewer-human-stops/fewer-human-stops.epic.md` › S1 (deferred sign-off). Depth full, Kind feature, cascade-reopen approach approved in chat 2026-11-19.

## Problem and current behaviour

**In short:** Three implement-stage rules cause the halt. Predictable person inputs are also asked late, so the run stops in the middle of a phase.

- **One active unit.** Only one phase or combinable group may be `Started`, `Reviewing`, or `Blocked` at a time.
- **Strict dependencies.** A phase starts only when every phase in its Depends on cell is `Done` or `Deferred`.
- **Human close halts.** A phase with Close `human` stays `Reviewing` after the agent review, and the runner stops.
- **Per-phase acceptance only.** Resume accepts one phase's pending human gates as a set, never several phases at once.
- **Inputs asked late.** Ask-before items (new dependency, missing command, branch or cloud consent) are asked when the runner reaches them.

| Path | What it does today |
| ---- | ------------------ |
| `skills/spec/stages/implement.md` | One active unit; human Close stays Reviewing; Ask-before mid-run |
| `skills/spec/stages/plan.md` | Writes phases, Close, Gates, Ask-before; no pre-flight list |
| `skills/spec/design-quality.md` | Close and Gates owners; no sign-off ordering or marker defaults |
| `skills/spec/templates/implementation-plan.md` | Status set without Awaiting sign-off; no pre-flight section |
| `skills/spec/scripts/validate` | Checks Close and Gates; no sign-off status or marker |
| `skills/spec/stages/linear-sync/status.md` | Maps today's statuses; archive asks on open Tracker Phases |

## Goals and acceptance criteria

### G1 (pre-flight inputs) — Predictable person inputs are answered once before phase 1

Source: fewer-human-stops › S1 (deferred sign-off)

- The plan stage collects every person input it can predict into one pre-flight list (for example a new dependency, a new command, a secret name, or branch or cloud consent).
- The person answers that list once before the first phase starts.
- Answers are recorded in the plan so the runner does not ask them again during the run.
- During the run, only an unpredicted input stops the runner.

### G2 (sign-off slot) — A phase awaiting sign-off does not stop independent later work

Source: fewer-human-stops › S1 (deferred sign-off)

- After verify and the agent review pass, a phase with Close `human` moves to `Awaiting sign-off` (see D2 (status name)).
- `Awaiting sign-off` does not count against the one-active-unit rule.
- By default, `Awaiting sign-off` satisfies a Depends on entry so a later phase may start.
- When the plan marks a Depends on entry as needs sign-off (see D3 (depends marker)), that dependent waits until the person accepts the earlier phase.
- Design-quality guidance defaults the marker by risk: migrations, stored data, auth, and secrets need sign-off; visual and copy checks can wait.
- Design-quality guidance places human-checked work as late as the dependencies allow.

### G3 (blocked dependents) — A blocked phase stops only the phases that depend on it

Source: fewer-human-stops › S1 (deferred sign-off)

- When a phase is `Blocked`, phases that do not depend on it may still start (subject to the one-active-unit rule and their own Depends on).
- A phase whose Depends on includes a blocked phase must not start until that dependency is cleared.

### G4 (batched sign-off) — All pending sign-offs are presented together when no other phase can run

Source: fewer-human-stops › S1 (deferred sign-off)

- When no ready phase remains, the runner lists every pending human gate across phases that are `Awaiting sign-off`.
- One reply can accept all of them, or name the ones it accepts.
- Accepted phases move to `Done`. Rejected phases follow D1 (cascade reopen).

### G5 (tracker archive) — Linear mirrors the new status, and archive waits for every sign-off

Source: fewer-human-stops › S1 (deferred sign-off)

- The Tracker Phase status map gains a key for `Awaiting sign-off`.
- Archive waits until every phase is `Done` or `Deferred` (no phase left in `Awaiting sign-off`).

## Non-goals

- Per-scenario check-off in the plan (later; epic S2 (scenario check-off)).
- Agent-observed checks as a Gates owner (later; epic S3 (agent visual checks)).
- Parallel implementers. Only one unit is implemented at a time.
- Rewriting existing plans in other repos to the new statuses, markers, or owners.

## Users and context

- **Primary user:** Spec authors and reviewers running `/spec` implement on a plan
- **When:** After the plan exists, before and during serial implementation
- **Who may do this:** Anyone who can invoke the Spec skill and answer Ask-before / sign-off prompts

## User journeys

### Pre-flight then implement past sign-off

Starting point: Author has an approved plan with at least one Close `human` phase and some predictable Ask-before items.

1. Plan stage (or implement start) presents the pre-flight list.
2. Author answers once; answers are stored on the plan.
3. Implement runs automated phases and moves human-closed phases to `Awaiting sign-off` after review.
4. A later phase that does not need that verdict starts while earlier phases await sign-off.
5. When nothing else can run, the runner presents every pending sign-off as one batch.
6. Author accepts some or all; accepted phases become `Done`.

End state: Independent work finished without waiting on each human Close mid-run. Predictable inputs were not re-asked.

Goes wrong when:

- An unpredicted Ask-before appears mid-phase — the runner still stops (G1 (pre-flight inputs)).
- Author rejects a sign-off after later work ran — cascade reopen (D1 (cascade reopen)).
- A dependent marked needs sign-off tries to start early — Depends on blocks it (G2 (sign-off slot)).

Covers: G1 (pre-flight inputs), G2 (sign-off slot), G4 (batched sign-off)

### Blocked phase with independent work

Starting point: One phase is `Blocked` after a failed fix loop. Another phase does not depend on it.

1. Runner leaves the blocked phase as-is.
2. Runner starts the independent ready phase (one active unit still holds).
3. Dependents of the blocked phase stay `Not started`.

End state: Only the blocked chain is stalled.

Goes wrong when:

- A phase that lists the blocked phase in Depends on is started anyway — must not happen (G3 (blocked dependents)).

Covers: G3 (blocked dependents)

### Reject sign-off after cascade work

Starting point: Phase A is `Awaiting sign-off`. Phase B finished while A was awaiting and did not require A's verdict.

1. Author rejects A's sign-off in the batch.
2. A reopens (blocked or back to reviewing per implement rules).
3. B and every later phase that ran while A was awaiting sign-off also reopen.

End state: No later work stays Done on top of a rejected earlier sign-off.

Goes wrong when:

- Only A reopens and B stays Done — violates D1 (cascade reopen).

Covers: G4 (batched sign-off), D1 (cascade reopen)

## Constraints

- **Preserve:** One implementer at a time; plan body as phase-status authority; Close `automated` / `human`; existing Progress gates; slug-prefixed emitted filenames
- **i18n:** n/a
- **Accessibility:** n/a
- **Security:** Secret values MUST NOT be written into the plan, Close-out, or Linear; record the secret name only. Auth, secrets, migrations, and stored-data checks default to needs sign-off (G2 (sign-off slot))
- **Performance:** n/a

## Notes

- **Sibling specs.** S2 (scenario check-off) and S3 (agent visual checks) depend on this folder's status and Gates shape. Prefer stable status and marker spelling before those children start.
- **Epic non-goals.** Parallel implementers and rewriting other repos stay epic-level non-goals; this child does not weaken them.

## Proposed solution

**In short:** Add one status, one Depends on marker, one plan pre-flight section, and matching guidance, validator, and Linear map changes. Keep serial implement; change what counts as "active" and what satisfies Depends on.

Plan stage builds a pre-flight list from predictable Ask-before items and records answers on the plan before phase 1. Implement moves a human-closed phase that passed verify and agent review to `Awaiting sign-off` instead of holding `Reviewing` as the sole active unit. Unmarked awaiting phases satisfy Depends on; marked ones do not until the person accepts. Blocked phases only stall their dependents. When the ready queue is empty, one batched sign-off prompt covers every pending human gate. Reject uses cascade reopen (D1 (cascade reopen)). Linear gains the new status key; archive still requires every phase Done or Deferred.

### Capabilities (v1)

- **Pre-flight list.** Collect, answer once, record, skip re-ask.
- **Awaiting sign-off status.** Free the active slot after agent review on Close `human`.
- **Needs-sign-off marker.** Opt a dependency into waiting for the person's verdict.
- **Batched sign-off.** One prompt when nothing else can run.
- **Cascade reopen.** Reject reopens the phase and later work that ran under it.
- **Tracker mirror.** Status map and archive gate include the new status.

## Touched paths

| Path | Area | Change |
| ---- | ---- | ------ |
| `skills/spec/stages/implement.md` | implement | Status machine, stop/resume, cascade, blocked rule |
| `skills/spec/stages/plan.md` | plan | Pre-flight list; marker and ordering guidance |
| `skills/spec/design-quality.md` | guidance | Sign-off defaults; place human work late |
| `skills/spec/templates/implementation-plan.md` | template | Status value; pre-flight; Depends marker |
| `skills/spec/scripts/validate` | validate | Status, marker, Depends on id, Close vs marker, Pre-flight presence/rows/answers (D6 (validator checks)) |
| `skills/spec/stages/linear-sync/status.md` | Linear | Map key; archive waits for sign-off |
| `skills/spec/templates/spec-docs-readme.md` | docs | Status list and conventions seed |
| `README.md` | docs | Status list if documented there |
| `spec_docs/README.md` | docs | Status list; Tracker Phase map placeholder |

## Work split

1. **Plan shape and guidance.** Covers G1 (pre-flight inputs), parts of G2 (sign-off slot). Outcome: template and design-quality/plan prose for pre-flight, marker, and ordering. Main surface: plan stage and templates.
2. **Implement status machine.** Covers G2 (sign-off slot), G3 (blocked dependents), G4 (batched sign-off), D1 (cascade reopen). Outcome: runner uses the new status, slot rule, batch prompt, and cascade. Main surface: implement stage.
3. **Validator.** Covers mechanical checks for G1 (pre-flight inputs) and G2 (sign-off slot) per D6 (validator checks). Outcome: validate reports unknown status, malformed marker, unknown Depends on id, needs-sign-off on automated Close, missing/empty Pre-flight shape, and unanswered Pre-flight once any phase is past `Not started`. Main surface: validate script.
4. **Linear and docs.** Covers G5 (tracker archive). Outcome: status map key, archive behaviour, README status lists. Main surface: linear-sync status and project docs.

## Glossary

- **Awaiting sign-off:** Phase status after verify and agent review when Close is `human`, before a person accepts. Does not count as the one active unit.
- **Needs sign-off:** Depends on annotation meaning the dependent must wait for the person's verdict, not only for `Awaiting sign-off`.
- **Pre-flight list:** Predictable person inputs collected before phase 1, with answers recorded on the plan.
- **Cascade reopen:** On reject, reopen the rejected phase and every later phase that ran while it was awaiting sign-off.

## Decisions

### D1 (cascade reopen) — Reject reopens later work that already ran

- **Date:** 2026-11-19 · **Area:** implement / sign-off
- **Why:** Safer for skill and docs work than leaving Done phases on top of a rejected earlier verdict.
- **Rejected:** Dependents-only reopen; halt-and-ask on reject

### D2 (status name) — The new status is `Awaiting sign-off`

- **Date:** 2026-11-19 · **Area:** plan status
- **Why:** Matches the epic wording and reads clearly in the progress overview.
- **Rejected:** Keeping human Close in `Reviewing` as the sole active halt

### D3 (depends marker) — Unmarked awaiting satisfies Depends on; marked waits for the person

- **Date:** 2026-11-19 · **Area:** plan Depends on
- **Why:** Most visual and copy checks should not block independent work; high-risk work opts into waiting.
- **Rejected:** Always wait for person on every Depends on entry; never wait (no marker)

### D4 (marker syntax) — Needs sign-off is a suffix on the phase id in Depends on

- **Date:** 2026-11-19 · **Area:** plan Depends on
- **Why:** Keeps Depends on as one cell; matches how authors already write phase ids; no new column for v1.
- **Rejected:** Separate column or field; defer spelling to promote

### D5 (pre-flight home) — Pre-flight items and answers live in a top-level Pre-flight section

- **Date:** 2026-11-19 · **Area:** plan template
- **Why:** One place before the progress overview; plan stage and implement both read the same section; answers stay off the overview table.
- **Rejected:** Rows under the progress overview; another home at promote

### D6 (validator checks) — Validate reports all seven plan-shape checks for this feature

- **Date:** 2026-11-19 · **Area:** validate
- **Why:** Catch status, marker, Depends on, Close/marker, and Pre-flight defects in one place; do not leave pre-flight or bad Depends on to author diligence alone.
- **Checks (all required):**
  1. **Unknown status** — progress overview Status not in the allowed set (including `Awaiting sign-off`).
  2. **Malformed marker** — Depends on token is not a bare phase id and not `<id> (needs sign-off)` per D4 (marker syntax).
  3. **Missing Pre-flight section** — any phase has Close `human`, but the top-level Pre-flight section from D5 (pre-flight home) is absent.
  4. **Marker on unknown id** — marked or unmarked Depends on target is not a phase in the overview.
  5. **Needs-sign-off on automated Close** — a Depends on entry marks needs sign-off for a target whose Close is `automated`.
  6. **Empty Pre-flight shape** — Pre-flight section exists but has no item rows / answer fields when at least one predictable Ask-before was collectable.
  7. **Unanswered pre-flight** — Pre-flight items exist with blank answers while any phase is past `Not started`.
- **Rejected:** Narrower sets (status+marker only; or status+marker+missing Pre-flight only); deferring breadth to promote
