---
work_item: n/a
tracker_spec_url: n/a
linear_project: n/a
linear_project_url: n/a
---

# Fewer human stops during implementation

**Kind:** epic

## TL;DR

- **What:** Change how plans are written and run so agents finish as much work as possible before a person must act.
- **Why:** Today one human check in an early phase halts every later phase, which slows implementation a lot.
- **v1 includes:** Inputs collected before phase 1, sign-offs moved to the end, per-scenario check-off, Close labels in Linear, and agent-observed checks.
- **v1 excludes:** Parallel implementers, and rewriting existing plans in other repos.

## Source

> Promoted from `spec_docs/todos.md` › Small to-do's. Three items: plan so agents get as far as possible without a person, leaving human interaction last or deferred; add Close labels (human / automated) to Linear tasks from plan phases; check each acceptance scenario directly instead of going back and forth through Done when. Scope settled in chat on 2026-11-19.

## Goals and acceptance criteria

### G1 (inputs before start) — Predictable person inputs are answered before phase 1

Source: todos › human interaction last

- A plan lists every person input it can predict, such as a new dependency, a new command, a secret name, or branch or cloud consent.
- The person answers that list once, before the first phase starts.
- During the run, only an unpredicted input stops the runner.

### G2 (sign-off at end) — A phase waiting on a person does not stop independent work

Source: todos › human interaction last

- After verify and the agent review pass, a phase with a human check no longer holds the single active slot.
- A later phase may start unless the plan says it needs that person's verdict first.
- A blocked phase does not stop phases that do not depend on it.
- When nothing else can run, the runner presents every pending sign-off as one batch.

### G3 (fewer human gates) — Agents run the checks they can observe

Source: chat 2026-11-19

- A check an agent can observe, such as a visual result in a browser, can be run and evidenced by an agent.
- A person can still reject that evidence during sign-off.

### G4 (traceable checks) — Checks are easy to tick and visible in the tracker

Source: todos › check each scenario, todos › Close labels in Linear

- A person can tick each acceptance scenario where it is written.
- A Linear Tracker Phase shows whether a person must close that phase.

## Non-goals

- Parallel implementers. Only one unit is implemented at a time.
- Rewriting existing plans in other repos to the new statuses, markers, or owners.

## Suggested specs

### S1 (deferred sign-off) — Ask for inputs first and sign-offs last

**Slug:** defer-human-gates
**Depends on:** —
**Status:** done

- **What:** Collect predictable person inputs before phase 1, and let phases waiting on a person stop holding up independent phases.
- **Why:** One human-closed phase or one blocked phase currently halts the whole run.
- **v1 includes:** A pre-flight input list, an `Awaiting sign-off` status, a "needs sign-off" dependency marker, batched sign-off, independent work past a blocked phase, plan guidance, and Linear status support.
- **v1 excludes:** Per-scenario check-off and agent-observed checks, which are separate specs.

**In short:** Three implement-stage rules cause the halt. The fix adds one status, one dependency marker, one plan section, and the matching guidance, validator, and Linear changes.

Current behaviour, from `skills/spec/stages/implement.md`:

- **One active unit.** Only one phase or combinable group may be `Started`, `Reviewing`, or `Blocked` at a time (Phase status).
- **Strict dependencies.** A phase starts only when every phase in its Depends on cell is `Done` or `Deferred` (Phase selection).
- **Human close halts.** A phase with Close `human` stays `Reviewing` after the agent review, and the runner stops (Stop and resume).
- **Per-phase acceptance only.** Resume accepts one phase's pending human gates as a set, never several phases at once.
- **Inputs asked late.** Ask-before items, such as a new dependency or a command missing from Project conventions, are asked when the runner reaches them.

Direction settled in chat:

