# Slug-prefixed spec doc filenames — implementation plan

Phases for [spec.md](./spec.md).

**Status values:** `Not started` · `Started` · `Reviewing` · `Done` · `Deferred` · `Blocked`

## Progress overview

| Phase | Status | Name | Tier | Depends on | Combinable with |
| ----- | ---- | ------ | ---- | ---------- | --------------- |
| **1** | Done | Skill path rewrite | Medium | — | — |
| **2** | Done | Rename recipe and README | Low | 1 | — |

## Phase 1 — Skill path rewrite

**Goal:** New `/spec` work creates and resolves only D1 (role map) filenames; template seed files on disk stay unprefixed.

**Covers:** G1 (slug prefix), G2 (short roles), G3 (plan extension), G4 (skill resolves), R1 (filename pattern), R2 (short roles only), R3 (new names only), R4 (no auto migrate), R5 (plan body authority), R6 (template seeds stay), R7 (skill surface complete), R9 (helper doc cites)

**Read first:**

- [business-logic.md › R1 (filename pattern)](./business-logic.md#r1-filename-pattern)
- [business-logic.md › R2 (short roles only)](./business-logic.md#r2-short-roles-only)
- [business-logic.md › R3 (new names only)](./business-logic.md#r3-new-names-only)
- [business-logic.md › R4 (no auto migrate)](./business-logic.md#r4-no-auto-migrate)
- [business-logic.md › R5 (plan body authority)](./business-logic.md#r5-plan-body-authority)
- [business-logic.md › R6 (template seeds stay)](./business-logic.md#r6-template-seeds-stay)
- [business-logic.md › R7 (skill surface complete)](./business-logic.md#r7-skill-surface-complete)
- [business-logic.md › R9 (helper doc cites)](./business-logic.md#r9-helper-doc-cites)
- [business-logic.md › Emit a new sibling](./business-logic.md#emit-a-new-sibling)
- [business-logic.md › Conditions and error cases](./business-logic.md#conditions-and-error-cases)

**Tier:** Medium — every stage must stay consistent with D1 (role map); a missed cite breaks new `/spec` runs, and typecheck cannot catch it

**Not in this phase:** Live `spec_docs/README.md` path table or rename recipe (phase 2). Auto-migration of existing folders. Cursor plan frontmatter or todos. Renaming this folder’s own files.

**Deliverables:**

- `skills/spec/SKILL.md` — extend: Progress, Spec docs, Infer table, and stage-detection prose cite `<slug>.spec.md`, `<slug>.logic.md`, `<slug>.contracts.md`, `<slug>.ui.md`, and `<slug>.plan.md`
- `skills/spec/stages/create-spec.md` — extend: write and resume `<slug>.spec.md` only
- `skills/spec/stages/tech-specs.md` — extend: emit and fold against the new tech-doc names
- `skills/spec/stages/plan.md` — extend: write `<slug>.plan.md`; no Cursor `todos` frontmatter
- `skills/spec/stages/implement.md` — extend: read and update the new plan and sibling names; archive still moves the folder
- `skills/spec/stages/audit.md` — extend: required-doc checks use the new names
- `skills/spec/templates/spec.md` — extend: Doc index rows and relative links use emitted `<slug>.…` names
- `skills/spec/templates/business-logic.md` — extend: links to `<slug>.spec.md` (seed filename on disk unchanged)
- `skills/spec/templates/contracts.md` — extend: same link pattern
- `skills/spec/templates/ui.md` — extend: same link pattern
- `skills/spec/templates/implementation-plan.md` — extend: title/links for emitted `<slug>.plan.md`; body stays the phase-status store
- `skills/spec/templates/spec-docs-readme.md` — extend: path table and How to use cite the new emitted names (recipe text waits for phase 2)
- `skills/spec/writing-style.md` — extend: “applies to” list uses the `<slug>.…` pattern
- `skills/spec/design-quality.md` — extend: plan filename citations use `<slug>.plan.md`
- `skills/spec/analysis-checklist.md` — extend: required-doc and business-rules-home checks use the new names

**Approach** (advisory):

1. Put D1 (role map) once in `skills/spec/SKILL.md` › Spec docs (or a short Naming subsection). Point every other skill file at that map instead of inventing a second table.
2. Rewrite stages in this order so create → promote → plan → implement → audit stay aligned: `create-spec.md`, `tech-specs.md`, `plan.md`, `implement.md`, `audit.md`.
3. Update each template’s *emitted* path text and Doc index. Leave seed basenames on disk as today (`templates/business-logic.md`, `templates/implementation-plan.md`, and so on) per R6 (template seeds stay).
4. Sweep `writing-style.md`, `design-quality.md`, and `analysis-checklist.md` for bare emitted basenames.

**Do:**

- Cite emitted siblings as `` `<slug>.logic.md` `` / `` `<slug>.plan.md` ``.
- Keep linking *to* seed files as `templates/business-logic.md` when the stage means the template source.

**Do not:**

- Rename or duplicate template seed files under `skills/spec/templates/`.
- Add dual-read or dual-write of bare and prefixed names.
- Add Cursor YAML `todos` (or other Plan Mode frontmatter) to the plan template.

### Acceptance scenarios

- **A1.1 — Create writes prefixed design**
  - Journey: Create and promote with the new names, step 1
  - Given a new slug and create-spec approval
  - When create-spec writes the design file
  - Then the path is `spec_docs/<slug>/<slug>.spec.md` and no bare `spec.md` is created

- **A1.2 — Promote emits short roles**
  - Journey: Create and promote with the new names, step 2
  - Given a design file at `<slug>.spec.md` with `Progress: design`
  - When tech-specs writes needed siblings
  - Then they are `<slug>.logic.md`, `<slug>.contracts.md`, and/or `<slug>.ui.md` as needed — never `business-logic.md`

- **A1.3 — Plan uses .plan.md body only**
  - Journey: Create and promote with the new names, step 3
  - Given tech docs are ready and the user asks for a plan
  - When plan stage writes the plan
  - Then the file is `<slug>.plan.md` with phase status in the markdown body and no Cursor `todos` frontmatter

- **A1.4 — Implement and archive use new names**
  - Journey: Create and promote with the new names, step 4
  - Given a folder that already uses the D1 (role map) names
  - When implement or archive runs
  - Then stages read and update those paths only, and archive moves the whole folder

- **A1.5 — Tabs show slug then role**
  - Journey: Tell specs apart in the editor, step 2
  - Given two new-spec folders each with a design or tech doc open
  - When the editor shows tab labels
  - Then each label starts with that folder’s slug and a short role (for example `….spec.md` or `….logic.md`)

- **A1.6 — Bare folder is left alone**
  - Journey: Leave an existing folder alone until a person renames, step 2
  - Given a folder that still has only bare basenames
  - When any `/spec` action runs on that folder
  - Then the skill does not rename those files and does not add a dedicated stop or migrate prompt (D4 (nothing on bare))

- **A1.7 — Skill surface has no stray emitted basenames**
  - Journey: —
  - Given phase 1 deliverables are complete
  - When someone searches stages, SKILL, helpers, and template *contents* for emitted bare names (`business-logic.md`, `implementation-plan.md` as sibling targets)
  - Then no hit remains that would make a stage write or require those bare siblings (template seed *paths* on disk may still use those basenames)

### Done when

- [x] Medium tier verify passes (Project conventions in `spec_docs/README.md`)
- [x] `rg` over `skills/spec/stages/`, `SKILL.md`, `writing-style.md`, `design-quality.md`, and `analysis-checklist.md` shows no instruction to create or require bare `business-logic.md` or `implementation-plan.md` as emitted siblings
- [x] Template seed files under `skills/spec/templates/` are still the unprefixed basenames on disk
- [x] A1.1–A1.7 pass
- [x] Progress gates, phase status vocabulary, and ID schemes are unchanged

### Close-out

- Verified: Medium (Low diff of deliverables + `rg` full-form IDs G1–G4, R1–R7, R9 in named skill surfaces). Bare-sibling `rg` clean for create/require instructions; only seed-path links and an explicit “Never emit bare `business-logic.md`” remain. Template seeds on disk still `spec.md`, `business-logic.md`, `contracts.md`, `ui.md`, `implementation-plan.md`, `spec-docs-readme.md`. A1.1 create → `<slug>.spec.md`; A1.2 promote → short roles; A1.3 plan → `<slug>.plan.md` body only / no Cursor todos; A1.4 implement+archive use D1 names and move folder; A1.5 slug-then-role filenames; A1.6 no bare-folder migrate path; A1.7 no stray emitted basenames. Progress gates / phase status vocabulary / ID schemes untouched.
- Deviations: none
- Follow-ups: Phase 2 — README rename recipe and live `spec_docs/README.md` path table (G5 / R8).

## Phase 2 — Rename recipe and README

**Goal:** A person can rename one existing folder onto D1 (role map) using documented steps; the live README path table matches.

**Covers:** G5 (rename recipe), R8 (rename recipe)

**Read first:**

- [business-logic.md › R8 (rename recipe)](./business-logic.md#r8-rename-recipe)
- [business-logic.md › Leave or migrate an existing folder](./business-logic.md#leave-or-migrate-an-existing-folder)
- [spec.md › D1 (role map)](./spec.md#d1-role-map--canonical-filename-pattern-for-new-specs)
- [spec.md › D3 (no auto migrate)](./spec.md#d3-no-auto-migrate--existing-folders-stay-on-bare-basenames-until-a-person-renames)

**Tier:** Low — documentation of an already decided map; mistakes show up in a README diff

**Not in this phase:** Further skill stage edits. Bulk migration. Migrating this folder unless the person chooses to run the recipe.

**Deliverables:**

- `skills/spec/templates/spec-docs-readme.md` — extend: add a one-folder rename recipe (design, tech docs, plan, legacy `data.md`, relative links); keep path table on the new names from phase 1
- `spec_docs/README.md` — extend: same recipe; path table and How to use match the new emitted names

**Approach** (advisory):

1. Add a short **Rename an existing folder** (or equivalent) section to the README template. Steps: rename each sibling per D1 (role map), fix relative links and Doc index rows, stop after that one folder.
2. Mirror the same section into live `spec_docs/README.md`.
3. Align the live path table and lifecycle bullets with phase 1’s emitted names.

**Do:** Cover `data.md` → `<slug>.data.md` when that file exists.

**Do not:** Tell an agent to migrate every active or archive folder in one pass.

### Acceptance scenarios

- **A2.1 — Recipe renames one folder**
  - Journey: Leave an existing folder alone until a person renames, steps 1 and 3
  - Given an older folder with bare basenames and the README recipe
  - When a person follows the recipe on that folder only
  - Then files and relative links match D1 (role map), including `data.md` → `<slug>.data.md` when present

- **A2.2 — Recipe forbids bulk agent migrate**
  - Journey: Leave an existing folder alone until a person renames, goes wrong
  - Given the README recipe text
  - When someone reads what the recipe instructs
  - Then it does not tell an agent to rewrite every active or archive folder in one pass

- **A2.3 — Live README matches new map**
  - Journey: —
  - Given phase 2 is complete
  - When a reader opens `spec_docs/README.md`
  - Then the path table and How to use cite the slug-prefixed emitted names

### Done when

- [x] Low tier verify passes (Project conventions in `spec_docs/README.md`)
- [x] A2.1–A2.3 pass
- [x] Template README and live README both contain the one-folder recipe and agree on the map

### Close-out

- Verified: Low — deliverables vs Done when; recipe and path tables match between `skills/spec/templates/spec-docs-readme.md` and `spec_docs/README.md` (D1 map including `data.md` → `<slug>.data.md`). A2.1 one-folder rename steps + link fix; A2.2 forbids bulk/agent migrate of every folder; A2.3 live README path table and How to use use slug-prefixed names. Template Project conventions `{{…}}` / seed HTML comments remain by design (bootstrap), not phase defects.
- Deviations: none
- Follow-ups: none

## Risks

- **Partial skill update.** Mitigation: phase 1 ships SKILL, every stage, helpers, and templates together; Done when includes an `rg` sweep for stray emitted bare basenames.
