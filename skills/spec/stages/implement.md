# Implement one phase, or archive

Execute one phase (or one sub-task, or one combinable group) of `<slug>.plan.md` (R3 (new names only)). Prefer one active spec at a time unless the user is explicitly working on another. Resolve only D1 (role map) names from [SKILL.md](../SKILL.md) › Spec docs; do not dual-read bare basenames or rename them (R4 (no auto migrate)).

## Preconditions

**Epic folder.** When `spec_docs/<slug>/<slug>.epic.md` is present, stop here, before step 1 and before Phase selection (R4 (refuse gates)). Reply with [SKILL.md](../SKILL.md) › Stage detection › Refusal, naming each suggested spec and the task names, or none. Do not start phase work, set a status, or change the folder. A child slug is its own folder and is not stopped here. This stop covers implement and continue only. Archive is unchanged.

1. Open `spec_docs/<slug>/`. If it is under `archive/`, stop unless they asked for a doc correction.
2. `Progress` is `plan` or `implementing`, and `<slug>.plan.md` exists with no `{{…}}` and no `[SUGGESTION:`. If not, stop and name the missing gate.
3. Read `<slug>.spec.md`, the plan's **progress overview**, and the **active phase** section. Read only the tech-doc sections that phase lists under **Read first**, not whole docs.

On the first phase that leaves **Not started**, set `Progress: implementing` in `<slug>.spec.md`. Do not rewrite the rest of the spec. When that Progress change lands, run [linear-sync/status.md](linear-sync/status.md) › Progress → Tracker Spec when write-back is allowed — Tracker Spec only; not a full sync (R11 (status mirror), R12 (selective tracker writes)).

## Phase selection

1. If a phase is `Started`, `Reviewing`, or `Blocked` → continue that phase. If it is `Started` from a prior session (not one just set in this turn), first inspect the scoped working-tree changes for that phase's deliverables, read-only (for example `git status` / `git diff` on the paths the phase names), and record what you find (matches plan, partial, or unexpected) before continuing — do not assume the tree matches the plan's Close-out, which may be empty. `Awaiting sign-off` is not this continue-target; it does not occupy the active slot (R4 (active slot)).
2. Else the first ready phase: not `Done`, `Deferred`, or `Awaiting sign-off`, and whose **Depends on** is satisfied (below).
3. **Depends on.** `—` means no dependency. Parse each token as a bare phase id or `<id> (needs sign-off)` (D4 (marker syntax)); any other shape is a defect — stop and name it. A token is satisfied when its target is `Done` or `Deferred`, or when the target is `Awaiting sign-off` and the token is unmarked (R5 (depends default)). A token is **not** satisfied when the target is `Blocked`, still open (`Not started` / `Started` / `Reviewing`), or `Awaiting sign-off` with the needs-sign-off mark — the dependent MUST NOT start until that clears (R5 (depends default), R7 (blocked dependents)). Name the blocking entry when stopping.
4. Before starting the unit, scan `<slug>.spec.md` **Open questions** for a **Blocks** line naming this phase (by number) or naming a gate this unit would cross. If one exists and is unresolved, stop and name the question instead of starting.
5. If **Combinable with** names the next siblings and the user wants one session, implement them together when the combined work still has one verifiable outcome.
6. A `Blocked` phase stalls only phases that list it in **Depends on**. Independents whose Depends on is satisfied MAY start (subject to the one-active-unit rule) (R7 (blocked dependents)). Unmarked `Awaiting sign-off` does not block unmarked dependents. If no ready phase remains and any phase is still `Awaiting sign-off`, go to Stop and resume › Batched sign-off — do not invent work.

When starting an allowed phase, set it to `Started`.

Before writing code, tell the user the phase, its tier, the reason, its **Close**, and the exact verify / Done-when command(s) that will run, so they can switch model or effort, see whether a person must continue, and see what will execute before it runs. A combinable group uses the highest tier among its members. Its **Close** is `human` if any member is `human`; otherwise `automated`. A sub-task uses its phase's tier and **Close**. When `Depth: lite` and the phase has no explicit tier reason that raises it, prefer **Low**.

