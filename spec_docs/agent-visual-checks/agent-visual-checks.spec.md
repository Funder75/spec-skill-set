---
work_item: n/a
tracker_spec_url: n/a
epic: fewer-human-stops
---

# Agent visual checks

**Progress:** design
**Depth:** lite
**Kind:** feature
**Depends on:** defer-human-gates

## TL;DR

- **What:** Add a Gates owner for checks an agent observes and evidences, such as a browser screenshot of a layout.
- **Why:** Many checks marked human today are visual checks an agent can perform, so fewer phases need to wait on a person.
- **v1 includes:** The new owner value, the evidence an agent must record, how it affects Close, and a person's right to reject it during batched sign-off.
- **v1 excludes:** Gates for auth, secrets, stored data, or migrations, which always stay with a person.

## Doc index

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file (`agent-visual-checks.spec.md`) | Scope, goals, journeys, constraints, work split | yes |
| agent-visual-checks.logic.md | Rules, workflows, state transitions | folded → [Technical notes › Rules](#rules) |
| agent-visual-checks.contracts.md | Types, API contracts, state ownership, storage | folded → [Technical notes › Contracts](#contracts) |
| agent-visual-checks.ui.md | Layout, interaction, states, copy | not needed |
| agent-visual-checks.plan.md | Phases and phase status | pending |

## Source

> `spec_docs/fewer-human-stops/fewer-human-stops.epic.md` › S3 (agent visual checks). Depth lite, Kind feature. Approach A (agent owner counts as automated for Close) approved in chat 2026-11-19.

## Problem and current behaviour

**In short:** Visual and copy checks are always Gates owner `human`, so Close becomes `human` and a person must wait even when an agent could observe the result.

- **Visual means human.** Design-quality Phase close sets Check `human` when a person must judge visual or copy results.
- **Review cannot pass human rows.** The implement review subagent does not pass a Gates row owned `human`.
- **Agent already records some evidence.** Review-observable evidence is allowed for some `none`-tier command rows, but not as a first-class owner for visual checks.
- **Sign-off already batches.** Deferred sign-off (`defer-human-gates`) moves Close `human` to `Awaiting sign-off` and can batch person accept or reject.

| Path | What it does today |
| ---- | ------------------ |
| `skills/spec/design-quality.md` | Visual or copy → Check/owner `human` |
| `skills/spec/stages/implement.md` | Review skips human Gates; batch sign-off |
| `skills/spec/stages/plan.md` | Gates owner is automated or human |
| `skills/spec/templates/implementation-plan.md` | Check and Gates: automated or human |
| `skills/spec/scripts/validate` | Gates↔Check for automated or human |

## Goals and acceptance criteria

### G1 (agent evidence) — A visual check can be run and evidenced by an agent without stopping the run

Source: fewer-human-stops › S3 (agent visual checks)

- Plan authors may set scenario Check and Gates owner to `agent` for an observable check (for example a browser layout).
- During implement, the agent runs that check, records evidence, and may mark the gate passed.
- Owner `agent` counts as automated when computing Close (see D1 (agent close)).
- A phase whose only non-command checks are `agent` can finish without a person stop after verify and the agent review.

### G2 (reject evidence) — A person can reject agent evidence during sign-off, which reopens that phase

Source: fewer-human-stops › S3 (agent visual checks)

- When Close is still `human` because another Gates row is `human`, batched sign-off presents agent evidence with the pending human gates.
- The person may reject that evidence.
- Reject reopens that phase under existing cascade-reopen rules from `defer-human-gates`.

### G3 (human stays) — Gates for auth, secrets, stored data, and migrations stay with a person

Source: fewer-human-stops › S3 (agent visual checks)

- Auth, secrets, stored-data, and migration checks MUST keep owner `human`.
- Guidance MUST NOT recommend owner `agent` for those checks.
- Validate or design-quality prose makes that boundary clear enough that authors do not mis-tag them.

## Non-goals

- A third Close value such as `agent` (rejected; see D1 (agent close)).
- Letting agents own auth, secrets, stored-data, or migration Gates.
- Rewriting existing plans in other repos to retag visual checks.
- Parallel implementers.
- Per-scenario check-off shape (sibling `scenario-check-off`).

## Users and context

- **Primary user:** Spec authors and agents running plan write and `/spec` implement
- **When:** Choosing Check/Gates owners at plan time, and running or signing off phases with observable checks
- **Who may do this:** Anyone who can edit the plan or accept human gates

## User journeys

### Agent evidences a visual check

Starting point: A phase has a layout check that an agent can observe in a browser. No other human-only Gates remain.

1. Author sets Check and Gates owner to `agent` for that scenario.
2. Implementer opens the surface, records evidence in Close-out, and marks the gate passed.
3. Verify and the agent review pass. Close is `automated`.
4. The phase becomes `Done` without batched sign-off.

End state: The visual check is evidenced and closed without a person stop.

Goes wrong when:

- Observation tools are missing — gate must not pass (G1 (agent evidence), D3 (tools fallback)).
- Evidence is missing from Close-out — review must not pass that gate (G1 (agent evidence), D2 (evidence shape)).

Covers: G1 (agent evidence)

### Person rejects agent evidence in a human batch

Starting point: A phase has Close `human` because at least one Gates row is still `human`, and it also has an `agent` row with evidence. The phase is `Awaiting sign-off`.

1. Runner presents the pending human gates and the agent evidence together.
2. Person rejects the agent evidence (alone or with other rejects).
3. That phase reopens; later phases that ran while it awaited follow cascade reopen.

End state: Rejected agent evidence does not leave the phase `Done`.

Goes wrong when:

- Pure-`agent` phases have no batch — reject-at-batch does not apply (D4 (reject scope)); person uses a later manual reopen if needed.

Covers: G2 (reject evidence)

### High-risk checks stay human

Starting point: A phase includes auth, secrets, stored-data, or migration acceptance.

1. Author sets those Checks and Gates owners to `human`.
2. Guidance and validation discourage or reject `agent` for those kinds.
3. Implement leaves those rows for person accept.

End state: High-risk gates still require a person.

Goes wrong when:

- An author tags a migration check `agent` — guidance or validate must catch or clearly forbid it (G3 (human stays)).

Covers: G3 (human stays)

## Constraints

- **Preserve:** Close values `automated` and `human` only; batched sign-off and cascade reopen from `defer-human-gates`; Gates as owner/evidence authority; scenario Check vocabulary extended only by `agent`
- **Security:** Do not put secrets in Close-out, evidence paths, or Linear bodies; record secret names only

## Notes

- **Depends on archived sibling.** `defer-human-gates` is archived; this child still depends on its `Awaiting sign-off` and batch reject behaviour.
- **Pure agent phases.** Under D4 (reject scope), a phase with only `agent` and `automated` owners has no mandatory person gate.

## Concerns

- **Design-quality drift.** Phase close still lists visual or copy as always human, and some human Close prose still says stay `Reviewing`. If left: authors keep tagging visuals `human` and G1 (agent evidence) is unmet.

## Proposed solution

**In short:** Add Gates and Check owner `agent` for observable checks. Treat it as automated for Close. Require Close-out evidence. Keep high-risk checks human. Let people reject agent evidence only when the phase is already in a human sign-off batch.

Plan and design-quality guidance teach when to use `agent` instead of `human` for visual (and similar observable) checks. Implement runs those rows, records evidence, and may mark them passed. Review requires that evidence. Validate accepts the new owner and keeps Close as the two existing values. Auth, secrets, stored data, and migrations stay `human`.

### Capabilities (v1)

- **Owner `agent`.** First-class Check and Gates value for agent-observed checks.
- **Evidence in Close-out.** Short note plus path or artifact ref.
- **Close unchanged set.** `agent` counts as automated for Close.
- **Batch reject when human.** Mixed human phases can reject agent evidence at sign-off.

## Touched paths

| Path | Area | Change |
| ---- | ---- | ------ |
| `skills/spec/design-quality.md` | guidance | Owner `agent`; visual default; Close rule |
| `skills/spec/stages/plan.md` | plan | When to write Check/Gates `agent` |
| `skills/spec/templates/implementation-plan.md` | template | Check and Gates allow `agent` |
| `skills/spec/stages/implement.md` | implement | Run agent gates; evidence; review; batch reject |
| `skills/spec/scripts/validate` | validate | Accept `agent`; Close still two values |
| `skills/spec/templates/spec-docs-readme.md` | docs | Mention `agent` owner if Close/Gates docs list owners |
| `spec_docs/README.md` | docs | Same if conventions describe Gates owners |

## Work split

1. **Owner and Close rules.** Covers G1 (agent evidence), G3 (human stays). Outcome: guidance and templates allow `agent`; visual defaults update; high-risk stays human; Close treats `agent` as automated. Main surface: design-quality, plan stage, plan template.
2. **Implement and evidence.** Covers G1 (agent evidence), G2 (reject evidence). Outcome: implement runs agent gates with evidence; review requires it; batch can reject; tools fallback is defined. Main surface: implement stage.
3. **Validate.** Covers mechanical checks for G1 (agent evidence) and G3 (human stays). Outcome: validate accepts `agent` on Check/Gates and keeps Close as `automated` or `human`. Main surface: validate script.

## Glossary

- **Agent owner:** Check or Gates value `agent` for a check the implementer observes and evidences without a person mid-phase.
- **Agent evidence:** Close-out note plus a path or artifact reference that shows what the agent observed.

## Technical notes (folded)

### Rules

**In short:** Binding owner, Close, evidence, tools, and reject rules for lite.

- **R1 (agent owner).** Check and Gates MAY use owner `agent` for a result the agent can observe in-session (for example browser layout or on-screen copy the tools can show).
- **R2 (agent close).** When computing Close, owner `agent` counts as automated. Close is `human` only if any owner is `human`. Close MUST remain only `automated` or `human`.
- **R3 (high risk human).** Auth, secrets, stored-data, and migration checks MUST use owner `human`. Plan and design-quality MUST NOT recommend `agent` for them.
- **R4 (evidence required).** An `agent` Gates row MUST NOT be marked passed unless Close-out names the check and points at evidence (path or artifact ref plus a short note). MUST NOT inline screenshot binaries or large blobs in the plan.
- **R5 (tools fallback).** If required observation tools are unavailable in the session, the agent MUST NOT pass the `agent` row. Stop and ask, or retag that row `human` and record the change under Close-out.
- **R6 (reject scope).** Batched sign-off MAY reject agent evidence when the phase Close is `human`. A pure `agent`+`automated` phase has no batch reject path in v1 (see D4 (reject scope)).
- **R7 (review).** The implement review MUST treat evidenced `agent` rows like automated rows for pass or fail. It MUST NOT pass an `agent` row with missing evidence.

### Contracts

**In short:** Binding vocabulary for Check, Gates, and Close-out evidence.

#### Check and Gates owner

| Value | Meaning | Counts as for Close |
| ----- | ------- | ------------------- |
| `automated` | Command, test, or repo-visible review result | automated |
| `agent` | Agent observes and evidences in-session | automated |
| `human` | Person must judge or accept | human |

#### Close-out evidence fields

| Field | Shape | Owner |
| ----- | ----- | ----- |
| Check id or Gates row | Scenario id or check name | Plan Close-out |
| Note | One short sentence of what was observed | Plan Close-out |
| Ref | Repo-relative path or session artifact reference | Plan Close-out |

Sketch (advisory):

```markdown
- A2.3 agent evidence: primary layout matches wire regions; ref `…/evidence/a2-3.png`
```

## Decisions

### D1 (agent close) — Owner `agent` counts as automated for Close

- **Date:** 2026-11-19 · **Area:** Close / Gates
- **Why:** Fewer visual-only phases wait on a person; Close stays two-valued for scenario-check-off labels.
- **Rejected:** Close stays human whenever an agent row exists (Approach B); third Close value (Approach C)

### D2 (evidence shape) — Evidence is a Close-out note plus a path or artifact ref

- **Date:** 2026-11-19 · **Area:** Close-out
- **Why:** Reviewers need something to inspect without bloating the plan with binaries.
- **Rejected:** Inline screenshots in the plan; evidence-only chat with no plan pointer

### D3 (tools fallback) — Missing tools block the agent gate

- **Date:** 2026-11-19 · **Area:** implement
- **Why:** Passing without observation invents evidence.
- **Rejected:** Silent skip; treat missing tools as automatic pass

### D4 (reject scope) — Batch reject applies only when Close is human

- **Date:** 2026-11-19 · **Area:** sign-off
- **Why:** Pure agent phases finish without a batch under D1 (agent close); mixed phases keep the epic's reject path.
- **Rejected:** Force every agent phase through Awaiting sign-off; invent a separate post-Done reject queue in v1
