# Linear integration

**Slug:** `linear-integration`
**Progress:** design
**Work item:** —
**Depends on:** `spec_docs/archive/multi-subagent` (phase brief and cloud contract)

## TL;DR

- **What:** Bidirectional lifecycle between Linear issues and `spec_docs/` — create, phase children, status mirror, cloud-ready kickoff text.
- **Why:** Tracker stays silent after create-spec today, and dual-edited prose would drift; Linear-only readers also need a safe mirror.
- **v1 includes:** Create-from Linear, marked phase children after plan, auto status sync, brief-quality child text for native `@Cursor`, regenerable Document mirror.
- **v1 excludes:** Bidirectional body sync, skill-owned Cloud Agent launcher, auto-delegate all phases, checkbox mirroring, unmarked-child ownership.

## Doc index

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file | Scope, goals, journeys, constraints, work split | yes |
| business-logic.md | Sync rules, freeze gates, conflict handling | pending |
| contracts.md | Markers, conventions schema, Document fields | pending |
| ui.md | Layout, interaction, states, copy | not needed |
| implementation-plan.md | Phases and phase status | pending |

## Source

> Todo "Integrate with Linear" and [investigation.md](./investigation.md) (25 Oct 2026), updated after multi-subagent. Settled there: repo canonical (S1), M2+ phase children, no children before plan, thin specs no-op children, auto tracker writes, native Cursor kickoff. Design chat: Document mirror option B (TL;DR + goals/AC).

## Problem and current behaviour

**In short:** The skill reads Linear once at create and never writes back. Multi-subagent prepared cloud briefs but left Linear kickoff here. Without a sync doctrine, dual truth is a deal breaker.

- **Input only today.** Create-spec can fetch a work item when Project conventions say how. It sets `Work item:` and maps AC into goals. It does not comment, label, or create children in Linear.
- **Conventions empty.** This repo’s Work items subsection is still the placeholder. Linear team, states, and labels have nowhere durable to live (init-project todo is the home).
- **No structure mirror.** Plan phases and Progress live only under `spec_docs/`. Linear boards cannot show phase progress without manual tickets.
- **Cloud gap closed halfway.** Implement already builds a phase brief and env checklist. Cursor already launches Cloud Agents from Linear. Nothing writes brief-quality text onto Linear children.
- **Drift fear.** If Linear descriptions stay editable AC after `spec.md` exists, agents and humans disagree on scope.

| Path | What it does today |
| ---- | ------------------ |
| `skills/spec/SKILL.md` | Work items + Bounds; serial SDD exception |
| `skills/spec/stages/create-spec.md` | Fetch work item; write `spec.md` only |
| `skills/spec/stages/plan.md` | Writes plan; no Linear write-back |
| `skills/spec/stages/implement.md` | Phase brief + env checklist; status in plan |
| `skills/spec/templates/spec-docs-readme.md` | Work items placeholder |
| `spec_docs/archive/multi-subagent/` | Brief contract; Linear kickoff deferred |

## Goals and acceptance criteria

**In short:** Repo stays binding. Linear tracks links, status, and phase children. Create-from and sync are automatic where safe. Linear-only readers get a regenerable Document. Cloud kickoff uses native Cursor on brief-quality children.

### G1 (create from linear) — A Linear issue can start a spec folder without rewriting the issue body

Source: todos create-from; investigation §1

- `/spec create from TEAM-123` (and Linear URL if conventions allow) fetches via Project conventions → Linear MCP.
- Title, description, and acceptance criteria seed create-spec as today. AC map onto goals’ `Source:` lines. Raw payload is not pasted into `spec.md`.
- `Work item:` is set to the issue id.
- On first successful link, Linear gets a comment and/or link pointing at `spec_docs/<slug>/`, plus a design-stage label when conventions define one.
- The skill MUST NOT replace the Linear issue description with the full spec.
- If Linear MCP or conventions are missing, the skill asks once and stops the write-back path rather than inventing a team.

### G2 (phase children) — Plan phases become marked Linear children after a plan exists

Source: todos subtasks; investigation M2+

