# Implement one phase, or archive

Execute one phase (or one sub-task, or one combinable group) of `<slug>.plan.md` (R3 (new names only)). Prefer one active spec at a time unless the user is explicitly working on another. Resolve only D1 (role map) names from [SKILL.md](../SKILL.md) › Spec docs; do not dual-read bare basenames or rename them (R4 (no auto migrate)).

## Preconditions

1. Open `spec_docs/<slug>/`. If it is under `archive/`, stop unless they asked for a doc correction.
2. `Progress` is `plan` or `implementing`, and `<slug>.plan.md` exists with no `{{…}}` and no `[SUGGESTION:`. If not, stop and name the missing gate.
3. Read `<slug>.spec.md`, the plan's **progress overview**, and the **active phase** section. Read only the tech-doc sections that phase lists under **Read first**, not whole docs.

On the first phase that leaves **Not started**, set `Progress: implementing` in `<slug>.spec.md`. Do not rewrite the rest of the spec. When that Progress change lands, run [linear-sync.md](linear-sync.md) › Status (selective) › Progress → Tracker Spec when write-back is allowed — Tracker Spec only; not a full sync (R11 (status mirror), R12 (selective tracker writes)).

## Phase selection

1. If a phase is `Started`, `Reviewing`, or `Blocked` → continue that phase.
2. Else the first phase that is not `Done` or `Deferred`.
3. It may start only when every phase in its **Depends on** cell is `Done` or `Deferred`. `—` means no dependency.
4. If **Combinable with** names the next siblings and the user wants one session, implement them together when the combined work still has one verifiable outcome.
5. If an upstream phase is still open, stop and report the blocker.

When starting an allowed phase, set it to `Started`.

Before writing code, tell the user the phase, its tier, and the reason, so they can switch model or effort. A combinable group uses the highest tier among its members. A sub-task uses its phase's tier.

Match the session to the tier:

- **Low.** Make the change and run verify.
- **Medium.** Read the linked tech section, and check the failure-mode scenarios before closing.
- **High.** Before writing code, state the approach and how it handles the deciding factor. Read the callers of any contract that changes. Ask before any fork. Record in **Close-out** how each failure mode was checked.

If the rating turns out wrong, update the label in the progress overview and the phase block, and record the change under **Close-out** deviations.

## Serial SDD

**In short:** Multi-unit plans dispatch one fresh implementer at a time. One-phase (or one combinable unit) stays in the parent. Parallel implementers are forbidden.

1. Count remaining dispatch units (each open phase, or one combinable group as one unit). Prefer one active spec at a time unless the user is explicitly working on another.
2. **More than one unit left** → serial subagent-driven development (SDD): the parent MUST dispatch a fresh implementer for the next legal unit and MUST NOT keep implementing the next unit in the same bloated parent session. Soft escapes stay rare (already-started unit; short clarification; research-only) and MUST NOT become a second default.
3. **One phase, or already one combinable unit** → the parent implements in the current session (or one cloud paste). Serial multi-agent ceremony MUST NOT be required.
4. Parallel implementers MUST NOT run. Only one unit may be `Started`, `Reviewing`, or `Blocked`. A unit starts only when every phase in its **Depends on** cell is `Done` or `Deferred`.
5. Default checkout is the shared working tree. Cloud, implementation branch, and worktree are separate Ask-before items (see below). Branch consent does not imply worktree, and the reverse does not hold.

### Phase brief

**In short:** Before each dispatch, the parent builds a chat-only phase brief from the active phase packet. Cloud adds an env checklist. The worker reads the brief and **Read first** only — not the full plan. Tracker Phase bodies in Linear reuse these same fields ([linear-sync.md](linear-sync.md) › Tracker Phase body).

Before dispatching an implementer (local subagent or cloud paste), the parent MUST assemble a phase brief that covers at least:

| Field | Required |
| ----- | -------- |
| Spec slug | yes |
| Phase id(s) | yes |
| Unit name | yes |
| Goals covered (full `G…` forms) | yes |
| Read first | yes |
| Deliverables | yes |
| Done when | yes |
| Tier (Low / Medium / High) | yes |
| Ask-before | yes (may be empty) |
| Scoped paths | yes |
| Stop after this unit | yes |
| Non-goals for this unit | no |

