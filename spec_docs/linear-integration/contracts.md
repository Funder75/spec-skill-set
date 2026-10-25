# Linear integration — contracts

> Created because: repo-stored tracker ids, conventions schema, Tracker Phase brief body, Document fields, and Linear MCP ops need binding shapes beyond spec.md.

Types, API contracts, state ownership, and storage for **linear-integration**. [spec.md](./spec.md) owns scope and decisions; cite them in full form (`see D12 (minimal conventions)`).

Read **Stack notes for spec docs** in `spec_docs/README.md` before filling this file. This repo has no app UI or data layer; contracts here are skill markdown shapes and Linear MCP payloads.

## TL;DR

- Conventions hold Linear project, team, fetch blurb, state maps, and optional default `[repo=…]`.
- `Work item:` identifies the Tracker Spec; each plan phase’s `Tracker phase:` identifies its Tracker Phase. Combined phases share one id.
- Tracker Phase bodies reuse the implement phase-brief field list for native Cursor kickoff.
- Sync only when linked; Linear MCP in-session for write-back; plugin root `README.md` documents local sync vs Linear kickoff.

## Summary of changes

| Layer | Change | Lands in | Persisted? |
| ----- | ------ | -------- | ---------- |
| Conventions schema | Tracker Work items slots | `templates/spec-docs-readme.md` | yes (project README) |
| Tracker Spec identity | `Work item: <id> \| n/a` | `spec.md` header | yes (repo) |
| Tracker Phase identity | `Tracker phase: <id> \| n/a` | each implementation-plan phase | yes (repo) |
| Progress marker | Progress-log HTML comment | Tracker Spec comment body | yes (in Linear) |
| Tracker Phase brief body | Brief-quality markdown | Tracker Phase `description` | yes (in Linear) |
| Document mirror | TL;DR + goals/AC summary | Linear Document on Tracker Spec | yes (in Linear) |
| Skill routing | `linear sync` + stage hooks | `SKILL.md`, stage files | no (skill text) |
| Sync helper stage | Shared sync doctrine | `stages/linear-sync.md` (new) | no (skill text) |
| Plugin operator docs | Linear local MCP vs `@Cursor` kickoff | root `README.md` | no (plugin docs) |

## Existing types reused

| Type | Location | Usage in this feature |
| ---- | -------- | --------------------- |
| Phase brief fields | `stages/implement.md` › Phase brief | Embedded into Tracker Phase bodies |
| Env checklist cues | `stages/implement.md` › Env checklist | Short cues on Tracker Phase for cloud |
| `Progress` gate | `spec.md` header | Maps to Tracker Spec state/labels |
| Plan phase status | `implementation-plan.md` overview | Maps to Tracker Phase state |
| `Work item:` field | `spec.md` header | Tracker Spec id |

## Types and fields

### Linear conventions (Project conventions › Work items)

**Lands in:** `skills/spec/templates/spec-docs-readme.md` — extend Work items placeholder; live fill owned by init-project todo

Binding fields the skill reads for Linear (D12 (minimal conventions), D14 (default repo)):

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Linear project | string id or `n/a` | yes | Valid project id, or explicit `n/a` | Human / init |
| Team | string (name or id) | yes for create | Non-empty | Human / init |
| Fetch blurb | prose | yes for create-from | Names Linear MCP `get_issue` | Human / init |
| Progress → Tracker Spec state/label map | map | yes for status update | Every Progress value covered or explicit skip | Human / init |
| Phase status → Tracker Phase state map | map | yes for phase status | Every plan status covered | Human / init |
| Design-stage label | string | no | Existing label name/id | Human / init |
| Default `[repo=…]` | string | no | Remote the cloud agent should use | Human / init (D14) |

```text
Work items (advisory sketch)
- Linear project: <id> | n/a
- Team: …
- Fetch: use Linear MCP get_issue by id or URL
- Tracker Spec Progress map: design → …; tech → …; …
- Tracker Phase status map: Not started → …; Started → …; …
- Optional: design label; default repo=owner/name
```

Richer knobs (Document toggle, nest flag) are out of v1 required fields (D12 (minimal conventions) rejected B).

### Tracker Spec identity

**Lands in:** linked `spec.md` near the top

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| `Work item` | string id or `n/a` | yes | Returned Linear work-item id, or explicit `n/a` | Create-from / human |
| Tracker Spec URL | URI | after successful link | Returned by Linear | Linear |
| Document mirror id | string | when Document exists | Returned by Linear | Linear |
| Document URL | URI | when Document exists | Returned by Linear | Linear |

