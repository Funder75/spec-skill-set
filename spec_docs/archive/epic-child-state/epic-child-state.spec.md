---
work_item: n/a
tracker_spec_url: n/a
epic: n/a
---

# Epic child state

**Progress:** archived
**Depth:** lite
**Kind:** bugfix
**Depends on:** —

## TL;DR

- **What:** Epic next and refuse replies show each suggested child’s Progress
- **Why:** Authors cannot tell a child is done without opening folders by hand
- **v1 includes:** Derive-on-read Progress (or not created); archived called out; skill and README wording
- **v1 excludes:** Status fields on epic sections; `/spec status` dashboard; Linear mirror

## Doc index

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file (`epic-child-state.spec.md`) | Scope, goals, behaviour lists, constraints | yes |
| epic-child-state.logic.md | Rules, workflows, state transitions | folded → [Technical notes › Rules](#rules) |
| epic-child-state.contracts.md | Types, API contracts, state ownership, storage | not needed |
| epic-child-state.ui.md | Layout, interaction, states, copy | not needed |
| [epic-child-state.plan.md](./epic-child-state.plan.md) | Phases and phase status | yes |

## Source

> `spec_docs/todos.md` › Small to-do's: "An epic suggested specs does not show the state of the specific spec (especially important if done)". Chat: Kind bugfix, Depth lite, slug `epic-child-state`, derive-on-read.

## Problem and current behaviour

**In short:** Epic replies list id, slug, and coverage only. Child Progress (including archived) is never read.

- **No child lookup.** Stage detection’s epic `/spec next` path reads only `<slug>.epic.md`.
- **No status on seed sections.** Create and the epic template forbid a status line on suggested specs.
- **Archive leaves the epic unchanged.** A finished child moves under `archive/` with `Progress: archived`, but the epic section still looks open.

| Path | What it does today |
| ---- | ------------------ |
| `skills/spec/SKILL.md` | Epic next / refuse list S id, slug, coverage only |
| `skills/spec/templates/epic.md` | Suggested specs: no status, tier, or verify line |
| `skills/spec/stages/create-spec.md` | Same: no status on suggested-spec sections |
| `README.md` | Epic next names suggested specs; no Progress |

### Current behaviour

- When the author runs `/spec next` on an epic, the system lists each suggested spec by id, slug, and coverage, and does not name Progress.
- When the author runs implement or promote on an epic, the system refuses and lists suggested specs the same way, without Progress.
- When a child folder is under `spec_docs/archive/<child>/` with `Progress: archived`, the system still describes that suggested spec as if no done state were known.

### Expected behaviour

- When the author runs `/spec next` on an epic, the system shall name each suggested spec’s Progress, or that no child folder exists yet.
- When the author runs implement or promote on an epic, the refuse reply shall name Progress the same way.
- When a child is under `archive/` with `Progress: archived`, the system shall make that done state unmistakable in the list.

### Unchanged behaviour

- When create writes a suggested-spec section, the system shall continue to omit a stored status, tier, or verify line on that section.
- When a child walks design → tech → plan → implement → archive, the system shall continue to own Progress only on `<child>.spec.md`.
- When Suggested specs is `none`, the system shall continue to say none for that list.

### Root cause

Epic Stage detection in `skills/spec/SKILL.md` describes suggested specs from the epic file alone. It never opens `spec_docs/<child>/` or `spec_docs/archive/<child>/` to read the Progress line. The template rule against a status field on seed sections is correct for the seed, but nothing derives live state at reply time.

## Goals and acceptance criteria

### G1 (show progress) — Epic replies include each child’s Progress or not-created

Source: todos › show the state

- `/spec next` on an epic names Progress for each suggested spec, or says the child folder does not exist yet.
- The refuse-gates reply (implement / promote on the epic) uses the same Progress wording.
- Lookup order: `spec_docs/<child>/`, then `spec_docs/archive/<child>/`. Read the child’s `**Progress:**` line when present.

### G2 (done visible) — Archived children read as done in those lists

Source: todos › especially important if done

- A child with `Progress: archived` (normally under `archive/`) is clearly marked done in the epic reply list.
- An author does not need to open the child folder to learn that outcome.

## Non-goals

- Writing a status field into `<slug>.epic.md` suggested-spec sections.
- The separate `/spec status` dashboard idea in `todos.md` (later).
- Mirroring epic child Progress into Linear or any tracker.
- Changing create-spec-for-epic, promote, implement, or archive of children beyond how epic replies describe them.

## Users and context

- **Primary user:** Spec authors steering an epic with `/spec next` or a refused epic gate
- **When:** After some children exist, are mid-flight, or are archived
- **Who may do this:** Anyone who can invoke the Spec skill

## Constraints

- **Preserve:** No status/tier/verify line on suggested-spec seed sections; Progress stays on the child spec only

## Proposed solution

At epic reply time, for each suggested spec’s **Slug**, look up the child folder under `spec_docs/` then `archive/`. Read Progress when the file exists. Include that value (or “not created”) next to the id and slug. Call out `archived` so done is obvious. Leave the epic markdown seed unchanged.

## Touched paths

| Path | Area | Change |
| ---- | ---- | ------ |
| `skills/spec/SKILL.md` | Stage detection | Epic next and refuse list Progress |
| `README.md` | Epic docs | Next / refuse include child state |
| `skills/spec/templates/spec-docs-readme.md` | Docs seed | Same wording if epic next is described |
| `spec_docs/README.md` | Project docs | Same wording if epic next is described |

## Technical notes (folded)

### Rules

- **R1 (child lookup).** For each suggested spec, resolve the child slug. Prefer `spec_docs/<child>/<child>.spec.md`. If missing, try `spec_docs/archive/<child>/<child>.spec.md`. Read that file’s `**Progress:**` line when present.
- **R2 (not created).** When neither path exists, the reply MUST say the child is not created yet (or equivalent clear wording). MUST NOT invent a Progress value.
- **R3 (progress missing).** When the child folder exists but the Progress line is absent, the reply MUST say Progress is missing. MUST NOT invent `full` or another gate from Depth defaults.
- **R4 (reply fields).** Epic `/spec next` and refuse-gates replies MUST include, for each suggested spec: full `S` id, slug, Progress or not-created / Progress-missing, and what it covers (coverage may stay as today).
- **R5 (archived done).** When Progress is `archived`, the reply MUST make done unmistakable (for example name `archived` and say done).
- **R6 (no epic write).** Those replies MUST NOT edit `<slug>.epic.md` to store status. Seed sections stay without a status line.

## Decisions

### D1 (derive on read) — Live Progress from the child folder; no status on the epic seed

- **Date:** 2026-11-19 · **Area:** epic replies
- **Why:** Avoids drift between a stored epic status and the child’s Progress line. Keeps the “no status on S sections” seed rule.
- **Rejected:** Writing a Status line into each suggested-spec section on every Progress change

### D2 (same wording) — `/spec next` and refuse-gates share the Progress rules

- **Date:** 2026-11-19 · **Area:** stage detection
- **Why:** Both replies already list suggested specs; authors hit either path when steering an epic.

## Glossary

- **Child Progress:** The `**Progress:**` body line on `<child>.spec.md` (`design` · `tech` · `plan` · `implementing` · `archived`).
- **Not created:** No folder at `spec_docs/<child>/` or `spec_docs/archive/<child>/`.
