# Serial subagent implement (SDD)

**Slug:** `multi-subagent`
**Progress:** tech
**Work item:** —
**Depends on:** —

## TL;DR

- **What:** Serial fresh implementers per plan phase, with a required review subagent after each unit.
- **Why:** Long plans burn parent context and judgment when one session implements phase after phase.
- **v1 includes:** Policy flip for serial implement, phase brief, required review agent, stop/resume at human review, cloud brief prep.
- **v1 excludes:** Parallel implementers, dual-reviewer loop, Linear kickoff, Cursor Plan dual-write, surprise SCM.

## Doc index

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file | Scope, goals, journeys, constraints, work split | yes |
| [business-logic.md](./business-logic.md) | Orchestrator rules, stop/resume, review gate | yes |
| [contracts.md](./contracts.md) | Phase brief shape and env checklist fields | yes |
| ui.md | Layout, interaction, states, copy | not needed |
| implementation-plan.md | Phases and phase status | pending |

## Source

> Investigation `spec_docs/investigations/multi-subagent.md` (25 Oct 2026), from todo "Use a multiple sub agent process". Direction settled there: Superpowers-style serial subagent-driven development (SDD), not parallel. Primary win is quality and context hygiene. Cloud prep is the same phase brief plus an env checklist; Linear kickoff stays a separate later spec.

## Problem and current behaviour

**In short:** Plans already carry a dependency graph and phase packets, but the skill forbids subagents, so multi-phase implement stays in one bloating parent session.

- **What already works.** Progress overview, `Depends on`, `Combinable with`, phase tier, and **Read first** are ready for a serial runner. Only one phase (or combinable group) may be `Started`, `Reviewing`, or `Blocked`.
- **What blocks fresh context.** `skills/spec/SKILL.md` says "Do not spawn subagents." The parent must implement the phase itself.
- **What burns quality.** One session walks phase after phase. Context grows; judgment falls. There is no supported path to a fresh implementer while keeping the progress overview as source of truth.
- **Cloud gap.** A cloud agent (or a human pasting into one) needs the same self-contained phase brief even when the runner is not a local subagent. Linear kickoff is out of scope here.

| Path | What it does today |
| ---- | ------------------ |
| `skills/spec/SKILL.md` | Forbids subagents; Bounds block surprise SCM |
| `skills/spec/stages/implement.md` | One phase or combinable group; one Started unit |
| `skills/spec/design-quality.md` | Combinable siblings; Depends on as order gate |
| `skills/spec/templates/implementation-plan.md` | Progress overview and phase packet shape |

## Goals and acceptance criteria

**In short:** Multi-phase implement runs serial SDD by default. One-phase stays in the parent. Each unit gets a brief, a required review agent, and clean status write-back. Human review stops the runner until resume.

### G1 (serial implementers) — Multi-phase implement uses a fresh context per dispatch unit

Source: investigation success sketch

- For a multi-phase plan, `/spec implement` (or continue) runs **serial** fresh implementers: one phase, or one combinable group marked as one unit, at a time.
- A new subagent (or equivalent clean context) is the **default** for each new dispatch unit. The parent does not keep implementing the next phase in a bloated session.
- Only one unit may be `Started`, `Reviewing`, or `Blocked` at a time (unchanged).
- Parallel implementers are forbidden.
- Thin or one-phase specs (including a plan that is already one combinable unit) stay in the parent. Serial SDD orchestration is not required there. Skip-processed stays simple.

### G2 (phase brief) — Each dispatch unit gets a defined phase brief

Source: investigation cloud prep + Superpowers brief habit

- The brief is the implementer's input for local subagent and for cloud paste. It is not the whole plan.
- The brief includes at least: phase identity, goals covered, **Read first**, deliverables, Done when, tier, Ask-before list, and scoped paths.
- The implementer must not be required to read the full plan or unrelated phases.
- An optional **env checklist** accompanies the brief for cloud runs (verify runnable, secrets/MCP expectations, stop after this unit).

### G3 (review agent) — A required review subagent runs after each implementer unit

Source: investigation settled review rule; D8 (review fail), D9 (done timing)

- After each implementer unit finishes its scoped work, the worker marks `Reviewing`, then the parent runs **one** review subagent before Done or escalate.
- The review checks spec compliance and code quality for that unit.
- On review pass: parent marks `Done` when the unit is agent-closable; otherwise `Reviewing` stays for human sign-off and the runner halts.
- On review fail: bounded implementer fix loop, then `Blocked` with findings if still failing (D8 (review fail)).
- A mandatory dual-reviewer loop (two separate review agents) is out of scope.

### G4 (stop resume) — Serial dispatch stops for human gates and resumes from the same entry point

Source: investigation stop/resume