- While `implementation-plan.md` exists, sync creates or updates one Linear child per dispatch unit (phase, or combinable group as one unit).
- Children are not created before a plan exists. Thin / planless specs leave Linear with **no** phase children (see G6 (thin noop)).
- Each synced child carries a durable marker (slug + phase or unit id) so re-sync is idempotent.
- Unmarked children are human-owned: sync MUST NOT delete, cancel, or rewrite them.
- Prefer create/refresh during plan review or when the plan’s phase list changes; fallback is at or just before first implement. Least user work: auto when conventions are present.
- Removed phases: cancel the marked child and comment — never silent delete.
- Nesting under an optional Implementation container is allowed; default layout is open: Q2 (nest default).

### G3 (status mirror) — Linear status follows repo Progress and plan phase status

Source: todos status sync

- Parent issue state/labels reflect `Progress` in `spec.md` using the Project conventions map.
- Marked child state reflects plan phase status (`Not started` … `Blocked`).
- One sticky progress comment on the parent is updated (edit-in-place when an id is known) instead of flooding new comments.
- Writes are automatic on gate changes and plan status updates when Linear is linked and conventions exist. No confirm prompt on every phase Done.
- Explicit `/spec linear sync` (or equivalent reconcile) recovers drift and handles renumber without silent reshuffle.
- Gate review asks in chat MAY add a comment; they MUST NOT invent a Linear “approval” workflow.

### G4 (cloud ready children) — Phase children are enough for native Cursor / `@Cursor` kickoff

Source: todos cloud agent; multi-subagent G7 (cloud ready brief) deferred here

- Marked phase children include brief-quality text: repo paths, phase identity, Done when summary, stop-after-this-unit, env checklist cues, and `[repo=…]` when conventions define a default.
- The child states that the repo is canonical and the agent must not invent scope from the Linear description beyond Done when.
- v1 uses Cursor’s native assign / `@Cursor` path. The skill MAY offer “mark ready to delegate.” Auto-assigning Cursor to every child is out of v1 unless Q5 (auto delegate) chooses otherwise later.
- The skill MUST NOT add a second Cloud Agent launcher API in v1.
- Linear-started cloud inherits cloud consent per multi-subagent G6 (scm consent); extra branch / worktree / commit still need an ask unless that runner’s normal story applies.

### G5 (document mirror) — Linear-only readers get a regenerable one-way Document

Source: design chat option B

- After link, the skill can create or update a Linear Document attached to the parent with TL;DR plus goals and acceptance criteria summary from `spec.md`.
- The Document (and any mirror label) states it is a mirror: edit binding content in the repo, not in Linear.
- Regenerating the Document is one-way from repo → Linear. It does not pull prose edits from Linear into `spec.md`.
- Full `spec.md` paste and bidirectional body sync are out of scope (see Non-goals and D3 (reject bidirectional)).

### G6 (thin noop) — Planless specs do not get phase children

Source: investigation Q10

- If the folder has no `implementation-plan.md`, structure sync is a no-op for children.
- Parent link-back, Progress-based labels/status, and optional Document mirror may still run.
- This keeps Linear structure aligned with “no phases” for skip-processed / thin specs.

### G7 (repo canonical) — After a spec folder exists, binding scope lives only in the repo

Source: investigation S1

- Goals, journeys, plan Approach, Done when, and other binding design content are authoritative under `spec_docs/<slug>/`.
- Linear holds tracker fields: ids, links, status, marked children, sticky comments, optional Document mirror.
- Create-spec may import a Linear snapshot once. Later Linear AC edits do not win over `spec.md`.
- Conflict when a human edits the Linear issue body after link: warn in Cursor and stop before overwriting mirrored surfaces until the person chooses — see D6 (conflict stop) and Q1 (body conflict) if refinements are needed.

## Non-goals

- Bidirectional prose sync between Linear descriptions and `spec.md` (D3 (reject bidirectional)).
- Skill-owned Cloud Agent SDK/API launcher (later only if native path fails).
- Auto-delegate of every phase child to Cursor in v1 (Q5 (auto delegate)).
- Mirroring Done-when checkboxes or full plan Approach into Linear.
- Owning, deleting, or reshaping unmarked / human Linear children.
- Linear Project / initiative sync across many specs (later).
- Webhooks or background sync outside an agent session that runs the skill.
- GitHub Issues dual-track, audit-report sync, or `[SUGGESTION:]` drafts into Linear.
- Replacing Linear’s own planning UI.
- Filling Project conventions automatically in this spec alone — schema and skill reads live here; the **init project** todo owns the interactive fill UX.

## Users and context

