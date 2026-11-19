# Epic child state — implementation plan

Phases for [epic-child-state.spec.md](./epic-child-state.spec.md).

**Status values:** `Not started` · `Started` · `Reviewing` · `Awaiting sign-off` · `Done` · `Deferred` · `Blocked`

## Progress overview

| Phase | Status | Name | Tier | Close | Depends on | Combinable with |
| ----- | ---- | ------ | ---- | ----- | ---------- | --------------- |
| **1** | Done | Show child Progress | Low | automated | — | — |

## Phase 1 — Show child Progress

**Tracker phase:** n/a

**Goal:** Epic `/spec next` and refuse-gates replies include each suggested child’s Progress (or not created / Progress missing), with archived clearly done, and project docs match.

**Covers:** G1 (show progress), G2 (done visible), R1 (child lookup), R2 (not created), R3 (progress missing), R4 (reply fields), R5 (archived done), R6 (no epic write), D1 (derive on read), D2 (same wording)

**Read first:**

- [epic-child-state.spec.md › Expected behaviour](./epic-child-state.spec.md#expected-behaviour)
- [epic-child-state.spec.md › Rules](./epic-child-state.spec.md#rules)
- [epic-child-state.spec.md › Decisions](./epic-child-state.spec.md#decisions)

**Tier:** Low — decided prose edits to Stage detection and docs; validate catches mechanical slips

**Close:** automated

**Not in this phase:** `/spec status` dashboard; storing status on epic sections; Linear mirroring

**Deliverables:**

- `skills/spec/SKILL.md` — extend: epic `/spec next` and refuse-gates bullets require child Progress lookup per R1 (child lookup) through R5 (archived done); keep R6 (no epic write)
- `README.md` — extend: Epic section says next / refuse include child Progress or not-created
- `skills/spec/templates/spec-docs-readme.md` — extend: same epic-next wording where suggested specs are described
- `spec_docs/README.md` — extend: same wording where epic next is described

**Approach** (advisory):

1. In Stage detection, on both epic next and refuse-gates replies, for each suggested spec resolve the slug, open the child or archive path, and include Progress (or not-created / Progress missing) next to the id and slug.
2. Keep epic template and create-spec “no status on S sections” text; do not add a Status field to seeds.
3. Mirror the behaviour in README and the two README seeds so humans and agents agree.

### Acceptance scenarios

- **A1.1 — Next shows Progress**
  - Trace: Expected behaviour › "When the author runs `/spec next` on an epic, the system shall name each suggested spec’s Progress, or that no child folder exists yet."
  - Regression: yes
  - Check: automated
  - Given an epic with a suggested spec whose child exists at `spec_docs/<child>/` with a Progress line
  - When the author runs `/spec next` on that epic
  - Then the reply names that Progress next to the suggested-spec id and slug

- **A1.2 — Refuse shows Progress**
  - Trace: Expected behaviour › "When the author runs implement or promote on an epic, the refuse reply shall name Progress the same way."
  - Regression: no
  - Check: automated
  - Given the same epic and child as A1.1
  - When the author runs implement or promote on the epic
  - Then the refuse reply includes the same Progress wording as `/spec next` would

- **A1.3 — Archived reads done**
  - Trace: Expected behaviour › "When a child is under `archive/` with `Progress: archived`, the system shall make that done state unmistakable in the list."
  - Regression: yes
  - Check: automated
  - Given a suggested-spec child only under `spec_docs/archive/<child>/` with `Progress: archived`
  - When the author runs `/spec next` on the epic
  - Then the reply marks that child as archived / done

- **A1.4 — Not created**
  - Trace: Expected behaviour › "When the author runs `/spec next` on an epic, the system shall name each suggested spec’s Progress, or that no child folder exists yet."
  - Regression: no
  - Check: automated
  - Given a suggested spec whose slug has no folder under `spec_docs/` or `archive/`
  - When the author runs `/spec next` on the epic
  - Then the reply says the child is not created yet and does not invent a Progress value

- **A1.5 — Seed stays status-free**
  - Trace: Unchanged behaviour › "When create writes a suggested-spec section, the system shall continue to omit a stored status, tier, or verify line on that section."
  - Regression: no
  - Check: automated
  - Given the epic template and create-spec suggested-spec rules after this phase
  - When those docs are read
  - Then they still forbid a status, tier, or verify line on suggested-spec seed sections

### Done when

- [x] Tier verify passes (Project conventions in `spec_docs/README.md`)
- [x] A1.1, A1.2, A1.3, A1.4, A1.5 pass
- [x] Epic seed sections still have no status field (A1.5)
- [x] Close-out for A1.1 and A1.3 records red-before-green

### Gates

| Check | Owner | Evidence |
| ----- | ----- | -------- |
| `/bin/sh skills/spec/scripts/validate spec_docs/epic-child-state/` | automated | Close-out command result |
| A1.1, A1.2, A1.3, A1.4, A1.5 | automated | Close-out; A1.1/A1.3 red-before-green |

**Ask-before:** —

### Close-out

- Verified:
  - `/bin/sh skills/spec/scripts/validate spec_docs/epic-child-state/` → pass (exit 0, silent)
  - **A1.1 red-before-green:** Before edit, Stage detection epic `/spec next` bullet listed S id + slug + coverage only and said “Do not read Progress” with no child lookup → fail. After edit, next bullet requires child’s Progress (or not created / Progress missing) via same rules as refuse → pass.
  - **A1.2:** Refuse bullet lists Progress fields and full lookup (active then archive; not created; Progress missing; archived = done; no epic write) → pass.
  - **A1.3 red-before-green:** Before edit, no archived/done callout for child Progress in SKILL or READMEs → fail. After edit, refuse and next require naming `archived` and saying done; README seeds say archived children are called out as done → pass.
  - **A1.4:** “not created yet” / do not invent Progress present in SKILL refuse rules and README wording → pass.
  - **A1.5:** `skills/spec/templates/epic.md` and `skills/spec/stages/create-spec.md` still say “No status, tier, or verify line” on suggested-spec sections → pass.
- Deviations: —
- Follow-ups: —
- Blocked: —
