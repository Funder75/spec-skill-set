# Linear sync

Shared Linear write-back doctrine for create-spec, plan, implement, archive, and explicit sync (G7 (repo canonical), R20 (routing entry)). Stages call this file; do not invent a second sync path.

The repo is canonical. Linear holds Tracker Spec / Tracker Phase identity, brief bodies, status mirrors, and optional Document mirrors. Do not pull Linear prose into `spec.md`.

## Preconditions

Before any Linear write or create-from fetch that needs MCP:

1. Read **Work items** under **Project conventions** in `spec_docs/README.md`. Require only the fields that operation uses (R1 (conventions gate)): fetch blurb for create-from; team/project for create; the relevant state map for a status update.
2. Linear MCP must be usable in this agent session (R21 (mcp session)). Cursor assign / `@Cursor` is not Linear MCP auth.
3. Routine writes need a stored id (R22 (reference gate)): Tracker Spec updates need `Work item: <id>`; Tracker Phase updates need `Tracker phase: <id>`. A routine hook MUST skip a field whose value is `n/a` and MUST NOT create tracker work as a side effect.

If a write or explicit create is requested and Linear MCP or required conventions are missing: warn once; skip write-back; do not invent a project, team, state map, or silent half-link (R1 (conventions gate), R21 (mcp session)). Create-spec MAY still write `spec.md` with `Work item` set after a successful fetch.

## Link-back

First successful link after create-spec sets `Work item` and write-back is allowed (G1 (create from linear), R3 (first link back)).

**In short:** Comment with the repo path; optional real URL `links` and design label; store the returned Tracker Spec URL. Never rewrite the issue description.

### When

- `Work item` is set to a real id (not `n/a`).
- Preconditions pass for write-back.

### Steps

1. `save_comment` on the Tracker Spec: body names `spec_docs/<slug>/` (path text only).
2. If conventions define a design-stage label: `save_issue` with `addLabels` for that label only (not a full label replace).
3. Append Linear `links` only when a real URI exists (hosted remote or equivalent). NEVER invent a bare-path link such as `spec_docs/foo/`.
4. After Linear returns the Tracker Spec URL, write it into `spec.md` as **Tracker Spec URL**. Do not invent the URL beforehand.

### MUST NOT

- Set Tracker Spec `description` to the full spec or binding AC from the repo (R2 (no body rewrite)).
- Paste the raw Linear payload into `spec.md` (create-spec maps AC onto goals’ `Source:` lines once; that stays in create-spec).
- Invent team, project, or half-links when conventions or MCP are missing.

After Link-back steps succeed, run **Document** › Create on first link.

## Tracker Phase create / update / cancel

Plan and implement hooks call this section (G2 (tracker phases), G4 (cloud ready phases), G6 (thin noop)). Identity is the repo-stored `Tracker phase:` id (R6 (repo-stored phase identity)). Never rediscover by title or description.

**In short:** One Tracker Phase per dispatch unit; create when `n/a`, update by stored id, cancel+comment before removing a field. No plan file → no-op. Unlinked → skip.

### Plan file required

Treat “plan exists” as either `<slug>.plan.md` or bare `implementation-plan.md` in that folder (R4 (no auto migrate), R5 (thin noop)). Prefer D1 names in new prose; existing folders may still use the bare plan basename. If neither file exists → Tracker Phase create/update/cancel is a no-op (R4 (freeze before plan), R5 (thin noop)). Do not invent a plan to unlock Tracker Phases.

### Guards (every call)

1. **Unlinked.** `Work item: n/a` on a routine plan/implement hook → skip all Tracker Phase writes; do not call Linear discovery (R22 (reference gate)). Explicit sync MAY create the Tracker Spec first — see Explicit sync below.
2. **No plan.** Neither plan filename exists → no-op (R5 (thin noop)).
3. **MCP / conventions.** Required team/project (for create) or write-back fields missing, or Linear MCP unusable → warn once; skip write-back; do not invent maps or half-create (R1 (conventions gate), R21 (mcp session)).

### Dispatch units

Build units from the plan progress overview:

- One open phase alone → one unit.
- Phases listed as **Combinable with** each other → one unit for the whole group.
- Every phase in a combinable unit MUST store the same `Tracker phase:` value (R6 (repo-stored phase identity)).