- **Primary user:** A developer in Cursor running `/spec` with Linear MCP connected.
- **Secondary user:** A PM or EM who lives in Linear and needs status plus a read-only design mirror.
- **When:** From create-from through plan, implement, archive — whenever a folder is linked to a Work item.
- **Who may do this:** Anyone who can run the skill and whose Linear integration can create/update issues in the configured team.

## User journeys

### Create a spec from a Linear issue

Starting point: An engineer has `TEAM-123` (or a Linear URL) and wants a spec folder.

1. They ask to create a spec from that issue.
2. The skill fetches title, description, and AC via conventions, runs create-spec dialogue, and writes `spec.md` with `Work item` set.
3. Linear receives a link/comment (and design label if configured). The issue body is not replaced.
4. Optionally a Document mirror is created or updated (G5 (document mirror)).

End state: Linked folder at `Progress: design`; Linear shows the repo pointer without dual AC.

Goes wrong when:

- MCP or conventions missing — skill asks; no silent half-link — G1 (create from linear).
- Issue body rewritten with full spec — forbidden — G1 (create from linear), G7 (repo canonical).

Covers: G1 (create from linear), G5 (document mirror), G7 (repo canonical)

### Plan phases appear as Linear children

Starting point: The linked spec has an implementation plan (or the plan’s phase list just changed).

1. Sync runs automatically (or via reconcile / first implement fallback).
2. Marked children appear for each dispatch unit; titles and brief-quality bodies refresh by marker.
3. Unmarked existing children are left alone.
4. Thin specs without a plan skip this journey’s children step.

End state: Linear board shows phase structure that matches the plan; no duplicate children on re-sync.

Goes wrong when:

- Children created during design before a plan — forbidden — G2 (phase children).
- Re-sync duplicates or deletes human children — markers + unmanaged rule — G2 (phase children).

Covers: G2 (phase children), G6 (thin noop)

### Status stays aligned during implement

Starting point: Serial SDD (or a single-phase implement) updates plan phase status.

1. As phases move `Started` / `Reviewing` / `Done` / `Blocked`, marked Linear children follow the conventions map.
2. Parent Progress updates when gates change; sticky comment refreshes.
3. On archive, parent reaches a terminal state per conventions; Deferred children follow the map (Q3 (archive rollup)).

End state: Linear board matches repo status without a confirm prompt each time.

Goes wrong when:

- Every Done asks for confirmation — fights least-user-work and SDD auto-continue — G3 (status mirror).
- Linear status becomes the driver of plan status — forbidden — G7 (repo canonical).

Covers: G3 (status mirror), G7 (repo canonical)

### Start cloud work from Linear

Starting point: A phase child is Ready; a human (or triage rule) assigns Cursor or comments `@Cursor`.

1. The agent reads the child’s brief-quality text and opens the named repo paths / phase.
2. It implements one unit, updates the plan on its checkout, and stops after that unit.
3. A later Cursor session syncs Linear status from the plan when the skill runs again.

End state: One cloud unit completed with repo plan as truth; Linear eventually mirrors.

Goes wrong when:

- Agent treats stale Linear AC as scope — child contract forbids it — G4 (cloud ready children), G7 (repo canonical).
- Skill invents a second launcher — out of scope — G4 (cloud ready children).

Covers: G4 (cloud ready children), G7 (repo canonical)

### Linear-only review of design

Starting point: Someone who does not open the repo wants to understand what is being built.

1. They open the parent issue and the attached Document mirror.
2. They read TL;DR and goals/AC summary.
3. If something is wrong, they comment or talk to the engineer; binding edits happen in the repo, then the Document regenerates.

End state: Visibility without dual canon.

Goes wrong when:

- They edit the Document or issue body as if it were AC truth — convention + conflict stop — G5 (document mirror), G7 (repo canonical), D6 (conflict stop).

Covers: G5 (document mirror), G7 (repo canonical)

## Constraints

- **Preserve:** Create-spec work-item mapping; serial SDD; phase brief + env checklist; Bounds no-surprise-SCM (cloud implied only when already in cloud / Linear-started cloud); one active Started/Reviewing/Blocked unit.
- **i18n:** n/a
- **Accessibility:** n/a
- **Security:** Do not push secrets into Linear. Spec excerpts in Documents widen read access to everyone with issue access — keep summaries, not private dumps.
- **Performance:** Idempotent sync; avoid creating duplicate issues; edit sticky comment in place.

## Notes

