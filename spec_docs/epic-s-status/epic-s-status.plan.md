# Epic suggested-spec Status — implementation plan

Phases for [epic-s-status.spec.md](./epic-s-status.spec.md).

**Status values:** `Not started` · `Started` · `Reviewing` · `Awaiting sign-off` · `Done` · `Deferred` · `Blocked`

## Progress overview

| Phase | Status | Name | Tier | Close | Depends on | Combinable with |
| ----- | ---- | ------ | ---- | ----- | ---------- | --------------- |
| **1** | Done | Durable S Status | Low | automated | — | — |

## Phase 1 — Durable S Status

**Tracker phase:** n/a

**Goal:** Epic S sections carry Status created then done; derive-on-read Progress lookup is gone; README matches.

**Covers:** G1 (status created), G2 (status done), G3 (replies use epic status), G4 (docs match), R1 (status tokens), R2 (created on create), R3 (done on archive), R4 (reply fields), R5 (seed omit), D1 (durable status), D2 (created then done)

**Read first:**

- [epic-s-status.spec.md › Expected behaviour](./epic-s-status.spec.md#expected-behaviour)
- [epic-s-status.spec.md › Rules](./epic-s-status.spec.md#rules)

**Tier:** Low — decided prose edits to skill stages, template, and docs

**Close:** automated

**Not in this phase:** Mid-flight Progress on S sections; Linear; rewriting epic-child-state Close-out

**Deliverables:**

- `skills/spec/SKILL.md` — extend: next/refuse list epic Status; remove child Progress folder lookup
- `skills/spec/stages/create-spec.md` — extend: set Status created on create spec for
- `skills/spec/stages/implement.md` — extend: set Status done on parent S section at archive
- `skills/spec/templates/epic.md` — extend: allow Status created \| done; seeds omit until create
- `README.md` — extend: Epic section documents Status lifecycle
- `skills/spec/templates/spec-docs-readme.md` — extend: same wording
- `spec_docs/README.md` — extend: same wording
- `spec_docs/archive/fewer-human-stops/fewer-human-stops.epic.md` — extend: Status done on each suggested spec

**Approach** (advisory):

1. Revert Stage detection Progress lookup; list Status from the epic.
2. Wire create and archive writers for Status.
3. Update template, README, and seeds; backfill fewer-human-stops.

### Acceptance scenarios

- **A1.1 — Create sets created**
  - Trace: Expected behaviour › "When the author runs `/spec create spec for` and the child is written, the system shall set `**Status:** created` on that suggested-spec section."
  - Regression: yes
  - Check: automated
  - Given create-spec-for-epic rules after this phase
  - When those docs are read
  - Then they require `**Status:** created` on the named S section in the same write as the child

- **A1.2 — Archive sets done**
  - Trace: Expected behaviour › "When the author archives a child whose frontmatter `epic` is set, the system shall set `**Status:** done` on the matching S section (by Slug)."
  - Regression: yes
  - Check: automated
  - Given Archive rules after this phase
  - When those docs are read
  - Then they require Status done on the matching parent S section after archive

- **A1.3 — Next uses epic Status**
  - Trace: Expected behaviour › "When the author runs `/spec next` or hits refuse-gates on an epic, the system shall name each S Status from the epic"
  - Regression: yes
  - Check: automated
  - Given Stage detection after this phase
  - When next and refuse bullets are read
  - Then they list Status from the epic and do not open child folders for Progress

- **A1.4 — README documents Status**
  - Trace: Expected behaviour › docs; G4 (docs match)
  - Regression: no
  - Check: automated
  - Given README Epic section after this phase
  - When it is read
  - Then it describes Status created on create and done on archive, not child Progress lookup

- **A1.5 — Seed omits Status**
  - Trace: Unchanged behaviour › seed omit; R5 (seed omit)
  - Regression: no
  - Check: automated
  - Given the epic template after this phase
  - When a new seed section is described
  - Then Status is omitted until create; tier and verify stay forbidden

### Done when

- [x] Tier verify passes (Project conventions in `spec_docs/README.md`)
- [x] A1.1, A1.2, A1.3, A1.4, A1.5 pass
- [x] fewer-human-stops suggested specs have Status done
- [x] Close-out for A1.1 and A1.3 records red-before-green

### Gates

| Check | Owner | Evidence |
| ----- | ----- | -------- |
| `/bin/sh skills/spec/scripts/validate spec_docs/epic-s-status/` | automated | Close-out command result |
| A1.1, A1.2, A1.3, A1.4, A1.5 | automated | Close-out; A1.1/A1.3 red-before-green |

**Ask-before:** —

### Close-out

- Verified:
  - `/bin/sh skills/spec/scripts/validate spec_docs/epic-s-status/` → pass (exit 0, silent)
  - **A1.1 red-before-green:** Before edit, create-spec-for-epic had no Status created write → fail. After edit, **Status created (R2 (created on create))** requires `**Status:** created` in the same write → pass.
  - **A1.2:** Archive step 7 **Epic parent Status (R3 (done on archive))** requires `**Status:** done` on matching S section → pass.
  - **A1.3 red-before-green:** Before edit, Stage detection opened child/archive for Progress → fail. After edit, next/refuse list Status from the epic only and forbid inventing Progress → pass.
  - **A1.4:** README Epic section documents Status `created` / `done` and drops child Progress lookup → pass. Seeds mirrored.
  - **A1.5:** Epic template and create Suggested specs omit Status on new seeds; no tier/verify → pass.
  - Backfill: fewer-human-stops S sections have `**Status:** done`.
  - Skill reinstall: `./scripts/update-user-spec-skill.sh` → exit 0.
- Deviations: —
- Follow-ups: —
- Blocked: —
