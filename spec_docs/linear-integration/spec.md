# Linear integration

**Slug:** `linear-integration`
**Progress:** plan
**Work item:** n/a
**Depends on:** `spec_docs/archive/multi-subagent` (phase brief and cloud contract)

## TL;DR

- **What:** Repo-led lifecycle between Linear work items and `spec_docs/` — create, Tracker Phases, status mirror, cloud-ready kickoff text.
- **Why:** Tracker stays silent after create-spec today, and dual-edited prose would drift; Linear-only readers also need a safe mirror.
- **v1 includes:** Create-from Linear, repo-stored Tracker Spec and Tracker Phase ids, selective status updates, brief-quality Tracker Phase text for native `@Cursor`, regenerable Document mirror, plugin README operator guidance.
- **v1 excludes:** Bidirectional body sync, skill-owned Cloud Agent launcher, auto-delegate all phases, checkbox mirroring, ownership of unreferenced tracker work, relying on cloud Linear MCP for tracker write-back.

## Doc index

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file | Scope, goals, journeys, constraints, work split | yes |
| [business-logic.md](./business-logic.md) | Sync rules, freeze gates, conflict handling | yes |
| [contracts.md](./contracts.md) | Markers, conventions schema, Document fields | yes |
| ui.md | Layout, interaction, states, copy | not needed |
| [implementation-plan.md](./implementation-plan.md) | Phases and phase status | yes |

## Source

> Todo "Integrate with Linear" and [investigation.md](./investigation.md) (25 Oct 2026), updated after multi-subagent and the repo-stored-id design change. Settled here: repo canonical, Tracker Spec/Tracker Phase terminology, no Tracker Phases before plan, thin specs no-op, selective tracker writes, native Cursor kickoff, and Document mirror option B (TL;DR + goals/AC).

## Problem and current behaviour

**In short:** The skill reads Linear once at create and never writes back. Multi-subagent prepared cloud briefs but left Linear kickoff here. Without a sync doctrine, dual truth is a deal breaker.

- **Input only today.** Create-spec can fetch a work item when Project conventions say how. It sets `Work item:` and maps AC into goals. It does not comment, label, or create Tracker Phases in Linear.
- **Conventions empty.** This repo’s Work items subsection is still the placeholder. Linear team, states, and labels have nowhere durable to live (init-project todo is the home).
- **No structure mirror.** Plan phases and Progress live only under `spec_docs/`. Linear boards cannot show phase progress without manual tickets.
- **Cloud gap closed halfway.** Implement already builds a phase brief and env checklist. Cursor already launches Cloud Agents from Linear. Nothing writes brief-quality text onto Tracker Phases.
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

**In short:** Repo stays binding. Linear tracks links, status, and Tracker Phases. Repo fields identify the Tracker Spec and Tracker Phases directly. Writes update only the affected tracker objects. Linear-only readers get a regenerable Document. Cloud kickoff uses native Cursor on brief-quality Tracker Phases.

### G1 (create from linear) — A Linear issue can start a spec folder without rewriting the issue body

Source: todos create-from; investigation §1

- `/spec create from TEAM-123` (and Linear URL if conventions allow) fetches via Project conventions → Linear MCP.
- Title, description, and acceptance criteria seed create-spec as today. AC map onto goals’ `Source:` lines. Raw payload is not pasted into `spec.md`.
- `Work item:` is set to the issue id.
- On first successful link, Linear gets a comment that names the repo path, plus a design-stage label when conventions define one. Linear `links` are used only when a real URL exists (never a bare `spec_docs/…` path).
- `Work item:` remains near the top of `spec.md`. Its value is the Tracker Spec id, or `n/a` when no Tracker Spec is currently linked.
- After Linear returns the issue (and later the Document), the skill writes those real Linear URLs into `spec.md` next to `Work item` (D17 (repo-stored tracker ids)).
- The skill MUST NOT replace the Linear issue description with the full spec.
- Routine hooks skip tracker writes when the required repo field is `n/a`. Explicit `/spec linear sync` may create the missing Tracker Spec or Tracker Phase and persist its returned id. If Linear MCP or required conventions are missing, the skill asks/warns rather than inventing a project, team, or state map.