Read **Close** from the progress overview. It must match the phase line. If **Close** is missing, or the two disagree, stop and ask. Do not treat a missing **Close** as `automated`.

Match the session to the tier:

- **Low.** Make the change and run verify.
- **Medium.** Read the linked tech section, and check the failure-mode scenarios before closing.
- **High.** Before writing code, state the approach and how it handles the deciding factor. Read the callers of any contract that changes. Ask before any fork. Record in **Close-out** how each failure mode was checked.

Match the session to **Close**. Run the **Gates** rows owned `automated`. Leave rows owned `human` unchecked. Do not treat a human check as passed because the review subagent was satisfied.

If the rating turns out wrong, update the label in the progress overview and the phase block, and record the change under **Close-out** deviations. If the work needs a person and **Close** says `automated`, set **Close** to `human` in the overview and on the phase, and record it under **Close-out**. Do not change `human` to `automated` unless the user asks.

## Serial SDD

**In short:** Multi-unit plans dispatch one fresh implementer at a time. One-phase (or one combinable unit) stays in the parent. Parallel implementers are forbidden.

1. Count remaining dispatch units (each open phase, or one combinable group as one unit). Prefer one active spec at a time unless the user is explicitly working on another.
2. **More than one unit left** → serial subagent-driven development (SDD): the parent MUST dispatch a fresh implementer for the next legal unit and MUST NOT keep implementing the next unit in the same bloated parent session. Soft escapes stay rare (already-started unit; short clarification; research-only) and MUST NOT become a second default.
3. **One phase, or already one combinable unit** → the parent implements in the current session (or one cloud paste). Serial multi-agent ceremony MUST NOT be required.
4. Parallel implementers MUST NOT run. Only one unit may be `Started`, `Reviewing`, or `Blocked` (R4 (active slot)). `Awaiting sign-off` MUST NOT count against that set. A unit starts only when Phase selection › **Depends on** is satisfied (unmarked `Awaiting sign-off` may satisfy; needs-sign-off and `Blocked` targets do not).
5. Default checkout is the shared working tree. Cloud, implementation branch, and worktree are separate Ask-before items (see below). Branch consent does not imply worktree, and the reverse does not hold.

### Phase brief

**In short:** Before each dispatch, the parent builds a chat-only phase brief from the active phase packet. Cloud adds an env checklist. The worker reads the brief and **Read first** only — not the full plan. Tracker Phase bodies in Linear reuse these same fields ([linear-sync/tracker-phases.md](linear-sync/tracker-phases.md) › Tracker Phase body).

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
| Close (`automated` or `human`) | yes |
| Gates | yes |
| Ask-before | yes (may be `—`) |
| Scoped paths | yes |
| Stop after this unit | yes |
| Non-goals for this unit | no |

