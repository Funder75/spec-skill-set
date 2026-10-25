# Fill Project conventions on init

**Slug:** `init-readme-fill`
**Progress:** archived
**Work item:** —
**Depends on:** —

## TL;DR

- **What:** On first bootstrap, ask whether to fill **Project conventions** placeholders, list them, and fill when the user opts in.
- **Why:** Programmers otherwise hand-edit `{{…}}` in the new README after every init.
- **v1 includes:** Bootstrap chat ask, listed placeholders, optional fill from chat answers and agent draft.
- **v1 excludes:** Re-fill of an existing README, a separate init command, and silent auto-fill.

## Doc index

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file | Scope, goals, journeys, constraints, work split | yes |
| business-logic.md | Rules, workflows, state transitions | folded → [Technical notes › Rules](#rules) |
| contracts.md | Types, API contracts, state ownership, storage | not needed |
| ui.md | Layout, interaction, states, copy | not needed |
| implementation-plan.md | Phases and phase status | yes |

## Source

> `spec_docs/todos.md` § "Init project for spec" (lines 48–54). Design chat: slug `init-readme-fill`; bootstrap-only ask; list placeholders so the user can answer some in chat; no tech docs.

## Problem and current behaviour

**In short:** Bootstrap copies a README full of `{{…}}` and forbids filling them. The programmer edits by hand later.

- **Bootstrap copies only.** When `spec_docs/` is missing, the skill copies the README template and adds `archive/.gitkeep`.
- **Placeholders stay.** **Project conventions** subsections still contain `{{…}}` after init.
- **Skill forbids fill.** Bootstrap text says not to search the repo or open other docs to fill those fields.
- **Later stages ask.** When a stage needs a convention that is still a placeholder, the agent asks then — after the moment when context was freshest.

| Path | What it does today |
| ---- | ------------------ |
| `skills/spec/SKILL.md` | Bootstrap: copy README; do not fill conventions |
| `skills/spec/stages/create-spec.md` | Same bootstrap steps; no ask or fill |
| `skills/spec/templates/spec-docs-readme.md` | Source of `{{…}}` under Project conventions |

## Goals and acceptance criteria

### G1 (bootstrap ask) — After writing the README on first init, the agent asks before filling conventions

Source: todos.md

- The ask runs only when bootstrap just created `spec_docs/README.md`.
- The ask offers to fill **Project conventions** automatically.
- Declining leaves the copied placeholders unchanged (today’s outcome).

### G2 (list placeholders) — The ask lists every Project conventions placeholder so the user can answer in chat

Source: todos.md

- The message names each fill-in (work items, verify tiers, complexity hotspots, stack notes, other commands).
- The user may supply answers for some or all of them in the same reply.
- Unanswered items may still be drafted by the agent when the user opts in to auto-fill.

### G3 (optional fill) — On opt-in, the agent writes concrete Project conventions into the new README

Source: todos.md

- Opt-in writes real text over `{{…}}` under **Project conventions** only.
- Chat answers the user gave win over agent drafts for the same item.
- Omitting a subsection that does not apply (for example empty complexity hotspots) is allowed when the template already permits omit.
- HTML author comments in that section stay stripped or as the template intends; no new `{{…}}` are left in filled subsections.

## Non-goals

- Re-prompting or re-filling when `spec_docs/README.md` already exists (later).
- A standalone “init” slash command separate from normal `/spec` bootstrap.
- Silent fill with no user ask.
- Changing README sections outside **Project conventions**.
- Changing the README template’s non-placeholder body, or inventing a new conventions schema.

## Users and context

- **Primary user:** A programmer starting the spec workflow in a repo that has no `spec_docs/` yet.
- **When:** The first `/spec` action that triggers bootstrap.
- **Who may do this:** Anyone who can run the skill and write files in the repo.

## User journeys

### First bootstrap with optional fill

Starting point: A programmer runs a `/spec` action in a repo with no `spec_docs/` folder.

1. The skill bootstraps: writes `spec_docs/README.md` from the template and adds `archive/.gitkeep`.
2. The agent asks whether to fill **Project conventions**, and lists each placeholder.
3. The programmer says no, says yes (and may paste answers), or answers some placeholders without saying yes.
4. On no or ignore, the README stays with placeholders. On yes or substantive placeholder answers, the agent fills conventions (chat answers first, then drafts) and continues the original `/spec` intent.

End state: Bootstrap files exist. Conventions are either still placeholders or filled per the reply.

Goes wrong when:

- The user ignores the ask — treat as decline; leave placeholders (G1 (bootstrap ask)).
- The agent cannot infer a value — leave that item as `{{…}}` or ask one follow-up; do not invent project facts that contradict the repo (G3 (optional fill)).

Covers: G1 (bootstrap ask), G2 (list placeholders), G3 (optional fill)

## Constraints

- **Preserve:** Bootstrap still creates the README and `archive/.gitkeep` before the ask. Declining keeps today’s placeholder README.
- **i18n:** n/a
- **Accessibility:** n/a — chat text only
- **Security:** Do not invent secrets, tokens, or private URLs into the README. Prefer public project facts.
- **Performance:** n/a

## Notes

- **Tech docs folded.** Behaviour is skill instruction text only. Binding rules live under **Technical notes** below instead of sibling tech files.
- **Template unchanged as schema.** The placeholder labels in `templates/spec-docs-readme.md` define what the ask must list; v1 does not redesign that section.

## Proposed solution

Extend Bootstrap in the skill and create-spec stage. After the copy steps, require a chat ask that lists the **Project conventions** placeholders. If the user declines, continue the original action with placeholders left. If they opt in, gather any answers from their reply, draft the rest from obvious project facts when safe, write **Project conventions** into `spec_docs/README.md`, then continue.

Do not search the whole repo on decline. On opt-in, read only what is needed to draft conventions (for example how work items are named, or that there is no app build).

### Capabilities (v1)

- **Bootstrap ask.** One chat turn after first README write.
- **Placeholder inventory.** List derived from the conventions section of the template.
- **Partial user fill.** Chat answers override drafts per subsection.

## Touched paths

| Path | Area | Change |
| ---- | ---- | ------ |
| `skills/spec/SKILL.md` | skill | Bootstrap: ask, list, optional fill |
| `skills/spec/stages/create-spec.md` | skill | Same bootstrap behaviour |

## Work split

1. **Bootstrap ask and fill.** Covers G1 (bootstrap ask), G2 (list placeholders), G3 (optional fill). Outcome: first init prompts, lists placeholders, and can write conventions. Main surface: skill Bootstrap text.

## Glossary

- **Bootstrap:** Creating `spec_docs/` when it is missing: README from template plus `archive/.gitkeep`.
- **Project conventions:** The README section the skill reads for work items, verify tiers, and related project facts.

## Technical notes (folded)

**In short:** Skill instruction text only. Rules land in both Bootstrap sections. No types or UI.

### Rules

### R1 (ask after copy)

**Lands in:** `skills/spec/SKILL.md` › Bootstrap; `skills/spec/stages/create-spec.md` › Bootstrap

- Bootstrap MUST write `spec_docs/README.md` from the template and add `spec_docs/archive/.gitkeep` before any fill ask.

> **Preserve:** Today’s copy-first order.

### R2 (decline preserves)

**Lands in:** same Bootstrap sections as R1 (ask after copy)

- On explicit decline, ignore, or a reply that continues the original action with no convention answers and no yes, Bootstrap MUST NOT rewrite **Project conventions**. Substantive answers to listed placeholders count as opt-in (D3 (answers alone opt-in)), not decline.

> **Preserve:** Placeholder README after decline (today’s outcome).

### R3 (list all)

**Lands in:** same Bootstrap sections as R1 (ask after copy)

- The ask MUST name each conventions placeholder group from `skills/spec/templates/spec-docs-readme.md` › **Project conventions**: work items, verify tiers, complexity hotspots, stack notes, other commands.

### R4 (chat wins)

**Lands in:** same Bootstrap sections as R1 (ask after copy)

- When the user opts in, values they stated in chat MUST override agent drafts for the same item.

### R5 (conventions only)

**Lands in:** same Bootstrap sections as R1 (ask after copy)

- Fill MUST change only **Project conventions** in `spec_docs/README.md`. It MUST NOT edit other README sections or the template file.

### R6 (no silent fill)

**Lands in:** same Bootstrap sections as R1 (ask after copy)

- Bootstrap MUST NOT fill conventions without opt-in in that session. Opt-in is an explicit yes, or a reply that answers one or more listed placeholders (D3 (answers alone opt-in)). Silence, ignore, bare continue of the original action, and explicit no are not opt-in.

### R7 (ask before continue)

**Lands in:** same Bootstrap sections as R1 (ask after copy)

- After the copy steps, Bootstrap MUST complete the fill ask (and any opt-in write) before Investigate, Clarify, or other stage work from the original `/spec` intent.

### R8 (safe draft)

**Lands in:** same Bootstrap sections as R1 (ask after copy)

- On opt-in, the agent MUST NOT invent secrets, tokens, or private URLs. When a value is unclear, it MUST leave that item as `{{…}}` or ask one follow-up. It MUST NOT invent facts that contradict files already opened for the draft.

### R9 (keep bootstraps aligned)

**Lands in:** `skills/spec/SKILL.md` › Bootstrap; `skills/spec/stages/create-spec.md` › Bootstrap

- The ask-and-fill steps in both Bootstrap sections MUST stay the same ordered behaviour. A change in one MUST be mirrored in the other.

### Workflow — bootstrap ask and optional fill

**In short:** Copy, ask with the placeholder list, then decline or fill, then resume the original action.

1. Detect missing `spec_docs/` and run today’s copy steps (R1 (ask after copy)).
2. Ask in chat whether to fill **Project conventions**, listing every placeholder group (R3 (list all), R6 (no silent fill)).
3. On decline, ignore, or continue with no yes and no convention answers: leave the README unchanged; resume the original intent (R2 (decline preserves), R7 (ask before continue)).
4. On yes or answers to listed placeholders: apply chat answers first, draft the rest from project facts when safe, write only **Project conventions**, strip author comments as the template intends, then resume (R4 (chat wins), R5 (conventions only), R6 (no silent fill), R8 (safe draft), D3 (answers alone opt-in)).

Goes wrong when:

- **User never answers the fill ask.** Treat as decline (R2 (decline preserves)).
- **Partial answers without clear yes.** Treat as opt-in; fill named items, draft or leave the rest (D3 (answers alone opt-in)).
- **Draft cannot infer a subsection.** Leave `{{…}}` or one follow-up; omit complexity hotspots when the template allows and there are none (R8 (safe draft), G3 (optional fill)).

### Contracts

not needed — no types, API, or storage.

### UI

not needed — chat copy only; no product surface.

## Open questions

none

## Decisions

### D1 (bootstrap only) — Ask and fill only on first bootstrap

- **Date:** 2026-10-25 · **Area:** scope
- **Why:** Matches the todo; avoids surprising rewrites of an edited README.
- **Rejected:** Re-prompt whenever placeholders remain

### D2 (no tech siblings) — Fold rules into this file; skip business-logic / contracts / ui

- **Date:** 2026-10-25 · **Area:** docs
- **Why:** Skill-markdown-only change; no types or UI.
- **Rejected:** Full promote-to-tech gate for this feature

### D3 (answers alone opt-in) — Substantive placeholder answers without yes count as opt-in

- **Date:** 2026-10-25 · **Area:** behaviour
- **Why:** If the user already answered listed placeholders, requiring a separate yes only adds friction; treat those answers as consent to write them (and draft or leave the rest).
- **Rejected:** Confirm before write (B); ignore answers until explicit yes (C)
- **Locks:** R2 (decline preserves), R6 (no silent fill)
