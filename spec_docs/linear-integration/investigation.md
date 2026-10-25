# Investigation: Linear integration

Status: promoted — see [spec.md](./spec.md) (`Progress: tech`).
Source: was `todos.md` › Integrate with Linear (removed on promote).
Date: 2026-10-25 (updated after [multi-subagent](../archive/multi-subagent/spec.md) landed).

## TL;DR

Deep Linear integration is feasible via Linear MCP and Cursor’s native Linear ↔ Cloud Agent product. The hard problem remains **keeping the repo spec and Linear from diverging**.

**Settled (this pass):**

| Decision | Choice |
| -------- | ------ |
| Source of truth | **S1 — repo only** after a spec folder exists. Linear is the tracker (links, status, phase mirrors, comments). |
| Primary operators | Cursor-first; Linear-only users still need visibility. Spec *review* from Linear is a **one-way mirror / pointer** problem, not dual-edited prose. |
| Structure | Prefer **M2+**: parent ↔ spec; children include **plan phases** (and optionally nest under an “Implementation” child). Non-phase children may exist; sync does not own them. |
| Freeze for children | **Not before the plan exists.** Prefer create/refresh while the plan is reviewed or on first implement — **least user work** (auto where safe). |
| Thin specs (no plan) | **No-op on children** so Linear reflects that there is no phase structure. |
| Team conventions | None yet — capture Linear team/states/labels during **project init** into `spec_docs/README.md` Project conventions. |
| Cloud kickoff | Multi-subagent already owns **phase brief + env checklist** and deferred Linear wiring here. Prefer **native assign Cursor / `@Cursor`** on children whose body points at the repo + pasteable brief contract — **not** a second skill-owned agent launcher. |

Deal-breaker risk is still dual canon. Reject bidirectional body sync (S3). Optional Linear Document / sticky comment as a **read-only snapshot** is the realistic path for “review the spec from Linear” without sync hell.

---

## Stated goals (from todos)

1. Create a spec from a Linear issue
2. Create subtasks in Linear from a spec
3. Update progress and status in Linear according to spec progress
4. Start a Cursor cloud agent to implement a spec

Stated deal-breaker concern: **repo spec and Linear issues must not drift**, especially while reviewing / changing the spec.

---

## What already exists (do not reinvent)

### In this skill (post multi-subagent)

| Piece | Today |
| ----- | ----- |
| Work-item field | `spec.md` has `**Work item:**` |
| Create from work item | `create-spec.md` + `SKILL.md` fetch via **Project conventions → Work items** |
| This repo’s conventions | Placeholder: “no work-item system” — **init project** todo should fill this |
| Progress | Gate in `spec.md` (`design` … `archived`); phase status only in `implementation-plan.md` |
| Serial SDD | Multi-phase implement: fresh implementer per dispatch unit + required review subagent ([archive/multi-subagent](./archive/multi-subagent/spec.md)) |
| Phase brief | Chat-only brief + cloud **env checklist**; worker must not need the full plan |
| Cloud consent | Chat ask, or **implied** when the run already is a Cloud Agent (incl. Linear-started cloud). Branch ≠ worktree; no surprise SCM |
| Linear kickoff | Explicitly **out of** multi-subagent — this investigation / future spec owns it |
| SCM | Skill MUST NOT branch/commit unless asked — Cloud Agents that auto-PR need the same project-convention clarity as multi-subagent G6 |

### Linear MCP (available in Cursor)

Already enough for a skill-driven integration:

- `get_issue` / `list_issues` / `save_issue` (create + update, including `parentId`, `state`, `labels`, `links`, `delegate`)
- `save_comment` (progress notes without rewriting descriptions)
- `save_document` (Linear Documents attached to an issue — optional **read-only** mirror surface)
- Attachments / uploads for snapshots if needed

No separate Linear API client is required for v1 if MCP is the project convention.

### Cursor ↔ Linear (product, already shipped)

Cursor already supports:

- Delegate a Linear issue to **Cursor** (assignee)
- Mention `@Cursor` in a comment to launch / follow up a Cloud Agent
- Agent progress back into Linear; PR when done
- Config via `[repo=…]`, `[model=…]`, `[branch=…]`, or `repo` label groups
- Optional triage rules that assign to Cursor

**Implication after multi-subagent:** Goal (4) is **“Linear child is ready to run the same phase brief contract”** — pointers to `spec_docs/<slug>/`, phase id, Done when, stop-after-this-unit, env checklist cues — then native delegate / `@Cursor`. Building a second launcher inside `/spec` still duplicates product surface. What multi-subagent unlocked is the **brief quality**, not a new start API.

