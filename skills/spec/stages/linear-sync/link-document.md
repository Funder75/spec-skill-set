# Linear sync › Link-back, Document, Conflict

Part of the shared Linear write-back doctrine — see [../linear-sync.md](../linear-sync.md) for Preconditions, Store, and the hook index. create-spec and explicit sync call this file.

## Link-back

First successful link after create-spec sets frontmatter `work_item` and write-back is allowed (G1 (create from linear), R3 (first link back)).

**In short:** Comment with the repo path; optional real URL `links` and design label; store the returned URL in frontmatter `tracker_spec_url`. Never rewrite the issue description.

### When

- Frontmatter `work_item` is set to a real id (not `n/a`).
- Preconditions pass for write-back.

### Steps

1. `save_comment` on the Tracker Spec: body names `spec_docs/<slug>/` (path text only).
2. If conventions define a design-stage label: `save_issue` with `addLabels` for that label only (not a full label replace).
3. Append Linear `links` only when a real URI exists (hosted remote or equivalent). NEVER invent a bare-path link such as `spec_docs/foo/`.
4. After Linear returns the Tracker Spec URL, write it into `<slug>.spec.md` frontmatter as `tracker_spec_url`. Do not invent the URL beforehand.

### MUST NOT

- Set Tracker Spec `description` to the full spec or binding AC from the repo (R2 (no body rewrite)).
- Paste the raw Linear payload into `<slug>.spec.md` (create-spec maps AC onto goals’ `Source:` lines once; that stays in create-spec).
- Invent team, project, or half-links when conventions or MCP are missing.

After Link-back steps succeed, run **Document** › Create on first link (below).

## Document

Create and regenerate the Linear Document mirror from the repo (G5 (document mirror), R17 (document mirror), D15 (document trigger)). One-way repo → Linear only. Never pull Linear prose into `<slug>.spec.md`.

**In short:** Create on first link; regenerate when TL;DR or goals change; store `document_id` and `document_url` in frontmatter after Linear returns them. Status-only ticks do not regenerate.

### Content

Build Document body via Linear MCP `save_document` with `issue` = Tracker Spec id (R19 (no secrets)):

| Field | Required | Source |
| ----- | -------- | ------ |
| Title | yes | Includes “mirror” or equivalent |
| Mirror banner | yes | Repo canonical; do not edit binding content in Linear (D16 (no linear edits)) |
| TL;DR | yes | From `<slug>.spec.md` TL;DR bullets |
| Goals / AC summary | yes | Goal titles + short criteria; not full journeys or the whole spec |

MUST NOT include full `<slug>.spec.md`, secrets, or private dumps.

### Create on first link

When Link-back succeeds (or Explicit sync creates a Tracker Spec) and write-back is still allowed:

1. If frontmatter `document_id` is already a real id (not `n/a`) → skip create; use Regenerate when TL;DR/goals warrant it. If it is `pending`, see **Repairing a `pending` marker** below instead of creating again.
2. Write frontmatter `document_id: pending` and save `<slug>.spec.md`, before calling Linear.
3. `save_document` create with the Content above.
4. After Linear returns Document id and URL, write `document_id` and `document_url` into `<slug>.spec.md` frontmatter, replacing `pending` (D17 (repo-stored tracker ids)). Do not invent them beforehand.
5. Missing MCP or conventions → warn once; skip Document write-back; clear the `pending` marker back to `n/a` (no Linear call was made) (R1 (conventions gate), R21 (mcp session)).

#### Repairing a `pending` marker

`document_id: pending` found means a previous create was interrupted. Do not auto-retry. Ask the user. If they ask to repair: the one narrow lookup allowed is listing Documents attached to `issue` = the Tracker Spec id (not a title search). If one is found, write its id and URL. If none is found, treat it as `n/a` and run Create again.

### Regenerate

When frontmatter `document_id` is a real id and TL;DR or goals in `<slug>.spec.md` changed (design edit, promote that revises goals, or Explicit sync that notices the delta):

1. Run **Conflict** (below) if a Linear prose conflict is known.
2. If Conflict allows overwrite (or no conflict known): `save_document` / update that Document id from Content above.
3. Refresh frontmatter `document_url` only when Linear returns a new URL.
4. MUST NOT regenerate on Progress-only or phase-status-only ticks (D15 (document trigger)).
5. Callers: create-spec does not regenerate; stages that rewrite TL;DR/goals on a linked folder, and Explicit sync when those fields changed, call this section.

### MUST NOT (Document)

- Treat Linear Document or issue body as editable AC truth.
- Require a body-hash fingerprint field in `<slug>.spec.md` (D16 (no linear edits), Q1 (auto detect) open).
- Push secrets or full private dumps (R19 (no secrets)).

## Conflict

When a Linear prose conflict with a mirrored surface is **known** (human report or a later trivial detector — not a required hash tripwire), warn and offer D20 (conflict choices) before overwriting (R14 (conflict stop), D6 (conflict stop), D9 (keep conflict stop)).

**In short:** Do not treat Linear as ahead of the repo. Status-only updates and new progress comments that leave bodies alone are not blocked.

### Choices (v1)

Offer exactly these options (D20 (conflict choices)):

1. **Regenerate from repo.** Overwrite the Document (or other mirrored surface) from `<slug>.spec.md`. Leave Linear status and comments alone.
2. **Skip this regenerate.** Leave Linear prose as-is this run; status-only and progress comments may continue.
3. **Stop Linear writes.** Ask before further Document or description touches until the person unblocks.

### MUST NOT (Conflict)

- Silent overwrite when a conflict is known.
- Require a body-hash or issue-`updatedAt` tripwire in v1 (D16 (no linear edits)).
- Invent Linear as source of truth for binding content.