Build the brief from the active phase packet (**Goal**, **Covers**, **Read first**, **Deliverables**, **Done when**, **Tier**, **Close**, **Gates**, **Not in this phase**, **Ask-before** from the plan plus this stage's Ask before, and scoped paths from deliverables / **Read first**). For a combinable unit, **Close** in the brief is `human` if any member is `human`. Include an explicit **stop after this unit** instruction so the worker does not start the next phase.

The brief is chat-only (or paste text for cloud). The parent MUST NOT write a durable brief file under the spec folder. The implementer MUST NOT be required to read the full plan or unrelated phases — only the brief and the linked **Read first** sections.

#### Env checklist (cloud companion)

When the user opted into a cloud agent for the unit, or the run already is a Cursor Cloud Agent, the parent MUST also supply this companion with the same phase brief. For a local subagent, omit unless useful.

| Field | Required |
| ----- | -------- |
| Verify runnable (yes / no + notes) | yes |
| Secret names (never values) | yes (may be "none") |
| Repo hooks only (cloud cannot assume `~/.cursor`) | yes |
| Status write-back (worker edits the plan on its checkout) | yes |
| Stop after this unit | yes |
| Integrate before next | yes |

**Integrate before next** is required whenever the worker runs on its own checkout or branch (cloud agent, or a local worktree/branch): the worker's branch (code + plan edits) MUST land in the shared checkout before a dependent unit may start. The runner MUST NOT grant branch or merge permission on its own (`SKILL.md` › Bounds forbids that); instead stop and ask the person to integrate the branch, then continue. A unit with no separate checkout (parent implements in the current session) has no integration step and may auto-continue per Stop and resume.

Secret names only: never put a token, password, key, or `.env` value in the brief, the Tracker Phase body, or Close-out.

Do not invent a project-level cloud opt-in in `spec_docs/README.md`. Chat consent (or already-in-cloud) is enough.

Keep this table and the Phase brief field list the source of truth for Tracker Phase body sections in [linear-sync/tracker-phases.md](linear-sync/tracker-phases.md) (R15 (cloud ready body)). When either side changes, update the other.

### Tracker Phase fallback create

Prefer create/refresh when the plan is written ([plan.md](plan.md) › Tracker Phases). If the active unit still has `Tracker phase: n/a` at or just before first implement on that unit, run [linear-sync/tracker-phases.md](linear-sync/tracker-phases.md) › Create when write-back is allowed (R4 (freeze before plan) fallback).

- **Allowed.** `<slug>.plan.md` exists, frontmatter `work_item` is a real id, conventions + Linear MCP ok → create missing Tracker Phase(s) for this unit only; write returned id(s); body from Phase brief / Env checklist fields. Then run [linear-sync/tracker-phases.md](linear-sync/tracker-phases.md) › Blockers for every unit that already has a real id, not only the unit just created.
- **Bare basename.** Only `implementation-plan.md` (no slug prefix) is present → stop and tell the user to rename it to `<slug>.plan.md` first (`SKILL.md` › Spec docs); do not read it as the plan.
- **`work_item: n/a` (or missing).** Skip; no Linear discovery on this routine hook (R22 (reference gate)).
- **No plan file.** Impossible here (preconditions require a plan); elsewhere Tracker Phases stay a no-op (R5 (thin noop)).
- **MCP / conventions missing.** Warn once; skip write-back; continue implement (R1 (conventions gate), R21 (mcp session)).

Do not auto-assign Cursor.

## Session checklist

- Scoped to one phase, one sub-task, or one combinable group.
- Before writing code: name the existing file to extend. A new file, module, or abstraction needs a one-line reason (reused by two or more callers, the existing file would become unwieldy, or a real lifecycle boundary). No new packages without asking.
- Smallest correct change. Do not start later phases.
- Do not add a second implementation of something that already exists nearby.
- Run the **Gates** rows owned `automated`: the default commands in **Verify tiers** for this phase's tier, plus any stronger command named in **Done when**. If **Verify tiers** is still the placeholder, ask. If the tier row is the explicit value `none` (no command by design), that is not a placeholder: the phase's **Close** must be `human`, or its **Gates** row must name review-observable evidence instead of a command — a `none` row with **Close** `automated` and no named evidence is a defect; stop and ask. Ask before running any command that is not already listed in **Verify tiers** or **Other commands** in `spec_docs/README.md`, or that pipes to a shell, fetches over the network, or touches paths outside the repo — name the command first and get a go-ahead. Record commands and the automated scenarios under **Close-out** as pass or fail plus a redacted excerpt. Leave **Gates** rows owned `human` unchecked. Record any deviation from advisory text under **Close-out** too.
- **Verify failure budget.** On a failing verify command, fix and re-run up to 2 more times (3 attempts total) in the same session. If it still fails, stop: set status `Blocked`, and fill the Close-out **Blocked** line with the reason, the date, and the last failing command, plus a short output summary (the error, not the full log) and which files were touched so far. Record that result as pass or fail plus a redacted excerpt. Do not mark `Reviewing` over a failing required command, and do not leave `Started` with no record of the failure.
- **No secret values.** Close-out records pass or fail and a redacted excerpt. Never paste tokens, passwords, keys, or secret-file contents.
- An out-of-scope finding goes under **Follow-ups** (added, phase, task, destination). Do not fix it in this phase.
- After verify, the worker MUST update the plan on its checkout: Done-when checkboxes, **Close-out**, and status to `Reviewing`. The worker MUST NOT mark `Done`. Report-only to the parent (no plan edit) does not count as finished (R6 (worker writeback), D9 (done timing)).
- **Regression Close-out (bugfix).** When the phase has a scenario marked **Regression: yes** (typical for `Kind: bugfix`), Reviewing / Done **Close-out** MUST record red-before-green for that scenario: the check failed without the fix and passed with it (command, manual repro, or equivalent). Green-only evidence for that scenario is a defect — do not mark `Reviewing` until it is recorded. This applies to the regression scenario only; it does not force TDD for every phase.
- Tell the user how to verify, and name any **Gates** row still owned `human`.

If implementation shows `<slug>.spec.md` scope, non-goals, or glossary are wrong, stop and update the spec, then the siblings that reference the change. Do not build around the mismatch.

## Phase status

Use these values in the progress overview (and on sub-tasks if present):

| Status | When |
| ------ | ---- |
| **Not started** | No work yet |
| **Started** | In progress, including a session that ends mid-phase or a fix re-dispatch |
| **Reviewing** | Worker finished automated verify and Close-out; agent review pending only (not the human sign-off halt) |
| **Awaiting sign-off** | Agent review passed; **Close** is `human`; person has not yet accepted (see D2 (status name)). Does not occupy the active slot |
| **Done** | Parent marks after the review passes when **Close** is `automated`, or after the person accepts from `Awaiting sign-off` when **Close** is `human`; every automated Done-when item verified and **Close-out** filled |
| **Deferred** | Remaining Done-when items for this phase deliberately dropped, and the drop is noted in **Close-out** or **Follow-ups** |
| **Blocked** | Stuck after exhausted fix budget or person Ask-before. Reason, date, and last failing command go on the Close-out **Blocked** line |

Only one phase (or combinable group) may be `Started`, `Reviewing`, or `Blocked` at a time. `Awaiting sign-off` MUST NOT count against that set (R4 (active slot)). Under serial SDD, after the parent marks a unit `Done` or moves it to `Awaiting sign-off`, the runner may start the next ready unit (Phase selection) whose **Close** is `automated` without asking (see Stop and resume). After review pass, **Close** `human` MUST move to `Awaiting sign-off` — MUST NOT leave `Reviewing` as the sole active halt (R3 (awaiting after review)). Otherwise leave later units `Not started` until continue or batch sign-off.

Ask before: a new dependency, a fork that changes the approach, a security or data-migration choice, cloud agent, implementation branch, worktree, commit / push / PR, archiving, or setting a phase to `Deferred`. Cloud, branch, and worktree are distinct asks — one does not imply another. Chat consent is enough; there is no project-level SCM opt-in. When the run already is a Cursor Cloud Agent, cloud consent is implied; extra branch / worktree / commit still need an ask unless that runner's normal branch story applies.

**Skip recorded pre-flight.** When an Ask-before item already has an Answer in the plan's top-level Pre-flight section, MUST NOT re-ask it (R2 (no re-ask)). Stop only for an unpredicted person input. When recording any Ask-before or Pre-flight answer that names a secret, record the secret **name** only — never the value — in the plan, Close-out, or Linear (R11 (secret names only)).

**MUST NOT:** Create a branch, worktree, or commit unless the user explicitly asked in this conversation. Default serial SDD uses the shared checkout.

### Tracker Phase status mirror

When a phase (or combinable unit) status changes in the plan, run [linear-sync/status.md](linear-sync/status.md) › Phase status → Tracker Phase when write-back is allowed (G3 (status mirror), R11 (status mirror), R12 (selective tracker writes)).

- Update **only** that unit’s Tracker Phase by its stored id. Combined phases that share one id → one update, using the least-advanced member rule in [linear-sync/status.md](linear-sync/status.md) › Phase status → Tracker Phase.
- On a real status delta, append a Tracker Spec progress-log comment; no-op → none (R13 (progress log)).
- MUST NOT prompt to confirm Linear on every phase Done. MUST NOT run full `/spec linear sync` for a routine status change.
- `Tracker phase: n/a` or frontmatter `work_item: n/a` (or missing) → skip that write (R22 (reference gate)). MCP / map missing → warn once; skip; continue implement (R1 (conventions gate), R21 (mcp session)).
- Linear MUST NOT drive plan status or Progress (G7 (repo canonical)).

## Review gate

**In short:** After the worker marks `Reviewing`, the parent runs exactly one review subagent. **Close** `automated` may then become `Done`. **Close** `human` moves to `Awaiting sign-off` and frees the active slot. Fail gets one autofix, then the same reviewer re-checks only its findings. Still failing → `Blocked`. Dual reviewers are forbidden.

After the worker marks `Reviewing`, the parent MUST run exactly one review subagent before marking `Done`, moving to `Awaiting sign-off`, or escalating (R7 (required review), D9 (done timing)). The review checks spec compliance and code quality for that unit only. It does not pass a **Gates** row owned `human`.

Pass the reviewer a Review packet with at least:

| Field | Required |
| ----- | -------- |
| Spec slug + phase id(s) | yes |
| Goals and rules in scope (full IDs) | yes |
| Deliverables and Done when | yes |
| Diff or changed paths | yes |
| Close (`automated` or `human`, from the plan) | yes |
| Close-out (commands, results, deviations) | yes |

The reviewer returns a verdict of `pass` or `fail`. For each automated **Gates** row, cite the **Close-out** result, re-run the cheapest automated row and record that result, or say why it could not be run. A packet with no Close-out is not a pass.

**On pass.** If **Close** is `automated`, the parent marks `Done` — MUST NOT enter `Awaiting sign-off`. If **Close** is `human`, move to `Awaiting sign-off` (R3 (awaiting after review), D2 (status name)) and free the active slot so another ready unit may start; MUST NOT leave `Reviewing` as the sole active halt after that pass. Do not infer **Close** from Done when. A missing or disagreed **Close** stops the run (see Phase selection).

**On fail.** Re-dispatch the implementer once for a bounded fix (D8 (review fail), D10 (fix budget)). The worker re-runs the automated **Gates** rows after the fix and updates **Close-out**. The same reviewer then re-checks only its findings (a continuation of that review, not a second reviewer). If findings remain after that attempt, mark `Blocked`, fill the Close-out **Blocked** line (reason, date, last failing command) and Follow-ups, and wait for continue.

A dual-reviewer loop (two review agents) MUST NOT be required.

## Stop and resume

**In short:** Auto-continue units whose **Close** is `automated`. After review pass, **Close** `human` → `Awaiting sign-off` (slot frees). Halt for `Blocked`, unpredicted Ask-before, or batched sign-off when the ready queue is empty. Resume finishes the open active unit first.

The runner MUST continue automatically across units whose **Close** is `automated` without asking "should I continue?" (R8 (stop resume)). It MUST NOT halt solely because the worker set `Reviewing` for the agent review gate when **Close** is `automated`. After that review passes, mark `Done` and start the next ready unit — unless that unit had its own checkout (cloud or branch/worktree), in which case integration gates the start (next bullet). After review pass on **Close** `human`, move to `Awaiting sign-off` (not stay `Reviewing`) and, when Phase selection allows, start the next ready unit (R3 (awaiting after review), R4 (active slot)).

It MUST stop when:

- No ready phase remains and one or more phases are `Awaiting sign-off` — batched sign-off (below)
- The unit is `Blocked` after a failed fix loop (independents may still be ready; see Phase selection)
- An Ask-before item only a person can answer **and** that item has no recorded Pre-flight Answer on the plan (R2 (no re-ask)). Skip re-asking recorded pre-flight items; secret answers record the name only (R11 (secret names only))
- The just-finished unit ran on its own checkout or branch (cloud agent, worktree, or branch) and a dependent unit is next: stop and ask the person to integrate that branch (code + plan edits) into the shared checkout before dispatching the dependent unit (see Env checklist › Integrate before next). A unit with no dependents, or a unit that was implemented directly in the shared checkout, is not gated by this.

### Batched sign-off

When Phase selection finds no ready unit and any phase is still `Awaiting sign-off`, the runner MUST list every pending human gate across those awaiting phases in **one** prompt (R8 (batched sign-off)). One reply MAY accept all of them, or name the ones it accepts. Accepted phases: record acceptance under **Close-out** (naming the human **Gates** rows in the set) and mark `Done`. Rejected phases follow cascade reopen below. A bare `implement` or `continue`, with no accept/reject wording, is not acceptance — show the batch set and stop. Do not ask the person to name each row, each scenario, or to repeat a set phrase unless they accept only some phases by name.

### Cascade reopen

On reject of a phase in `Awaiting sign-off`, reopen that phase (`Reviewing` or `Blocked` per implement rules) and MUST also reopen every later phase that ran while it was `Awaiting sign-off` (R9 (cascade reopen), D1 (cascade reopen)). Name the reopened phases to the person. Do not leave later Done work sitting on a rejected earlier verdict.

Resume uses the same `/spec implement` / continue entry: finish the open `Started` / `Reviewing` / `Blocked` unit first, then pick the next ready unit or run batched sign-off. The controller MUST NOT invent rulings that replace Ask-before for security or irreversible ops. The controller MUST NOT mark a human **Gates** row passed unless the person has accepted that phase's pending human gates (batch or named), or has named that row.

## Archive

When the user confirms the spec is done — including when they deliberately drop phases that are still `Not started` or `Deferred`:

1. **Refuse while awaiting.** If any phase is still `Awaiting sign-off`, stop and refuse archive until every phase is `Done` or `Deferred` (R10 (archive wait)). Tell the person to finish or defer those sign-offs first. Do not move the folder.
2. Note skipped or deferred phases in `<slug>.plan.md`, including anything left under **Follow-ups**.
3. **Validate the destination.** `spec_docs/archive/<slug>/` must not already exist (slugs are unique across `spec_docs/` and `spec_docs/archive/` — [create-spec.md](create-spec.md) › Slug). If it does, stop and ask; do not nest or overwrite.
4. **Archive gate (Linear).** Before marking the Tracker Spec Done, run [linear-sync/status.md](linear-sync/status.md) › Archive gate (R18 (archive gate)). Tracker Spec Done only when every referenced Tracker Phase is Done or Deferred; otherwise ask. Do not silently complete the Tracker Spec.
5. Move the whole folder `spec_docs/<slug>/` to `spec_docs/archive/<slug>/` (do not rename siblings as a side effect — R4 (no auto migrate)).
6. Set `Progress: archived` in `<slug>.spec.md`, now at its archived path. Set it last, only once the move succeeded, so an interruption before this point leaves the folder active (router re-offers archive) instead of falsely reporting `archived`.
7. When the Linear gate allowed (or the user confirmed past it), update only the Tracker Spec via selective Progress → Tracker Spec — not a full explicit sync.

Do not archive without explicit confirmation. If every phase is `Done`, or only `Done` plus `Deferred` (no `Awaiting sign-off` remains), offer archive and wait. Do not re-archive. Do not read other archive folders.