---

## Problem framing

Today the skill treats Linear (or any tracker) as **input only**: read title/description/AC → write `spec.md` → never write back. The proposed feature adds a **bidirectional lifecycle**:

```text
Linear issue ──create──► spec_docs/<slug>/
     ▲                         │
     │                    promote / plan
     │                         │
     └──status/subtasks◄── implementation-plan.md
                                 │
                    phase brief → native @Cursor / cloud
```

Drift happens whenever two surfaces can be edited independently:

| Drift class | Example | Severity |
| ----------- | ------- | -------- |
| Scope drift | Goals change in `spec.md`; Linear description still has old AC | High (wrong work) |
| Structure drift | Plan phases renumbered; Linear sub-issues still map to old phases | High |
| Status drift | Phase `Done` in plan; Linear still `In Progress` | Medium (planning noise) |
| Agent context drift | Cloud agent runs from stale Linear body, ignores repo plan / brief | High |
| Dual-edit conflict | Human edits Linear summary while agent patches `spec.md` | High |

The deal-breaker concern is mostly **scope + structure + agent context**, not mere status lag.

**“Review specs from Linear” tension:** Cursor users need Linear aligned; Linear-only users want to read design there. Under S1, that means **one-way publish** (comment, Document, or labeled “mirror — edit in repo”) — not treating Linear as editable AC after link. Full live prose sync is the deal breaker; a regenerable snapshot is not.

---

## Impact of multi-subagent (re-read)

Settled there and already in the skill:

1. **Serial SDD** is the multi-phase implement default; one active unit; parallel implementers forbidden.
2. **Phase brief** is the shared contract for local subagent and cloud paste (chat-only; no durable brief file).
3. **Cloud prep** = brief + env checklist; worker updates the plan on its checkout.
4. **Linear kickoff deferred** to this todo on purpose (D6 / G7 in multi-subagent).
5. Cloud consent implied when already in cloud / Linear-started cloud; still no surprise extra SCM.

So this Linear work should:

- **Consume** the phase-brief / env-checklist contract when writing child issue text for `@Cursor`.
- **Not** re-implement serial orchestration or a competing cloud starter.
- Treat status sync as a **mirror of plan phase status** the SDD runner already writes — Linear lags the plan, never the reverse for binding content.

Open cloud question **reframed:** not “does the skill start agents?” → “how much does the skill write into Linear so native Cursor launch does the right unit?”

---

## Capability breakdown

### 1. Create a spec from a Linear issue

**Fit with current skill:** High. Extend **Project conventions → Work items** to “fetch via Linear MCP `get_issue`,” map AC → goals’ `Source:` lines, set `Work item: TEAM-123`, keep **Source** short (no raw payload dump — already required).

**Open design choices:**

| Topic | Options |
| ----- | ------- |
| Trigger | `/spec create from TEAM-123` only · also from Linear URL · triage label “needs-spec” |
| When to link back | On first write of `spec.md` · only after design approval · never auto |
| What goes back to Linear on create | Comment + link to repo path · `links` attachment · optional Linear Document snapshot · **do not** replace description with full spec |
| Issue already has children | Refuse · adopt unmanaged · ignore unmanaged |

**Pros of thin create (read-only + Work item field):** Low sync risk; matches today’s skill.  
**Cons:** Linear stays silent; PMs don’t see that design started.

**Pros of create + “spec linked” write-back:** Visibility for Linear-only users.  
**Cons:** Starts dual-write if description is rewritten — avoid rewriting AC body.

### 2. Create Linear subtasks from a spec

**What could map to a Linear child?**

| Repo artifact | Linear child meaning | Notes |
| ------------- | -------------------- | ----- |
| Plan phase | Implementable unit | **Primary** — matches serial SDD dispatch unit |
| Combinable group | One child for the group | Prefer one child when the plan marks one unit |
| Nesting: “Implementation” parent child | Container for phase children | Optional; keeps non-implement noise off the epic |
| Ad-hoc / human Linear children | Unmanaged | Sync leaves them alone (no marker) |
| Work-split slice (`spec.md`) | Coarse epic children | Unstable until design settles — **not** default create |
| Goal (G1…) | Outcome tracking | Poor fit for implementation agents |
| Whole spec / thin (no plan) | **No children** | Settled: no-op so Linear matches “no phases” |

**When to create children (timing):**