`Work item:` stays tracker-agnostic. In this feature, the Linear object it references is called the **Tracker Spec**.

### Tracker Phase identity

**Lands in:** every phase section in `implementation-plan.md`

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| `Tracker phase` | string id or `n/a` | yes | Returned Linear work-item id, or explicit `n/a` | Linear create / human |

```text
## Phase 2 — Example

**Tracker phase:** TEAM-456
```

- The stored id is the identity and update target. Do not parse Linear descriptions or titles to rediscover it.
- When creation succeeds, write the returned id immediately.
- Every phase in a combinable dispatch unit stores the same Tracker Phase id.
- Linear work not referenced by one of these fields is human-owned.

### Progress-log marker

**Lands in:** Tracker Spec comment `body` on each new progress comment; doctrine in `stages/linear-sync.md`

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| `slug` | kebab-case string | yes | Matches folder slug | Spec folder |

```text
<!-- spec-sync-progress: slug=linear-integration -->
```

Create a new comment with `save_comment` (no `id`) on each real Progress / Tracker Phase status change (R13 (progress log), D18 (append progress)). Do not edit prior progress comments. This marker identifies skill-authored timeline entries; it is not tracker-object identity.

Repo tracker fields are machine identity, not binding design (D17 (repo-stored tracker ids)). Write ids and URLs only after Linear returns them. Never invent a fake `spec_docs/…` URI.

### Document mirror content

**Lands in:** Linear Document via `save_document` with `issue` = Tracker Spec id

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Title | string | yes | Includes “mirror” or equivalent | Skill |
| Mirror banner | markdown | yes | Repo canonical; do not edit in Linear | Skill |
| TL;DR | markdown | yes | From `spec.md` TL;DR bullets | Repo |
| Goals / AC summary | markdown | yes | Goal titles + short criteria; not full journeys | Repo |

Must NOT include full `spec.md`, secrets, or private dumps (R19 (no secrets), D8 (document depth)).

Create on first link; regenerate when TL;DR or goals change (D15 (document trigger)).

### Tracker Phase body (cloud-ready)

**Lands in:** Tracker Phase `description`

Binding sections (G4 (cloud ready phases)); field meanings match implement Phase brief / Env checklist:

| Section | Required | Source |
| ------- | -------- | ------ |
| Canon banner | yes | Fixed: repo canonical; do not invent scope beyond Done when |
| Spec slug + unit name | yes | Folder + plan |
| Phase id(s) | yes | Plan |
| Goals covered (full `G…` forms) | yes | Phase **Covers** |
| Scoped paths / Read first cues | yes | Phase packet |
| Done when summary | yes | Phase **Done when** (summary, not full checkbox mirror) |
| Stop after this unit | yes | Fixed instruction |
| Env checklist cues | yes for cloud-ready | Short bullets; not a second launcher |
| `[repo=…]` | when conventions default set | D14 (default repo) |

```text
> Tracker Phase. Binding scope is in the repo. Do not treat this description as AC truth beyond Done when.

## Unit
- slug: …
- phase: …
- stop after this unit: yes

## Done when (summary)
- …

## Paths
- …

[repo=owner/name]
```

## Commands

| Name | Lands in | Validates | Mutates |
| ---- | -------- | --------- | ------- |
| Link-back | `linear-sync.md` › Link-back | R1–R3, R22 (reference gate) | Comment; real URL links; labels |
| Update Tracker Phase | `linear-sync.md` › Tracker Phase | R4–R10, R15, R22 (reference gate) | One referenced Tracker Phase |
| Update status | stage hook + `linear-sync.md` | R11–R13 | Affected Tracker Spec/Phase; progress comment |
| Regenerate Document | `linear-sync.md` › Document mirror | R14, R17 | Linear Document |
| Explicit sync | `linear-sync.md` › Explicit sync | R8, R22 (reference gate) | Create missing, update referenced, repair fields |
| Conflict check | `linear-sync.md` › Conflict check | R14, D20 (conflict choices) | Chat choices when conflict known |

### Link-back

First successful link after create-spec sets `Work item`.

**Payload** (binding):

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Tracker Spec id | string | yes | `Work item` value | `spec.md` |
| Repo path in comment | string | yes | `spec_docs/<slug>/` text in comment body | Folder |
| Real URL for `links` | URI | no | Only if a real URI exists | Remote / Linear |
| Design label | string | no | Conventions | Conventions |

**Side effects:**

- `save_comment` with repo path text
- `save_issue` `links` append only when URL is a real URI — never a bare path
- Optional `addLabels`
- Write Tracker Spec URL into `spec.md` after Linear returns it (D17 (repo-stored tracker ids))
- MUST NOT set full `description` to the spec (R2 (no body rewrite))