Build the brief from the active phase packet (**Goal**, **Covers**, **Read first**, **Deliverables**, **Done when**, **Tier**, **Not in this phase**, Ask-before from the plan plus this stage's Ask before, and scoped paths from deliverables / **Read first**). Include an explicit **stop after this unit** instruction so the worker does not start the next phase.

The brief is chat-only (or paste text for cloud). The parent MUST NOT write a durable brief file under the spec folder. The implementer MUST NOT be required to read the full plan or unrelated phases — only the brief and the linked **Read first** sections.

#### Env checklist (cloud companion)

When the user opted into a cloud agent for the unit, or the run already is a Cursor Cloud Agent, the parent MUST also supply this companion with the same phase brief. For a local subagent, omit unless useful.

| Field | Required |
| ----- | -------- |
| Verify runnable (yes / no + notes) | yes |
| Secrets or MCP expectations | yes (may be "none") |
| Repo hooks only (cloud cannot assume `~/.cursor`) | yes |
| Status write-back (worker edits the plan on its checkout) | yes |
| Stop after this unit | yes |
| Integrate before next | no |

Do not invent a project-level cloud opt-in in `spec_docs/README.md`. Chat consent (or already-in-cloud) is enough.

Keep this table and the Phase brief field list the source of truth for Tracker Phase body sections in [linear-sync.md](linear-sync.md) (R15 (cloud ready body)). When either side changes, update the other.

### Tracker Phase fallback create

Prefer create/refresh when the plan is written ([plan.md](plan.md) › Tracker Phases). If the active unit still has `Tracker phase: n/a` at or just before first implement on that unit, run [linear-sync.md](linear-sync.md) › Tracker Phase create when write-back is allowed (R4 (freeze before plan) fallback).

- **Allowed.** Plan file exists (`<slug>.plan.md` or bare `implementation-plan.md`), `Work item` is a real id, conventions + Linear MCP ok → create missing Tracker Phase(s) for this unit only; write returned id(s); body from Phase brief / Env checklist fields.
- **`Work item: n/a`.** Skip; no Linear discovery on this routine hook (R22 (reference gate)).
- **No plan file.** Impossible here (preconditions require a plan); elsewhere Tracker Phases stay a no-op (R5 (thin noop)).
- **MCP / conventions missing.** Warn once; skip write-back; continue implement (R1 (conventions gate), R21 (mcp session)).

Do not auto-assign Cursor.

## Session checklist

- Scoped to one phase, one sub-task, or one combinable group.
- Before writing code: name the existing file to extend. A new file, module, or abstraction needs a one-line reason (reused by two or more callers, the existing file would become unwieldy, or a real lifecycle boundary). No new packages without asking.
- Smallest correct change. Do not start later phases.
- Do not add a second implementation of something that already exists nearby.
- Run the default commands in **Verify tiers** for this phase's tier, plus any stronger command named in **Done when**. If **Verify tiers** is still the placeholder, ask. Record commands, results, and the scenarios checked under **Close-out**. Record any deviation from advisory text there too.
- An out-of-scope finding goes under **Follow-ups** (added, phase, task, destination). Do not fix it in this phase.
- After verify, the worker MUST update the plan on its checkout: Done-when checkboxes, **Close-out**, and status to `Reviewing`. The worker MUST NOT mark `Done`. Report-only to the parent (no plan edit) does not count as finished (R6 (worker writeback), D9 (done timing)).
- Tell the user how to verify.

If implementation shows `<slug>.spec.md` scope, non-goals, or glossary are wrong, stop and update the spec, then the siblings that reference the change. Do not build around the mismatch.

## Phase status

Use these values in the progress overview (and on sub-tasks if present):

| Status | When |
| ------ | ---- |
| **Not started** | No work yet |
| **Started** | In progress, including a session that ends mid-phase or a fix re-dispatch |
| **Reviewing** | Worker finished verify and Close-out; agent review pending, or human sign-off still required after agent pass |
| **Done** | Parent marks after required review passes and the unit is agent-closable (or after human continue when sign-off was required); every Done-when item verified and **Close-out** filled |
| **Deferred** | Remaining Done-when items for this phase deliberately dropped, and the drop is noted in **Close-out** or **Follow-ups** |
| **Blocked** | Stuck after exhausted fix budget or person Ask-before — one-line reason |

Only one phase (or combinable group) may be `Started`, `Reviewing`, or `Blocked` at a time. Under serial SDD, after the parent marks a unit `Done`, the runner may start the next ready agent-closable unit without asking (see Stop and resume). Otherwise leave later units `Not started` until continue.

Ask before: a new dependency, a fork that changes the approach, a security or data-migration choice, cloud agent, implementation branch, worktree, commit / push / PR, archiving, or setting a phase to `Deferred`. Cloud, branch, and worktree are distinct asks — one does not imply another. Chat consent is enough; there is no project-level SCM opt-in. When the run already is a Cursor Cloud Agent, cloud consent is implied; extra branch / worktree / commit still need an ask unless that runner's normal branch story applies.

**MUST NOT:** Create a branch, worktree, or commit unless the user explicitly asked in this conversation. Default serial SDD uses the shared checkout.

### Tracker Phase status mirror

When a phase (or combinable unit) status changes in the plan, run [linear-sync.md](linear-sync.md) › Status (selective) › Phase status → Tracker Phase when write-back is allowed (G3 (status mirror), R11 (status mirror), R12 (selective tracker writes)).

- Update **only** that unit’s Tracker Phase by its stored id. Combined phases that share one id → one update.
- On a real status delta, append a Tracker Spec progress-log comment; no-op → none (R13 (progress log)).
- MUST NOT prompt to confirm Linear on every phase Done. MUST NOT run full `/spec linear sync` for a routine status change.
- `Tracker phase: n/a` or `Work item: n/a` → skip that write (R22 (reference gate)). MCP / map missing → warn once; skip; continue implement (R1 (conventions gate), R21 (mcp session)).
- Linear MUST NOT drive plan status or Progress (G7 (repo canonical)).

## Review gate

**In short:** After the worker marks `Reviewing`, the parent runs exactly one review subagent before `Done`. Fail gets one autofix, then `Blocked`. Dual reviewers are forbidden.

After the worker marks `Reviewing`, the parent MUST run exactly one review subagent before marking `Done` or escalating (R7 (required review), D9 (done timing)). The review checks spec compliance and code quality for that unit only.

Pass the reviewer a Review packet with at least:

| Field | Required |
| ----- | -------- |
| Spec slug + phase id(s) | yes |
| Goals and rules in scope (full IDs) | yes |
| Deliverables and Done when | yes |
| Diff or changed paths | yes |
| Human gate after pass (leave `Reviewing` when still required) | yes |

**On pass.** If the unit is agent-closable (verify + Done when allow `Done` without a person), the parent marks `Done`. If human sign-off is still required, leave `Reviewing` and halt — that halt is the human gate, not a second agent.

**On fail.** Re-dispatch the implementer once for a bounded fix (D8 (review fail), D10 (fix budget)). If findings remain after that attempt, mark `Blocked` with findings in Close-out / Follow-ups and wait for continue.

A dual-reviewer loop (two review agents) MUST NOT be required.

## Stop and resume

**In short:** Auto-continue agent-closable units. Halt on human `Reviewing`, `Blocked`, or person Ask-before. Resume finishes the open unit first.

The runner MUST continue automatically across agent-closable units without asking "should I continue?" (R8 (stop resume)). It MUST NOT halt solely because the worker set `Reviewing` for the agent review gate.

It MUST stop when:

- Human sign-off is still required after agent review pass (`Reviewing` stays)
- The unit is `Blocked` after a failed fix loop
- An Ask-before item only a person can answer

Resume uses the same `/spec implement` / continue entry: finish the open `Reviewing` / `Blocked` unit first, then pick the next ready unit.

The controller MUST NOT invent rulings that replace Ask-before for security or irreversible ops.

## Archive

When the user confirms the spec is done — including when they deliberately drop phases that are still `Not started` or `Deferred`:

1. Note skipped or deferred phases in `<slug>.plan.md`, including anything left under **Follow-ups**.
2. Set `Progress: archived` in `<slug>.spec.md`.
3. Move the whole folder `spec_docs/<slug>/` to `spec_docs/archive/<slug>/` (do not rename siblings as a side effect — R4 (no auto migrate)).
4. **Archive gate (Linear).** Before marking the Tracker Spec Done, run [linear-sync.md](linear-sync.md) › Status (selective) › Archive gate (R18 (archive gate)). Tracker Spec Done only when every referenced Tracker Phase is Done or Deferred; otherwise ask. Do not silently complete the Tracker Spec. When the gate allows (or the user confirms), update only the Tracker Spec via selective Progress → Tracker Spec — not a full explicit sync.

Do not archive without explicit confirmation. If every phase is `Done`, or only `Done` plus `Deferred`, offer archive and wait. Do not re-archive. Do not read other archive folders.
