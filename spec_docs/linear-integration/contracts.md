# Linear integration — contracts

> Created because: markers, conventions schema, child brief body, Document fields, and Linear MCP ops need binding shapes beyond spec.md.

Types, API contracts, state ownership, and storage for **linear-integration**. [spec.md](./spec.md) owns scope and decisions; cite them in full form (`see D12 (minimal conventions)`).

Read **Stack notes for spec docs** in `spec_docs/README.md` before filling this file. This repo has no app UI or data layer; contracts here are skill markdown shapes and Linear MCP payloads.

## TL;DR

- Conventions hold team, fetch blurb, state map, and optional default `[repo=…]`.
- Durable HTML markers identify marked children and progress-log comments; Document id and conflict hash live in `spec.md`.
- Child bodies reuse the implement phase-brief field list for native Cursor kickoff.
- Tracker write-back needs Linear MCP in-session; plugin root `README.md` documents local sync vs Linear kickoff.

## Summary of changes

| Layer | Change | Lands in | Persisted? |
| ----- | ------ | -------- | ---------- |
| Conventions schema | Linear Work items slots | `templates/spec-docs-readme.md` | yes (project README) |
| Sync markers | Child + progress-log HTML comments | Linear issue/comment bodies | yes (in Linear) |
| Sync ids in spec | Document id + conflict fingerprint | `spec.md` (near Work item) | yes (repo) |
| Child brief body | Brief-quality markdown on children | Linear child `description` | yes (in Linear) |
| Document mirror | TL;DR + goals/AC summary | Linear Document on parent | yes (in Linear) |
| Skill routing | `linear sync` + stage hooks | `SKILL.md`, stage files | no (skill text) |
| Sync helper stage | Shared sync doctrine | `stages/linear-sync.md` (new) | no (skill text) |
| Plugin operator docs | Linear local MCP vs `@Cursor` kickoff | root `README.md` | no (plugin docs) |

## Existing types reused

| Type | Location | Usage in this feature |
| ---- | -------- | --------------------- |
| Phase brief fields | `stages/implement.md` › Phase brief | Embedded into marked child bodies |
| Env checklist cues | `stages/implement.md` › Env checklist | Short cues on child for cloud |
| `Progress` gate | `spec.md` header | Maps to parent Linear state/labels |
| Plan phase status | `implementation-plan.md` overview | Maps to marked child state |
| `Work item:` field | `spec.md` header | Linked parent issue id |

## Types and fields

### Linear conventions (Project conventions › Work items)

**Lands in:** `skills/spec/templates/spec-docs-readme.md` — extend Work items placeholder; live fill owned by init-project todo

Binding fields the skill reads for Linear (D12 (minimal conventions), D14 (default repo)):

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Team | string (name or id) | yes for write-back | Non-empty | Human / init |
| Fetch blurb | prose | yes for create-from | Names Linear MCP `get_issue` | Human / init |
| Progress → parent state/label map | map | yes for status sync | Every Progress value covered or explicit skip | Human / init |
| Phase status → child state map | map | yes for child status | Every plan status covered | Human / init |
| Design-stage label | string | no | Existing label name/id | Human / init |
| Default `[repo=…]` | string | no | Remote the cloud agent should use | Human / init (D14) |

```text
Work items (advisory sketch)
- Team: …
- Fetch: use Linear MCP get_issue by id or URL
- Parent Progress map: design → …; tech → …; …
- Phase status map: Not started → …; Started → …; …
- Optional: design label; default repo=owner/name
```

Richer knobs (project id, Document toggle, nest flag) are out of v1 required fields (D12 (minimal conventions) rejected B).

### Spec sync marker (marked child)

**Lands in:** Linear child `description` (HTML comment); doctrine in `stages/linear-sync.md`

Durable identity so re-sync is idempotent (G2 (phase children)). One marker line near the top of the child description:

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| `slug` | kebab-case string | yes | Matches `spec_docs/<slug>/` | Spec folder |
| `unit` | string | yes | Phase id (`3`) or combinable key (`2+3`) | Plan dispatch unit |

```text
<!-- spec-sync: slug=linear-integration unit=2 -->
```

- **Match key:** `slug` + `unit`. Same key → update that issue; never create a second.
- **Unmanaged:** any child without this marker (R7 (unmanaged leave)).
- Paths are advisory; the comment shape is binding.

### Progress-log marker

**Lands in:** Linear parent comment `body` on each new progress comment; doctrine in `stages/linear-sync.md`

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| `slug` | kebab-case string | yes | Matches folder slug | Spec folder |

```text
<!-- spec-sync-progress: slug=linear-integration -->
```

Create a new comment with `save_comment` (no `id`) on each real Progress / marked-child status change (R13 (progress log), D18 (append progress)). Do not edit prior progress comments. Marker identifies skill-authored timeline entries; it is not used for edit-in-place.

