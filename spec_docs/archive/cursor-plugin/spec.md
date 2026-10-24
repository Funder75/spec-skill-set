# Cursor plugin for the spec skill

**Slug:** `cursor-plugin`
**Progress:** archived
**Work item:** —
**Depends on:** —

## TL;DR

- **What:** Ship the current spec skill as a Cursor plugin.
- **Why:** The skill lives in one user store, so another machine cannot install it.
- **v1 includes:** A plugin manifest, an unchanged skill copy, local install steps, and this repo's spec folder.
- **v1 excludes:** Brainstorming changes, npm publish, marketplace listing, and session hooks.

## Doc index

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file | Scope, goals, journeys, constraints, work split | yes |
| business-logic.md | Rules, workflows, state transitions | pending |
| contracts.md | Types, API contracts, state ownership, storage | pending |
| ui.md | Layout, interaction, states, copy | not needed |
| implementation-plan.md | Phases and phase status | pending |

## Source

> Conversation on 24 Oct 2026. Package the existing user-level spec skill as a Cursor plugin named spec-skill-set. Use a local copy until it is listed. Keep Superpowers adaptations in a second design.

## Problem and current behaviour

**In short:** The spec skill already runs, but only as files in one Cursor user store. There is no plugin to install.

- **Where it lives.** The skill is a markdown folder in the user agent store. It is not a plugin.
- **What it already does.** It writes a design, then tech docs, then a plan, then one phase, then an archive. It does not create branches or commits on its own.
- **What is missing.** There is no plugin manifest, no install note, and no spec folder for this package.
- **What stays put.** Skill instructions are copied, not rewritten. Dialogue and UI-rule changes wait for a later design.

| Path | What it does today |
| ---- | ------------------ |
| User-store `SKILL.md` | Routes spec actions to stage files |
| User-store `stages/create-spec.md` | Writes the design spec only |
| User-store `templates/spec.md` | Shape of a design spec |
| User-store `templates/spec-docs-readme.md` | Spec index and conventions |
| Cursor plugins docs | Local plugins load from a copied folder |

## Goals and acceptance criteria

**In short:** A loadable plugin, the same skill text, a local install guide, and a spec folder in this repo.

### G1 (plugin manifest) — Cursor can recognize this folder as a plugin

Source: —

- The manifest name is `spec-skill-set`.
- The display name is Spec.
- Skills load from the skills directory.
- The manifest does not register hooks.

### G2 (unchanged skill) — The packaged skill matches the copied source

Source: —

- The skill tree is the user-level spec skill as copied on 24 Oct 2026.
- Stage files, templates, and checklists are not edited in this design.
- The skill still does not create branches or commits unless the user asks.

### G3 (local install) — A developer can load the plugin without a listing

Source: —

- The readme gives the copy destination, the reload step, and where to confirm the skill.
- The readme says a symlink to a repo outside that folder is skipped.
- The readme says an Enterprise account must allow local plugin imports.
- The readme says opening this repo is not enough to load the plugin.
- The readme says to copy again after the repo changes, then reload.

### G4 (in-repo specs) — This repository can hold its own design specs

Source: —

- `spec_docs` has an index and an empty archive placeholder.
- This design is `spec_docs/cursor-plugin/spec.md`.
- Project convention placeholders stay as copied from the template.

## Non-goals

- Brainstorming questions, approach options, and approval before the spec file exists (later). See D5 (later adaptations).
- Stronger UI rules in the design stage (later). See D5 (later adaptations).
- Publishing an npm package.
- Submitting this plugin to the Cursor marketplace, or automating that listing (later).
- Hooks that inject the skill into every chat. See D4 (no hooks).
- Git worktrees, or commits the skill makes on its own.
- A script that syncs the user-store copy with this repo.
- Filling verify commands, work-item lookup, or stack notes in the spec index.

## Users and context

- **Primary user:** The author of the spec skill, on their own Cursor.
- **When:** They want the skill from a repo, not only from one user store.
- **Who may do this:** Anyone who can copy files into their Cursor config.

## User journeys

**In short:** Copy the plugin locally, use the same spec gates on another project, and read this design in the repo.

### Install on this machine

Starting point: the developer has this repo and wants the spec skill loaded.

1. They copy the repo into the local plugins folder, using the name in the readme.
2. They reload Cursor.
3. They open Customize and look for the Spec plugin and the spec skill.
4. They ask a new chat what the spec skill does.

End state: the skill is available without a marketplace listing.

Goes wrong when:

- They symlink the repo from another folder. Cursor skips that link. G3 (local install) tells them to copy.
- They only open the repo as a project. The plugin does not load. G3 (local install) says so.
- Enterprise policy blocks local imports. The skill never appears. G3 (local install) names the admin setting.
- An older user-store copy is still installed. A chat may follow that copy. G3 (local install) says to treat this repo as the plugin source.

Covers: G1 (plugin manifest), G3 (local install)

### Use the skill on another project

Starting point: the plugin is loaded, and the developer is in some other project.

1. They ask to create a spec, promote it, or implement the next phase.
2. The agent follows the packaged skill.
3. Spec files land in that project's spec folder, as the skill already requires.

End state: the other project gets the same gates the user-store skill already had.

Goes wrong when:

- Packaging edited the skill text. The gates would change. G2 (unchanged skill) forbids that.
- They expect a brainstorming dialogue before any spec file. This version does not do that. The non-goals defer it.

Covers: G2 (unchanged skill)

### Read this package's own design

Starting point: a reader opens the repo to see what this version is.