### G2 (tracker phases) — Plan phases become linked Tracker Phases after a plan exists

Source: todos subtasks; investigation M2+

- While `implementation-plan.md` exists, the skill creates or updates one Linear work item per dispatch unit (phase, or combinable group as one unit). These work items are called **Tracker Phases** in this feature.
- Tracker Phases are not created before a plan exists. Thin / planless specs leave Linear with **no** Tracker Phases (see G6 (thin noop)).
- Each plan phase stores `Tracker phase: <work item id> | n/a`. The repo field is the durable identity; sync does not rediscover owned work by parsing Linear descriptions.
- Phases combined into one dispatch unit MUST carry the same Tracker Phase id.
- Linear work items not referenced by a `Tracker phase:` field are human-owned: sync MUST NOT delete, cancel, or rewrite them.
- Prefer create/refresh during plan review or when the plan’s phase list changes; fallback is at or just before first implement. Least user work: auto when conventions are present.
- When a plan edit removes a phase with a Tracker Phase id, the skill cancels that known Tracker Phase and comments before removing the field — never silent delete. A later explicit sync does not scan Linear for orphaned work items.
- Tracker Phases hang directly under the Tracker Spec by default (D10 (flat phases)). Nesting under an Implementation work item remains allowed later if conventions add it.

### G3 (status mirror) — Tracker status follows repo Progress and plan phase status

Source: todos status sync

- Tracker Spec state/labels reflect `Progress` in `spec.md` using the Project conventions map.
- Each Tracker Phase state reflects its plan phase status (`Not started` … `Blocked`). Combined phases sharing an id are one dispatch unit and therefore produce one Tracker Phase update.
- On each real Progress or Tracker Phase status change, the skill posts a **new** progress comment (what changed, when) so Linear keeps a readable timeline (D18 (append progress)).
- Writes are selective and automatic on gate changes and plan status updates when Linear is linked and conventions exist: update the affected Tracker Spec or Tracker Phase only. No confirm prompt on every phase Done and no full sync for a routine change.
- Explicit `/spec linear sync` creates missing linked objects, updates referenced objects, and repairs repo-field drift. If required information is missing, it asks for that information. It does not make routine selective writes wait for a full sync.
- Gate review asks in chat MAY add a comment; they MUST NOT invent a Linear “approval” workflow.

### G4 (cloud ready phases) — Tracker Phases are enough for native Cursor / `@Cursor` kickoff

Source: todos cloud agent; multi-subagent G7 (cloud ready brief) deferred here

- Tracker Phases include brief-quality text: repo paths, phase identity, Done when summary, stop-after-this-unit, env checklist cues, and `[repo=…]` from the single conventions default when set (D14 (default repo)).
- The Tracker Phase states that the repo is canonical and the agent must not invent scope from the Linear description beyond Done when.
- v1 uses Cursor’s native assign / `@Cursor` path. The skill MAY offer “mark ready to delegate.” Auto-assigning Cursor is always human-gated in v1 (D13 (human gated)).
- The skill MUST NOT add a second Cloud Agent launcher API in v1.
- Linear-started cloud inherits cloud consent per multi-subagent G6 (scm consent); extra branch / worktree / commit still need an ask unless that runner’s normal story applies.

### G5 (document mirror) — Linear-only readers get a regenerable one-way Document

Source: design chat option B

- On first successful link, the skill MUST create a Linear Document on the Tracker Spec with TL;DR plus goals and acceptance criteria summary from `spec.md` (D15 (document trigger)).
- The Document (and any mirror label) states it is a mirror: edit binding content in the repo, not in Linear (D16 (no linear edits)).
- Regenerating the Document is one-way from repo → Linear. It does not pull prose edits from Linear into `spec.md`.
- Full `spec.md` paste and bidirectional body sync are out of scope (see Non-goals and D3 (reject bidirectional)).

### G6 (thin noop) — Planless specs do not get Tracker Phases

Source: investigation Q10

