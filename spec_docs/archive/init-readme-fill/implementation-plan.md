# Fill Project conventions on init — implementation plan

Phases for [spec.md](./spec.md).

**Status values:** `Not started` · `Started` · `Reviewing` · `Done` · `Deferred` · `Blocked`

## Progress overview

| Phase | Status | Name | Tier | Depends on | Combinable with |
| ----- | ------ | ---- | ---- | ---------- | --------------- |
| **1** | Done | Bootstrap ask and fill | High | — | — |

## Phase 1 — Bootstrap ask and fill

**Goal:** First bootstrap asks before filling conventions, lists every placeholder group, and on opt-in writes only **Project conventions**.

**Covers:** G1 (bootstrap ask), G2 (list placeholders), G3 (optional fill), R1 (ask after copy), R2 (decline preserves), R3 (list all), R4 (chat wins), R5 (conventions only), R6 (no silent fill), R7 (ask before continue), R8 (safe draft), R9 (keep bootstraps aligned)

**Read first:**

- [spec.md › R1 (ask after copy)](./spec.md#r1-ask-after-copy)
- [spec.md › R2 (decline preserves)](./spec.md#r2-decline-preserves)
- [spec.md › R3 (list all)](./spec.md#r3-list-all)
- [spec.md › R4 (chat wins)](./spec.md#r4-chat-wins)
- [spec.md › R5 (conventions only)](./spec.md#r5-conventions-only)
- [spec.md › R6 (no silent fill)](./spec.md#r6-no-silent-fill)
- [spec.md › R7 (ask before continue)](./spec.md#r7-ask-before-continue)
- [spec.md › R8 (safe draft)](./spec.md#r8-safe-draft)
- [spec.md › R9 (keep bootstraps aligned)](./spec.md#r9-keep-bootstraps-aligned)
- [spec.md › Workflow — bootstrap ask and optional fill](./spec.md#workflow--bootstrap-ask-and-optional-fill)
- [spec.md › D3 (answers alone opt-in)](./spec.md#d3-answers-alone-opt-in)

**Tier:** High — bootstrap chat-gate ordering (ask, opt-in/decline, fill) with weak feedback until a dry-read or live init

**Not in this phase:** Re-fill when README already exists; a standalone init command; edits outside **Project conventions** or to the template schema; inventing a new conventions shape

**Deliverables:**

- `skills/spec/SKILL.md` — extend: Bootstrap section becomes copy → ask with placeholder list → decline or fill → then resume; remove the blanket “do not fill” line
- `skills/spec/stages/create-spec.md` — extend: same ordered Bootstrap behaviour as `SKILL.md` (R9 (keep bootstraps aligned))

**Approach** (advisory):

1. Read the current Bootstrap blocks in `skills/spec/SKILL.md` and `skills/spec/stages/create-spec.md`, and the placeholder groups under **Project conventions** in `skills/spec/templates/spec-docs-readme.md`.
2. Replace each Bootstrap block with the same ordered steps: copy README + `archive/.gitkeep`; ask listing work items, verify tiers, complexity hotspots, stack notes, and other commands; on decline/ignore/bare continue leave the README; on yes or substantive answers fill only **Project conventions** (chat first, then safe drafts); then resume the original `/spec` intent.
3. **Do:** state opt-in as explicit yes **or** answers to listed placeholders (D3 (answers alone opt-in)); leave unclear items as `{{…}}` or one follow-up (R8 (safe draft)).
4. **Do not:** fill without opt-in; search the repo on decline; edit README sections outside **Project conventions** or change `templates/spec-docs-readme.md`.
5. Keep both Bootstrap sections identical in ordered behaviour; mirror any wording fix in the other file.

### Acceptance scenarios

- **A1.1 — Copy before ask**
  - Journey: First bootstrap with optional fill, step 1
  - Given a repo with no `spec_docs/` and a `/spec` action that triggers bootstrap
  - When bootstrap runs
  - Then `spec_docs/README.md` and `spec_docs/archive/.gitkeep` exist before any fill ask

- **A1.2 — Ask lists every group**
  - Journey: First bootstrap with optional fill, step 2
  - Given bootstrap just wrote the README from the template
  - When the agent asks about filling conventions
  - Then the message names work items, verify tiers, complexity hotspots, stack notes, and other commands

- **A1.3 — Decline leaves placeholders**
  - Journey: First bootstrap with optional fill, step 3–4 (decline / ignore)
  - Given the fill ask was shown
  - When the user says no, ignores the ask, or continues the original action with no yes and no convention answers
  - Then **Project conventions** still contain the copied `{{…}}` placeholders

- **A1.4 — Opt-in fills conventions only**
  - Journey: First bootstrap with optional fill, step 4 (yes path)
  - Given the user opts in with at least one chat answer for a listed group
  - When the agent writes the README
  - Then only **Project conventions** change, chat answers override drafts for the same item, and filled subsections have no remaining `{{…}}` for those items

- **A1.5 — Answers alone count as opt-in**
  - Journey: First bootstrap with optional fill, step 3 (answers without yes)
  - Given the fill ask listed the placeholder groups
  - When the user answers one or more groups without saying yes
  - Then the agent treats that as opt-in and writes those values (drafting or leaving the rest per R8 (safe draft))

- **A1.6 — Ask before stage work**
  - Journey: First bootstrap with optional fill, step 4
  - Given bootstrap just finished the copy steps
  - When the original `/spec` intent would next Investigate, Clarify, or otherwise continue
  - Then the fill ask (and any opt-in write) completes first

### Done when

- [x] Tier verify passes (High row in Project conventions)
- [x] A1.1–A1.6 pass
- [x] Both Bootstrap sections describe the same ordered ask-and-fill behaviour (R9 (keep bootstraps aligned))
- [x] Decline path still leaves today’s placeholder README; template file unchanged
- [x] No silent fill path remains in either Bootstrap section

### Close-out

- Verified:
  - Low: Diff of `skills/spec/SKILL.md` and `skills/spec/stages/create-spec.md` matches Done when; no leftover author HTML comments in touched skill files; intentional `{{…}}` only as “leave unclear items” instruction text.
  - Medium: Behaviour for R1–R9 and G1–G3 encoded in both Bootstrap sections (ordered copy → ask → decline/fill → resume). Skill prose does not embed ID labels; IDs remain in `spec.md`.
  - High dry-read: Missing `spec_docs/` → step 1 writes README + `.gitkeep` before ask (A1.1); step 2 lists work items, verify tiers, complexity hotspots, stack notes, other commands and blocks Investigate/Clarify until done (A1.2, A1.6); step 3 decline/ignore/bare continue leaves placeholders and forbids search (A1.3); step 4 yes or answers-alone opt-in applies chat first, safe drafts, conventions only (A1.4, A1.5); no path fills without opt-in. Template `skills/spec/templates/spec-docs-readme.md` unchanged. Both Bootstrap blocks share the same four-step order (R9).
- Deviations: none
- Follow-ups: none