| Option | Pros | Cons | Status |
| ------ | ---- | ---- | ------ |
| At design approval | Early visibility | High churn | **Rejected** (too early) |
| **While plan exists / on plan review** | Structure stable enough; sync on plan edits | Needs idempotent reconcile | **Preferred if low friction** |
| At first implement (or just before) | Minimal orphans | Board lags until implement | **Acceptable fallback** |
| Explicit `/spec linear sync` only | Human-controlled | Easy to forget | Supplement, not sole path if “least user work” |
| Never structure-sync | Almost no structure drift | Fails goal 2 | Rejected as sole approach |

**Identity / idempotency:** Durable marker so re-sync does not duplicate children, e.g. in child description:

```text
<!-- spec-sync: slug=foo phase=2 -->
```

Prefer **update-by-marker** over delete/recreate. Unmarked children are human-owned.

### 3. Update progress and status from the spec

**Repo signals that could drive Linear:**

| Repo signal | Suggested Linear effect |
| ----------- | ----------------------- |
| `Progress: design` | Parent: Backlog / Speccing + label `spec:design` |
| `Progress: tech` / `plan` | Labels or custom states if configured |
| `Progress: implementing` | Parent In Progress |
| Phase `Started` / `Reviewing` / `Done` | Matching child state (Reviewing ≈ In Review or label) |
| `Progress: archived` | Parent Done (or Cancelled if deferred-heavy) |
| Phase `Blocked` | Child Blocked + comment with reason |
| Gate review ask in chat | Optional comment only — do not invent Linear “approval” |

**Status-only + sticky progress comment (recommended baseline):**

- Pros: Small surface; hard to get semantically wrong; survives big `spec.md` rewrites.
- Cons: Linear description can still lie about *what* is being built — mitigate with pointer + optional regenerable Document.

**Mirroring plan checkboxes into Linear:** Highest drift risk — out of v1.

**Auto vs ask (inferred from “least user work” + SDD write-back):** Prefer **automatic status/structure writes** when the skill crosses gates or reconciles the plan (create/update marked children, map states, refresh sticky comment). Keep an explicit `/spec linear sync` / reconcile for recovery and renumber. Do **not** require a confirm prompt on every phase Done — that fights serial SDD’s auto-continue. First-time enable / missing conventions may still ask once.

### 4. Start a Cursor cloud agent to implement a spec

**Reality check (post multi-subagent):** The skill already knows how to build a phase brief + env checklist. Cursor already launches Cloud Agents from Linear. Linear v1 should **bridge** those two, not invent a third runner.

| Approach | Pros | Cons | Fit |
| -------- | ---- | ---- | --- |
| **Native Linear → Cursor** with brief-quality child text | Supported product path; progress/PR already flow | Agent may ignore repo unless prompted well | **v1 default** |
| Skill-invoked Cloud Agent SDK/API | Tighter prompt control | Extra surface; duplicates product; auth | Later / only if native path fails |
| Local `/spec implement` only | Matches Cursor-primary users | Does not satisfy Linear-started walk-away | Still primary for Cursor users |
| Hybrid | Child Ready + optional `delegate`; human or triage assigns | Needs excellent issue text | **Recommended** |

**Critical conflict with skill bounds:** Implement stage says no branches/commits unless asked. Cloud Agents typically branch + PR. Align with multi-subagent G6: when the run **already is** cloud (incl. Linear-started), cloud consent is implied; document that in Project conventions for Linear-delegated work.

**Agent context quality:** Issue body should **point** at repo paths and embed / link the phase-brief fields — not paste a stale full plan. Repo remains canonical; Linear is the launch ticket.

---

## Source-of-truth options (the deal-breaker fork)

### Option S1 — Repo canonical; Linear is a tracker mirror — **settled**

**Rule:** Binding content lives only under `spec_docs/`. Linear holds: issue id link, status, optional short pointer, sub-issues keyed to phases, progress comments, optional **read-only** Document snapshot. Humans **must not** treat Linear description as the design doc after link.

| Pros | Cons |
| ---- | ---- |
| Matches how the skill already thinks | PMs who live in Linear see thin issues unless we add a mirror |
| Review/change of spec does not require Linear prose edits | Need discipline / labels (“do not edit body — see repo”) |
| Drift limited to status/structure | Structure sync still needed for children |

**Sync on spec edit:** Update Linear **only** if phase list/status markers change (and optional regenerate Document); never treat Linear AC as winning over `spec.md`.

### Option S2 — Linear canonical until `Progress: plan`, then repo locks

Rejected for post-folder life; create-spec may still **import** a Linear snapshot once.

### Option S3 — Bidirectional content sync

**Rejected** for v1 (and likely forever for a markdown skill).

### Option S4 — Dual write with conflict detection (no auto-merge)