Ensure each phase section has `Tracker phase: <id> | n/a`. Default new packets to `n/a`.

### Create (field is `n/a`)

When write-back is allowed, a plan exists, `Work item` is a real id, and the unit’s `Tracker phase` is `n/a`:

1. Build the Tracker Phase body (below).
2. `save_issue` create: team (and project if conventions require), title from unit name / phase ids, `description` = body, Linear API `parentId` = Tracker Spec id (flat — R10 (flat phases)). Do not nest under an Implementation container by default.
3. Immediately write the returned id onto **every** phase in that dispatch unit as `Tracker phase: <id>`.
4. Do not title-search or scan descriptions for an existing phase (R8 (direct and selective update)).

### Update (field is a stored id)

When a unit already has `Tracker phase: <id>` and a source field for the body changed (or plan create/refresh asks for a refresh):

1. `save_issue` update that id only: changed fields (usually `description`, optionally `title`). Prefer `addLabels` / `removeLabels` over full label replace.
2. Do not create a duplicate because a phase was renamed or renumbered (R8 (direct and selective update)). Preserve the stored id across renames/renumbering.
3. Leave Linear work not referenced by `Work item:` or any `Tracker phase:` untouched (R7 (unreferenced leave)). Never `list_issues` to guess ownership.

### Cancel removed unit

When a plan edit removes a dispatch unit that still has a stored Tracker Phase id (R9 (cancel removed)):

1. `save_comment` on that Tracker Phase with the reason (unit removed from plan).
2. `save_issue` set state to canceled (conventions map if present).
3. Only then remove the `Tracker phase:` field / phase section from the plan.
4. MUST NOT silent-delete. MUST NOT later scan Linear to rediscover which unreferenced item “used to” belong to the phase.

### Tracker Phase body (cloud-ready)

Build `description` from the same fields as [implement.md](implement.md) › Phase brief and Env checklist (R15 (cloud ready body)). Keep sections aligned when either contract changes.

| Section | Required | Source |
| ------- | -------- | ------ |
| Canon banner | yes | Fixed: repo canonical; do not invent scope beyond Done when |
| Spec slug + unit name | yes | Folder + plan |
| Phase id(s) | yes | Plan |
| Goals covered (full `G…` forms) | yes | Phase **Covers** |
| Scoped paths / Read first cues | yes | Phase packet |
| Done when summary | yes | Phase **Done when** (summary, not full checkbox mirror) |
| Stop after this unit | yes | Fixed instruction |
| Env checklist cues | yes for cloud-ready | Short bullets from implement Env checklist; not a second launcher |
| `[repo=…]` | when conventions set a default | Project conventions |

Shape (illustrative):

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

### MUST NOT (Tracker Phase)

- Auto-assign Cursor or call a skill Cloud Agent launcher (R16 (human gated launch)). MAY mention “mark Tracker Phase ready to delegate” as status/label only.
- Invent scope in the body beyond Done when / the phase packet.
- Create Tracker Phases while no plan file exists.
- Touch unreferenced Linear work.
- Run full explicit sync as a side effect of a routine plan/implement hook (R8 (direct and selective update), R12 (selective tracker writes)).

## Status (selective)

Plan, implement, and archive hooks call this section (G3 (status mirror), R11 (status mirror), R12 (selective tracker writes), R13 (progress log), R18 (archive gate)). Repo Progress and plan phase status own the truth; Linear never writes them (G7 (repo canonical)).

**In short:** Gate → Tracker Spec only; phase status → that Tracker Phase only; new progress comment on a real delta; archive asks before Tracker Spec Done if any referenced Tracker Phase is still open. Routine hooks MUST NOT run Explicit sync.

### Guards (every call)

1. **Unlinked / `n/a`.** Routine status write needs a stored id (R22 (reference gate)): Tracker Spec updates need `Work item: <id>`; Tracker Phase updates need `Tracker phase: <id>`. Skip that field when the value is `n/a`; do not create tracker work as a side effect.
2. **MCP / conventions.** Required state map (Progress → Tracker Spec, or phase status → Tracker Phase) missing, or Linear MCP unusable → warn once; skip write-back; do not invent maps (R1 (conventions gate), R21 (mcp session)).
3. **Selective only.** Update only the affected object by stored id. MUST NOT run full Explicit sync from a gate, phase-status, or archive hook (R8 (direct and selective update), R12 (selective tracker writes)).