- The runner continues automatically across agent-closable units (verify + Done when allow Done without a person).
- It does **not** halt solely because the worker set `Reviewing` for the agent review gate. It **stops** when human sign-off is still required after that pass, on `Blocked` after a failed fix loop, or on an Ask-before item only a person can answer (D8 (review fail), D9 (done timing)).
- Resume is the same `/spec implement` / continue entry: finish or continue the `Reviewing` / blocked unit after the human is done, then pick the next ready unit.
- The controller does not invent rulings that replace Ask-before for security or irreversible ops.

### G5 (status writeback) — The worker updates the plan on its checkout

Source: investigation status writer; D9 (done timing)

- The implementer worker **must** update `implementation-plan.md`: status to `Reviewing` after verify, Done-when checkboxes, and **Close-out**.
- The worker MUST NOT mark `Done` before the required review agent passes.
- Report-only to the parent (comment-only, no plan edit) is not enough.
- The progress overview remains the source of truth for what may start next.

### G6 (scm consent) — Cloud, branch, and worktree stay ask-before; branch is not worktree

Source: investigation cloud/SCM consent; preserves adapt-superpowers no-surprise-SCM

- Chat consent is enough: for example "use a cloud agent", "use a worktree", or "create an implementation branch." No project-level opt-in in `spec_docs/README.md`.
- When the run **already is** a Cursor Cloud Agent (or was started into cloud from elsewhere), cloud consent is **implied**. Extra branches, worktrees, or commits still need an ask unless the cloud runner's normal branch story applies.
- An **implementation branch** (same checkout, new git branch) and a **worktree** (separate checkout, usually with its own branch) are named distinctly. Asking for one does not imply the other.
- Default serial SDD uses the shared checkout. No surprise SCM.

### G7 (cloud ready brief) — Cloud uses the same brief; Linear kickoff is not this spec

Source: investigation prepare-for-cloud

- Cloud dispatch, when opted in, uses the same phase brief and env checklist as local SDD.
- Cloud still runs **one** next-ready unit at a time (deps satisfied), not N writers at once.
- Wiring cloud start from Linear (or issue kickoff) is deferred to a separate spec.

## Non-goals

- Parallel implementers, ready-set fan-out, or worktree-based parallel writers (later only if a separate investigation reopens it).
- Redefining `Combinable with` as parallel-safe, or adding a `Parallel with` column.
- Making SDD the only implement path (one-phase / thin / skip-processed stay simple).
- Replacing outcome-sized phases with Superpowers-style 2–5 minute paste tasks.
- Mandatory dual-reviewer loop (two review agents) as in full Superpowers SDD.
- Automatic branch, worktree, or commit without chat ask (see G6 (scm consent)).
- Dual-write or competition with Cursor Plan / "Build in Parallel."
- Linear kickoff / cloud-from-issue wiring (separate later spec).
- Autonomous controller rulings that replace Ask-before for security or irreversible ops.

## Users and context

- **Primary user:** A developer running `/spec implement` (or continue) on a multi-phase plan in Cursor.
- **When:** After `Progress` is `plan` or `implementing`, while walking phases.
- **Who may do this:** Anyone who can run the spec skill in the project; same as today's implement.

## User journeys

### Multi-phase serial implement

Starting point: The user asks to implement or continue a multi-phase plan with more than one dispatch unit left.

1. The parent picks the next legal unit from the progress overview (`Depends on` satisfied; only one active unit).
2. It builds a chat-only phase brief and dispatches a fresh implementer for that unit only (D7 (brief medium)).
3. The worker implements, verifies, updates Done when / Close-out, and marks `Reviewing` (D9 (done timing)).
4. The parent runs the required review subagent on that unit.
5. If review passes and the unit is agent-closable, the parent marks `Done` and continues to the next ready unit without asking "should I continue?"
6. If review passes but human sign-off is still required, `Reviewing` stays and the runner **halts**. On review fail: bounded fix loop, then `Blocked` if still failing (D8 (review fail)). Person Ask-before also halts.

End state: Either the next human gate is waiting, or every agent-closable ready unit in the chain has been processed until a stop.

Goes wrong when:

- Parent keeps implementing in one session without a fresh context — G1 (serial implementers).
- Worker leaves status stale — G5 (status writeback).
- Runner starts the next phase while this unit is still `Reviewing` — G4 (stop resume).

Covers: G1 (serial implementers), G2 (phase brief), G3 (review agent), G4 (stop resume), G5 (status writeback)

### Resume after human review

Starting point: A phase is `Reviewing` (or blocked on a person Ask-before). The human has finished sign-off or answered.

1. The user says implement / continue.
2. The parent continues that same unit (not a parallel sibling).
3. After close, it picks the next ready unit and resumes serial SDD as in the first journey.

End state: Human gate cleared; serial dispatch continues or the plan has no more ready agent-closable units.