### Create or update Tracker Phase

**Preconditions:** A routine update requires a Tracker Spec id. Explicit sync may create it first when `Work item: n/a` (R22 (reference gate)). Missing MCP or required conventions → warn and ask/skip (R1 (conventions gate)).

**Payload** (binding):

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Tracker Spec id | string | yes | Linked | `Work item` |
| Dispatch unit | phase or combinable group | yes | From plan | Plan |
| Tracker Phase id | string id or `n/a` | yes | Same value on every combined phase | Plan phase fields |
| Linear project/team | ids | for create | Conventions or user answer | README / chat |

**Side effects:**

- If `Tracker phase:` is `n/a`, `save_issue` creates one work item with Linear API `parentId` = Tracker Spec id, then writes the returned id to every phase in the dispatch unit.
- If an id exists, `save_issue` updates that id directly.
- Combined phases point to the same Tracker Phase id.
- Refresh brief body only when its source fields change; do not scan Linear descriptions for identity.

### Selective status update

**Payload** (binding):

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Progress | enum | yes | Gate line | `spec.md` |
| Phase statuses | map unit → status | yes when plan exists | Plan vocabulary | Plan |
| State maps | maps | yes | Conventions | README |

**Side effects:**

- Tracker Spec/Tracker Phase `state` and labels via conventions
- New Tracker Spec progress comment on real status delta (D18 (append progress)); never edit prior progress comments

### Explicit sync

Explicit `/spec linear sync` reads repo fields, creates objects whose fields are `n/a`, updates referenced objects, and repairs invalid references. It asks for missing project, team, state-map, or ownership information. Routine gate and phase events remain selective and MUST NOT run this full operation (R12 (selective tracker writes)).

## External contracts

### Linear MCP `get_issue`

- **Kind:** API · **Lands in:** `stages/create-spec.md` › Input; conventions fetch blurb
- **Request:** `id` (issue id or identifier); optional `fields` including `description`, `labels`, `status`, `documents`, `url`
- **Response:** Title, description, labels, status, documents list, issue `url` as needed
- **Boundary validation:** Conventions must name this tool; ask if Work items still placeholder
- **Errors:** Missing MCP on linked folder → R1 (conventions gate) warn; unknown id → stop create-from fetch

### Linear MCP `save_issue`

- **Kind:** API · **Lands in:** `stages/linear-sync.md`
- **Request:** Create Tracker Phase: `team`, optional project, `title`, brief `description`, and API `parentId` = Tracker Spec id. Update: stored `id` plus changed fields only. Prefer `addLabels` / `removeLabels` over full `labels` replace. Append `links` only with real URIs. Cancel removed units via `state` (canceled) plus comment.
- **Response:** Issue id / identifier / `url` when available
- **Boundary validation:** Returned create id is persisted in `Tracker phase:`; no full-spec description on Tracker Spec; no bare-path `links`
- **Errors:** Permission / validation → report in chat; do not invent ids or touch unreferenced work

### Linear MCP `save_comment`

- **Kind:** API · **Lands in:** `stages/linear-sync.md` › Link-back / progress log
- **Request:** Create only: `issueId` + `body` (progress marker + what changed, or link-back path text). Do not pass `id` to edit prior progress comments (D18 (append progress))
- **Response:** Comment id (not stored in repo)
- **Boundary validation:** Progress body includes progress-log marker
- **Errors:** Create failure → report in chat; do not invent edit-in-place fallback

### Linear MCP `list_comments`

- **Kind:** API · **Lands in:** `stages/linear-sync.md` › optional discovery / human timeline
- **Request:** `issueId` on Tracker Spec when the timeline must be read
- **Response:** Comment list; progress markers identify skill timeline entries
- **Boundary validation:** —
- **Errors:** — (progress log does not require prior comments to exist)

### Linear MCP `save_document` / `get_document`

- **Kind:** API · **Lands in:** `stages/linear-sync.md` › Document mirror
- **Request:** Create: `title`, `content`, `issue` = Tracker Spec. Update: `id` + `content` (full replace ok for regenerate)
- **Response:** Document id / slug / URL when available
- **Boundary validation:** Mirror banner required (D16 (no linear edits)); summary depth only (D8 (document depth))
- **Errors:** Known conflict → R14 (conflict stop) + D20 (conflict choices)

### Native Cursor assign / `@Cursor`

