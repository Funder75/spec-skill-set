# Slug-prefixed spec doc filenames

**Slug:** `slug-prefixed-docs`
**Progress:** archived
**Work item:** —
**Depends on:** —

## TL;DR

- **What:** Rename files inside each spec folder so the slug leads, roles shorten, and the plan uses `.plan.md`.
- **Why:** With several specs open, editor tabs all say `spec.md` and are hard to tell apart.
- **v1 includes:** New naming in the skill, templates, and README template; a human rename recipe; no Cursor plan todos.
- **v1 excludes:** Auto-migration of existing folders, Cursor YAML frontmatter, dual filenames, and any folder-layout change.

## Doc index

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file | Scope, goals, journeys, constraints, work split | yes |
| [business-logic.md](./business-logic.md) | Rules, workflows, resolution and migration | yes |
| contracts.md | Types, API contracts, state ownership, storage | not needed |
| ui.md | Layout, interaction, states, copy | not needed |
| [implementation-plan.md](./implementation-plan.md) | Phases and phase status | yes |

## Source

> `spec_docs/todos.md` § "use spec slug for file name and cursor plan for implementation plan" (lines 31–42). Design chat: keep `spec_docs/<slug>/`; prefix files with the slug; shorten role names; use `.plan.md` for the plan body we already own; skip Cursor todos until the Plan UI is tried.

## Problem and current behaviour

**In short:** Each feature already lives under `spec_docs/<slug>/`, but every sibling file uses a fixed basename. Tabs lose the slug.

- **Folder is fine.** `spec_docs/<slug>/` already groups one feature. Archive moves the whole folder. That layout stays.
- **Tabs collide.** Open `spec.md` from two specs and both tabs show the same label. The same happens for `business-logic.md` and `implementation-plan.md`.
- **Names are long.** `business-logic.md` and `implementation-plan.md` eat tab width before the useful part shows.
- **Skill hardcodes basenames.** Stages, templates, the README template, writing style, design quality, and the analysis checklist all name `spec.md`, `business-logic.md`, `contracts.md`, `ui.md`, and `implementation-plan.md`.
- **Cursor plan extension.** Cursor treats `*.plan.md` as a plan file. The todo asked to try that extension. We keep our phase markdown as the contract and do not adopt Cursor todo frontmatter in v1 (see D2 (no cursor todos)).

| Path | What it does today |
| ---- | ------------------ |
| `skills/spec/SKILL.md` | Routes actions; cites fixed basenames |
| `skills/spec/stages/*.md` | Create, promote, plan, implement, audit |
| `skills/spec/templates/*.md` | Doc shapes and relative links |
| `skills/spec/templates/spec-docs-readme.md` | Bootstrap README path table |
| `skills/spec/writing-style.md` | Lists docs the style applies to |
| `skills/spec/design-quality.md` | Plan quality; cites plan filename |
| `skills/spec/analysis-checklist.md` | Audit checks for required docs |
| `spec_docs/README.md` | Live project path table (same names) |

## Goals and acceptance criteria

**In short:** Tabs show the slug and a short role; the skill resolves only the new names for new work; existing folders are left alone unless a person follows the recipe.

### G1 (slug prefix) — Every durable sibling file in a spec folder starts with the folder slug

Source: todos.md naming sketch

- For a folder `spec_docs/<slug>/`, the design file is `<slug>.spec.md`.
- Tech docs and the plan use the same prefix with their short role (see G2 (short roles)).
- Relative links inside a folder use the new filenames.
- The folder path itself stays `spec_docs/<slug>/` (and `archive/<slug>/` when archived).

### G2 (short roles) — Role names in filenames are short enough for editor tabs

Source: todos.md abbreviation ask

- Canonical map for new specs (see D1 (role map)):
  - design overview → `spec`
  - business rules → `logic` (was `business-logic`)
  - types and API → `contracts`
  - UI → `ui`
  - implementation plan → `plan`, and the file ends with `.plan.md`
- An older folder that already has `data.md` keeps the role `data` when migrated by hand; it remains the same doc as contracts.
- After the map, a typical tab reads like `multi-subagent.spec.md` or `multi-subagent.logic.md`.

### G3 (plan extension) — The implementation plan file uses the `.plan.md` extension

Source: todos.md Cursor plan note

- New plans are written as `<slug>.plan.md`, not `<slug>.implementation-plan.md` or `implementation-plan.md`.
- Phase status, Done when, Close-out, tier, Ask-before, and acceptance scenarios stay in the markdown body as today.
- v1 does not add Cursor YAML `todos` (or other Plan Mode frontmatter) as a second status store (see D2 (no cursor todos)).
- After ship, someone may open a plan in Cursor’s Plan UI to see what breaks; that test does not change the v1 contract.

### G4 (skill resolves) — The skill creates, reads, and updates only the new names for new work

Source: —