Goes wrong when:

- Parent invents a ruling instead of waiting for the person — G4 (stop resume).

Covers: G4 (stop resume)

### One-phase or single combinable unit

Starting point: The plan has only one phase, or work that is already one combinable unit.

1. The user asks to implement.
2. The parent implements in the current session (or one cloud paste). No serial multi-agent orchestration.
3. Status and Close-out update as today.

End state: That unit is Done or Reviewing; no unused orchestrator ceremony.

Goes wrong when:

- Skill forces subagent overhead for a single unit — G1 (serial implementers) exception.

Covers: G1 (serial implementers)

### Optional cloud phase with the same brief

Starting point: The user asks to use a cloud agent for the next unit, or the run already is a cloud agent.

1. Parent (or human) uses the phase brief plus env checklist.
2. Cloud worker updates the plan on its branch/checkout for that unit only.
3. After Done (and any project-required integrate), the next dependent unit may start — still serial.

End state: One cloud unit completed with status write-back; no silent next-phase start.

Goes wrong when:

- Cloud agent starts phase N+1 without consent — G2 (phase brief) and G7 (cloud ready brief) require a stop-after-this-unit brief.
- Extra worktree created because "cloud" was said — G6 (scm consent).

Covers: G2 (phase brief), G6 (scm consent), G7 (cloud ready brief)

## Constraints

- **Preserve:** One Started / Reviewing / Blocked unit; `Depends on` / `Combinable with` semantics; progress overview as source of truth; Bounds no-surprise-SCM unless asked (G6 (scm consent)).
- **i18n:** n/a
- **Accessibility:** n/a
- **Security:** Ask-before for security and irreversible ops stays; controller must not replace it.
- **Performance:** Extra agent seats and review latency are accepted for quality; parallel wall-clock is not a v1 goal.

## Notes

- **Inspiration.** Shape comes from Superpowers `subagent-driven-development` (serial implementer then reviewer). Parallel domain agents and Build in Parallel are deliberately not the model.
- **Combinable unchanged.** Means same session / same dispatch unit for one reviewable outcome. Not a parallel signal.
- **Tier.** Phase tier remains the signal for model / effort choice on the implementer (and combinable group uses the highest member tier).
- **adapt-superpowers.** That spec already deferred "SDD as required path" and forbade surprise SCM. This spec adds **optional** serial SDD as the default for multi-phase implement, without making it the only path.

## Concerns

- **Status desync.** Worker marks Done on a branch; parent never reconciles; archive lies. If left: progress overview cannot be trusted — G5 (status writeback).
- **Policy wording.** Softening "Do not spawn subagents" without a crisp implement-only exception invites misuse. If left: parallel or surprise SCM creeps in — D1 (serial default), G6 (scm consent).
- **Cost.** N phases × implementer × required reviewer × fix loops. If left unstated: users expect cheap fan-out; docs must say serial and quality-first.
- **False "parallel" expectation.** Old todo wording said parallel. If left: skill text must say serial clearly everywhere implement spawns agents.

## Proposed solution

**In short:** Flip implement policy to Superpowers-style serial SDD for multi-phase plans. Keep one active unit. Share one phase brief with cloud. Stop for humans; resume from the same gate.

The parent becomes a thin orchestrator on `/spec implement` / continue when the plan has multiple dispatch units. It selects the next legal unit, passes a chat-only phase brief, spawns one implementer, requires one review subagent after the worker marks `Reviewing`, marks `Done` on pass when agent-closable (or leaves `Reviewing` / `Blocked` per D8 (review fail) and D9 (done timing)), then either continues or halts for a human gate.

One-phase and already-single-unit plans stay in the parent. Parallel remains forbidden. SCM stays ask-before, with branch and worktree named separately, and cloud consent implied only when already in cloud.

### Capabilities (v1)

- **Serial orchestrator.** Parent may spawn subagents for implement; one implementer at a time; fresh context per new unit by default.
- **Phase brief.** Chat-only packet for local and cloud paste; plus env checklist for cloud (D7 (brief medium)).
- **Required unit review.** One review subagent after each implementer unit; bounded fix then Blocked on fail (D8 (review fail)).
- **Stop / resume.** Auto-continue agent-closable units; halt when `Reviewing` remains for a human or on person Ask-before; same entry to resume.
- **Worker write-back.** Implementer updates plan to `Reviewing` and Close-out; parent marks `Done` after review pass when agent-closable (D9 (done timing)).

## Touched paths

| Path | Area | Change |
| ---- | ---- | ------ |
| `skills/spec/SKILL.md` | Skill policy | Allow serial implement subagents; keep Bounds |
| `skills/spec/stages/implement.md` | Implement stage | Orchestrator, brief, review, stop/resume |
| `skills/spec/design-quality.md` | Plan quality | Brief/orchestrator expectations if needed |
| `skills/spec/templates/implementation-plan.md` | Plan template | Brief-oriented phase packet clarity if needed |
| `skills/spec/writing-style.md` | — | Only if implement copy needs style rules |

