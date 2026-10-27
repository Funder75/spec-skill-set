# Linear sync

Shared Linear write-back doctrine for create-spec, plan, implement, archive, and explicit sync (G7 (repo canonical), R20 (routing entry)). Stages call this file or the hook file it points to; do not invent a second sync path.

The repo is canonical. Linear holds Tracker Spec / Tracker Phase identity, brief bodies, status mirrors, and optional Document mirrors. Do not pull Linear prose into `<slug>.spec.md`.

**Store:** Durable Tracker Spec foreign keys live in `<slug>.spec.md` YAML frontmatter only: `work_item`, `tracker_spec_url`, `document_id`, `document_url`. Unset is `n/a` (treat a missing key as `n/a`); `pending` is a third transient value written just before a create call and replaced by the real id (or cleared back to `n/a`) right after — see each hook file's **Repairing a `pending` marker**. Do not mirror these ids in the markdown body (optional one-line `Linked: …` is display only). `Progress` stays a body line. Plan phase `Tracker phase:` and Status stay in the plan body — never in Cursor plan `todos` frontmatter; `Tracker phase:` uses the same `n/a` / `pending` / `<id>` values.

## Preconditions

Before any Linear write or create-from fetch that needs MCP:

1. Read **Work items** under **Project conventions** in `spec_docs/README.md`. Require only the fields that operation uses (R1 (conventions gate)): fetch blurb for create-from; team/project for create; the relevant state map for a status update.
2. Linear MCP must be usable in this agent session (R21 (mcp session)). Cursor assign / `@Cursor` is not Linear MCP auth.
3. Routine writes need a stored id (R22 (reference gate)): Tracker Spec updates need frontmatter `work_item: <id>`; Tracker Phase updates need `Tracker phase: <id>`. A routine hook MUST skip a field whose value is `n/a` (or missing) and MUST NOT create tracker work as a side effect. A field whose value is `pending` means an earlier create was interrupted: a routine hook MUST skip it the same way (do not create again, do not write status to it) and mention it once so the user can repair it (see the hook file's **Repairing a `pending` marker**).

If a write or explicit create is requested and Linear MCP or required conventions are missing: warn once; skip write-back; do not invent a project, team, state map, or silent half-link (R1 (conventions gate), R21 (mcp session)). Create-spec MAY still write `<slug>.spec.md` with frontmatter `work_item` set after a successful fetch.

## Hooks

Read only the one hook file a caller needs — not this whole doctrine on every routine write:

| Hook | File | Called by |
| ---- | ---- | --------- |
| Link-back, Document, Conflict | [linear-sync/link-document.md](linear-sync/link-document.md) | create-spec (Link-back, Document create); Explicit sync (below) |
| Tracker Phase create / update / cancel | [linear-sync/tracker-phases.md](linear-sync/tracker-phases.md) | plan, implement (Tracker Phase fallback create); Explicit sync |
| Status (selective): Progress → Tracker Spec, Phase status → Tracker Phase, progress-log comment, Archive gate | [linear-sync/status.md](linear-sync/status.md) | plan, implement, archive |
| Explicit sync | This file, below | `/spec linear sync` and equivalent wording |

## Explicit sync

Entry: `/spec linear sync`, `sync with linear`, `sync to linear`, or equivalent create/repair wording (R20 (routing entry), R8 (direct and selective update), R22 (reference gate)).

**In short:** Create objects whose repo field is `n/a`, update referenced objects, repair invalid references, ask for missing project/team/maps/ownership. Never infer ownership from titles. Routine hooks MUST NOT run this full operation.

### When

User asked for explicit create/repair (Infer routes here). Not a side effect of plan write, phase status, Progress, or archive.

### Steps

1. Read **Preconditions** above. If Linear MCP or required conventions for the operations below are missing → warn once; ask for the missing project, team, state-map, or ownership information; do not invent them.
2. **Tracker Spec.** If frontmatter `work_item` is `n/a` or missing → ask for any missing create inputs, write frontmatter `work_item: pending` and save `<slug>.spec.md`, then create the Tracker Spec, then write the returned id into frontmatter `work_item` (and URL into `tracker_spec_url` when Linear returns it) immediately, replacing `pending`. If `work_item` is already `pending` → ask the user before retrying; the one narrow lookup allowed is listing issues by team/project named in conventions that reference this repo path in a comment (not a title search), to check whether the interrupted create actually landed. If `work_item` holds an id that Linear rejects as invalid → ask how to repair (new create vs corrected id); do not title-search. If the id is valid → update referenced Tracker Spec fields that are out of date (status/labels via maps when Progress warrants it; do not rewrite description with the full spec — R2 (no body rewrite)).
3. **Tracker Phases.** When `<slug>.plan.md` exists: for each dispatch unit with `Tracker phase: n/a`, reuse [linear-sync/tracker-phases.md](linear-sync/tracker-phases.md) › Create (same path — do not invent a second create). For each stored id, update by id when source fields warrant it. For an invalid stored id → ask/repair; never `list_issues` or title-search to guess ownership (R7 (unreferenced leave), R8 (direct and selective update)). If only the bare `implementation-plan.md` is present, stop and tell the user to rename it to `<slug>.plan.md` first.
4. **No plan.** Tracker Phase create stays a no-op (R5 (thin noop)); Tracker Spec create/update may still run.
5. **Document.** If frontmatter `document_id` is `n/a` or missing after a linked Tracker Spec exists → [linear-sync/link-document.md](linear-sync/link-document.md) › Create on first link. If `document_id` is a real id and TL;DR or goals changed → Regenerate (via Conflict when known). Status-only → skip Document.
6. **Progress comments.** Only if this sync produced a real Progress or Tracker Phase status delta → new progress-log comment ([linear-sync/status.md](linear-sync/status.md) › Progress-log comment). No-op sync → none (R13 (progress log)).
7. Leave Linear work not referenced by frontmatter `work_item` or any `Tracker phase:` untouched.

### MUST NOT

- Infer project, team, state maps, or which Linear issue “belongs” to a phase from titles or descriptions.
- Duplicate a Tracker Phase because a title or phase number changed when a valid stored id exists.
- Become a prerequisite that routine selective hooks must run first.