### Progress → Tracker Spec

When `Progress` in `spec.md` changes (promote, implement start, archive) and write-back is allowed:

1. Map the new Progress value to Tracker Spec state and labels via conventions **Tracker Spec Progress map**.
2. `save_issue` update that Tracker Spec id only (`state` / `addLabels` / `removeLabels` as the map requires). Prefer label add/remove over a full label replace.
3. If Progress actually changed (not a no-op re-apply), post a progress-log comment (below).
4. Do not touch Tracker Phases on a Progress-only event.

### Phase status → Tracker Phase

When a plan phase (or combinable dispatch unit) status changes and write-back is allowed:

1. Read that unit’s stored `Tracker phase:` id. If `n/a`, skip (R22 (reference gate)).
2. Map the new plan status (`Not started` … `Blocked`) to Tracker Phase state via conventions **Tracker Phase status map**.
3. `save_issue` update that Tracker Phase id only. Combined phases that share one id → update once using the dispatch unit’s status (R11 (status mirror)).
4. If the Tracker Phase status actually changed, post a progress-log comment on the Tracker Spec (below).
5. Do not update other Tracker Phases. Do not require a confirm prompt on every phase Done (R12 (selective tracker writes)).

### Progress-log comment

On a **real** Progress or referenced Tracker Phase status delta (R13 (progress log), D18 (append progress)):

1. `save_comment` on the Tracker Spec with **no** `id` (create a new comment only).
2. Body MUST include the marker and a short summary of what changed:

```text
<!-- spec-sync-progress: slug=<folder-slug> -->
…
```

3. MUST NOT edit prior progress comments in place (never pass `id` to `save_comment` for a progress entry).
4. MUST NOT post a progress comment on a no-op (same Progress / same Tracker Phase state re-applied, including a no-op explicit sync with no status delta).

### Archive gate

When archive is confirmed and the skill would mark the Tracker Spec Done (R18 (archive gate)):

1. For every plan phase with a stored `Tracker phase: <id>` (not `n/a`), check that Tracker Phase is Done or Deferred per the conventions map (Deferred follows the map).
2. If every referenced Tracker Phase is Done or Deferred → map archive Progress to Tracker Spec Done (and labels) and post a progress-log comment when Progress actually changed.
3. If any referenced Tracker Phase is still open → ask before marking the Tracker Spec Done. Do not silently complete it.
4. Status-only archive updates that leave the issue body alone are not blocked by conflict rules (R14 (conflict stop)).

### MUST NOT (Status)

- Overwrite plan phase status or `Progress` from Linear (G7 (repo canonical), A3.3).
- Prompt to confirm Linear on every phase Done.
- Run Explicit sync as a prerequisite for routine selective writes.
- Edit prior progress comments or invent an edit-in-place fallback when create fails.

## Document

Create and regenerate the Linear Document mirror from the repo (G5 (document mirror), R17 (document mirror), D15 (document trigger)). One-way repo → Linear only. Never pull Linear prose into `spec.md`.

**In short:** Create on first link; regenerate when TL;DR or goals change; store Document id and URL after Linear returns them. Status-only ticks do not regenerate.

### Content

Build Document body via Linear MCP `save_document` with `issue` = Tracker Spec id (R19 (no secrets)):

| Field | Required | Source |
| ----- | -------- | ------ |
| Title | yes | Includes “mirror” or equivalent |
| Mirror banner | yes | Repo canonical; do not edit binding content in Linear (D16 (no linear edits)) |
| TL;DR | yes | From `spec.md` TL;DR bullets |
| Goals / AC summary | yes | Goal titles + short criteria; not full journeys or the whole spec |

MUST NOT include full `spec.md`, secrets, or private dumps.

### Create on first link

When Link-back succeeds (or Explicit sync creates a Tracker Spec) and write-back is still allowed:

1. If **Document id** is already stored → skip create; use Regenerate when TL;DR/goals warrant it.
2. `save_document` create with the Content above.
3. After Linear returns Document id and URL, write **Document id** and **Document URL** into `spec.md` (D17 (repo-stored tracker ids)). Do not invent them beforehand.
4. Missing MCP or conventions → warn once; skip Document write-back; do not fail create-spec solely for sync (R1 (conventions gate), R21 (mcp session)).