- **Pre-flight list.** The plan stage collects predictable person inputs into one list. The person answers it before phase 1. Answers are recorded in the plan so the runner does not ask again.
- **New status.** A human-closed phase that passed verify and the agent review moves to `Awaiting sign-off`. It does not count against the one-active-unit rule.
- **Dependency marker.** By default, `Awaiting sign-off` satisfies a Depends on entry. The plan marks an entry as "needs sign-off" when the dependent must wait for the person.
- **Default by risk.** Design-quality guidance defaults to "needs sign-off" for migrations, stored data, auth, and secrets. Visual and copy checks default to "can wait."
- **Plan ordering.** Design-quality guidance places human-checked work as late as the dependencies allow.
- **Blocked phases.** A blocked phase stops only the phases that depend on it.
- **Batched sign-off.** When no ready phase remains, the runner lists every pending human gate across phases. One reply can accept all of them, or name the ones it accepts.
- **Tracker and archive.** The Linear status map gains a key for the new status. Archive waits until every phase is `Done` or `Deferred`.

The child must decide:

- What happens to dependents that already ran when a person rejects a sign-off.
- The exact status name and how the marker is written in the Depends on cell.
- How the validator checks the new status, the marker, and the pre-flight list.

Likely touched paths: `skills/spec/stages/implement.md`, `skills/spec/stages/plan.md`, `skills/spec/design-quality.md`, `skills/spec/templates/implementation-plan.md`, `skills/spec/scripts/validate`, `skills/spec/stages/linear-sync/status.md`, `skills/spec/templates/spec-docs-readme.md`, `README.md`, and `spec_docs/README.md`.

**Outcomes:**

- Predictable person inputs are answered once before phase 1, and the runner does not re-ask them.
- A phase awaiting sign-off does not stop a later phase that does not need its verdict.
- A blocked phase stops only the phases that depend on it.
- All pending sign-offs are presented together when no other phase can run.
- Linear mirrors the new status, and archive waits for every sign-off.

### S2 (scenario check-off) — Tick scenarios directly and label Close in Linear

**Slug:** scenario-check-off
**Depends on:** S1 (deferred sign-off)
**Status:** done

- **What:** Give each acceptance scenario its own tick, and add Close labels to Linear Tracker Phases.
- **Why:** Done when points at scenario ranges, so a reviewer jumps back and forth to tick them, and Linear does not show who closes a phase.
- **v1 includes:** A per-scenario check state in the plan template, a simpler Done when that no longer repeats scenario ranges, and `human` / `automated` Close labels on Tracker Phases.
- **v1 excludes:** Changes to how scenarios are written (Given / When / Then stays).

It depends on S1 (deferred sign-off) because both change the plan template's Gates and status shape. Close labels must reflect S1's status rules.

Today Done when lists lines such as "A2.1–A2.4 pass", and Gates repeats the same ranges. Close is already in the Tracker Phase body (`skills/spec/stages/linear-sync/tracker-phases.md` › Tracker Phase body), but not as a label.

The child must decide:

- Where the tick lives (on the scenario, in Gates, or both), and how Gates stays the owner record.
- Label names, and whether they come from Project conventions like the status map.
- How labels follow a Close change during implement.

**Outcomes:**

- A reviewer ticks each scenario where it is written, without cross-referencing Done when.
- Each Linear Tracker Phase carries a label saying whether a person must close it.

### S3 (agent visual checks) — Let agents run checks they can observe

**Slug:** agent-visual-checks
**Depends on:** S1 (deferred sign-off)
**Status:** done

- **What:** Add a Gates owner for checks an agent observes and evidences, such as a browser screenshot of a layout.
- **Why:** Many checks marked human today are visual checks an agent can perform, so fewer phases need to wait on a person.
- **v1 includes:** The new owner value, the evidence an agent must record, how it affects Close, and a person's right to reject it during batched sign-off.
- **v1 excludes:** Gates for auth, secrets, stored data, or migrations, which always stay with a person.

It depends on S1 (deferred sign-off) because a person reviews agent evidence during S1's batched sign-off.

Today a check is human whenever "a person must judge the result: visual or copy" (`skills/spec/design-quality.md` › Phase close). The implement review subagent cannot pass a human Gates row (`skills/spec/stages/implement.md` › Review gate).

The child must decide:

- Whether the new owner counts as automated for Close, or is a third Close value.
- What evidence is enough, and where it is stored without bloating the plan.
- Which tools the agent may use, and what happens when they are unavailable.

**Outcomes:**

- A visual check can be run and evidenced by an agent without stopping the run.
- A person can reject agent evidence during sign-off, which reopens that phase.
- Gates for auth, secrets, stored data, and migrations stay with a person.

## Tasks

none
