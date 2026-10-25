# Linear integration — contracts

> Created because: markers, conventions schema, child brief body, Document fields, and Linear MCP ops need binding shapes beyond spec.md.

Types, API contracts, state ownership, and storage for **linear-integration**. [spec.md](./spec.md) owns scope and decisions; cite them in full form (`see D12 (minimal conventions)`).

Read **Stack notes for spec docs** in `spec_docs/README.md` before filling this file. This repo has no app UI or data layer; contracts here are skill markdown shapes and Linear MCP payloads.

## TL;DR

- Conventions hold team, fetch blurb, state map, and optional default `[repo=…]`.
- Durable HTML markers identify sticky comments and marked children for idempotent sync.
- Child bodies reuse the implement phase-brief field list for native Cursor kickoff.

## Summary of changes

| Layer | Change | Lands in | Persisted? |
| ----- | ------ | -------- | ---------- |
| Conventions schema | Linear Work items slots | `templates/spec-docs-readme.md` | yes (project README) |
| Sync markers | Child + sticky HTML comments | Linear issue/comment bodies | yes (in Linear) |
| Child brief body | Brief-quality markdown on children | Linear child `description` | yes (in Linear) |
| Document mirror | TL;DR + goals/AC summary | Linear Document on parent | yes (in Linear) |
| Skill routing | `linear sync` + stage hooks | `SKILL.md`, stage files | no (skill text) |
| Sync helper stage | Shared sync doctrine | `stages/linear-sync.md` (new) | no (skill text) |

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

### Sticky progress marker

**Lands in:** Linear parent comment `body`; doctrine in `stages/linear-sync.md`

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| `slug` | kebab-case string | yes | Matches folder slug | Spec folder |

```text
<!-- spec-sync-sticky: slug=linear-integration -->
```

Find via `list_comments` on the parent; update with `save_comment` + `id` when found (R13 (sticky progress)).

> **Open:** Q1 (sync state store) — whether a repo-side id cache is also required.

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
| Sync status | `linear-sync.md` › Status sync | R11–R13 | Parent/child state; sticky |
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
- Sticky comment create or in-place edit

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

- **Kind:** API · **Lands in:** `stages/linear-sync.md` › Link-back / sticky
- **Request:** Create: `issueId` + `body`. Update sticky: `id` + `body`
- **Response:** Comment id
- **Boundary validation:** Sticky body includes sticky marker
- **Errors:** Missing comment on update → create new sticky once

### Linear MCP `list_comments`

- **Kind:** API · **Lands in:** `stages/linear-sync.md` › sticky / reconcile discovery
- **Request:** `issueId` on parent (and on children when scanning markers if needed)
- **Response:** Comment list; match sticky marker in `body`
- **Boundary validation:** —
- **Errors:** Empty list → create sticky on next status sync

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
- **Boundary validation:** Skill MUST NOT call a second launcher; MUST NOT auto-`delegate` in v1 (R16 (human gated launch))
- **Errors:** Stale Linear AC as scope — forbidden by canon banner on child

## State ownership and lifecycle

| State | Owner | Load | Refresh | Invalidate | Persisted? |
| ----- | ----- | ---- | ------- | ---------- | ---------- |
| `Work item` id | `spec.md` | Create-from / manual | On relink (rare) | Clear only if user unlinks | yes (repo) |
| Progress gate | `spec.md` | Always | Gate crossings | — | yes (repo) |
| Phase statuses | `implementation-plan.md` | Implement / SDD | Each unit | — | yes (repo) |
| Marked children | Linear + markers | Child sync | Plan/list change | Cancel on unit remove | yes (Linear) |
| Sticky comment | Linear + marker | Status sync | Each status sync | — | yes (Linear) |
| Document mirror | Linear Document | Document path | Regenerate | — | yes (Linear) |
| Conventions maps | Project README | Before write-back | Init-project fill | — | yes (repo) |
| Conflict fingerprint | Skill (hash of parent description) | After link (D16) | On person resolve / re-link | On person resolve | Store location > **Open:** Q1 |

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

### Access control

- Anyone who can run the skill and whose Linear integration can create/update issues in the configured team (Users and context in `spec.md`).
- Document summaries widen read access to everyone with issue access — keep summaries only (R19 (no secrets)).

### Migration

1. Template gains Linear schema slots; existing READMEs keep placeholder until init-project or a human fills them.
2. No automatic backfill of historical Linear children.
3. Rollback: leave conventions blank; skill asks and skips write-back (R1 (conventions gate)).

## Rollout and compatibility

- v1 assumes Linear MCP in the agent session. No webhooks or background sync (Non-goals).
- Folders without `Work item` are untouched by sync.
- Thin / planless specs: parent sync only; no children (G6 (thin noop)).
- Child body field list MUST stay aligned with `stages/implement.md` phase brief when that contract changes (Notes › Multi-subagent dependency).