## Work split

1. **Policy and stage contract.** Covers G1 (serial implementers), G4 (stop resume), G6 (scm consent). Outcome: SKILL and implement stage allow serial SDD, forbid parallel, document one-phase parent path and SCM consent. Main surface: skill markdown.
2. **Phase brief and env checklist.** Covers G2 (phase brief), G7 (cloud ready brief). Outcome: Defined brief contents and cloud env checklist; implementer must not need the whole plan. Main surface: implement stage + templates / contracts.
3. **Review gate and status write-back.** Covers G3 (review agent), G5 (status writeback), D8 (review fail), D9 (done timing). Outcome: Worker marks `Reviewing`; required review agent; bounded fix then `Blocked`; parent marks `Done` on agent-closable pass. Main surface: implement stage.

## Glossary

- **Dispatch unit:** One phase, or one combinable group the plan marks to do together, as a single brief and review.
- **Phase brief:** Self-contained packet for one dispatch unit (not the full plan).
- **Serial SDD:** Fresh implementer per unit, then required review agent, then the next unit — never parallel implementers.
- **Agent-closable:** Unit can reach Done from verify + Done when without a person.
- **Implementation branch:** New git branch on the same checkout.
- **Worktree:** Separate checkout (usually with its own branch); not the same ask as implementation branch.

## Decisions

### D1 (serial default) — Default multi-phase implement is serial SDD, not parallel

- **Date:** 25 Oct 2026 · **Area:** implement orchestration
- **Why:** Primary win is quality and context hygiene. Parallel writers cause merge conflicts; Superpowers forbids them for plan execution for the same reason.
- **Rejected:** Parallel ready-set fan-out; document-only "open a new chat yourself"; Cursor Plan dual-write as the skill default.

### D2 (combinable meaning) — Combinable keeps same-unit meaning

- **Date:** 25 Oct 2026 · **Area:** plan semantics
- **Why:** Planners already mark true siblings for one outcome. Orchestrator trusts the table; does not second-guess High siblings.
- **Rejected:** Redefining Combinable as parallel-safe; adding `Parallel with`.

### D3 (unit of dispatch) — One brief per phase or marked combinable group

- **Date:** 25 Oct 2026 · **Area:** orchestrator
- **Why:** Matches today's implement session size and one verifiable outcome.
- **Rejected:** Splitting combinable siblings across parallel writers.

### D4 (required single reviewer) — One review subagent after each unit is required

- **Date:** 25 Oct 2026 · **Area:** quality gate
- **Why:** Spec compliance and code quality need a fresh reviewer; cost accepted.
- **Rejected:** No automated review (human-only); mandatory dual-reviewer (two agents) loop in v1.

### D5 (fresh context exceptions) — Default always fresh; rare escapes only

- **Date:** 25 Oct 2026 · **Area:** implement
- **Why:** Avoid bloated parent across phases; still skip ceremony for one-phase / single-unit plans.
- **Rejected:** Hard zero-exception rule; optional rare-mode only (fresh must be the default for multi-phase).

### D6 (cloud prep scope) — Brief + env checklist only; Linear later

- **Date:** 25 Oct 2026 · **Area:** cloud
- **Why:** Unblocks paste/cloud runners without coupling to Linear status sync.
- **Rejected:** Linear kickoff in this v1; dual-write to Cursor Plan format.

### D7 (brief medium) — Phase brief is chat-only; no durable file

- **Date:** 25 Oct 2026 · **Area:** phase brief
- **Why:** One payload to the subagent (or paste into cloud) is enough; a durable brief file adds ceremony without a v1 reader.
- **Rejected:** Durable file under the spec folder or temp (option B); either-mode with optional file (option C).

### D8 (review fail) — Bounded fix loop, then Blocked with findings

- **Date:** 25 Oct 2026 · **Area:** review gate
- **Why:** Cheap agent fixes should run before bothering a human; exhausted budget must leave a clear Blocked unit with findings.
- **Rejected:** Immediate human escalate with no fix loop (option B alone); Blocked-first without an autofix attempt.

### D9 (done timing) — Worker marks Reviewing; Done only after review pass (or human gate)

- **Date:** 25 Oct 2026 · **Area:** status write-back
- **Why:** Prevents Done-before-review; `Reviewing` is the post-verify gate. Parent marks `Done` when the agent review passes and the unit is agent-closable; otherwise `Reviewing` stays for human sign-off.
- **Rejected:** Worker marks Done before review (option A); worker leaves Started for parent-only Done (option B).