- If the folder has no `implementation-plan.md`, structure sync is a no-op for Tracker Phases.
- Tracker Spec link-back, Progress-based labels/status, and the Document mirror may still run when the folder is linked.
- This keeps Linear structure aligned with “no phases” for skip-processed / thin specs.

### G7 (repo canonical) — After a spec folder exists, binding scope lives only in the repo

Source: investigation S1

- Goals, journeys, plan Approach, Done when, and other binding design content are authoritative under `spec_docs/<slug>/`.
- Linear holds tracker fields, status, Tracker Phase bodies, progress comments, and the Document mirror. Tracker Spec identity lives in `spec.md`; Tracker Phase identity lives on each plan phase (D17 (repo-stored tracker ids)).
- Create-spec may import a Linear snapshot once. Later Linear AC edits do not win over `spec.md`.
- Humans MUST NOT treat Linear descriptions or the Document as editable binding content (D16 (no linear edits)). If a known conflict needs a choice, use D20 (conflict choices).

## Non-goals

- Bidirectional prose sync between Linear descriptions and `spec.md` (D3 (reject bidirectional)).
- Skill-owned Cloud Agent SDK/API launcher (later only if native path fails).
- Auto-delegate of every Tracker Phase to Cursor in v1 (D13 (human gated)).
- Mirroring Done-when checkboxes or full plan Approach into Linear.
- Owning, deleting, or reshaping Linear work items not referenced by repo tracker fields.
- Linear Project / initiative sync across many specs (later).
- Webhooks or background sync outside an agent session that runs the skill.
- GitHub Issues dual-track, audit-report sync, or `[SUGGESTION:]` drafts into Linear.
- Replacing Linear’s own planning UI.
- Filling Project conventions automatically in this spec alone — schema and skill reads live here; the **init project** todo owns the interactive fill UX.

## Users and context

- **Primary user:** A developer in Cursor running `/spec` with Linear MCP connected (usually local IDE).
- **Secondary user:** A PM or EM who lives in Linear and needs status plus a read-only design mirror; may kick off cloud via `@Cursor`.
- **When:** From create-from through plan, implement, archive — whenever a folder is linked to a Work item. Tracker sync when Linear MCP is available; cloud kickoff may be separate.
- **Who may do this:** Anyone who can run the skill and whose Linear MCP can create/update issues in the configured team.

## User journeys

### Create a spec from a Linear issue

Starting point: An engineer has `TEAM-123` (or a Linear URL) and wants a spec folder.

1. They ask to create a spec from that issue.
2. The skill fetches title, description, and AC via conventions, runs create-spec dialogue, and writes `spec.md` with `Work item` set.
3. Linear receives a comment (and design label if configured). Real Linear URLs are written into `spec.md`. The issue body is not replaced.
4. A Document mirror is created on the Tracker Spec (G5 (document mirror)).

End state: Linked folder at `Progress: design`; Linear shows the repo pointer without dual AC.

Goes wrong when:

- Requested write but MCP or conventions missing — skill asks/warns; no silent half-link — G1 (create from linear), R22 (reference gate).
- Issue body rewritten with full spec — forbidden — G1 (create from linear), G7 (repo canonical).
- Fake `links` URI from a bare repo path — forbidden — G1 (create from linear), R3 (first link back).

Covers: G1 (create from linear), G5 (document mirror), G7 (repo canonical)

### Plan phases appear as Tracker Phases

Starting point: The linked spec has an implementation plan (or the plan’s phase list just changed).

1. Plan creation selectively creates missing Tracker Phases; `/spec linear sync` is the recovery path.
2. A Tracker Phase appears for each dispatch unit. Its returned id is written to `Tracker phase:` on every phase in that unit.
3. Existing Tracker Phases update directly by their stored ids; unrelated Linear work items are left alone.
4. Thin specs without a plan skip this journey’s Tracker Phase step.

End state: Linear board shows phase structure that matches the plan; stored ids prevent duplicate Tracker Phases.

Goes wrong when:

- Tracker Phases created during design before a plan — forbidden — G2 (tracker phases).
- Re-sync duplicates work or touches human-owned Linear work — stored ids + unreferenced-work rule — G2 (tracker phases).

