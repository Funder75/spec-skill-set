# Linear sync

Shared Linear write-back doctrine for create-spec, plan, implement, archive, and explicit sync (G7 (repo canonical), R20 (routing entry)). Stages call this file or the hook file it points to; do not invent a second sync path.

The repo is canonical. Linear holds Tracker Spec / Tracker Phase identity, brief bodies, status mirrors, and an optional description mirror (full overview, TL;DR abstract, or custom text). Do not pull Linear prose into `<slug>.spec.md` or `<slug>.epic.md`.

**Store:** Durable Tracker Spec foreign keys live in `<slug>.spec.md` YAML frontmatter, or in `<slug>.epic.md` when the folder is an epic: `work_item`, `tracker_spec_url`. Older folders may still carry `document_id` / `document_url` from the retired Document mirror; ignore them and do not write them. An epic may also store `linear_project` and `linear_project_url` when explicit sync created a Linear project instead of an issue (R24 (epic shape)). A spec does not use those two keys. A child of an epic also stores frontmatter `epic: <epic-slug>`; that slug is the only input for nesting its Tracker Spec under the epic (R26 (epic child parent)). Unset is `n/a` (treat a missing key as `n/a`); `pending` is a third transient value written just before a create call and replaced by the real id (or cleared back to `n/a`) right after — see each hook file's **Repairing a `pending` marker**. Do not mirror these ids in the markdown body (optional one-line `Linked: …` is display only). A real `linear_project` means the epic is a Linear project: leave `work_item` at `n/a` and do not also create an issue. Do not set `work_item` and `linear_project` both to real ids. `Progress` stays a body line on a spec. An epic has no Progress line. Plan phase `Tracker phase:` and Status stay in the plan body — never in Cursor plan `todos` frontmatter; `Tracker phase:` uses the same `n/a` / `pending` / `<id>` values. An epic has no plan, so it has no Tracker Phases.

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
| Link-back, Description, Conflict | [linear-sync/link-document.md](linear-sync/link-document.md) | create-spec (Link-back); Explicit sync (below) |
| Tracker Phase create / update / cancel | [linear-sync/tracker-phases.md](linear-sync/tracker-phases.md) | plan, implement (Tracker Phase fallback create); Explicit sync |
| Status (selective): Progress → Tracker Spec, Phase status → Tracker Phase, progress-log comment, Archive gate | [linear-sync/status.md](linear-sync/status.md) | plan, implement, archive |
| Explicit sync | This file, below | `/spec linear sync` and equivalent wording |

## Explicit sync

Entry: `/spec linear sync`, `sync with linear`, `sync to linear`, or equivalent create/repair wording (R20 (routing entry), R8 (direct and selective update), R22 (reference gate)).

**In short:** Ask the questions under Asks, then create objects whose repo field is `n/a`, update referenced objects, repair invalid references, and ask for missing project/team/maps/ownership. Never infer ownership from titles. Routine hooks MUST NOT run this full operation and MUST NOT ask these questions.

### When

User asked for explicit create/repair (Infer routes here). Not a side effect of plan write, phase status, Progress, or archive.

### Asks

Only explicit sync asks these. On an epic, ask Epic shape first. Ask Issue body when the target is or will be an issue or project. Wait for each answer. Do not infer it, and do not store it. The next explicit sync asks again.

**Epic shape (R24 (epic shape)).** Only when `<slug>.epic.md` exists and both `work_item` and `linear_project` are `n/a` or missing. Ask once: a new Linear project, or a Linear issue.

- **Project.** Create the project. Do not create an issue. Leave `work_item` and `tracker_spec_url` at `n/a`. Then ask Issue body (the project description).
- **Issue.** Create or update the Tracker Spec. Do not create a project. Leave `linear_project` and `linear_project_url` at `n/a`. Then ask Issue body.
- A real `work_item` is already an issue. Skip this ask. Do not create a project. Ask Issue body.
- A real `linear_project` is already a project. Skip this ask. Do not create an issue. Ask Issue body (the project description).
- `pending` on either key is the repair ask under Epic sync, not this shape ask.
- If both keys are real ids, warn once and ask which link to keep. Create nothing until they answer. Clear the rejected key back to `n/a`. Do not delete the Linear object.

**Issue body (R25 (issue body ask)).** Feature, bugfix, and any epic: ask once how to set the Linear description. The target is the issue description, or the project description when the epic is a Linear project. Offer exactly these four choices. Wait for the answer. Do not infer it, and do not store it.