- **Kind:** Product path (not skill API) · **Lands in:** Tracker Phase body contract only
- **Request:** Human (or triage) assigns Cursor or comments `@Cursor` on the Tracker Phase
- **Response:** Cloud agent run (product-owned)
- **Boundary validation:** Skill MUST NOT call a second launcher; MUST NOT auto-`delegate` in v1 (R16 (human gated launch)). Product Linear integration is not Linear MCP (D19 (mcp session), R21 (mcp session)).
- **Errors:** Stale Linear AC as scope — forbidden by canon banner on Tracker Phase. Tracker write-back deferred to an MCP-capable session.

## State ownership and lifecycle

| State | Owner | Load | Refresh | Invalidate | Persisted? |
| ----- | ----- | ---- | ------- | ---------- | ---------- |
| `Work item` id | `spec.md` | Create-from / manual | On relink (rare) | Clear only if user unlinks | yes (repo) |
| Tracker Spec URL | `spec.md` | After link-back | On relink | Clear on unlink | yes (repo) |
| Progress gate | `spec.md` | Always | Gate crossings | — | yes (repo) |
| Phase statuses | `implementation-plan.md` | Implement / SDD | Each unit | — | yes (repo) |
| Tracker Phase ids | `implementation-plan.md` | Plan / explicit sync | On create or relink | Remove only after cancel/unlink | yes (repo) |
| Tracker Phases | Linear | Direct id from plan | Selective source-field change | Cancel on unit remove | yes (Linear) |
| Progress comments | Linear (append-only) | Status update on real delta | Each Progress / Tracker Phase status change | — | yes (Linear) |
| Document mirror | Linear Document | Document path | Regenerate via id in `spec.md` | — | yes (Linear) |
| Document mirror id + URL | `spec.md` | After Document create | On recreate (rare) | Clear on unlink | yes (repo) |
| Conventions maps | Project README | Before write-back | Init-project fill | — | yes (repo) |

Repo remains canonical for binding design. Linear holds tracker fields only (G7 (repo canonical)).

## Persistence changes

### Project conventions (README)

**Lands in:** `skills/spec/templates/spec-docs-readme.md` (schema); live `spec_docs/README.md` filled by init-project

| Column / path | Type | Purpose |
| ------------- | ---- | ------- |
| Work items › Linear project | string id or `n/a` | Project used for creates |
| Work items › Linear team | string | Create team |
| Work items › fetch blurb | prose | Create-from MCP instructions |
| Work items › state maps | maps | Progress → Tracker Spec; phase → Tracker Phase |
| Work items › optional label / repo | string | Design label; `[repo=…]` |

### Tracker ids (`spec.md` and implementation plan)

**Lands in:** linked `spec.md` and each implementation-plan phase (D17 (repo-stored tracker ids))

| Column / path | Type | Purpose |
| ------------- | ---- | ------- |
| `spec.md` › Work item | string id or `n/a` | Tracker Spec identity |
| `spec.md` › Tracker Spec URL | URI | Real Linear link after create |
| Document mirror id | string | Update same Linear Document on regenerate |
| Document URL | URI | Real Document link after create |
| phase › Tracker phase | string id or `n/a` | Tracker Phase identity; shared across combined phases |

### Access control

- Anyone who can run the skill and whose Linear integration can create/update issues in the configured team (Users and context in `spec.md`).
- Document summaries widen read access to everyone with issue access — keep summaries only (R19 (no secrets)).

### Migration

1. Template gains Linear schema slots; existing READMEs keep placeholder until init-project or a human fills them.
2. Linked specs gain Tracker Spec URL on link-back; Document id + URL on Document create.
3. Implementation-plan templates gain `Tracker phase: n/a` per phase. Existing plans receive fields on explicit sync; the skill asks before adopting existing Linear work.
4. Rollback: leave conventions blank; skill warns and skips write-back on linked folders (R1 (conventions gate)).

## Rollout and compatibility

- v1 assumes Linear MCP in the agent session that performs write-back. No webhooks or background sync (Non-goals). Linear-started cloud without working Linear MCP is kickoff-only for tracker fields (D19 (mcp session), R21 (mcp session)).
- Plugin root `README.md` MUST document the local-sync vs Linear-kickoff operator model when this feature ships.
- Routine hooks skip `n/a` tracker fields. Explicit `/spec linear sync` may create the missing Tracker Spec or Tracker Phase and persist the returned id (R22 (reference gate)).
- Thin / planless specs: Tracker Spec updates only; no Tracker Phases (G6 (thin noop)).
- Tracker Phase body field list MUST stay aligned with `stages/implement.md` phase brief when that contract changes (Notes › Multi-subagent dependency).
- No required conflict fingerprint in v1 (D16 (no linear edits); Q1 (auto detect)).