Covers: G2 (tracker phases), G6 (thin noop)

### Status stays aligned during implement

Starting point: Serial SDD (or a single-phase implement) updates plan phase status.

1. As phases move `Started` / `Reviewing` / `Done` / `Blocked`, their referenced Tracker Phases follow the conventions map.
2. Tracker Spec Progress updates when gates change; a new progress comment records what changed.
3. On archive, the Tracker Spec becomes Done only when every referenced Tracker Phase is Done or Deferred; otherwise the skill asks (D11 (archive gate)). Deferred Tracker Phases follow the conventions map.

End state: Linear board matches repo status without a confirm prompt each time.

Goes wrong when:

- Every Done asks for confirmation — fights least-user-work and SDD auto-continue — G3 (status mirror).
- Linear status becomes the driver of plan status — forbidden — G7 (repo canonical).

Covers: G3 (status mirror), G7 (repo canonical)

### Start cloud work from Linear

Starting point: A Tracker Phase is Ready; a human (or triage rule) assigns Cursor or comments `@Cursor`.

1. The agent reads the Tracker Phase’s brief-quality text and opens the named repo paths / phase.
2. It implements one unit, updates the plan on its checkout, and stops after that unit.
3. Linear status catch-up runs in a later session that has working Linear MCP (usually local IDE), not inside the Linear-started cloud run — D19 (mcp session).

End state: One cloud unit completed with repo plan as truth; Linear mirrors when an MCP-capable session syncs.

Goes wrong when:

- Agent treats stale Linear AC as scope — Tracker Phase contract forbids it — G4 (cloud ready phases), G7 (repo canonical).
- Skill invents a second launcher — out of scope — G4 (cloud ready phases).
- Operator expects Linear → cloud alone to sync tracker fields — false; kickoff ≠ MCP write-back — D19 (mcp session).

Covers: G4 (cloud ready phases), G7 (repo canonical)

### Linear-only review of design

Starting point: Someone who does not open the repo wants to understand what is being built.

1. They open the Tracker Spec and the attached Document mirror.
2. They read TL;DR and goals/AC summary.
3. If something is wrong, they comment or talk to the engineer; binding edits happen in the repo, then the Document regenerates.

End state: Visibility without dual canon.

Goes wrong when:

- They edit the Document or issue body as if it were AC truth — forbidden by mirror banner — G5 (document mirror), G7 (repo canonical), D16 (no linear edits).

Covers: G5 (document mirror), G7 (repo canonical)

## Constraints

- **Preserve:** Create-spec work-item mapping; serial SDD; phase brief + env checklist; Bounds no-surprise-SCM (cloud implied only when already in cloud / Linear-started cloud); one active Started/Reviewing/Blocked unit.
- **i18n:** n/a
- **Accessibility:** n/a
- **Security:** Do not push secrets into Linear. Spec excerpts in Documents widen read access to everyone with issue access — keep summaries, not private dumps.
- **Performance:** Idempotent writes; avoid creating duplicate issues; progress comments only on real status/gate changes (not every redundant explicit sync).

## Notes

- **Init project.** Linear project id, Linear team id, Work-items MCP fetch blurb, and Tracker Spec/Tracker Phase state maps belong in `spec_docs/README.md` Project conventions (D12 (minimal conventions)). Optional default `[repo=…]` for cloud Tracker Phases is D14 (default repo). This spec defines what the skill reads; the init-project todo owns the fill UX.
- **Operator model (local sync vs Linear kickoff).** Cursor’s Linear product integration (assign / `@Cursor`) launches cloud agents without Linear MCP. Skill tracker write-back (create-from fetch, Tracker Phases, status, Document, explicit sync) needs Linear MCP in that agent session. Local IDE with Linear MCP authenticated is the reliable sync path. Linear-started cloud is kickoff-only for tracker writes until that session has working Linear MCP — D19 (mcp session). Cloud Agents keep a separate MCP sign-in from the desktop app; installing the Linear integration is not the same as authorizing Linear MCP for cloud.
- **Plugin README.** Implement MUST add a short “Linear” (or “Work items”) section to this plugin’s root [`README.md`](../../README.md). Cover: connect Linear MCP in the IDE; fill Project conventions; create-from and sync from a local session; native `@Cursor` from Linear for cloud implement; do not expect cloud alone to sync Linear status; optional note that cloud Linear MCP OAuth may be unavailable. Adopter project conventions stay in `spec_docs/README.md` (init-project); this root README is operator guidance for the plugin itself.
- **Multi-subagent dependency.** Cloud kickoff text must stay aligned with the phase brief field list in implement stage / archived multi-subagent contracts.
- **Investigation kept.** [investigation.md](./investigation.md) stays as background; binding choices live in Decisions below.