- **Init project.** Linear team, project, state/label map, and Work-items MCP instructions belong in `spec_docs/README.md` Project conventions. This spec defines what the skill reads; the init-project todo owns the fill UX.
- **Multi-subagent dependency.** Cloud kickoff text must stay aligned with the phase brief field list in implement stage / archived multi-subagent contracts.
- **Investigation kept.** [investigation.md](./investigation.md) stays as background; binding choices live in Decisions below.

## Concerns

- **Dual canon social failure.** People will still edit Linear bodies. If left without D6 (conflict stop): agents ship the wrong scope — G7 (repo canonical).
- **State map mismatch.** Teams use different workflow names. If left hard-coded: sync fails or mislabels — conventions schema in contracts; Q4 (conventions schema).
- **Document feels authoritative.** Rich mirrors invite edits. If left unlabeled: drift returns — G5 (document mirror).
- **Status across cloud branches.** Plan on the agent checkout may not be visible until merge. If left unstated: Linear lags or lies — note in implement sync; same class as multi-subagent status desync.

## Proposed solution

**In short:** Treat Linear as a tracker and one-way mirror. Extend the skill stages to write markers, status, brief-quality children, and a Document summary. Keep Cursor’s native delegate path for cloud.

Create-from stays the existing dialogue plus thin write-back (comment, link, label). After a plan exists, an idempotent sync maintains marked phase children and refreshes their bodies from the phase brief contract. Status sync rides gate and phase updates automatically. A regenerable Document gives Linear-only readers TL;DR and goals/AC without making Linear editable truth.

### Capabilities (v1)

- **Linear work-item fetch.** Conventions-driven MCP get by id/URL for create-spec.
- **Link-back.** Comment / link / label without body rewrite.
- **Marked child sync.** Create, update, cancel-by-marker for plan dispatch units.
- **Status + sticky comment.** Progress and phase → Linear states via conventions map.
- **Reconcile command.** Explicit recovery when structure drifts.
- **Cloud-ready child text.** Brief fields embedded for native `@Cursor`.
- **Document mirror.** One-way TL;DR + goals/AC regenerate.

## Touched paths

| Path | Area | Change |
| ---- | ---- | ------ |
| `skills/spec/SKILL.md` | Skill routing | Linear sync entry / conventions pointers |
| `skills/spec/stages/create-spec.md` | Create | Link-back after Work item set |
| `skills/spec/stages/plan.md` | Plan | Trigger child sync when plan exists |
| `skills/spec/stages/implement.md` | Implement | Status sync; cloud-ready child refresh |
| `skills/spec/templates/spec-docs-readme.md` | Conventions | Linear / Work items schema slots |
| `skills/spec/templates/spec.md` | Template | Only if Work item / link notes need it |

## Work split

1. **Conventions and create-from.** Covers G1 (create from linear), G7 (repo canonical). Outcome: Work-items Linear MCP instructions and link-back without body rewrite. Main surface: create-spec + README template.
2. **Phase children and thin no-op.** Covers G2 (phase children), G6 (thin noop). Outcome: Idempotent marked children after plan; no children without plan. Main surface: plan stage + sync helper rules.
3. **Status mirror and reconcile.** Covers G3 (status mirror). Outcome: Auto Progress/phase → Linear; sticky comment; explicit reconcile. Main surface: implement / archive hooks + sync rules.
4. **Cloud-ready text and Document mirror.** Covers G4 (cloud ready children), G5 (document mirror). Outcome: Brief-quality child bodies; regenerable Document; conflict stop before overwrite. Main surface: sync rules + implement brief reuse.

## Glossary

- **Marked child:** Linear issue with a durable `spec-sync` marker the skill owns.
- **Unmanaged child:** Linear child without a marker; humans own it.
- **Document mirror:** One-way Linear Document summarizing TL;DR and goals/AC from the repo.
- **Dispatch unit:** One plan phase, or one combinable group treated as a single child (same meaning as multi-subagent).
- **Reconcile:** Explicit sync that diffs markers against the plan and proposes create/cancel/rename.

## Decisions

### D1 (repo canonical) — Binding scope lives only in the repo after the folder exists

- **Date:** 25 Oct 2026 · **Area:** sync doctrine
- **Why:** Dual-edited AC is the deal breaker named in the todo.
- **Rejected:** Linear canonical until plan (S2) for ongoing edits; bidirectional prose (S3).