### Regenerate

When **Document id** is stored and TL;DR or goals in `spec.md` changed (design edit, promote that revises goals, or Explicit sync that notices the delta):

1. Run **Conflict** if a Linear prose conflict is known.
2. If Conflict allows overwrite (or no conflict known): `save_document` / update that Document id from Content above.
3. Refresh **Document URL** in `spec.md` only when Linear returns a new URL.
4. MUST NOT regenerate on Progress-only or phase-status-only ticks (D15 (document trigger)).
5. Callers: create-spec does not regenerate; stages that rewrite TL;DR/goals on a linked folder, and Explicit sync when those fields changed, call this section.

### MUST NOT (Document)

- Treat Linear Document or issue body as editable AC truth.
- Require a body-hash fingerprint field in `spec.md` (D16 (no linear edits), Q1 (auto detect) open).
- Push secrets or full private dumps (R19 (no secrets)).

## Conflict

When a Linear prose conflict with a mirrored surface is **known** (human report or a later trivial detector — not a required hash tripwire), warn and offer D20 (conflict choices) before overwriting (R14 (conflict stop), D6 (conflict stop), D9 (keep conflict stop)).

**In short:** Do not treat Linear as ahead of the repo. Status-only updates and new progress comments that leave bodies alone are not blocked.

### Choices (v1)

Offer exactly these options (D20 (conflict choices)):

1. **Regenerate from repo.** Overwrite the Document (or other mirrored surface) from `spec.md`. Leave Linear status and comments alone.
2. **Skip this regenerate.** Leave Linear prose as-is this run; status-only and progress comments may continue.
3. **Stop Linear writes.** Ask before further Document or description touches until the person unblocks.

### MUST NOT (Conflict)

- Silent overwrite when a conflict is known.
- Require a body-hash or issue-`updatedAt` tripwire in v1 (D16 (no linear edits)).
- Invent Linear as source of truth for binding content.

## Explicit sync

Entry: `/spec linear sync` or equivalent create/repair wording (R20 (routing entry), R8 (direct and selective update), R22 (reference gate)).

**In short:** Create objects whose repo field is `n/a`, update referenced objects, repair invalid references, ask for missing project/team/maps/ownership. Never infer ownership from titles. Routine hooks MUST NOT run this full operation.

### When

User asked for explicit create/repair (Infer routes here). Not a side effect of plan write, phase status, Progress, or archive.

### Steps

1. Read Preconditions. If Linear MCP or required conventions for the operations below are missing → warn once; ask for the missing project, team, state-map, or ownership information; do not invent them.
2. **Tracker Spec.** If `Work item: n/a` → ask for any missing create inputs, create the Tracker Spec, then write the returned id (and URL when Linear returns it) into `spec.md` immediately. If `Work item` holds an id that Linear rejects as invalid → ask how to repair (new create vs corrected id); do not title-search. If the id is valid → update referenced Tracker Spec fields that are out of date (status/labels via maps when Progress warrants it; do not rewrite description with the full spec — R2 (no body rewrite)).
3. **Tracker Phases.** When a plan file exists (`<slug>.plan.md` or bare `implementation-plan.md`): for each dispatch unit with `Tracker phase: n/a`, reuse **Tracker Phase create / update / cancel** › Create (same path — do not invent a second create). For each stored id, update by id when source fields warrant it. For an invalid stored id → ask/repair; never `list_issues` or title-search to guess ownership (R7 (unreferenced leave), R8 (direct and selective update)).
4. **No plan.** Tracker Phase create stays a no-op (R5 (thin noop)); Tracker Spec create/update may still run.
5. **Document.** If Document id is `—` / missing after a linked Tracker Spec exists → Create on first link. If Document id is stored and TL;DR or goals changed → Regenerate (via Conflict when known). Status-only → skip Document.
6. **Progress comments.** Only if this sync produced a real Progress or Tracker Phase status delta → new progress-log comment. No-op sync → none (R13 (progress log)).
7. Leave Linear work not referenced by `Work item:` or any `Tracker phase:` untouched.

### MUST NOT

- Infer project, team, state maps, or which Linear issue “belongs” to a phase from titles or descriptions.
- Duplicate a Tracker Phase because a title or phase number changed when a valid stored id exists.
- Become a prerequisite that routine selective hooks must run first.