## Concerns

- **Dual canon social failure.** People will still edit Linear bodies. v1 relies on clear “do not edit in Linear” banners rather than a heavy compare — D16 (no linear edits). If left unlabeled: agents may ship the wrong scope — G7 (repo canonical).
- **State map mismatch.** Teams use different workflow names. If left hard-coded: sync fails or mislabels — minimal conventions fields in D12 (minimal conventions).
- **Document feels authoritative.** Rich mirrors invite edits. If left unlabeled: drift returns — G5 (document mirror).
- **Status across cloud branches.** Plan on the agent checkout may not be visible until merge. If left unstated: Linear lags or lies — note in implement sync; same class as multi-subagent status desync.
- **Cloud Linear MCP auth.** Cloud Agents support MCP in product, but Linear MCP OAuth for cloud often fails or has no usable authorize path (separate sign-in from IDE; cloud redirect URI not always accepted by Linear). If left assumed working: operators think Linear → cloud syncs the board. Mitigate with D19 (mcp session) and the plugin README operator section.

## Proposed solution

**In short:** Treat Linear as a tracker and one-way mirror. Store Tracker Spec and Tracker Phase ids in the repo, update affected tracker objects directly, and maintain brief-quality Tracker Phases plus a Document summary. Keep Cursor’s native delegate path for cloud.

Create-from stays the existing dialogue plus thin write-back (comment, optional real URL `links`, label). Real Linear URLs are stored in `spec.md` after create. After a plan exists, `Tracker phase:` fields identify work directly; creation writes returned ids into those fields, and combined phases share one id. Gate and phase events selectively update only their affected tracker objects. A regenerable Document gives Linear-only readers TL;DR and goals/AC without making Linear editable truth.

### Capabilities (v1)

- **Linear work-item fetch.** Conventions-driven MCP get by id/URL for create-spec.
- **Link-back.** Comment / link / label without body rewrite.
- **Tracker Phase sync.** Create when `Tracker phase:` is `n/a`, update directly by stored id, and write returned ids into the plan.
- **Status + progress log.** Progress and phase → Linear states via conventions map; append a timeline comment on each real change.
- **Sync command.** Explicit create-missing, update-referenced, and repo-field repair path; asks for missing required information.
- **Cloud-ready Tracker Phase text.** Brief fields embedded for native `@Cursor`.
- **Document mirror.** One-way TL;DR + goals/AC regenerate.
- **Plugin README operator section.** How to use Linear with this plugin (local MCP sync vs Linear kickoff).

## Touched paths

| Path | Area | Change |
| ---- | ---- | ------ |
| `skills/spec/SKILL.md` | Skill routing | Linear sync entry / conventions pointers |
| `skills/spec/stages/create-spec.md` | Create | Link-back after Work item set |
| `skills/spec/stages/plan.md` | Plan | Add `Tracker phase:` fields and create missing Tracker Phases |
| `skills/spec/stages/implement.md` | Implement | Selective status update; cloud-ready Tracker Phase refresh |
| `skills/spec/stages/linear-sync.md` | Sync helper | Shared link-back, Tracker Phases, status, Document, explicit sync; MCP-session skip |
| `skills/spec/templates/spec-docs-readme.md` | Conventions | Linear / Work items schema slots |
| `skills/spec/templates/spec.md` | Template | Only if Work item / link notes need it |
| `README.md` | Plugin operator docs | Linear usage: local MCP sync vs `@Cursor` kickoff |

## Work split