### D2 (phase mapping) — Children map to plan dispatch units (M2+), not work-split or goals

- **Date:** 25 Oct 2026 · **Area:** structure
- **Why:** Matches serial SDD units and stable-enough structure after plan.
- **Rejected:** Children at design from work-split (M3); children per plan sub-task (M4) as default.

### D3 (reject bidirectional) — No bidirectional body sync in v1

- **Date:** 25 Oct 2026 · **Area:** sync doctrine
- **Why:** Conflict loops and lost updates; markdown skill cannot own merge.
- **Rejected:** Auto-merge either direction.

### D4 (freeze after plan) — No phase children before an implementation plan exists

- **Date:** 25 Oct 2026 · **Area:** structure timing
- **Why:** Design churn orphans tickets; thin specs should stay childless.
- **Rejected:** Create children at design approval.

### D5 (auto tracker writes) — Status and marked structure sync without per-gate confirm

- **Date:** 25 Oct 2026 · **Area:** UX
- **Why:** Least user work; matches SDD auto-continue across agent-closable units.
- **Rejected:** Always-confirm `/spec linear sync` as the only write path.

### D6 (conflict stop) — After link, human Linear body edits trigger warn and stop before overwrite

- **Date:** 25 Oct 2026 · **Area:** multi-player
- **Why:** Silent overwrite hides PM intent; ignore allows dual canon to fester.
- **Rejected:** Silent overwrite from repo; ignore forever without surfacing.

### D7 (native cloud kickoff) — v1 uses native Cursor assign / `@Cursor`, not a skill launcher

- **Date:** 25 Oct 2026 · **Area:** cloud
- **Why:** Multi-subagent already owns the brief; product path already launches agents from Linear.
- **Rejected:** Skill-owned Cloud Agent SDK starter in v1.

### D8 (document depth) — Mirror Document is TL;DR plus goals/AC summary

- **Date:** 25 Oct 2026 · **Area:** Linear-only readers
- **Why:** Enough to review intent without full dual prose; regenerable.
- **Rejected:** Comment-only (A); near-full `spec.md` mirror (C).

## Open questions

### Q1 (body conflict) — Any refinement beyond warn-and-stop for post-link body edits?

- **Priority:** — · **Blocks:** — · **Owner:** Dan
- **Options:**
  - **A.** Keep D6 (conflict stop) as-is.
  - **B.** Warn only; allow Document regenerate while leaving issue description untouched.
  - **C.** Stronger: refuse all Linear description updates from the skill after link.

### Q2 (nest default) — Default board shape for phase children?

- **Priority:** high · **Blocks:** plan / contracts for child parentId · **Owner:** Dan
- **Options:**
  - **A.** Flat: phase children hang directly under the parent issue.
  - **B.** Nest under a marked Implementation container child.
  - **C.** Configurable in Project conventions (default A or B).

### Q3 (archive rollup) — Parent and Deferred children on archive?

- **Priority:** — · **Blocks:** archive sync rules · **Owner:** Dan
- **Options:**
  - **A.** Parent Done; Deferred children Canceled (or Done + `deferred` label).
  - **B.** Parent Done only when every marked child is Done or Deferred; else ask.
  - **C.** Leave Linear terminal states entirely to conventions with examples only.

### Q4 (conventions schema) — Exact Project conventions fields for Linear?

- **Priority:** high · **Blocks:** create-from and status map · **Owner:** Dan
- **Options:**
  - **A.** Minimal: team id, Work-items fetch blurb, state map for Progress + phase statuses.
  - **B.** Richer: default project, label names, Document toggle, `[repo=…]`, Implementation nest flag.
  - Draft the field table in contracts at promote; prefer B if init-project can fill it.

### Q5 (auto delegate) — Opt-in auto-assign Cursor on Ready children?

- **Priority:** — · **Blocks:** — · **Owner:** Dan
- **Options:**
  - **A.** Always human-gated in v1 (recommended).
  - **B.** Conventions opt-in auto-`delegate`.
  - **C.** Per-command “delegate this child” only.

### Q6 (multi repo) — How to choose `[repo=…]` when Touched paths span packages?

- **Priority:** — · **Blocks:** — · **Owner:** Dan
- **Options:**
  - **A.** Single default repo in conventions.
  - **B.** Per-spec override field in `spec.md`.
  - **C.** Omit `[repo=…]` unless conventions set one.
