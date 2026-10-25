# Investigation: Linear integration

Status: pre-spec exploration (not a gated `spec.md`).
Source: [todos.md › Integrate with Linear](./todos.md).
Date: 2026-10-25.

## TL;DR

Deep Linear integration is feasible via the existing Linear MCP and Cursor’s native Linear ↔ Cloud Agent product. The hard problem is not create/read/update of issues — it is **keeping the repo spec and Linear from diverging**, especially while the design is still under review. Without an explicit source-of-truth rule and a narrow sync surface, this feature is likely a deal breaker in practice.

Recommended direction to debate (not decided): **repo is canonical for design content; Linear is the work tracker** (links, status, phase/sub-task mirrors). Defer full body mirroring. Prefer **status + pointers + comments** over dual-edited prose. For “start a cloud agent,” prefer **composing Linear issues that Cursor’s native delegate/@Cursor flow can run**, not inventing a second launcher inside the skill.

---

## Stated goals (from todos)

1. Create a spec from a Linear issue
2. Create subtasks in Linear from a spec
3. Update progress and status in Linear according to spec progress
4. Start a Cursor cloud agent to implement a spec

Stated deal-breaker concern: **repo spec and Linear issues must not drift**, especially while reviewing / changing the spec.

---

## What already exists (do not reinvent)

### In this skill

| Piece | Today |
| ----- | ----- |
| Work-item field | `spec.md` has `**Work item:**` |
| Create from work item | `create-spec.md` + `SKILL.md` already fetch via **Project conventions → Work items** |
| This repo’s conventions | Placeholder: “no work-item system” |
| Progress | Gate in `spec.md` (`design` … `archived`); phase status only in `implementation-plan.md` |
| SCM | Skill MUST NOT branch/commit unless asked — cloud agents that auto-PR conflict with that unless scoped carefully |

### Linear MCP (available in Cursor)

Already enough for a skill-driven integration:

- `get_issue` / `list_issues` / `save_issue` (create + update, including `parentId`, `state`, `labels`, `links`, `delegate`)
- `save_comment` (progress notes without rewriting descriptions)
- `save_document` (Linear Documents attached to an issue — optional mirror surface)
- Attachments / uploads for snapshots if needed

No separate Linear API client is required for v1 if MCP is the project convention.

### Cursor ↔ Linear (product, already shipped)

Cursor already supports:

- Delegate a Linear issue to **Cursor** (assignee)
- Mention `@Cursor` in a comment to launch / follow up a Cloud Agent
- Agent progress back into Linear; PR when done
- Config via `[repo=…]`, `[model=…]`, `[branch=…]`, or `repo` label groups
- Optional triage rules that assign to Cursor

Implication: goal (4) may be **“produce Linear work that is ready to delegate”** rather than “the `/spec` skill starts cloud agents itself.” Building a second launch path inside the skill may duplicate product surface and fight auth/billing defaults.

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
                           cloud agent / implement
