# Project README docs TLC — implementation plan

Phases for [readme-docs-tlc.spec.md](./readme-docs-tlc.spec.md).

**Status values:** `Not started` · `Started` · `Reviewing` · `Done` · `Deferred` · `Blocked`

## Progress overview

| Phase | Status | Name | Tier | Depends on | Combinable with |
| ----- | ---- | ------ | ---- | ---------- | --------------- |
| **1** | Done | README docs and tips | Low | — | — |

## Phase 1 — README docs and tips

**Tracker phase:** n/a

**Goal:** Root README explains `spec_docs/`, the write/iterate loop, and a tips list informed by an archive pass.

**Covers:** G1 (folder docs), G2 (write process), G3 (tips list), D1 (root primary), D2 (no skill edits), D3 (tip count)

**Read first:**

- [readme-docs-tlc.spec.md › Goals](./readme-docs-tlc.spec.md#goals-and-acceptance-criteria)
- [readme-docs-tlc.spec.md › Proposed solution](./readme-docs-tlc.spec.md#proposed-solution)
- [readme-docs-tlc.spec.md › Decisions](./readme-docs-tlc.spec.md#decisions)

**Tier:** Low — prose edits against decided scope; mistakes show in review of the markdown

**Not in this phase:** Skill or template edits; marketplace GHA; conventions placeholder fill; rewriting `spec_docs/README.md` wholesale

**Deliverables:**

- `README.md` — extend: folder overview, write/iterate process (incl. Depth), tips section
- `spec_docs/README.md` — extend: cross-link polish only if needed for consistency
- `spec_docs/archive/` — read-only: skim for tip material (no file edits required)

**Approach** (advisory):

1. Skim `spec_docs/archive/*/` specs for durable tips (Depth, Linear, naming, process gotchas).
2. Draft root README sections for G1 (folder docs), G2 (write process), and G3 (tips list); keep install / Linear / contrib intact.
3. Check `spec_docs/README.md` for contradictory pointers; adjust only if needed.

Note: the source todo was removed from `spec_docs/todos.md` when this folder was created.

### Acceptance scenarios

- **A1.1 — Folder explained**
  - Journey: Discover the workflow from the project README, step 1
  - Given a reader opens root `README.md`
  - When they look for what `spec_docs/` is
  - Then they find plain-language folder role, active vs archive, and a link to `spec_docs/README.md`

- **A1.2 — Process described**
  - Journey: Discover the workflow from the project README, step 2
  - Given the same reader
  - When they look for how to write and iterate specs
  - Then create through archive is described and Depth is named without contradicting `spec_docs/README.md`

- **A1.3 — Tips present**
  - Journey: Discover the workflow from the project README, step 3
  - Given the archive pass was done
  - When they read the tips section
  - Then they see a short tips list, and at least one tip is archive-grounded or the section notes the pass found nothing new

### Done when

- [x] Tier verify passes (Project conventions in `spec_docs/README.md`)
- [x] A1.1–A1.3 pass
- [x] Existing install, Linear, and contrib sections remain accurate
- [x] No files under `skills/spec/` were changed

### Close-out

- Verified: Tier Low → n/a (Project conventions). A1.1: root README › What `spec_docs/` is for covers folder role, active vs archive, link to `spec_docs/README.md`. A1.2: Write and iterate names create → archive and Depth without contradicting `spec_docs/README.md`. A1.3: Tips has 7 bullets; archive-grounded items include slug-prefixed names (`slug-prefixed-docs`), bootstrap conventions fill (`init-readme-fill`), one-open-unit / no parallel implementers (`multi-subagent`), repo-canonical Linear (`linear-integration`), no surprise SCM (`adapt-superpowers` / `cursor-plugin`). `git diff --stat -- skills/spec/` empty. Install / Getting started / Contribute unchanged in substance; Linear kept with one accuracy tweak (`spec.md` → `<slug>.spec.md`).
- Deviations: None from advisory Approach. Light cross-link added at top of `spec_docs/README.md` (in scope).
- Follow-ups: —