1. They open the spec docs index.
2. They open this design.
3. They see that a second design name is reserved and not written yet.

End state: they can tell packaging from the later adaptations.

Goes wrong when:

- The index or this spec is missing. G4 (in-repo specs) requires both.
- They search for the adaptations spec and think it was dropped. The notes name it as later work.

Covers: G4 (in-repo specs)

## Constraints

- **Preserve:** Current spec stages, templates, and no commits unless the user asks.
- **i18n:** n/a
- **Accessibility:** n/a
- **Security:** Instructions and templates only. No tokens and no session hook.
- **Performance:** n/a

## Notes

**In short:** Listing comes later. The adaptations spec is reserved. This repo is the source after the copy.

- **Marketplace later.** `/add-plugin` installs a plugin that is already listed. This design uses the local plugins folder instead. Listing is a non-goal.
- **Second design.** The slug `adapt-superpowers` is reserved for brainstorming and UI changes. It is not written in this pass.
- **Copy date.** The skill tree was copied from the user agent store on 24 Oct 2026. See D7 (repo canonical).
- **Symlink rule.** Cursor loads a symlink in the local plugins folder only when the target is also inside that folder.

## Concerns

- **Two copies.** The user store and this repo can both hold the skill. If left: a fix in one place stays out of the other, and a chat may follow the stale copy. The readme says to treat this repo as the plugin source. It does not delete the store copy. Touches G3 (local install).
- **Stale load copy.** Edits in git do not update the folder Cursor already loaded. If left: reload still runs the old plugin. G3 (local install) tells the developer to copy again.

## Proposed solution

Ship a Cursor plugin. The manifest names the plugin and points at a skills directory. That directory holds the spec skill as copied, with no instruction edits.

Install is a file copy into Cursor's local plugins folder, then a window reload. The readme is the only install guide. There is no npm package and no marketplace submission in this version.

This repo also keeps its own spec docs, starting with this design. Convention fields in the index stay as template placeholders. When a later plan needs a verify command, the skill asks instead of inventing one.

Workflow changes, including a longer design dialogue, belong in the reserved follow-up spec. They are not part of this solution.

## Touched paths

| Path | Area | Change |
| ---- | ---- | ------ |
| `.cursor-plugin/plugin.json` | Plugin | New manifest |
| `skills/spec/` | Skill | Copied, not edited |
| `README.md` | Docs | Local install steps |
| `LICENSE` | Legal | MIT license |
| `spec_docs/` | Specs | Index, archive, this design |
| `.gitignore` | Repo | Ignore local noise |

## Work split

1. **Plugin package.** Covers G1 (plugin manifest) and G2 (unchanged skill). Outcome: the manifest and the skill tree are in the repo, and the skill text is unchanged. Main surface: plugin package.
2. **Install guide.** Covers G3 (local install). Outcome: a developer can load the plugin from the readme alone. Main surface: readme.
3. **In-repo specs.** Covers G4 (in-repo specs). Outcome: spec docs exist, and this design is the first spec. Main surface: spec docs.

## Glossary

- **Cursor plugin:** A folder Cursor loads from a marketplace or from the local plugins folder. Its manifest lives under `.cursor-plugin`.
- **Local plugins folder:** `~/.cursor/plugins/local/` on this machine. Cursor reads plugin copies here before they are listed.
- **Spec skill:** The spec workflow: design, tech docs, plan, one phase, then archive.

## Decisions

**In short:** Cursor plugin, local copy to install, skill text unchanged, no hooks, adaptations later.

### D1 (cursor plugin) — Distribute as a Cursor plugin, not npm

- **Date:** 2026-10-24 · **Area:** distribution
- **Why:** The install to match is Superpowers on Cursor. That product is a plugin, not an npm module.
- **Rejected:** an npm package as the first install path.

### D2 (local copy) — First install is a copy into the local plugins folder

- **Date:** 2026-10-24 · **Area:** install
- **Why:** `/add-plugin` installs listed plugins. This plugin is not listed. Cursor's documented path before listing is a copy, then a reload.
- **Rejected:** documenting `/add-plugin spec-skill-set` as if listing already existed. A symlink from this repo into the local folder, because Cursor skips a link that points outside that folder.

### D3 (skill unchanged) — Do not edit skill behavior in this design

- **Date:** 2026-10-24 · **Area:** skill
- **Why:** Packaging and workflow changes are two reviews. Mixing them hides a behavior change inside a copy.
- **Rejected:** porting brainstorming habits in the same change.

### D4 (no hooks) — Do not register session hooks

- **Date:** 2026-10-24 · **Area:** plugin
- **Why:** A hook that injects the skill into every chat is out of scope. The user invokes the spec skill.
- **Rejected:** a session-start hook like Superpowers uses.

### D5 (later adaptations) — Brainstorming and UI changes are a second spec

- **Date:** 2026-10-24 · **Area:** scope
- **Why:** Those changes need their own review. The reserved slug is `adapt-superpowers`.
- **Rejected:** one design that both packages the skill and changes how specs are written.

### D6 (plugin name) — Identifier spec-skill-set, display name Spec

- **Date:** 2026-10-24 · **Area:** plugin
- **Why:** The identifier matches the project folder. The short display name is what Customize shows.
- **Rejected:** naming the plugin only `spec`, which collides with the skill name in conversation.

### D7 (repo canonical) — This repo is the plugin source after the copy

- **Date:** 2026-10-24 · **Area:** source
- **Why:** Two editable copies will diverge. Change the git repo. The local plugins folder is only the loaded copy. The user store was the seed.
- **Rejected:** a sync script in this version.