1. **Conventions and create-from.** Covers G1 (create from linear), G7 (repo canonical). Outcome: Work-items Linear MCP instructions and link-back without body rewrite. Main surface: create-spec + README template.
2. **Tracker Phases and thin no-op.** Covers G2 (tracker phases), G6 (thin noop). Outcome: Repo-stored Tracker Phase ids after plan; no Tracker Phases without plan. Main surface: plan stage + sync helper rules.
3. **Status mirror and explicit sync.** Covers G3 (status mirror). Outcome: selective Progress/phase → Linear updates; append progress comments; explicit create/repair sync. Main surface: implement / archive hooks + sync rules.
4. **Cloud-ready text and Document mirror.** Covers G4 (cloud ready phases), G5 (document mirror). Outcome: Brief-quality Tracker Phase bodies; regenerable Document; conflict stop before overwrite. Main surface: sync rules + implement brief reuse.
5. **Operator docs and MCP-session skip.** Covers D19 (mcp session). Outcome: Plugin root `README.md` Linear section; sync helper skips write-back cleanly when Linear MCP is missing (same ask path as R1 (conventions gate)). Main surface: `README.md` + `linear-sync.md`.

## Glossary

- **Tracker Spec:** The Linear work item referenced by `Work item:` near the top of `spec.md`.
- **Tracker Phase:** A Linear work item referenced by `Tracker phase:` on one or more implementation-plan phases.
- **Linked folder:** A `spec_docs/<slug>/` whose `Work item` names a Tracker Spec id. Routine hooks skip `n/a`; explicit sync may create and link missing tracker work.
- **Unreferenced tracker work:** Linear work with no corresponding repo tracker field; humans own it.
- **Document mirror:** One-way Linear Document summarizing TL;DR and goals/AC from the repo.
- **Progress comment:** A new Linear comment on the Tracker Spec when Progress or a referenced Tracker Phase status actually changes; forms a timeline (D18 (append progress)).
- **Dispatch unit:** One plan phase, or one combinable group whose phases share one Tracker Phase id (same meaning as multi-subagent).
- **Sync:** Explicit create-missing, update-referenced, and field-repair operation. Routine gate and phase updates remain selective.

## Decisions

### D1 (repo canonical) — Binding scope lives only in the repo after the folder exists

- **Date:** 25 Oct 2026 · **Area:** sync doctrine
- **Why:** Dual-edited AC is the deal breaker named in the todo.
- **Rejected:** Linear canonical until plan (S2) for ongoing edits; bidirectional prose (S3).

### D2 (phase mapping) — Tracker Phases map to plan dispatch units, not work-split or goals

- **Date:** 25 Oct 2026 · **Area:** structure
- **Why:** Matches serial SDD units and stable-enough structure after plan.
- **Rejected:** Tracker Phases at design from work-split; Tracker Phases per plan sub-task as default.

### D3 (reject bidirectional) — No bidirectional body sync in v1

- **Date:** 25 Oct 2026 · **Area:** sync doctrine
- **Why:** Conflict loops and lost updates; markdown skill cannot own merge.
- **Rejected:** Auto-merge either direction.

### D4 (freeze after plan) — No Tracker Phases before an implementation plan exists

- **Date:** 25 Oct 2026 · **Area:** structure timing
- **Why:** Design churn orphans tracker work; thin specs should have no Tracker Phases.
- **Rejected:** Create Tracker Phases at design approval.

### D5 (selective tracker writes) — Update affected tracker objects without per-gate confirm or full sync

- **Date:** 25 Oct 2026 · **Area:** UX
- **Why:** Least user work; matches SDD auto-continue across agent-closable units and avoids unnecessary full reconciliation.
- **Rule:** A gate change updates the Tracker Spec. A phase change updates that Tracker Phase. `/spec linear sync` is create/repair/recovery, not a prerequisite for routine updates.
- **Rejected:** Always-confirm `/spec linear sync` as the only write path; running a full sync after every local change.

### D6 (conflict stop) — Known conflicts use D20 (conflict choices); no silent dual canon