Useful if we ever push mirrors: before overwrite, compare Linear `updatedAt` / hash; if Linear changed since last push, **stop and ask**. Compatible with S1 for optional Document sync. **Still open** for human body edits after link (see clarifying answers).

---

## Mapping models (structure)

### M1 — One Linear issue ↔ one spec folder

No children. Status maps from `Progress` only.  
Simplest; weak on phase/agent granularity. Still the effective shape for **thin specs** (no plan → no children).

### M2 — Parent issue ↔ spec; children ↔ plan phases — **base default**

Create/refresh children once a plan exists (or on first implement). Marker `phase=N`.  
Best match for goals 2–4 and serial SDD units.

### M2+ — Parent ↔ spec; optional Implementation container; phase children; unmanaged extras — **preferred direction**

```text
Parent (TEAM-123)          ↔ spec folder
└── Implementation (opt.)  ↔ “implement this spec”
    ├── Phase 1 (marked)   ↔ plan phase 1 / dispatch unit
    ├── Phase 2 (marked)
    └── … human child …    ↔ unmanaged (no marker)
```

Phases may hang directly under the parent if the team prefers flatter boards. Sync:

- Creates/updates **marked** phase (or combinable-unit) children.
- Does not delete unmarked children.
- May cancel+comment marked children whose phase was removed (never silent delete).

### M3 — Children ↔ work-split slices

Earlier visibility; worse churn — not default.

### M4 — Children ↔ plan sub-tasks

Finest board; highest spam — not default (phases are the unit; plan sub-tasks stay repo-only unless a human creates Linear work).

### M5 — Linear Project ↔ multi-spec initiative

Later / out of scope unless already used.

**Phase ↔ Linear state sketch (for M2 / M2+):**

| Plan status | Child Linear state (example) |
| ----------- | ---------------------------- |
| Not started | Backlog / Todo |
| Started | In Progress |
| Reviewing | In Review (if exists) else In Progress + label |
| Done | Done |
| Deferred | Canceled or Done + label `deferred` |
| Blocked | Blocked / as-team-defines |

Parent state: roll up (any child In Progress → parent In Progress; all Done/Deferred → Done).

---

## Review / change protocol (must-have for the deal breaker)

1. **No Linear phase children until a plan exists** (or first implement if plan sync was skipped).
2. **Idempotent sync** via markers; never delete children automatically; cancel + comment instead.
3. **Content edits** to goals/journeys/plan Approach happen in repo only; Linear gets a “spec revised” comment (and optional Document regenerate) when agent-relevant content changes.
4. **Re-plan / phase renumber:** reconcile that diffs markers vs plan and proposes create/cancel/rename — never silent reshuffle.
5. **Human edits in Linear description after link:** convention = do not edit binding AC; detection TBD (warn vs stop — still open).
6. **Cloud agent prompt contract:** child says “repo is canonical; read these paths / brief fields; stop after this unit; do not invent scope from this description beyond Done when.”

Without (1)–(4), design/plan iteration will orphan or mis-map sub-issues — the failure mode in todos.

---

## Suggested v1 shape (updated strawman)

Not a gated spec yet — concrete enough to disagree precisely:

1. **Conventions / init:** Project init fills Linear team, default project, state/label map, and Work-items fetch via MCP into `spec_docs/README.md` (ties to **Init project for spec** todo).
2. **Create:** `/spec create from TEAM-123` → existing create-spec dialogue → `Work item` set → Linear comment + link (`spec_docs/<slug>/`) + label `spec:design`. **Do not** rewrite issue description with the full spec. Optional: attach/update a Document titled as mirror.
3. **Subtasks:** After plan exists, auto-create/refresh marked phase children (M2 or M2+). Re-sync when the plan’s phase list changes during review. Fallback: create just before / at first implement if not done yet. Thin specs: **no children**.
4. **Status:** On implement/archive (and reconcile), map phase + Progress → Linear states; update one sticky progress comment on the parent. Prefer auto writes; expose `/spec linear sync` for recovery.
5. **Cloud agent:** Phase children include brief-quality text (paths, Done when, stop-after-this-unit, env cues, `[repo=…]` if configured) so assign Cursor / `@Cursor` works. Skill may “mark ready to delegate”; auto-delegate is opt-in later. No skill-owned second launcher in v1.
6. **Sync doctrine:** S1. Reject body bidirectional sync. Optional one-way Document for Linear-only readers.

**Out of v1:** Bidirectional prose; initiative sync; auto-delegate all phases; webhooks outside the agent session; mirroring Done-when checkboxes; owning unmarked Linear children.

---

## Interaction with sibling todos