- SKILL, stages, templates, writing style, design quality, analysis checklist, and the README template name the new paths.
- Create-spec writes `<slug>.spec.md`. Promote, plan, implement, archive, and audit look for the new names.
- Doc index rows and cross-links in templates use the new filenames.
- The skill does not invent a compatibility layer that writes both old and new names.

### G5 (rename recipe) — Existing folders get a documented one-time rename, not an agent migration

Source: clarify out-of-scope A

- The skill or README documents how a person renames files in one folder to the new map and fixes relative links.
- Active and archive folders keep today’s basenames until someone runs that recipe.
- v1 does not auto-rename existing folders during create, promote, implement, or archive.

## Non-goals

- Auto-migration of active or archive `spec_docs/` folders.
- Dual-write or dual-read of old and new basenames.
- Changing `spec_docs/<slug>/` or `archive/<slug>/` folder layout.
- Adopting Cursor plan YAML frontmatter, `todos`, or Plan Mode as the source of phase status (later, after a UI test).
- Renaming template *source* files under `skills/spec/templates/` to slug-prefixed names (templates stay role-named seeds; only emitted docs in `spec_docs/` use the slug prefix).
- Changing Progress gates, phase status values, or ID schemes (`G`, `R`, `D`, `Q`, `A`).
- Building a product UI; this is skill and markdown only.

## Users and context

- **Primary user:** A developer working several specs at once in the editor.
- **When:** Opening, comparing, or editing sibling docs across folders; running `/spec` create, promote, implement, or archive.
- **Who may do this:** Anyone editing this repo’s skill or `spec_docs/`.

## User journeys

### Tell specs apart in the editor

Starting point: A developer has docs from two or more specs open.

1. They open the design or a tech doc from each folder.
2. Each tab label starts with that folder’s slug, then a short role.
3. They switch tabs without relying on the full path alone.

End state: Tab text identifies which feature the file belongs to.

Goes wrong when:

- A new file is still written with a bare basename — G4 (skill resolves) prevents that for new work.
- An unmigrated old folder still uses bare names — expected until G5 (rename recipe); tabs there stay ambiguous.

Covers: G1 (slug prefix), G2 (short roles)

### Create and promote with the new names

Starting point: A developer runs create-spec (and later promote / plan) for a new slug.

1. Create-spec writes `<slug>.spec.md` under `spec_docs/<slug>/`.
2. Promote adds `<slug>.logic.md`, `<slug>.contracts.md`, and/or `<slug>.ui.md` when needed (or folds notes).
3. Plan writes `<slug>.plan.md` with today’s phase sections in the body.
4. Implement and archive read and update those same paths.

End state: The folder uses only the new map; Progress and phase status behave as today.

Goes wrong when:

- A stage still points at `implementation-plan.md` — G4 (skill resolves) requires every stage update.
- Someone expects Cursor todos to drive status — out of scope; body remains authoritative (D2 (no cursor todos)).

Covers: G1 (slug prefix), G2 (short roles), G3 (plan extension), G4 (skill resolves)

### Leave an existing folder alone until a person renames

Starting point: An older folder still has `spec.md` and siblings with bare names.

1. The developer keeps editing those files by hand, or follows the documented rename recipe when ready.
2. The skill does not rename those files as a side effect of `/spec` actions, and does nothing special when only bare basenames are present (D4 (nothing on bare)).
3. After a manual rename, relative links inside the folder match the new map.

End state: Bare names stay usable by hand; migration is intentional and local. `/spec` on that folder may miss files until renamed — accepted minor side effect.

Goes wrong when:

- An agent rewrites every archive folder on first touch — forbidden by G5 (rename recipe).

Covers: G5 (rename recipe), D4 (nothing on bare)

## Constraints

- **Preserve:** Progress line and gate meanings; phase status only in the plan body; binding vs advisory rules; ID citation form; one folder per slug.
- **i18n:** n/a
- **Accessibility:** n/a (editor tabs are the host IDE’s concern)
- **Security:** n/a
- **Performance:** n/a

## Notes

- **Cursor Plan UI is a post-ship probe.** After v1, open a `<slug>.plan.md` in Cursor and note breakage. Frontmatter or todos are a later change only if that probe demands them.
- **This folder itself.** `spec_docs/slug-prefixed-docs/` is created under today’s basenames. It migrates only when someone runs the recipe after the skill ships, or when a later phase explicitly includes that.

## Concerns

- **Partial skill update.** If one stage still cites `business-logic.md` after others move, promote or implement will look in the wrong place. If left: broken `/spec` runs on new folders. Mitigated by G4 (skill resolves) covering every hardcoded path.
- **Plan UI surprise.** Cursor may treat `.plan.md` specially (custom editor, expected frontmatter). If left untested: noisy UX, but phase status in the body still works for the skill. Tracked as a follow-up after D2 (no cursor todos).

## Proposed solution

Keep one folder per feature. Change only the filenames inside it.