- **Date:** 25 Oct 2026 · **Area:** multi-player · **Updated:** 25 Oct 2026
- **Why:** Silent overwrite hides PM intent; ignore allows dual canon to fester.
- **Rule:** When a conflict with Linear prose is known, warn and apply D20 (conflict choices). Day-to-day v1 does not run a hash tripwire — D16 (no linear edits).
- **Rejected:** Silent overwrite from repo; ignore forever without surfacing.

### D7 (native cloud kickoff) — v1 uses native Cursor assign / `@Cursor`, not a skill launcher

- **Date:** 25 Oct 2026 · **Area:** cloud
- **Why:** Multi-subagent already owns the brief; product path already launches agents from Linear.
- **Rejected:** Skill-owned Cloud Agent SDK starter in v1.

### D8 (document depth) — Mirror Document is TL;DR plus goals/AC summary

- **Date:** 25 Oct 2026 · **Area:** Linear-only readers
- **Why:** Enough to review intent without full dual prose; regenerable.
- **Rejected:** Comment-only (A); near-full `spec.md` mirror (C).

### D9 (keep conflict stop) — Resolve path stays D6 (conflict stop) plus D20 (conflict choices)

- **Date:** 25 Oct 2026 · **Area:** multi-player · **Updated:** 25 Oct 2026
- **Why:** Named choices beat inventing a chat UX per session; softer “warn while regenerating” still invites dual canon.
- **Rejected:** Warn-only while regenerating Document (B); refuse all description updates after link (C).

### D10 (flat phases) — Tracker Phases hang directly under the Tracker Spec

- **Date:** 25 Oct 2026 · **Area:** structure
- **Why:** Simplest board shape; matches “one Tracker Phase per dispatch unit” without an extra container ticket.
- **Rejected:** Nest under Implementation container by default (B); make nest vs flat a conventions flag in v1 (C).

### D11 (archive gate) — Tracker Spec Done only when every referenced Tracker Phase is Done or Deferred

- **Date:** 25 Oct 2026 · **Area:** archive
- **Why:** Avoids marking the Tracker Spec Done while phase work is still open or canceled without intent; ask when the board is incomplete.
- **Rejected:** Always complete the Tracker Spec and map Deferred alone (A); leave all terminal states to conventions examples only (C).

### D12 (minimal conventions) — Tracker conventions are project/team, fetch blurb, and state maps

- **Date:** 25 Oct 2026 · **Area:** conventions
- **Why:** Enough to create Tracker Specs/Phases and mirror status without hard-coding a team’s workflow.
- **Rule:** Project conventions include `Linear project: <id> | n/a`, team, fetch instructions, `Progress → Tracker Spec state/label`, and `Phase status → Tracker Phase state`. Optional default `[repo=…]` remains D14 (default repo).
- **Rejected:** Richer schema (Document toggle, nest flag) as v1 required fields (B).

### D13 (human gated) — Cursor assign / `@Cursor` stays human-gated in v1

- **Date:** 25 Oct 2026 · **Area:** cloud
- **Why:** Least surprise; native kickoff already works once a human marks the Tracker Phase ready.
- **Rejected:** Conventions opt-in auto-delegate (B); skill-only “delegate this Tracker Phase” command as the sole path (C).

### D14 (default repo) — One optional conventions default for `[repo=…]` on all Tracker Phases

- **Date:** 25 Oct 2026 · **Area:** cloud
- **Why:** One remote covers this project and most adopters; no path heuristics or per-spec field in v1.
- **Rejected:** Per-spec override in `spec.md` (B); omit `[repo=…]` even when a conventions default exists (C as the only path).

### D15 (document trigger) — Create Document on first link; regenerate when TL;DR or goals change

- **Date:** 25 Oct 2026 · **Area:** Document mirror
- **Why:** Linear-only readers get a mirror without an extra ask; keep it current when binding summary surfaces change; avoid regenerating on every status tick.
- **Rejected:** Create only when the user asks; auto on first link with no later regenerate; regenerate on every gate including status-only.

### D16 (no linear edits) — Do not change binding content in Linear; skip non-trivial compare