- **Full.** `description` is one canon line (`Repo canonical. Do not edit binding content in Linear.`) plus the overview file after its YAML frontmatter: `<slug>.spec.md`, or `<slug>.epic.md` when the folder is an epic. Not the tech siblings and not the plan. Omit secret values (R19 (no secrets)).
- **Abstract.** The same canon line, then the `#` title and the `## TL;DR` section (the four bullets) from that overview file. Not goals, suggested specs, tech siblings, or the plan. Omit secret values (R19 (no secrets)).
- **Custom.** Ask for the description text in the same turn. Use exactly what they provide, still prefixed with the canon line. Do not invent prose. Omit secret values (R19 (no secrets)).
- **Skip.** Do not set or rewrite the description (R2 (no body rewrite)).

On **Full**, **Abstract**, or **Custom**: on create, pass that description; on an existing issue or project, replace the description. When a Linear prose conflict is known, run [linear-sync/link-document.md](linear-sync/link-document.md) › Conflict before that replace; choice 1 includes this description write (rebuilding Full or Abstract from the repo, or re-asking Custom text), choice 2 skips it this run (R14 (conflict stop)).

Create-spec link-back and routine hooks do not ask and do not write this description.

### Epic sync

When `spec_docs/<slug>/<slug>.epic.md` exists, run this instead of the numbered steps below. One way, repo to Linear. Never copy Linear description or comments into `<slug>.epic.md`.

1. Read **Preconditions**. Team is required when a project or a Tracker Spec must be created. The conventions Linear project is required only when creating a Tracker Spec and conventions put issues under a project. A Progress state map is not required.
2. Run **Epic shape** when it applies. If both `work_item` and `linear_project` are real ids, finish that ask before the next step.
3. **Project.** When the shape answer is project, or `linear_project` is a real id or `pending` while `work_item` is `n/a`:
   - Do not create a Tracker Spec.
   - If `linear_project` is `n/a` or missing: ask for a missing team. Write `linear_project: pending` and save `<slug>.epic.md`, then `save_project` with `name` from the epic title and `addTeams` from the conventions team. Set the project `description` only when the Issue body answer was Full, Abstract, or Custom. Do not write this id into **Project conventions**. After Linear returns the id and URL, write `linear_project` and `linear_project_url`, replacing `pending`.
   - If `linear_project` is `pending`: ask before retrying. The one narrow lookup is projects on the conventions team whose comment names `spec_docs/<slug>/` (not a title search).
   - If Linear rejects the id: ask how to repair (new create vs corrected id). Do not title-search.
   - If the id is valid: update the project name when the epic title differs. Write the project description only when the Issue body answer was Full, Abstract, or Custom.
   - When the id is real and `linear_project_url` is `n/a`: `save_comment` with `projectId` set to that id and a body that names `spec_docs/<slug>/`. Append `links` only when a real URI exists. Then write the returned URL into `linear_project_url`. No issue label.
   - No Tracker Phases. No progress-log comment. Do not create child-spec Tracker Specs from this epic sync; each child files itself under **Epic child parent** when that child is synced. Stop this epic sync here.
4. **Issue.** When the shape answer is issue, or `work_item` is already a real id: run **Issue body**, then the same create, pending, and invalid-id rules as step 2 under Steps, reading and writing frontmatter on `<slug>.epic.md`. On Full, Abstract, or Custom, set or replace the issue description as Issue body says. On Skip, do not rewrite it (R2 (no body rewrite)). Do not set Linear state from Progress. Do not create a Linear project. Do not create child-spec Tracker Specs here; each child sync applies **Epic child parent**.
5. **No Tracker Phases.** An epic has no plan. Skip phase create and update.
6. **Link-back.** When `work_item` is a real id and `tracker_spec_url` is `n/a`, run [linear-sync/link-document.md](linear-sync/link-document.md) › Link-back against `<slug>.epic.md`. Link-back still does not rewrite the description; Issue body already did when the answer was Full, Abstract, or Custom.
7. Do not append a progress-log comment. Leave Linear work not referenced by frontmatter `work_item` or `linear_project` untouched.

### Epic child parent (R26 (epic child parent))

When syncing a feature or bugfix whose frontmatter `epic` is a real slug (not `n/a`), nest its Tracker Spec under that epic's Linear object. Read `spec_docs/<epic-slug>/<epic-slug>.epic.md` frontmatter. Do not title-search. Do not invent a parent.

