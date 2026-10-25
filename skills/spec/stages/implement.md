# Implement one phase, or archive

Execute one phase (or one sub-task, or one combinable group) of `implementation-plan.md`. Prefer one active spec at a time unless the user is explicitly working on another.

## Preconditions

1. Open `spec_docs/<slug>/`. If it is under `archive/`, stop unless they asked for a doc correction.
2. `Progress` is `plan` or `implementing`, and `implementation-plan.md` exists with no `{{…}}` and no `[SUGGESTION:`. If not, stop and name the missing gate.
3. Read `spec.md`, the plan's **progress overview**, and the **active phase** section. Read only the tech-doc sections that phase lists under **Read first**, not whole docs.

On the first phase that leaves **Not started**, set `Progress: implementing` in `spec.md`. Do not rewrite the rest of the spec.

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

## Session checklist

- Scoped to one phase, one sub-task, or one combinable group.
- Before writing code: name the existing file to extend. A new file, module, or abstraction needs a one-line reason (reused by two or more callers, the existing file would become unwieldy, or a real lifecycle boundary). No new packages without asking.
- Smallest correct change. Do not start later phases.
- Do not add a second implementation of something that already exists nearby.
- Run the default commands in **Verify tiers** for this phase's tier, plus any stronger command named in **Done when**. If **Verify tiers** is still the placeholder, ask. Record commands, results, and the scenarios checked under **Close-out**. Record any deviation from advisory text there too.
- An out-of-scope finding goes under **Follow-ups** (added, phase, task, destination). Do not fix it in this phase.
- Update phase status and Done-when checkboxes in the plan before ending the session.
- Tell the user how to verify.

If implementation shows `spec.md` scope, non-goals, or glossary are wrong, stop and update the spec, then the siblings that reference the change. Do not build around the mismatch.

## Phase status

Use these values in the progress overview (and on sub-tasks if present):

| Status | When |
| ------ | ---- |
| **Not started** | No work yet |
| **Started** | In progress, including a session that ends mid-phase |
| **Reviewing** | Scoped work done, verify passed, waiting on manual QA or sign-off |
| **Done** | Every Done-when item verified, and **Close-out** filled |
| **Deferred** | Remaining Done-when items for this phase deliberately dropped, and the drop is noted in **Close-out** or **Follow-ups** |
| **Blocked** | Stuck — one-line reason |

Only one phase (or combinable group) may be `Started`, `Reviewing`, or `Blocked` at a time. After close, leave the next phase `Not started` until the user asks to continue.

Ask before: a new dependency, a fork that changes the approach, a security or data-migration choice, git branch / worktree / commit / push / PR, archiving, or setting a phase to `Deferred`.

**MUST NOT:** Create a branch, worktree, or commit unless the user explicitly asked in this conversation.

## Archive

When the user confirms the spec is done — including when they deliberately drop phases that are still `Not started` or `Deferred`:

1. Note skipped or deferred phases in the plan, including anything left under **Follow-ups**.
2. Set `Progress: archived` in `spec.md`.
3. Move `spec_docs/<slug>/` to `spec_docs/archive/<slug>/`.

Do not archive without explicit confirmation. If every phase is `Done`, or only `Done` plus `Deferred`, offer archive and wait. Do not re-archive. Do not read other archive folders.