- **Date:** 25 Oct 2026 · **Area:** multi-player · **Updated:** 25 Oct 2026
- **Why:** Repo is always source of truth after the folder exists. A body-hash tripwire is easy to get wrong. Issue `updatedAt` bumps on status and labels too, so date compare is not a reliable body-edit signal.
- **Rule:** Mirror banners and operator docs state: do not edit the Linear issue body or Document as binding AC. Document regenerate is one-way from the repo. Automatic conflict detection is low priority and MUST stay trivial to read and update — otherwise v1 does not ship it (see Q1 (auto detect)).
- **Rejected:** Required description-hash fingerprint in v1. Issue-level `updatedAt` compare as the tripwire. Embed a marker in the issue body to detect drift.

### D17 (repo-stored tracker ids) — Repo fields are the identity for Tracker Specs and Tracker Phases

- **Date:** 25 Oct 2026 · **Area:** sync persistence · **Updated:** 25 Oct 2026
- **Why:** Direct ids are simpler and safer than scanning Linear descriptions for ownership markers. The next Cursor session can update exactly the referenced tracker object.
- **Stores:** Tracker Spec id in `spec.md` `Work item`; Tracker Spec URL, Document mirror id, and Document URL near it; Tracker Phase id in each plan phase’s `Tracker phase:` line. Combined phases store the same Tracker Phase id. Progress comments are append-only (D18 (append progress)) — no comment id to cache.
- **Rule:** `n/a` means no tracker object is currently linked. Routine hooks skip it; explicit sync may create the object and writes the returned id back immediately. Sync MUST NOT infer ownership from titles or hidden description markers.
- **Rejected:** Find-by-marker in Linear; separate sync sidecar file; storing a conflict fingerprint (superseded by D16 (no linear edits)).

### D18 (append progress) — Post a new progress comment on each real status change

- **Date:** 25 Oct 2026 · **Area:** status UX
- **Why:** A timeline of what happened and when is more useful in Linear than one overwritten snapshot. Linear’s own timestamps stay on each comment.
- **Rejected:** One sticky comment edited in place (avoids “flood” but erases history).

### D19 (mcp session) — Tracker write-back only in sessions with working Linear MCP

- **Date:** 25 Oct 2026 · **Area:** cloud
- **Why:** Native Linear → Cursor kickoff does not require Linear MCP. Skill sync does. Cloud Linear MCP auth is separate from the IDE and often unavailable (OAuth redirect / no authorize UI). Treating kickoff as sync would silently leave Linear stale.
- **Rule:** Create-from fetch, link-back, Tracker Phase create/update, status, Document, and explicit sync run only when Linear MCP works in the current session. Routine hooks require stored ids and skip `n/a`. Explicit sync may create missing objects and persist their ids. Linear-started cloud implements from the Tracker Phase brief; a later MCP-capable session (usually local IDE) owns Linear catch-up. Missing MCP → R1 (conventions gate) warn / skip write-back — do not invent a second API.
- **Rejected:** Require cloud Linear MCP for v1 cloud kickoff (B). Skill-owned Cloud Agent launcher just to attach MCP (C — already out via D7 (native cloud kickoff)).

### D20 (conflict choices) — Regular options when a Linear prose conflict is known

- **Date:** 25 Oct 2026 · **Area:** multi-player
- **Why:** Implementers need a fixed menu instead of inventing resolve UX. Pairs with D6 (conflict stop).
- **Options (v1):**
  - **Regenerate from repo.** Overwrite the Document (or other mirrored surface) from `spec.md`. Keep Linear status/comments alone.
  - **Skip this regenerate.** Leave Linear prose as-is this run; status-only and progress comments may continue.
  - **Stop Linear writes.** Ask before further Document or description touches until the person unblocks.
- **Open:** Q1 (auto detect) may add or drop automatic detection that surfaces these choices.

## Open questions

### Q1 (auto detect) — Should v1 add any automatic Linear body-edit detection?

- **Priority:** —
- **Blocks:** —
- **Context:** D16 (no linear edits) makes policy the default. A trivial, reliable compare would be welcome; issue-level dates are not reliable. If nothing trivial fits, keep policy-only and D20 (conflict choices) for known conflicts (human report or later hook).