| Epic frontmatter | On child Tracker Spec create / repair |
| ---------------- | ------------------------------------- |
| `work_item` is a real id | Pass Linear `parentId` = that id (sub-issue of the epic issue). Keep the conventions project when conventions put issues under a project. |
| `linear_project` is a real id and `work_item` is `n/a` | Pass Linear `project` = that id. Do not set `parentId` (the epic is a project, not an issue). Prefer this project over a conventions default when both exist. |
| Both keys `n/a` / missing, or the only set key is `pending` | Create or update the child without nesting. Warn once that the epic is not linked yet, so the child was not nested. A later sync after the epic is linked repairs via the rows above. |
| Epic file missing | Warn once; create or update without nesting. Do not clear frontmatter `epic`. |

Apply this table on create (step 2 below) and on update when the stored child `work_item` is valid and the Linear parent/project still disagrees with the table. Do not nest Tracker Phases under the epic; they stay under the child's Tracker Spec (`parentId` = child `work_item`).

### Steps

These steps are for a feature or bugfix folder. An epic uses Epic sync above.

1. Read **Preconditions** above. If Linear MCP or required conventions for the operations below are missing → warn once; ask for the missing project, team, state-map, or ownership information; do not invent them.
2. **Tracker Spec.** Run **Issue body** first. Resolve **Epic child parent** when frontmatter `epic` is set. If frontmatter `work_item` is `n/a` or missing → ask for any missing create inputs, write frontmatter `work_item: pending` and save `<slug>.spec.md`, then create the Tracker Spec (include the Issue body description only when the answer was Full, Abstract, or Custom; include `parentId` / `project` from **Epic child parent**), then write the returned id into frontmatter `work_item` (and URL into `tracker_spec_url` when Linear returns it) immediately, replacing `pending`. If `work_item` is already `pending` → ask the user before retrying; the one narrow lookup allowed is listing issues by team/project named in conventions that reference this repo path in a comment (not a title search), to check whether the interrupted create actually landed — when **Epic child parent** supplies a real epic `work_item`, that lookup MAY instead list by `parentId` = the epic issue (still not a title search). If `work_item` holds an id that Linear rejects as invalid → ask how to repair (new create vs corrected id); do not title-search. If the id is valid → update referenced Tracker Spec fields that are out of date (status/labels via maps when Progress warrants it), and repair `parentId` / `project` when **Epic child parent** says they disagree. Replace the description only when this sync's Issue body answer was Full, Abstract, or Custom (R25 (issue body ask)); on Skip do not rewrite it (R2 (no body rewrite)).
3. **Tracker Phases.** When `<slug>.plan.md` exists: for each dispatch unit with `Tracker phase: n/a`, reuse [linear-sync/tracker-phases.md](linear-sync/tracker-phases.md) › Create (same path — do not invent a second create). For each stored id, update by id when source fields warrant it. For an invalid stored id → ask/repair; never `list_issues` or title-search to guess ownership (R7 (unreferenced leave), R8 (direct and selective update)). If only the bare `implementation-plan.md` is present, stop and tell the user to rename it to `<slug>.plan.md` first.
4. **No plan.** Tracker Phase create stays a no-op (R5 (thin noop)); Tracker Spec create/update may still run.
5. **Progress comments.** Only if this sync produced a real Progress or Tracker Phase status delta → new progress-log comment ([linear-sync/status.md](linear-sync/status.md) › Progress-log comment). No-op sync → none (R13 (progress log)).
6. Leave Linear work not referenced by frontmatter `work_item` or any `Tracker phase:` untouched.

### MUST NOT

- Infer project, team, state maps, or which Linear issue “belongs” to a phase from titles or descriptions.
- Duplicate a Tracker Phase because a title or phase number changed when a valid stored id exists.
- Become a prerequisite that routine selective hooks must run first.
- Create both a Linear project and a Linear issue for one epic (R24 (epic shape)).
- Write a Linear description unless this explicit sync's Issue body answer was Full, Abstract, or Custom (R25 (issue body ask), R2 (no body rewrite)).
- Ask Epic shape or Issue body from a routine hook or from create-spec link-back.
- Nest a child Tracker Spec under an epic by guessing from titles; only use stored epic frontmatter ids (R26 (epic child parent)).
- Create every child Tracker Spec as a side effect of epic sync.