```

Drift happens whenever two surfaces can be edited independently:

| Drift class | Example | Severity |
| ----------- | ------- | -------- |
| Scope drift | Goals change in `spec.md`; Linear description still has old AC | High (wrong work) |
| Structure drift | Plan phases renumbered; Linear sub-issues still map to old phases | High |
| Status drift | Phase `Done` in plan; Linear still `In Progress` | Medium (planning noise) |
| Agent context drift | Cloud agent runs from stale Linear body, ignores repo plan | High |
| Dual-edit conflict | Human edits Linear summary while agent patches `spec.md` | High |

The deal-breaker concern is mostly **scope + structure + agent context**, not mere status lag.

---

## Capability breakdown

### 1. Create a spec from a Linear issue

**Fit with current skill:** High. Extend **Project conventions → Work items** to “fetch via Linear MCP `get_issue`,” map AC → goals’ `Source:` lines, set `Work item: TEAM-123`, keep **Source** short (no raw payload dump — already required).

**Open design choices:**

| Topic | Options |
| ----- | ------- |
| Trigger | `/spec create from TEAM-123` only · also from Linear URL · triage label “needs-spec” |
| When to link back | On first write of `spec.md` · only after design approval · never auto |
| What goes back to Linear on create | Comment + link to repo path · `links` attachment · patch a “Spec” section into description · Linear Document |
| Issue already has children | Refuse · adopt as work-split · ignore |

**Pros of thin create (read-only + Work item field):** Low sync risk; matches today’s skill.  
**Cons:** Linear stays silent; PMs don’t see that design started.

**Pros of create + “spec linked” write-back:** Visibility.  
**Cons:** Starts the dual-write problem immediately if description is rewritten.

### 2. Create Linear subtasks from a spec

**What could map to a Linear child?**

| Repo artifact | Linear child meaning | Notes |
| ------------- | -------------------- | ----- |
| Work-split slice (`spec.md`) | Coarse epic children | Exists early; unstable until design settles |
| Plan phase | Implementable unit | Best match for “one session / one PR” |
| Plan sub-task | Smaller than a phase | Can explode issue count |
| Goal (G1…) | Outcome tracking | Poor fit for implementation agents |
| Whole spec | Single issue, no children | Simplest; loses phase tracking |

**When to create children (timing is the sync lever):**

| Option | Pros | Cons |
| ------ | ---- | ---- |
| **A. At design approval** (work split) | Early visibility | High churn while iterating `spec.md` |
| **B. At plan gate** (phases) | Structure more stable; maps to implement | Still churn if plan is revised |
| **C. At implement start** (one phase → one child, just-in-time) | Minimal orphan issues | Linear board lags until implement |
| **D. On explicit `/spec sync`** | Human-controlled | Easy to forget; drift by omission |
| **E. Never structure-sync; status comments only** | Almost no structure drift | Weak “subtasks from spec” goal |

**Identity / idempotency:** Any create path needs a durable marker so re-sync does not duplicate children, e.g. in child description:

```text
<!-- spec-sync: slug=foo phase=2 -->
```

Same pattern used by other Linear↔GitHub sync tools. Prefer **update-by-marker** over delete/recreate.

### 3. Update progress and status from the spec

**Repo signals that could drive Linear:**

| Repo signal | Suggested Linear effect |
| ----------- | ----------------------- |
| `Progress: design` | Parent: “Speccing” / Backlog + label `spec:design` |
| `Progress: tech` / `plan` | Labels or custom states if the team has them |
| `Progress: implementing` | Parent In Progress |
| Phase `Started` / `Reviewing` / `Done` | Matching child state |
| `Progress: archived` | Parent Done (or Cancelled if deferred-heavy) |
| Phase `Blocked` | Child Blocked + comment with reason |
| Gate review ask in chat | Optional comment only — do not invent Linear “approval” |

**Status-only sync (recommended baseline):**

- Pros: Small surface; hard to get semantically wrong; survives big `spec.md` rewrites.
- Cons: Linear description can still lie about *what* is being built.

**Status + progress comments:**

- Append/update a bot comment: “Phase 2 Started — see `spec_docs/foo/implementation-plan.md`.”
- Pros: Audit trail; no description overwrite.
- Cons: Comment noise; needs “edit same comment” discipline (`save_comment` with id).

**Mirroring plan checkboxes into Linear:**

- Pros: Board looks rich.
- Cons: Two checklists; highest drift risk.

### 4. Start a Cursor cloud agent to implement a spec

**Reality check:** Cursor already launches Cloud Agents from Linear (delegate / `@Cursor`). The skill’s job may be:

1. Ensure the **issue body** (or comment) contains enough context: repo path to plan phase, Done when, `[repo=…]`, maybe “run `/spec implement` for phase N”.
2. Optionally set `delegate` to Cursor via MCP (`save_issue.delegate`) — if the integration exposes that the same way as the UI.
3. Or stop at “child issue is Ready” and let a human assign Cursor.

| Approach | Pros | Cons |
| -------- | ---- | ---- |
| **Native Linear → Cursor** | Uses supported product path; progress/PR already flow to Linear | Agent may ignore `spec_docs/` unless prompted well; skill bounds (no surprise SCM) collide with auto-PR |
| **Skill-invoked cloud agent (SDK/API)** | Tighter control of prompt (“read plan phase 2 only”) | Extra surface; auth; may bypass Linear visibility unless also commented |
| **Local `/spec implement` only** | Matches current skill; human in the loop | Does not satisfy “start cloud agent” goal |
| **Hybrid** | Phase child ready-to-delegate; human or triage rule assigns Cursor | Needs excellent issue text so agent reads repo canon |

**Critical conflict with current skill bounds:** Implement stage says no branches/commits unless asked. Cloud Agents typically branch + PR. Any cloud path needs an explicit **project convention** exception: “when delegated from Linear, SCM is allowed.”

**Agent context quality:** If Linear holds a stale summary and the agent trusts the issue over `implementation-plan.md`, sync failure becomes a **wrong PR**, not just a stale board. Prefer issue text that **points at repo paths** (“canonical: `spec_docs/<slug>/…`”) rather than pasting the full plan.

---

## Source-of-truth options (the deal-breaker fork)

This is the decision that should block promoting to a spec until settled.

### Option S1 — Repo canonical; Linear is a tracker mirror

**Rule:** Binding content lives only under `spec_docs/`. Linear holds: issue id link, status, optional short pointer, sub-issues keyed to phases, progress comments. Humans **must not** treat Linear description as the design doc after link.

| Pros | Cons |
| ---- | ---- |
| Matches how the skill already thinks | PMs who live in Linear see thin issues |
| Review/change of spec does not require Linear prose edits | Need discipline / labels (“do not edit body — see repo”) |
| Drift limited to status/structure | Structure sync still needed for children |

**Sync on spec edit:** Update Linear **only** if phase list/status markers change; never auto-rewrite goals into Linear.

### Option S2 — Linear canonical until `Progress: plan`, then repo locks

**Rule:** Early scoping happens in Linear (and create-spec imports it). After plan exists, repo wins; Linear children are generated once and status-synced.

| Pros | Cons |
| ---- | ---- |
| Matches “ticket first” teams | Import becomes a snapshot; later Linear AC edits are ignored or conflict |
| Clear freeze point | Freeze is easy to violate socially |

### Option S3 — Bidirectional content sync

**Rule:** Edits in either place propagate.

| Pros | Cons |
| ---- | ---- |
| Feels “integrated” | Conflict resolution, lost updates, agent loops — classic deal breaker |
| — | Almost certainly out of scope for a markdown skill |

**Recommendation:** Reject S3 for v1.

### Option S4 — Dual write with conflict detection (no auto-merge)

**Rule:** Skill can push summaries; before push, compare Linear `updatedAt` / hash marker; if Linear changed since last push, **stop and ask**.

| Pros | Cons |
| ---- | ---- |
| Safer than silent overwrite | Still tempts people to edit two places |
| Makes drift visible | More protocol complexity in the skill |

---

## Mapping models (structure)

### M1 — One Linear issue ↔ one spec folder

No children. Status maps from `Progress` only.  
Simplest; weak on phase/agent granularity.

### M2 — Parent issue ↔ spec; children ↔ plan phases

Create/refresh children at plan gate (or on sync). Marker `phase=N`.  
Best default candidate for goals 2–4.

### M3 — Parent ↔ spec; children ↔ work-split slices; phases stay repo-only

Earlier Linear visibility; worse churn during design.

### M4 — Parent ↔ spec; children ↔ plan sub-tasks

Finest board; highest issue spam and sync cost.

### M5 — Linear Project ↔ multi-spec initiative; issues ↔ specs

Useful later; out of scope unless you already run initiatives that way.

**Phase ↔ Linear state sketch (for M2):**

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

Whatever mapping we pick, promote-to-spec should require rules like:

1. **No Linear children until freeze gate** (recommend: plan exists, or first implement).
2. **Idempotent sync** via markers; never delete children automatically; cancel + comment instead.
3. **Content edits** to goals/journeys/plan Approach happen in repo only; Linear gets a “spec revised” comment when gate content that affects agents changes.
4. **Re-plan / phase renumber:** explicit `/spec linear reconcile` that diffs markers vs plan and proposes create/cancel/rename — never silent reshuffle.
5. **Human edits in Linear description after link:** either forbidden by convention, or detected as conflict (S4).
6. **Cloud agent prompt contract:** issue body says “repo is canonical; read these paths; do not invent scope from this description beyond Done when.”

Without (1)–(4), design iteration will orphan or mis-map sub-issues — the exact failure mode called out in todos.

---

## Suggested v1 shape (strawman for debate)

Not approved — a concrete strawman so we can disagree precisely:

1. **Conventions:** Fill `Work items` with Linear MCP fetch by id/url; team/project defaults.
2. **Create:** `/spec create from TEAM-123` → existing create-spec dialogue → `Work item` set → optional Linear comment + link (`spec_docs/<slug>/`) + label `spec:design`. **Do not** rewrite issue description with the full spec.
3. **Subtasks:** On promote-to-plan (or first explicit sync after plan), create children for each phase (M2) with markers + Done-when summary + path to phase heading + `[repo=…]` if configured.
4. **Status:** On implement/archive (and optional `/spec linear sync`), map phase + Progress → Linear states; update one sticky progress comment on the parent.
5. **Cloud agent:** Children are written so a human (or triage rule) can assign Cursor / `@Cursor implement phase N per repo plan`. Skill may offer “mark ready to delegate” ; auto-delegate is a separate opt-in.
6. **Sync doctrine:** S1 (repo canonical). Reject body bidirectional sync. Reconcile is explicit.

**Out of v1:** Linear Documents as full mirrors; initiative/project sync; auto-delegate all phases; watching Linear webhooks outside the agent session.

---

## Interaction with sibling todos

| Todo | Interaction |
| ----- | ----------- |
| Skip processed (thin specs) | Linear create still works; maybe skip children if no plan file |
| Multiple subagents / cloud agents | Cloud-agent launch is shared infrastructure; Linear is one trigger surface |
| Skill “no surprise SCM” | Needs an explicit exception when work is Cursor-delegated from Linear |

---

## Risks and concerns

- **Deal breaker — dual canon:** If PMs edit Linear AC after `spec.md` exists, implementers/agents disagree on truth.
- **Issue explosion:** Phase+sub-task children clutter the board; teams hate auto-created tickets they did not ask for.
- **Stale agent context:** Native Cursor agent reads Linear issue text first; thin/wrong text → bad PR even if repo plan is perfect.
- **Auth & portability:** Skill assumes Linear MCP connected; Project conventions must say what to do when missing.
- **State taxonomy mismatch:** Linear workflow states differ per team; mapping must be configurable in Project conventions, not hard-coded English names.
- **Permissions:** Creating many issues / assigning Cursor may need admin-connected integration.
- **Archive:** Moving folder to `spec_docs/archive/` should not break Linear links; prefer durable repo paths or commit SHAs in comments.
- **Secrets / private specs:** Pushing spec excerpts into Linear widens read access to everyone with issue access.

---

## Open questions (for the future spec)

### Product / process

1. Who is the primary operator — engineer in Cursor, or PM/EM in Linear?
2. Is Linear already the team’s system of record for *scope*, or only for *scheduling*?
3. Must subtasks exist for every phase, or only when a cloud agent / parallel owner will take them?
4. Is auto-assigning Cursor allowed, or always human-gated?
5. After archive, should the parent auto-Done, and what happens to Deferred phases?

### Sync doctrine

6. Confirm S1 vs S2 (S3 rejected)?  
7. Freeze gate for creating children: plan promote · first implement · explicit sync only?  
8. On `spec.md` revision after children exist: comment-only · reconcile command · cancel-all-and-recreate (usually bad)?  
9. How to treat human edits to Linear description after link — ignore, warn, or block sync?

### Mapping

10. M1 vs M2 vs M3 for v1?  
11. Parent rollup rules when some children Deferred?  
12. Custom Linear states / labels per consuming project — how much config lives in `spec_docs/README.md` Project conventions?

### Cloud agent

13. Is “ready-to-delegate Linear child” enough for goal (4), or do we need skill-initiated Cloud Agent APIs?  
14. How do we reconcile skill “no surprise SCM” with Cloud Agent PRs?  
15. Multi-repo: how is `[repo=…]` chosen when **Touched paths** span packages?

### Non-goals candidates

16. Bidirectional prose sync  
17. Replacing Linear’s own project planning UI  
18. Syncing audit reports / `[SUGGESTION:]` drafts into Linear  
19. GitHub Issues dual-track (Linear already has GH integrations)

---

## Clarifying questions for you (please answer what you can)

Answer in any form; numbered replies are enough. Starred items most block the future spec.

1. **\*Source of truth:** After a spec folder exists, should binding scope live **only in the repo** (Linear = tracker), or should Linear remain editable truth for AC until some gate?
2. **\*Primary user:** Is this mainly so *you in Cursor* stay aligned with Linear, or so *people who never open the repo* can drive and watch work from Linear?
3. **\*Subtask granularity:** Prefer children = **plan phases**, work-split slices, or start with **no children** (status on parent only)?
4. **\*When to create children:** Earliest acceptable moment — design approval, plan promote, implement start, or explicit sync only?
5. **\*Cloud agent:** Is leveraging native **assign Cursor / @Cursor** enough for v1, or do you need the skill to start agents itself?
6. **Auto vs ask:** Should status/subtask writes to Linear be automatic on gate changes, or always confirm (`/spec linear sync`)?
7. **Team conventions:** Do you already have Linear states/labels for design vs implement, and a default team/project this plugin should document against?
8. **Multi-player conflict:** If someone edits the Linear issue body after link, what should happen — warn in Cursor, overwrite from repo, or stop?
9. **Scope of v1:** Rank the four todo bullets by must-have vs later (create-from / subtasks / status sync / cloud agent).
10. **Relation to thin specs:** If a small feature skips the plan file, should Linear integration no-op on children, or create a single implement child from `spec.md` alone?

---

## Possible next step

Once the starred questions have answers (especially source of truth + freeze gate + granularity), promote a real `spec_docs/linear-integration/spec.md` with those decisions recorded as **D** items and remaining items as **Q**. Until then, keep this investigation as the working note and avoid implementing sync helpers in the skill.
