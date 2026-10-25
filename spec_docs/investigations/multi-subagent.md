# Investigation: multi-subagent / serial phase implementers

**Status:** investigation complete — ready to promote to a spec (not yet binding)  
**Source todo:** `spec_docs/todos.md` — "Use a multiple sub agent process"  
**Date:** 25 Oct 2026  
**Direction (settled in discussion):** Superpowers-style **serial** SDD — fresh subagent (or equivalent fresh context) **per phase**, required review subagent after each unit, never parallel implementers. One-phase / combinable-as-one stay in the parent. Primary win is **quality / context hygiene**, not wall-clock fan-out. Cloud prep = phase brief + env checklist (Linear kickoff later, separate).

---

## One-line takeaway

You already have a **dependency graph** and **phase packets** (`Depends on`, Read first, Done when). Superpowers SDD is the right shape: **one implementer at a time**, fresh context per unit of work, required review subagent after each unit — **not** parallel implementers (merge conflicts). The gap is flipping "Do not spawn subagents" into an **orchestrated serial** implement mode (and preparing the same phase brief for cloud), not inventing parallelism.

---

## What Superpowers actually does

Two different skills are easy to conflate. **Only the first matches the intended direction.**

### 1. `subagent-driven-development` (plan execution) — **steal this shape**