| Todo | Interaction |
| ----- | ----------- |
| Skip processed (thin specs) | Create-from still works; **no-op children** without a plan |
| Multiple subagents / cloud agents | **Done** — provides brief + SDD; Linear kickoff consumes that contract |
| Init project for spec | **Home for Linear conventions** (team, states, Work items MCP) — not ad-hoc per chat |
| Skill “no surprise SCM” | Same G6 story: Linear-started cloud implies cloud consent; extra SCM still ask |

---

## Risks and concerns

- **Deal breaker — dual canon:** If PMs edit Linear AC after `spec.md` exists, implementers/agents disagree on truth.
- **Linear-only readers:** Thin tracker issues feel empty; Document/mirror must stay clearly non-authoritative or people will edit it.
- **Issue explosion:** Phase children + optional Implementation container + human extras; sync must not touch unmarked issues.
- **Stale agent context:** Native Cursor agent reads Linear first; child text must point at repo + brief fields.
- **Auth & portability:** Skill assumes Linear MCP connected; conventions must say what to do when missing.
- **State taxonomy mismatch:** Mapping must be configurable in Project conventions (init), not hard-coded English names.
- **Permissions:** Creating many issues / assigning Cursor may need admin-connected integration.
- **Archive:** Moving folder to `spec_docs/archive/` should not break Linear links; prefer durable paths or commit SHAs in comments.
- **Secrets / private specs:** Pushing excerpts into Linear widens read access.
- **Status desync across cloud branches:** Same concern as multi-subagent — plan on the agent’s checkout is truth; Linear mirrors after sync in a session that can see that plan.

---

## Clarifying questions — answers

Starred items that blocked the future spec:

1. **\*Source of truth:** **Only in the repo** after a spec folder exists. Linear = tracker.
2. **\*Primary user:** Mostly Cursor users; also Linear-only users. Ideal: review specs from Linear — pursue via **one-way mirror / pointer**, not dual-edited AC (sync difficulty acknowledged).
3. **\*Subtask granularity:** **Phases as subtasks**; other subtasks may exist; optional nest phases under an Implementation child (M2+).
4. **\*When to create children:** **Not before the plan.** Prefer during plan change/review sync; else at/just before first phase implement. Optimize for **least user work**.
5. **\*Cloud agent:** After multi-subagent — **native assign / `@Cursor` + brief-quality child text** is enough for v1; skill does not need its own agent starter. Multi-subagent already owns brief/env; this feature wires Linear kickoff.
6. **Auto vs ask:** Inferred: **auto** status/structure writes on gate/plan changes (least user work; matches SDD auto-continue); keep explicit reconcile for recovery. Confirm once at enable / missing conventions if needed.
7. **Team conventions:** **No** existing map. Candidate for **project init** → `spec_docs/README.md` Project conventions.
8. **Multi-player conflict:** *Still open* — recommend warn-in-Cursor + S4-style stop before overwrite; do not silent-overwrite from repo.
9. **Scope of v1 ranking:** *Still open* — strawman priority: create-from → phase children + status → cloud-ready text → optional Document mirror → auto-delegate later.
10. **Thin specs:** **No-op on children** so Linear reflects the (planless) spec.

---

## Remaining open questions (for the future spec)

### Product / process

1. Confirm Q8: warn vs stop vs ignore when Linear body is edited after link?
2. Rank the four todo bullets for must-have vs later (Q9).
3. After archive: parent auto-Done? Deferred phase children?
4. Optional Implementation container by default, or flat phase children under the parent?
5. How rich is the Linear Document / mirror for Linear-only review (TL;DR only vs goals+AC vs full `spec.md`)?

### Sync doctrine

6. Freeze default: sync children as soon as plan exists vs only at first implement?
7. On `spec.md` revision after children exist: comment-only vs also regenerate Document?

### Mapping / conventions

8. Parent rollup when some children Deferred?
9. Exact Project conventions schema for Linear states/labels/team (for init)?

### Cloud agent

10. Opt-in auto-`delegate` to Cursor in v1 or always human-gated?
11. Multi-repo: how is `[repo=…]` chosen when **Touched paths** span packages?

### Non-goals (candidates to record in the future spec)

12. Bidirectional prose sync  
13. Replacing Linear’s project planning UI  
14. Syncing audit reports / `[SUGGESTION:]` drafts into Linear  
15. GitHub Issues dual-track  
16. Skill-owned Cloud Agent launcher (unless native path proves insufficient)

---

## Possible next step

Done: promoted to [spec.md](./spec.md). Iterate there; do not implement sync helpers until the design gate is accepted and stages are planned.