### Sync ids in `spec.md`

**Lands in:** linked `spec.md` near `Work item` (exact shape left to template / implement)

| Field | Type | Required after link | Purpose |
| ----- | ---- | ------------------- | ------- |
| Document mirror id | string | yes when Document exists | Regenerate same Document (D15, D17) |
| Conflict fingerprint | string (hash) | yes after first link | D16 (conflict fingerprint) compare |

Machine fields only — not binding design (D17 (ids in spec)).

### Document mirror content

**Lands in:** Linear Document via `save_document` with `issue` = parent id

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Title | string | yes | Includes “mirror” or equivalent | Skill |
| Mirror banner | markdown | yes | States repo is canonical | Skill |
| TL;DR | markdown | yes | From `spec.md` TL;DR bullets | Repo |
| Goals / AC summary | markdown | yes | Goal titles + short criteria; not full journeys | Repo |

Must NOT include full `spec.md`, secrets, or private dumps (R19 (no secrets), D8 (document depth)).

Create on first link; regenerate when TL;DR or goals change (D15 (document trigger)).

### Marked child body (cloud-ready)

**Lands in:** Linear child `description` after the sync marker

Binding sections (G4 (cloud ready children)); field meanings match implement Phase brief / Env checklist:

| Section | Required | Source |
| ------- | -------- | ------ |
| Sync marker | yes | Spec sync marker above |
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
<!-- spec-sync: slug=… unit=… -->

> Mirror ticket. Binding scope is in the repo. Do not treat this description as AC truth beyond Done when.

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
| Link-back | `linear-sync.md` › Link-back | R1–R3 | Linear comment / links / labels |
| Sync children | `linear-sync.md` › Child sync | R4–R10, R15 | Marked Linear children |
| Sync status | `linear-sync.md` › Status sync | R11–R13 | Parent/child state; progress comment |
| Regenerate Document | `linear-sync.md` › Document mirror | R14, R17 | Linear Document |
| Reconcile | `linear-sync.md` › Reconcile | R8 | Propose + apply structure fixes |
| Conflict check | `linear-sync.md` › Conflict check | R14 | Chat only until person chooses |

### Link-back

First successful link after create-spec sets `Work item`.

**Payload** (binding):

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Parent issue id | string | yes | `Work item` value | `spec.md` |
| Repo path pointer | string | yes | `spec_docs/<slug>/` | Folder |
| Design label | string | no | Conventions | Conventions |

**Side effects:**

- `save_comment` and/or `save_issue` `links` append
- Optional `addLabels`
- MUST NOT set full `description` to the spec (R2 (no body rewrite))

### Sync children

**Payload** (binding):

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Slug | string | yes | Folder exists | Path |
| Dispatch units | list | yes | From plan; empty if no plan | Plan |
| Parent issue id | string | yes | Linked | `Work item` |

**Side effects:**

- `save_issue` create with `parentId`, or update by marker
- Cancel + comment for removed units
- Refresh brief body

### Sync status

**Payload** (binding):

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Progress | enum | yes | Gate line | `spec.md` |
| Phase statuses | map unit → status | yes when plan exists | Plan vocabulary | Plan |
| State maps | maps | yes | Conventions | README |

**Side effects:**

- Parent/child `state` / labels via conventions
- New progress comment on real status delta (D18 (append progress)); never edit prior progress comments

### Reconcile

Explicit `/spec linear sync`. Diffs markers vs plan; shows create / cancel / rename; applies when the user confirms the reconcile plan (recovery path; day-to-day sync stays auto per R12 (auto tracker writes)).

## External contracts

### Linear MCP `get_issue`

- **Kind:** API · **Lands in:** `stages/create-spec.md` › Input; conventions fetch blurb
- **Request:** `id` (issue id or identifier); optional `fields` including `description`, `labels`, `status`, `documents`
- **Response:** Title, description, labels, status, documents list as needed
- **Boundary validation:** Conventions must name this tool; ask if Work items still placeholder
- **Errors:** Missing MCP → R1 ask; unknown id → stop create-from fetch

### Linear MCP `save_issue`

- **Kind:** API · **Lands in:** `stages/linear-sync.md`
- **Request:** Create child: `team`, `title`, `description` (marker + brief body), `parentId`. Update: `id` plus fields. Prefer `addLabels` / `removeLabels` over full `labels` replace. Append `links` for repo pointer.
- **Response:** Issue id / identifier
- **Boundary validation:** Marker present on skill-owned children; no full-spec description on parent
- **Errors:** Permission / validation → report in chat; do not half-apply unmarked deletes

### Linear MCP `save_comment`

- **Kind:** API · **Lands in:** `stages/linear-sync.md` › Link-back / progress log
- **Request:** Create only: `issueId` + `body` (progress marker + what changed). Do not pass `id` to edit prior progress comments (D18 (append progress))
- **Response:** Comment id (not stored in repo)
- **Boundary validation:** Progress body includes progress-log marker
- **Errors:** Create failure → report in chat; do not invent edit-in-place fallback