- Fresh **implementer** subagent per plan task, then a **task reviewer** (spec compliance + code quality), then the next task.
- Controller keeps a **ledger** (git-ignored workspace) so progress survives compaction.
- Task brief is extracted to a file; the subagent must **not** read the whole plan.
- Model selection by task hardness (cheap for mechanical, stronger for judgment / final review).
- Explicit rule: **never dispatch multiple implementation subagents in parallel** (file conflicts).
- Continuous: do not pause between tasks for "should I continue?" — **we keep that for agent-closable phases**, but **stop** when the plan needs human review (`Reviewing` / person Ask-before) and resume after.
- Swarm / parallel worktrees for independent plan tasks is a **requested** enhancement ([obra/superpowers#464](https://github.com/obra/superpowers/issues/464)), not the current skill — **and we are not taking that path.**

So "process the implementation plan with parallel sub-processors" (as the loose todo phrased it) is **not** what Superpowers ships, and **not** what we want. We want **serial** sub-processors with fresh context per phase; a **separate reviewer subagent after each phase** (not parallel implementers).

### 2. `dispatching-parallel-agents` (independent domains) — **out of scope for this todo**

- Used when several **unrelated** problems can be investigated/fixed without shared state (classic: failing tests in different files).
- Dispatch several agents in **one** parent response → concurrent.
- Integrate + run full suite after; avoid when fixes would collide or share root cause.

Useful elsewhere (research, multi-bug triage). **Not** the implement-plan runner for this skill.

### Habits worth stealing vs habits we already rejected

| Habit | Superpowers | This skill today | Steal? |
| ----- | ----------- | ---------------- | ------ |
| Fresh context per unit of work | Yes (per task) | One session, one phase; "Do not spawn subagents" | **Yes — default** for implement (see note below) |
| Brief file, not whole plan | Yes | "Read first" + active phase only | Already aligned in spirit |
| Per-task review gate | Spec + quality reviewer | User / implement session Close-out | **Yes — required** (one review subagent; not Superpowers' dual-reviewer loop) |
| Ledger / resume map | Required | Phase status in plan | Keep as is |
| Parallel implementers | Forbidden | Also forbidden (one Started phase) | **No** — only sequentially |
| Auto worktree / branch + commits | Common in their flow | Explicitly forbidden (G6 / D6 in adapt-superpowers) | Only with user ask; branch ≠ worktree |
| Pasteable micro-tasks | Default plan shape | Rejected (outcome phases, guided Approach) | No |
| SDD as required path | Default for plans | Non-goal in adapt-superpowers | Keep optional (mode, not the only path) |

**Fresh context — default always, rare exceptions.** For each **new** phase (or combinable group as one unit), use a new subagent / clean context. Do **not** keep implementing the next phase in a bloated parent. Settled exceptions: **single-phase** (or already one combinable unit) specs — stay in the parent; there is no serial multi-phase story to orchestrate. Other rare escapes (tiny work inside an already-started phase; user explicitly continuing after a short clarification; research-only turns) stay as soft escapes, not a second mode.

---

## What this repo already enables

The todo's "we have created a system that enables this" points at the plan **progress overview** and phase structure, not at a runner.

Already present:

- **`Depends on`** — hard order gate; a phase may start only when every listed dependency is `Done` or `Deferred`.
- **`Combinable with`** — names true siblings so one *session* (or one serial dispatch unit) can do them together when there is still one verifiable outcome. **Not** a parallel signal; leave semantics as today.
- Optional Mermaid when there are many phases.
- **Phase tier** — already a signal for model / effort choice (maps cleanly to Superpowers' model-selection idea).
- **Read first** — scoped context for an implementer who was not in the design chat (implementer test in design-quality).

What currently **blocks** serial multi-agent execution:

| Constraint | Where | Effect |
| ---------- | ----- | ------ |
| "Do not spawn subagents" | `skills/spec/SKILL.md` | Parent must do the phase itself; no fresh implementer |
| Only one phase (or combinable group) `Started` / `Reviewing` / `Blocked` | `stages/implement.md` | Correct for serial — **keep** |
| No surprise worktrees / commits | SKILL Bounds, implement, adapt-superpowers G6 | Fine for serial shared-checkout SDD; cloud/worktree still need opt-in |
| Prefer one active spec at a time | implement.md | Soft bias; orthogonal |

So: **graph and phase packets are ready; the serial orchestrator and policy flip are not.**

**Combinable (settled):** keep meaning **"same session / same dispatch unit, together"** for one reviewable outcome. Do **not** redefine as parallel-safe. No `Parallel with` column for this direction.

---

## Cursor platform (2026) — relevant primitives

These matter for "prepare for cloud agents" as much as for local subagents.

| Mechanism | Isolation | Fits which job |
| --------- | --------- | -------------- |
| Subagents in one chat (`Task`, etc.) | Shared checkout by default | **Serial** phase implementers + required reviewer after each unit (intended path) |
| Subagents + explicit isolation | Own worktree or cloud env + branch | Optional for cloud / user-opt-in SCM — not for parallel fan-out |
| Agents Window worktrees | Separate local checkout per agent | Human-supervised tracks; not required for serial SDD |
| Cloud Agents | Own VM, clone, branch | Walk-away **one phase (or remaining plan) at a time**; same serial discipline |
| Cursor plan "Build in Parallel" | Dependency-aware step scheduling | Complementary platform feature; **not** our implement default |

Cloud agents need a usable environment (`.cursor/environment.json` / builds / secrets). A phase that cannot verify in that environment is a bad cloud candidate regardless of graph structure. Cloud dispatch should still be **serial ready-set** (next legal phase only), not N writers at once.

---

## Problem framing (for a future spec)

**Problem:** Long plans burn **parent context** and judgment quality when one session implements phase after phase. The skill forbids subagents, so there is no supported way to get Superpowers-style fresh implementers while keeping one Started phase and the progress overview as source of truth. Separately, cloud agents need the same **phase brief** even when the runner is "human pastes into Cloud Agent."

**Non-problems (do not solve in v1):**

- Parallel implementers / fan-out wall-clock (rejected — merge conflicts; Superpowers forbids it for good reason).
- Replacing outcome-sized phases with Superpowers 2–5 minute paste tasks.
- Making SDD the only implement path (keep skip-processed / thin specs simple).
- Auto-committing or auto-worktreeing without an explicit mode / user ask.
- Redefining `Combinable with` as parallel-safe.

**Success sketch (this investigation — settled):**

- `/spec implement` (or an explicit SDD mode) runs **serial** fresh implementers: one phase (or combinable group) at a time; worker updates plan status; **required** review subagent after each unit (separate from human `Reviewing`).
- Continues to the next ready unit until a phase needs **human** review (`Reviewing` / Ask-before that only a person can answer), then **stops**; resume continues from that phase when the human is done.
- Phase brief (+ cloud env checklist) is a defined artifact for local subagent and cloud paste; Linear kickoff stays in the other todo.
- Progress overview remains the source of truth; still only one Started / Reviewing / Blocked phase.
- Parallel remains forbidden unless a later, separate investigation reopens it with isolation — **not this todo.**
- Thin / one-phase specs: no need for serial SDD orchestration — implement in the parent (or one cloud paste); skip-processed stays simple.

---

## Options (execution modes)

### Option A — Document-only / opt-in by user instruction

Keep "Do not spawn subagents" as default. Teach users: "open a new chat or cloud agent per phase yourself; update status carefully."

| Pros | Cons |
| ---- | ---- |
| No skill risk; preserves G6 | Easy to desync status; no standard brief |
| Zero new failure modes in the skill | Leaves the todo half-done |
| Matches "one phase per session" mental model | Doesn't use the graph you already write |

### Option B — Orchestrator parent (serial SDD-style) — **preferred**

Parent may spawn subagents; still **one implementer at a time**. Subagent gets brief = phase block + Read first + paths. **Worker** updates plan status; parent runs a **required** review subagent after each unit. Fresh context is the **default** for each new phase, not a rare mode. Auto-continue across agent-closable units; **halt** on human `Reviewing` / person Ask-before until resume.

| Pros | Cons |
| ---- | ---- |
| Closest to Superpowers SDD; matches settled intent | Cost (extra agent seats + required reviewer) |
| Fresh context; controller stays small; one-Started preserved | Reviewer cost on every phase — accepted |
| Softens "Do not spawn subagents" without inviting merge wars | Rare in-session continue escapes must stay crisp |

**When it helps:** every **multi-phase** plan; resume via status table (incl. after human review); model routing by tier; cloud using the same brief. One-phase / combinable-as-one: parent (or one paste) is enough.

### Option C — Parallel ready-set (local, with isolation) — **rejected for this direction**

Parent computes ready set and dispatches N isolated implementers.

| Pros | Cons |
| ---- | ---- |
| Wall-clock on fan-out plans | Merge conflicts; status races; G6 tension |
| Uses Depends on | Harder to reason about; contradicts Superpowers + our choice |

Kept only so a future doc can reopen it; **do not** build in the multi-subagent v1.

### Option D — Cloud-first phase dispatch (serial)

Each **next** ready phase (deps satisfied) is a Cloud Agent prompt with folder path, phase id, Read first, Done when, and "update Close-out / status on the branch." Parent or human merges; then the next phase. Same serial rule as B.

| Pros | Cons |
| ---- | ---- |
| Natural isolation (VM + branch) | Needs good cloud environment; secrets; verify story |
| Matches Linear todo ("start cloud agent to implement") | Status sync across branches is hard (same concern as Linear sync) |
| Walk-away without local context bloat | Cost; latency; harder interactive Q&A mid-phase |

Compatible with B: same brief, different runner.

### Option E — Dual-write / hand off to Cursor Plan parallel — **defer / low priority**

Keep `implementation-plan.md` as the contract; optionally sync a Cursor-native plan for "Build in Parallel."

| Pros | Cons |
| ---- | ---- |
| Reuse platform UI | Two plan representations → drift; pushes parallel we don't want as default |
| Less custom orchestrator | Spec skill loses Close-out / tier / Ask-before control |

Not aligned with serial-first; revisit only if users demand platform parallel later.

### Option F — Hybrid serial + optional cloud — **recommended shape**

Default implement path: **serial SDD (Option B)** with fresh context per phase. Cloud (Option D) uses the same phase brief when the user opts in (or when the run already *is* a cloud / Linear-started agent — consent implied). No parallel mode. No surprise branches / worktrees / commits (G6) unless the user asks — including an optional **implementation branch** (shared checkout) or **worktree** (separate checkout + usually its own branch); those are related but not the same ask.

**Stop / resume:** serial dispatch continues automatically across agent-closable phases, but **stops** when the plan needs human review (`Reviewing`, or an Ask-before that only a person can answer). Resume is the same entry point: continue the `Reviewing` / blocked phase after the human finishes, then pick the next ready unit.

| Pros | Cons |
| ---- | ---- |
| Matches Superpowers + our decisions | Template / SKILL surface for brief + mode |
| Graph reused; Combinable unchanged | Document rare fresh-per-phase escapes (one-phase stays in parent) |
| Prepares cloud (brief + env) without Linear coupling | — |

---

## When parallel would have been a good idea (parked)

Previously useful as a design checklist; **not in scope** now. If someone reopens parallel later:

**Would have been good candidates:** fan-out after a shared foundation; disjoint paths; independent verify surfaces; read-mostly research beside one writer.

**Still bad even then:** shared modules/schema; high-tier lifecycle work; open questions blocking many phases; Combinable siblings meant as one outcome; short dependency chains.

**Our rule now:** do not parallelize implementers. Sequential fresh contexts avoid merge conflicts; Combinable means "do together in one unit," not "run two writers."

---

## Design decisions a future spec must make

**Settled in this investigation:**

1. **Intent:** Superpowers **SDD** (serial fresh implementers + required review subagent). Not parallel domain agents, not Build in Parallel as the skill default. Primary win: **quality / context**, then walk-away cloud via the same brief — not wall-clock fan-out.
2. **Combinable:** keep current meaning; **do not** split or redefine for parallel.
3. **Parallel implementers:** **no.**
4. **Unit of dispatch:** one brief = one phase, **or** a combinable group as one brief when the plan marks them combinable. High-tier / hard-to-combine cases are already handled when writing the plan (combinable group takes the highest member tier; planners should not mark High siblings combinable unless they truly share one outcome). Orchestrator does not second-guess the table.
5. **G6 / cloud & SCM consent:** chat consent is enough — e.g. "use a cloud agent", "use a worktree", "create an implementation branch." No project-level opt-in in `spec_docs/README.md`. When the run **already is** a Cursor Cloud Agent (or was started from Linear into cloud), cloud consent is **implied**; still do not create extra branches / worktrees / commits unless asked (or the cloud runner's normal branch story applies).
6. **Branch vs worktree:** optional **implementation branch** (same checkout, new git branch) is a valid ask and is **not** the same as a **worktree** (separate checkout, usually paired with its own branch). Spec should name both under G6 ask-before, not treat "worktree" as covering "new branch."
7. **Status writer:** the **worker must** update `implementation-plan.md` (status, Done-when, Close-out) on its branch / checkout. Not report-only for the parent.
8. **Ask-before / human vs agent:** already defined by the plan + implement statuses — agent closes what verify + Done when allow; **`Reviewing`** (and Ask-before items that need a person) escalate to the human. Serial SDD **stops** at that gate and **resumes** when the human finishes; do not invent controller "rulings" that replace Ask-before for security / irreversible ops.
9. **Cursor plans:** **do not** dual-write or compete with Cursor Plan / Build in Parallel — **deferred** (Option E stays parked). Spec skill plan format remains the only one for now.
10. **Fresh-context exceptions:** Default = **always** a new context for each new phase. Rare escapes only. Prefer continuing in the parent for **one-phase** (or already one combinable unit) specs — serial SDD adds little there. Soft escapes: work inside an already-started phase; user explicitly continuing after a short clarification; research-only turns.
11. **Review (second agent):** **Required** after each implementer unit (one review subagent). Separate from human `Reviewing`. Not Superpowers' mandatory dual-reviewer loop (spec + quality as two agents) — defer that fuller loop.
12. **Linear / skip-processed:** **Out of scope** for this todo. Do not couple. Thin one-phase specs gain little from serial SDD; leave skip-processed alone.
13. **Success metric:** Covered by the success sketch — reliable serial SDD (fresh context per phase, required review agent, stop/resume at human review, clean status). Cloud paste readiness is the brief + env checklist, not a second archive criterion; Linear kickoff is the other todo.
14. **Prepare for cloud (this investigation):** Phase **brief + env checklist** is enough for the follow-up. Linear / kickoff in a **separate** spec later.

---

## Cloud-agent preparation (serial, same brief as local SDD)

Even serial cloud implement needs:

| Prep item | Why |
| --------- | --- |
| Machine-readable progress overview | Agent must pick the next legal phase without chat history |
| Self-contained phase packet | Goal, Read first, deliverables, Done when, tier, Ask-before list |
| Touched paths / file ownership | Scope the clone and reduce blast radius |
| Verify tiers runnable in cloud env | Otherwise Done when is fiction |
| Status write-back convention | Worker **must** update the plan on its branch (status / Done when / Close-out); not comment-only |
| Explicit non-goals for the agent | Stop it "helpfully" starting phase N+1 |
| Secrets / MCP / hooks story | Cloud does not see `~/.cursor`; repo hooks only |

Do **not** start the next dependent phase until the current one is Done — or, if the current unit is `Reviewing`, **stop the serial runner** until a human clears it (then resume). For PR-based cloud, integrate as the project requires before the next dependent phase.

---

## Concerns and risks

- **Status desync:** worker marks Done; parent never reconciles; archive lies — still real for serial + cloud branches.
- **Cost:** N phases × required review agents × fix loops (Superpowers already expensive when serial).
- **Policy contradiction:** adapting Superpowers SDD while keeping "no surprise SCM" and today's "no subagents" without a crisp mode switch — v1 must flip the subagent rule for implement-SDD explicitly.
- **Review cost:** required review subagent after every phase adds seats/latency; accepted. Still defer Superpowers' dual-reviewer (two agents) loop as mandatory.
- **False expectation from the old todo wording ("parallel"):** docs and SKILL must say serial clearly.
- **Linear coupling:** starting cloud agents from Linear without a single source of truth for phase status (deal-breaker in the Linear todo).
- **Platform drift:** Cursor multitask / Build in Parallel evolve; we are not building a parallel orchestrator that duplicates them.

---

## Suggested v1 vs later (if you promote)

**Possible v1 (small):**

- Flip policy: implement may spawn **serial** subagents by default (fresh context per phase / combinable group as the plan already groups them). One-phase / combinable-as-one: stay in parent.
- Define a **phase brief** shape (local subagent + cloud paste) + **env checklist** for cloud.
- Keep **one** Started / Reviewing / Blocked unit; Combinable unchanged; parallel remain forbidden.
- Worker updates the plan; serial runner **stops** on human `Reviewing` / person Ask-before, **resumes** on continue.
- **Required** post-phase review subagent (one agent), separate from human `Reviewing`.
- Document cloud: chat "use a cloud agent" or implied when already in cloud; same brief; worker status write-back. Optional branch vs worktree named distinctly under G6. No Linear coupling in this v1.

**Defer:**

- Parallel ready-set / worktree fan-out.
- Full Superpowers dual-reviewer loop (two review agents) as mandatory.
- Automatic branch / worktree / commit without ask.
- Dual-write to Cursor Plan format (do not use Cursor plans for this skill).
- Autonomous rulings that replace Ask-before for security / irreversible ops.
- Linear kickoff / cloud-from-issue wiring (separate spec).

---

## Open questions for you

**Answered:**

1. **Intent of the todo:** **Yes — Superpowers SDD** (serial fresh implementers + required review subagent). Not parallel domain agents / Build in Parallel as the goal. Primary win: quality via fresh context; cloud prep shares the brief.
2. **Combinable vs parallel:** **No parallel.** Do not split or redefine Combinable; keep same-session / same-unit meaning.
3. **Unit of dispatch:** Combinable group as one brief when the plan says so; High / hard cases handled at plan time — orchestrator trusts the table.
4. **G6:** Chat consent ("use a cloud agent" / branch / worktree) is enough; **implied** when already running as cloud / Linear-started cloud. No README project opt-in. Branch ≠ worktree (both ask-before).
5. **Stop / resume:** Serial implementation **stops** when human review is needed; **continues** when that review is done.
6. **Status writer:** Worker **must** update `implementation-plan.md`.
7. **Ask-before / human vs agent:** Already in the plan + implement statuses (`Reviewing` vs agent-closable Done when); no new ruling layer.
8. **Cursor plans:** Do not use / dual-write — deferred.
9. **Fresh-per-phase:** Default **always** new context per new phase; rare exceptions only (one-phase / combinable-as-one stay in parent; soft escapes as above). Not a hard zero-exception rule.
10. **Review (second agent):** **Required** (one review subagent after each unit). Human `Reviewing` unchanged and separate.
11. **Prepare for cloud:** Phase brief + env checklist is enough here; Linear kickoff in a separate later spec.
12. **Success / Linear coupling / skip-processed:** Success = serial SDD sketch above. Linear relationship **out of scope**. One-phase thin specs stay simple.

**Still open:** none for this investigation — ready to promote to a spec when you want.

---

## Sources

- [obra/superpowers — subagent-driven-development](https://github.com/obra/superpowers/blob/main/skills/subagent-driven-development/SKILL.md)
- [obra/superpowers — dispatching-parallel-agents](https://github.com/obra/superpowers/blob/main/skills/dispatching-parallel-agents/SKILL.md)
- [obra/superpowers#464 — Swarm / parallel execution request](https://github.com/obra/superpowers/issues/464)
- [Cursor — Subagents](https://cursor.com/docs/subagents)
- [Cursor — Cloud Agents](https://cursor.com/docs/cloud-agent)
- [Cursor — Worktrees](https://cursor.com/docs/configuration/worktrees)
- [Cursor help — multi-agent / Build in Parallel](https://cursor.com/help/ai-features/multi-agent)
- Local: `skills/spec/SKILL.md`, `stages/implement.md`, `stages/plan.md`, `design-quality.md`, `templates/implementation-plan.md`
- Local: `spec_docs/archive/adapt-superpowers/spec.md` (G6 no SCM; SDD not required)