Every durable sibling becomes `<slug>.<role>[.<extra>].md`. The role map shortens long names. The plan’s extra extension segment is `plan.md`, so the full name is `<slug>.plan.md`.

Update the skill surface so new work never emits the old basenames. Document a rename recipe for people who want old folders to match. Do not teach the agent to migrate on its own.

Do not mirror phase status into Cursor `todos`. The implementation plan body remains the only phase-status store.

### Capabilities (v1)

- **Naming map.** One binding table from role to filename pattern (D1 (role map)).
- **Skill path rewrite.** All stages and supporting skill docs use that map.
- **Human migration note.** Steps to rename one folder and fix its relative links.

## Touched paths

| Path | Area | Change |
| ---- | ---- | ------ |
| `skills/spec/SKILL.md` | skill | Cite new basenames and plan path |
| `skills/spec/stages/` | skill | Create, tech, plan, implement, audit paths |
| `skills/spec/templates/` | skill | Emitted names, doc index, cross-links |
| `skills/spec/templates/spec-docs-readme.md` | skill | Path table for bootstrap README |
| `skills/spec/writing-style.md` | skill | Doc list uses new names |
| `skills/spec/design-quality.md` | skill | Plan filename citations |
| `skills/spec/analysis-checklist.md` | skill | Required-doc checks |
| `spec_docs/README.md` | docs | Live path table when conventions update |
| `spec_docs/*/ (existing)` | docs | Out of scope unless human recipe |

## Work split

1. **Naming contract.** Covers G1 (slug prefix), G2 (short roles), G3 (plan extension). Outcome: D1 (role map) is written into the skill and templates so every new file name is unambiguous. Main surface: skill templates and SKILL overview.
2. **Stage path rewrite.** Covers G4 (skill resolves). Outcome: every stage and helper doc creates or reads only the new names. Main surface: stages plus writing-style, design-quality, analysis-checklist.
3. **Migration recipe and README.** Covers G5 (rename recipe). Outcome: a person can rename one folder without guessing; project README path table matches. Main surface: README template and live `spec_docs/README.md`.

## Glossary

- **Slug:** The kebab-case folder name under `spec_docs/` (or `archive/`). Unchanged by this spec.
- **Role:** The short middle segment of a sibling filename (`spec`, `logic`, `contracts`, `ui`, `plan`, or legacy `data`).
- **Bare basename:** Today’s unprefixed name (`spec.md`, `business-logic.md`, …).
- **Rename recipe:** Documented manual steps to move one existing folder onto the new map.

## Decisions

### D1 (role map) — Canonical filename pattern for new specs

- **Date:** 2026-10-25 · **Area:** naming
- **Why:** Tabs need the slug first and a short role second. One map keeps the skill and humans aligned.
- **Rejected:** Keeping `business-logic` / `implementation-plan` spelled out; dropping the slug because the folder already has it (tabs still hide the folder).

| Role | Filename |
| ---- | -------- |
| Design overview | `<slug>.spec.md` |
| Business rules | `<slug>.logic.md` |
| Types / API / storage | `<slug>.contracts.md` |
| UI | `<slug>.ui.md` |
| Implementation plan | `<slug>.plan.md` |
| Legacy contracts alias | `<slug>.data.md` (only when that folder already used `data.md`) |

### D2 (no cursor todos) — Plan body stays the only phase-status store in v1

- **Date:** 2026-10-25 · **Area:** plan format
- **Why:** We want the `.plan.md` extension for tab naming and a later Plan UI probe. Cursor `todos` would dual-track status with Close-out and tier.
- **Rejected:** Cursor-native todos as source of truth; optional frontmatter in v1 “just in case.”

### D3 (no auto migrate) — Existing folders stay on bare basenames until a person renames

- **Date:** 2026-10-25 · **Area:** migration
- **Why:** Silent renames across active and archive specs are risky and out of the smallest shippable slice.
- **Rejected:** Migrating all active folders in v1; dual-read compatibility forever.

### D4 (nothing on bare) — `/spec` does nothing special on unmigrated folders

- **Date:** 2026-10-25 · **Area:** migration / resolve
- **Why:** We are starting from scratch after the skill ships. Bare basenames stay openable and editable by hand; a dedicated stop or “unsupported until rename” path is not worth the Preconditions surface. Minor side effects (e.g. stages looking for new names and not finding them) are acceptable.
- **Rejected:** Stop and point at the rename recipe (option A); document `/spec` as unsupported until renamed (option B); dual-read of bare and prefixed names (non-goal).

## Open questions

### Q1 (plan ui probe) — What breaks when Cursor opens our body-only `.plan.md`?

- **Priority:** — · **Blocks:** — · **Owner:** after v1 ship
- **Options:**
  - **A.** Nothing material; keep body-only.
  - **B.** Add thin frontmatter later without moving status into `todos`.
  - **C.** Revisit todos as a sync concern in a later spec.
