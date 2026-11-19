---
work_item: n/a
tracker_spec_url: n/a
epic: n/a
---

# Epic suggested-spec Status

**Progress:** implementing
**Depth:** lite
**Kind:** bugfix
**Depends on:** —

## TL;DR

- **What:** Suggested-spec sections on an epic carry durable Status (`created`, then `done`)
- **Why:** Authors need to see which children exist and which are finished in the epic file itself
- **v1 includes:** Status on create and archive; revert derive-on-read Progress lookup; README wording
- **v1 excludes:** Mid-flight Progress on S sections; `/spec status` dashboard; Linear mirror

## Doc index

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file (`epic-s-status.spec.md`) | Scope, goals, behaviour lists, constraints | yes |
| epic-s-status.logic.md | Rules, workflows, state transitions | folded → [Technical notes › Rules](#rules) |
| epic-s-status.contracts.md | Types, API contracts, state ownership, storage | not needed |
| epic-s-status.ui.md | Layout, interaction, states, copy | not needed |
| [epic-s-status.plan.md](./epic-s-status.plan.md) | Phases and phase status | yes |

## Source

> Chat after archived `epic-child-state`: derive-on-read replies were the wrong fix. Authors want Status on each `Sx` in the epic. Tokens: `created` on create spec for, `done` on child archive. Supersedes `spec_docs/archive/epic-child-state/`.

## Problem and current behaviour

**In short:** The epic file never records whether a suggested spec was created or finished. A prior fix only taught chat replies to peek at child Progress folders.

- **No Status on S sections.** Template and create forbid a status line on suggested specs.
- **Create leaves the epic seed unchanged** (aside from optional seed edits), so a created child still looks unstarted in the epic.
- **Archive leaves the epic unchanged.** The child moves under `archive/` with `Progress: archived`, but the S section still looks open.
- **Derive-on-read replies.** Stage detection opens child or archive folders for Progress at `/spec next` / refuse time, instead of reading a durable field on the epic.

### Current behaviour

- When the author runs `/spec create spec for` an epic section, the system writes the child and does not set Status on that S section.
- When the author archives a child of an epic, the system does not set Status on the matching S section.
- When the author opens the epic markdown, finished children are indistinguishable from open seeds.
- When the author runs `/spec next` on an epic, the system looks up each child’s Progress folder rather than a Status line on the epic.

### Expected behaviour

- When the author runs `/spec create spec for` and the child is written, the system shall set `**Status:** created` on that suggested-spec section.
- When the author archives a child whose frontmatter `epic` is set, the system shall set `**Status:** done` on the matching S section (by Slug).
- When the author reads the epic file, created and done children shall be visible from Status on each S section.
- When the author runs `/spec next` or hits refuse-gates on an epic, the system shall name each S Status from the epic (or that Status is absent), and shall not open child folders to invent Progress.

### Unchanged behaviour

- When create writes a new suggested-spec seed, the system shall omit Status until create spec for runs.
- When a child walks design → tech → plan → implementing, the system shall keep those Progress values only on `<child>.spec.md`.
- When the epic has file-level Kind, the system shall continue to omit file-level Progress and Depth on the epic.

### Root cause

`epic-child-state` chose derive-on-read for replies and rejected storing Status on S sections. That left the epic file looking open after children were archived.

## Goals and acceptance criteria

### G1 (status created) — Create sets Status created on the S section

Source: chat › mark on create

- `/spec create spec for` sets `**Status:** created` on the named suggested-spec section in the same write as the child.
- Status is not copied into `<child>.spec.md`.

### G2 (status done) — Archive sets Status done on the matching S section

Source: chat › mark when done or archived

- After a child of an epic is archived (`Progress: archived`), the parent epic’s matching S section (Slug = child slug) has `**Status:** done`.
- Parent resolve: `spec_docs/<epic>/` then `spec_docs/archive/<epic>/`. Missing epic or section warns in chat; archive still succeeds.

### G3 (replies use epic status) — Next and refuse read Status from the epic

Source: chat › replace derive-on-read

- `/spec next` and refuse-gates list each S id, slug, Status from the epic (or Status absent), and coverage.
- They do not look up child Progress under `spec_docs/<child>/` or `archive/` for that list.

### G4 (docs match) — README describes Status created and done

Source: plan › README.md required

- Project README Epic section describes Status `created` / `done` and the create / archive triggers.
- README seeds match that wording where epic suggested specs are described.

## Non-goals

- Mirroring child Progress (`design` / `plan` / …) onto S sections.
- Status values beyond `created` and `done`.
- `/spec status` dashboard; Linear mirror of S Status.
- Rewriting archived `epic-child-state` Close-out as if it delivered this.

## Users and context

- **Primary user:** Spec authors steering an epic by reading `<slug>.epic.md` or `/spec next`
- **When:** After create spec for, and after archiving a child
- **Who may do this:** Anyone who can invoke the Spec skill

## Constraints

- **Preserve:** No file-level Progress on the epic; no tier or verify line on S sections; child Progress stays on `<child>.spec.md` only
- **Tokens:** Exact Status values are `created` and `done`

## Proposed solution

Allow optional `**Status:** created | done` on suggested-spec sections. Set `created` in create-spec-for-epic. Set `done` in Archive when the child has frontmatter `epic`. Revert Stage detection Progress folder lookup; list Status from the epic instead. Document in README and seeds.

## Touched paths

| Path | Area | Change |
| ---- | ---- | ------ |
| `skills/spec/SKILL.md` | Stage detection | Revert Progress lookup; list epic Status |
| `skills/spec/stages/create-spec.md` | Create for epic | Set Status created |
| `skills/spec/stages/implement.md` | Archive | Set Status done on parent S section |
| `skills/spec/templates/epic.md` | Epic seed | Allow Status created \| done |
| `README.md` | Epic docs | Status lifecycle |
| `skills/spec/templates/spec-docs-readme.md` | Docs seed | Same wording |
| `spec_docs/README.md` | Project docs | Same wording |
| `spec_docs/archive/fewer-human-stops/fewer-human-stops.epic.md` | Backfill | Status done on each suggested spec |

## Technical notes (folded)

### Rules

- **R1 (status tokens).** Suggested-spec Status MUST be omitted, or exactly `created`, or exactly `done`. MUST NOT invent other values or child Progress tokens on the epic.
- **R2 (created on create).** When create spec for writes the child, it MUST set or replace `**Status:** created` on that S section in the same write. MUST NOT copy Status into the child spec.
- **R3 (done on archive).** After archive sets `Progress: archived` on a child with frontmatter `epic` set to a real slug, the runner MUST set or replace `**Status:** done` on the S section whose **Slug** matches the child. Prefer `spec_docs/<epic>/<epic>.epic.md`, else `spec_docs/archive/<epic>/<epic>.epic.md`. When the epic or section is missing, warn in chat and MUST NOT fail the archive move.
- **R4 (reply fields).** Epic `/spec next` and refuse-gates MUST include, for each suggested spec: full `S` id, slug, Status from the epic or that Status is absent, and coverage. MUST NOT open child folders to invent Progress for that list.
- **R5 (seed omit).** New suggested-spec seed sections MUST omit Status until create spec for runs. MUST NOT add tier or verify lines.

## Decisions

### D1 (durable status) — Store Status on the S section; supersede derive-on-read

- **Date:** 2026-11-19 · **Area:** epic suggested specs
- **Why:** Authors read the epic file; chat-only Progress lookup left finished children looking open.
- **Rejected:** Keeping only derive-on-read Progress from child folders (`epic-child-state`)

### D2 (created then done) — Two Status tokens only

- **Date:** 2026-11-19 · **Area:** status values
- **Why:** Matches create and archive gates without mirroring mid-flight Progress.
- **Rejected:** `Spec'ed`; mirroring `design` / `plan` / `implementing` onto S sections

## Glossary

- **Suggested-spec Status:** The optional `**Status:**` line on an `S` section in `<slug>.epic.md` (`created` · `done`).
- **Derive-on-read (retired):** Looking up child Progress under `spec_docs/<child>/` or `archive/` for epic replies without writing the epic.
