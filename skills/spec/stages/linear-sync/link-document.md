# Linear sync › Link-back, Description, Conflict

Part of the shared Linear write-back doctrine — see [../linear-sync.md](../linear-sync.md) for Preconditions, Store, and the hook index. create-spec and explicit sync call this file.

**Epic folder.** When `<slug>.epic.md` is present, every frontmatter read and write in this file uses that file instead of `<slug>.spec.md`. Do not create Tracker Phases. Do not map Progress. Do not pull Linear prose into the epic.

## Link-back

First successful link after create-spec sets frontmatter `work_item` and write-back is allowed (G1 (create from linear), R3 (first link back)).

**In short:** Comment with the repo path; optional real URL `links` and design label; store the returned URL in frontmatter `tracker_spec_url`. Never rewrite the issue description. Explicit sync may already have set that description when the user said yes (R25 (issue body ask)); this section still does not.

### When

- Frontmatter `work_item` is set to a real id (not `n/a`).
- Preconditions pass for write-back.

### Steps

1. `save_comment` on the Tracker Spec: body names `spec_docs/<slug>/` (path text only).
2. If conventions define a design-stage label: `save_issue` with `addLabels` for that label only (not a full label replace).
3. Append Linear `links` only when a real URI exists (hosted remote or equivalent). NEVER invent a bare-path link such as `spec_docs/foo/`.
4. After Linear returns the Tracker Spec URL, write it into the overview file's frontmatter as `tracker_spec_url` (`<slug>.spec.md`, or `<slug>.epic.md` when the folder is an epic). Do not invent the URL beforehand.

### MUST NOT

- Set Tracker Spec `description` to the full spec or binding AC from the repo (R2 (no body rewrite)).
- Paste the raw Linear payload into `<slug>.spec.md` or `<slug>.epic.md`. Feature and bugfix create maps acceptance criteria onto goals’ `Source:` lines once; that stays in create-spec. Epic create does not.
- Invent team, project, or half-links when conventions or MCP are missing.

## Description

The Linear description is the one Linear mirror of the repo overview: the issue description, or the project description when the epic is a Linear project. One way, repo → Linear. Never pull Linear prose into `<slug>.spec.md` or `<slug>.epic.md`.

**In short:** Written only by explicit sync when its Issue body answer was yes (R25 (issue body ask)). Create-spec, link-back, and routine hooks never write it. Status-only ticks do not touch it.

### Content

The canon line `Repo canonical. Do not edit binding content in Linear.` (D16 (no linear edits)), then the overview file after its YAML frontmatter: `<slug>.spec.md`, or `<slug>.epic.md` when the folder is an epic. An epic file already carries its suggested specs and tasks. Not the tech siblings and not the plan. Omit secret values (R19 (no secrets)).

### Write

When an explicit sync's Issue body answer was yes:

1. Issue: create with the description, or replace the existing issue description. Project epic: pass the same content as the project `description` on `save_project` (create or update).
2. When a Linear prose conflict is known, run **Conflict** (below) before the replace.

### Refresh

When TL;DR or goals change on a linked folder (on an epic, when suggested specs or tasks change), the Linear description is now stale. Routine stages do not write it, because the Issue body answer is not stored. Tell the user to run `/spec linear sync` to refresh it; that sync asks Issue body again. Progress-only and phase-status-only ticks do not trigger this.

### MUST NOT (Description)

- Treat the Linear description as editable AC truth.
- Write the description from create-spec, link-back, or a routine hook.
- Require a body-hash fingerprint field in `<slug>.spec.md` (D16 (no linear edits), Q1 (auto detect) open).
- Push secrets (R19 (no secrets)).

## Conflict

When a Linear prose conflict with a mirrored surface is **known** (human report or a later trivial detector — not a required hash tripwire), warn and offer D20 (conflict choices) before overwriting (R14 (conflict stop), D6 (conflict stop), D9 (keep conflict stop)).

**In short:** Do not treat Linear as ahead of the repo. Status-only updates and new progress comments that leave bodies alone are not blocked.

### Choices (v1)

Offer exactly these options (D20 (conflict choices)):

1. **Regenerate from repo.** Replace the description from `<slug>.spec.md`, or from `<slug>.epic.md` when the folder is an epic. This applies only in an explicit sync whose Issue body answer was yes (R25 (issue body ask)). Leave Linear status and comments alone.
2. **Skip this regenerate.** Leave Linear prose as-is this run; status-only and progress comments may continue.
3. **Stop Linear writes.** Ask before further description touches until the person unblocks.

### MUST NOT (Conflict)

- Silent overwrite when a conflict is known.
- Require a body-hash or issue-`updatedAt` tripwire in v1 (D16 (no linear edits)).
- Invent Linear as source of truth for binding content.