### Linear MCP `list_comments`

- **Kind:** API · **Lands in:** `stages/linear-sync.md` › optional discovery / human timeline
- **Request:** `issueId` on parent (and on children when scanning markers if needed)
- **Response:** Comment list; progress markers identify skill timeline entries
- **Boundary validation:** —
- **Errors:** — (progress log does not require prior comments to exist)

### Linear MCP `save_document` / `get_document`

- **Kind:** API · **Lands in:** `stages/linear-sync.md` › Document mirror
- **Request:** Create: `title`, `content`, `issue` = parent. Update: `id` + `content` (full replace ok for regenerate)
- **Response:** Document id / slug
- **Boundary validation:** Mirror banner required; summary depth only (D8 (document depth))
- **Errors:** Conflict stop before overwrite when R14 fires — D16 (conflict fingerprint)

### Native Cursor assign / `@Cursor`

- **Kind:** Product path (not skill API) · **Lands in:** child body contract only
- **Request:** Human (or triage) assigns Cursor or comments `@Cursor` on the marked child
- **Response:** Cloud agent run (product-owned)
- **Boundary validation:** Skill MUST NOT call a second launcher; MUST NOT auto-`delegate` in v1 (R16 (human gated launch)). Product Linear integration is not Linear MCP (D19 (mcp session), R21 (mcp session)).
- **Errors:** Stale Linear AC as scope — forbidden by canon banner on child. Tracker write-back deferred to an MCP-capable session.

## State ownership and lifecycle

| State | Owner | Load | Refresh | Invalidate | Persisted? |
| ----- | ----- | ---- | ------- | ---------- | ---------- |
| `Work item` id | `spec.md` | Create-from / manual | On relink (rare) | Clear only if user unlinks | yes (repo) |
| Progress gate | `spec.md` | Always | Gate crossings | — | yes (repo) |
| Phase statuses | `implementation-plan.md` | Implement / SDD | Each unit | — | yes (repo) |
| Marked children | Linear + markers | Child sync | Plan/list change | Cancel on unit remove | yes (Linear) |
| Progress comments | Linear (append-only) | Status sync on real delta | Each Progress / child status change | — | yes (Linear) |
| Document mirror | Linear Document | Document path | Regenerate via id in `spec.md` | — | yes (Linear) |
| Document mirror id | `spec.md` | After Document create | On recreate (rare) | Clear on unlink | yes (repo) |
| Conventions maps | Project README | Before write-back | Init-project fill | — | yes (repo) |
| Conflict fingerprint | `spec.md` (hash of parent description) | After link (D16, D17) | On person resolve / re-link | On person resolve | yes (repo) |

Repo remains canonical for binding design. Linear holds tracker fields only (G7 (repo canonical)).

## Persistence changes

### Project conventions (README)

**Lands in:** `skills/spec/templates/spec-docs-readme.md` (schema); live `spec_docs/README.md` filled by init-project

| Column / path | Type | Purpose |
| ------------- | ---- | ------- |
| Work items › Linear team | string | Create + child team |
| Work items › fetch blurb | prose | Create-from MCP instructions |
| Work items › state maps | maps | Progress + phase → Linear |
| Work items › optional label / repo | string | Design label; `[repo=…]` |

### Sync ids (`spec.md`)

**Lands in:** linked `spec.md` near `Work item` (D17 (ids in spec))

| Column / path | Type | Purpose |
| ------------- | ---- | ------- |
| Document mirror id | string | Update same Linear Document on regenerate |
| Conflict fingerprint | string | Body-hash tripwire for R14 (conflict stop) |

### Access control

- Anyone who can run the skill and whose Linear integration can create/update issues in the configured team (Users and context in `spec.md`).
- Document summaries widen read access to everyone with issue access — keep summaries only (R19 (no secrets)).

### Migration

1. Template gains Linear schema slots; existing READMEs keep placeholder until init-project or a human fills them.
2. Linked specs gain Document id + fingerprint fields on first link / Document create.
3. No automatic backfill of historical Linear children.
4. Rollback: leave conventions blank; skill asks and skips write-back (R1 (conventions gate)).

## Rollout and compatibility

- v1 assumes Linear MCP in the agent session that performs write-back. No webhooks or background sync (Non-goals). Linear-started cloud without working Linear MCP is kickoff-only for tracker fields (D19 (mcp session), R21 (mcp session)).
- Plugin root `README.md` MUST document the local-sync vs Linear-kickoff operator model when this feature ships.
- Folders without `Work item` are untouched by sync.
- Thin / planless specs: parent sync only; no children (G6 (thin noop)).
- Child body field list MUST stay aligned with `stages/implement.md` phase brief when that contract changes (Notes › Multi-subagent dependency).
