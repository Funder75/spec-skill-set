# Adapt Superpowers habits into the spec skill

**Slug:** `adapt-superpowers`
**Progress:** plan
**Work item:** —
**Depends on:** —

## TL;DR

- **What:** Borrow Superpowers brainstorming habits into the existing spec skill.
- **Why:** Create-spec jumps to a file too soon, and UI-heavy work under-specifies the screen.
- **v1 includes:** Chat dialogue before the file, approach options, chat approval, UI depth, guided plan Approach (not pasteables), explicit no SCM.
- **v1 excludes:** Extra skills, session hooks, worktrees, auto-commits, and Superpowers-style full-code micro plans.

## Doc index

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file | Scope, goals, journeys, constraints, work split | yes |
| [business-logic.md](./business-logic.md) | Rules, workflows, state transitions | yes |
| contracts.md | Types, API contracts, state ownership, storage | not needed |
| ui.md | Layout, interaction, states, copy | not needed |
| [implementation-plan.md](./implementation-plan.md) | Phases and phase status | yes |

## Source

> Conversation comparing Superpowers and this skill (24 Oct 2026). Keep the gated lifecycle. Steal dialogue, approaches, and chat approval. Strengthen UI in design. Plans stay contracts with guiding code and do/do-not examples — not pasteable full implementations. Stay one skill. Packaging is archived as `cursor-plugin`.

## Problem and current behaviour

**In short:** Create-spec asks a few must-ask items, then writes the file. It skips approach exploration in chat. UI-heavy features can leave screen depth thin until promote.

- **What works.** Gates stay clear: design, tech, plan, one phase, archive. Plans stay outcome-sized. The skill does not invent commits or worktrees.
- **Where Superpowers wins.** One question at a time. Two or three approaches with a recommendation. Design sections approved in chat before a durable file.
- **Where Superpowers hurts.** Many skills. Plans written as almost-final code for a "junior with poor taste" who needs no judgement. Automatic branches and commits. Weak UI focus in the design doc.
- **Gap in create-spec.** After the must-ask list, it writes `spec.md`. Approach rounds and chat approval before the file are missing.
- **Gap for UI work.** `templates/ui.md` is rich, but create-spec only requires journeys. A UI-primary feature can leave layout and interaction thin until promote.
- **Gap in plan stage.** Approach today is mostly paths and order. That under-guides an LLM. Nothing also forbids pasteable full implementations that replace review.

| Path | What it does today |
| ---- | ------------------ |
| `skills/spec/stages/create-spec.md` | Clarifies, then writes design file |
| `skills/spec/stages/plan.md` | Writes phased plan; Approach is advisory |
| `skills/spec/templates/ui.md` | UI tech doc shape after promote |
| `skills/spec/design-quality.md` | Plan quality and phase tier rules |
| `skills/spec/SKILL.md` | Routes actions; one skill |
| `spec_docs/archive/cursor-plugin/spec.md` | Packaging only; deferred these habits |

## Goals and acceptance criteria

**In short:** Dialogue and approval before the file, stronger UI when the surface is a screen, plans with guiding code but no pasteables, and no SCM or skill sprawl.

### G1 (chat dialogue) — Create-spec explores the idea in chat before writing the file

Source: —

- After investigate, the agent asks clarifying questions one at a time when answers are still missing.
- Prefer multiple choice when the options are clear.
- Skip questions the input or chat already answered.
- Do not create `spec.md` until the dialogue and design approval in G2 (chat approval) finish, or the user says to proceed with recorded assumptions.

### G2 (chat approval) — The design shape is approved in chat before the file exists

Source: —

- When the feature has a real fork, the agent proposes two or three approaches with trade-offs and a recommendation.
- Skip the approach round when there is no meaningful fork.
- The agent presents the design in short chat sections scaled to complexity.
- It asks for approval after sections, not only after the file is written.
- Only then does it write `spec.md` and ask for file review, as today.

### G3 (self review) — A short checklist runs before asking for file review

Source: —

- Before asking the user to review the written `spec.md`, the agent checks for placeholders, contradictions, scope leaks into non-goals, and bare ID citations.
- Failures are fixed in the same turn when cheap, or called out in the review ask.

### G4 (ui depth) — UI-primary features get screen depth at design time

Source: —

- Create-spec detects when the primary surface is a user-facing screen.
- For those specs, `spec.md` must cover layout regions, main interactions, empty and error states, and glance versus control when both exist.
- The design still defers component props and wireframes to `ui.md` at promote.
- Non-UI features keep journeys as `n/a` with a reason, as today.

### G5 (plan contracts) — Plans guide tightly with examples, not pasteable full code

Source: —

- Approach is richer than today's path-and-order style: enough guiding code, do/do-not examples, and code-design notes that an LLM has little room to invent a different shape.
- Approach must not ship full implementation blocks meant to be pasted into the repo (the Superpowers "junior with poor taste" plan shape).
- The plan still expects judgement and review before execute. It is not a no-thinking paste script. It is a tight contract an implementer follows after that review.
- Phase size stays outcome-based. No 2–5 minute micro-steps as the default unit.
- TDD is not required by the skill unless the consuming project's conventions say so.

### G6 (no scm) — The skill never creates branches, worktrees, or commits on its own

Source: —

- Stage files state that the skill must not run git write commands unless the user explicitly asks in that conversation.
- No worktree creation step is part of create, promote, or implement.
- Existing user or project git rules still apply; the skill does not fight them by inventing commits.

### G7 (one skill) — The workflow stays one skill with stages

Source: —

- Adaptations land in the existing `spec` skill tree.
- No new peer skills for brainstorming, planning, or TDD are added for this design.
- The skill does not auto-invoke a separate implementation pipeline after the design file is approved.

## Non-goals

- Packaging, marketplace listing, or npm publish. See archived `cursor-plugin`.
- Session hooks that inject the skill into every chat.
- A visual companion browser for brainstorming.
- Subagent-driven development as a required path.
- Copying Superpowers plan templates or tasks written so a "junior with poor taste, no judgement" can paste them without review.
- Requiring design dialogue for every one-line bugfix outside `/spec create`.
- Syncing the user agent store with this repo.
- Changing writing-style.md sentence rules except where a stage must point at them.

## Users and context

- **Primary user:** A developer using `/spec` to design a feature.
- **When:** They create a new design, especially when the surface is a screen or there is more than one approach.
- **Who may do this:** Anyone who can run the packaged or user-level spec skill.

## User journeys

**In short:** Create a design with dialogue first; run a UI-heavy create with screen depth; promote a plan that stays a contract; refuse surprise SCM.

### Create a design with dialogue

Starting point: the developer asks `/spec` to create a design for a non-trivial feature.

1. The agent investigates the repo paths that own the behaviour.
2. It asks one missing clarifying question at a time.
3. If there is a real fork, it shows two or three approaches and a recommendation.
4. It presents the design in chat sections and asks whether each looks right.
5. After approval, it writes `spec.md` and runs the self-review checklist.
6. It asks the developer to review the file.

End state: the durable design matches what was approved in chat.

Goes wrong when:

- The agent writes the file during the first reply. G1 (chat dialogue) and G2 (chat approval) forbid that.
- There is no fork, but the agent forces three fake approaches. G2 (chat approval) allows skipping.
- The user says proceed with assumptions. Assumptions become open questions or decisions, then the file may be written.

Covers: G1 (chat dialogue), G2 (chat approval), G3 (self review)

### Create a UI-primary design

Starting point: the developer asks for a design whose main surface is a screen.

1. Dialogue and approval run as in the first journey.
2. The written design includes layout regions, main interactions, and empty or error states.
3. Component props stay out of `spec.md`.

End state: a reviewer can accept screen behaviour without reading a tech doc yet.

Goes wrong when:

- Journeys exist but the screen is still undescribed. G4 (ui depth) fails the design.
- The design dumps component props. Those belong at promote in `ui.md`.

Covers: G4 (ui depth)

### Promote to an implementation plan

Starting point: tech docs are reviewed, and the developer asks for the plan.

1. The agent writes phases with goals, deliverables, and Done when.
2. Approach cites paths and order, plus guiding snippets, do/do-not examples, and code-design notes where shape would otherwise be ambiguous.
3. The plan has no pasteable full implementations.

End state: after review, an LLM implementer has little room to reinterpret the shape; Done when stays the binding check.

Goes wrong when:

- Approach is only bare paths with no shape guidance. G5 (plan contracts) expects tighter guidance than today.
- Approach contains full code to paste. G5 (plan contracts) forbids that.
- Phases become 2–5 minute micro-steps. G5 (plan contracts) forbids that as the default.

Covers: G5 (plan contracts)

### Implement without surprise SCM

Starting point: the developer asks to implement a phase.

1. The agent edits product files as the phase requires.
2. It does not create a branch, worktree, or commit unless asked.
3. It stops for review when the phase Done when is met.

End state: git history stays under the developer's control.

Goes wrong when:

- The skill creates a worktree or commits "as Superpowers would." G6 (no scm) forbids that.

Covers: G6 (no scm), G7 (one skill)

## Constraints

- **Preserve:** Progress gates, ID citation form, one-phase implement, no auto-promote across gates.
- **i18n:** n/a
- **Accessibility:** For UI-primary designs, empty and error states must be named in the design. Deeper a11y stays in `ui.md`.
- **Security:** Skill text only. No tokens. No session hooks.
- **Performance:** n/a
- **Persistence:** n/a — instruction files only; no app storage.

## Notes

**In short:** Packaging already shipped separately. Superpowers is a reference, not a dependency. This design edits skill behaviour in this repo.

- **Archived packaging.** `spec_docs/archive/cursor-plugin` covered the plugin shape. This design changes skill text inside `skills/spec/`.
- **Reference only.** Superpowers brainstorming is a behaviour reference. Do not vendor its skill files.
- **Reload after edits.** If the plugin is loaded from the local plugins folder, copy and reload after skill changes. That is an install concern, not a goal here.

## Concerns

- **Longer create loop.** Dialogue adds turns. Without skip rules, small specs feel heavy. G2 (chat approval) allows skipping approaches when there is no fork.
- **UI detection.** "Primary surface is a screen" can be fuzzy. If left vague: agents under- or over-apply G4 (ui depth). See Q1 (ui trigger).

## Proposed solution

Extend create-spec with a chat gate after investigation. Ask missing questions one at a time. When a real fork exists, show a short approach set and a recommendation. Present the design in chat and get approval. Only then write `spec.md`, self-review, and ask for file review.

When the feature is UI-primary, the design must state screen structure and interaction depth. Props and wireframes still wait for `ui.md`.

Tighten the plan stage so Approach stays advisory but richer: guiding code, do/do-not examples, and code-design notes that leave little LLM wiggle room. Forbid pasteable full implementations. Keep phase sizing outcome-based. Review before execute remains expected.

State the no-SCM rule in stages that touch execution. Keep a single `spec` skill. Do not add brainstorming or TDD as separate skills.

### Capabilities (v1)

- **Dialogue gate.** Questions and optional approaches before any design file.
- **Chat design approval.** Sectional approval, then write the file.
- **UI depth at design.** Required screen content for UI-primary specs.
- **Plan contract rule.** Guiding code and examples in Approach; no pasteable full implementations.
- **SCM refusal.** No branches, worktrees, or commits unless the user asks.

## Touched paths

| Path | Area | Change |
| ---- | ---- | ------ |
| `skills/spec/stages/create-spec.md` | Skill | Dialogue, approval, UI depth, self-review |
| `skills/spec/stages/plan.md` | Skill | Require guiding examples; forbid pasteable full code |
| `skills/spec/design-quality.md` | Skill | Align plan quality with guided-contract rule |
| `skills/spec/SKILL.md` | Skill | Point at no-SCM and single-skill bounds |
| `skills/spec/templates/spec.md` | Templates | Optional UI-primary design prompts |
| `skills/spec/stages/implement.md` | Skill | Restate no SCM unless asked |
| `README.md` | Docs | Note behaviour changes after packaging |

## Work split

1. **Create-spec dialogue.** Covers G1 (chat dialogue), G2 (chat approval), G3 (self review). Outcome: create-spec cannot write the file before chat approval. Main surface: create-spec stage.
2. **UI depth at design.** Covers G4 (ui depth). Outcome: UI-primary designs carry screen depth in `spec.md`. Main surface: create-spec and the design template.
3. **Plan contract rule.** Covers G5 (plan contracts). Outcome: Approach carries guiding code and do/do-not examples; pasteable full code stays forbidden. Main surface: plan stage and design-quality.
4. **Bounds.** Covers G6 (no scm) and G7 (one skill). Outcome: stages state no SCM and no new peer skills. Main surface: skill entry and implement stage.

## Glossary

- **Chat approval:** The user accepts the design shape in conversation before `spec.md` exists.
- **UI-primary:** The main deliverable is a screen or interactive surface people use.
- **Approach round:** Two or three options with trade-offs and a recommendation, only when a real fork exists.
- **Pasteable code:** Full implementation blocks in a plan meant to be copied into the repo without further design.
- **Guiding code:** Short snippets, signatures, or sketches that show the intended shape without being a drop-in file.

## Decisions

**In short:** One skill, chat-first create, UI depth when needed, plans are guided contracts (not paste scripts), no SCM, packaging stays separate.

### D1 (one skill) — Keep a single spec skill with stages

- **Date:** 2026-10-24 · **Area:** skill shape
- **Why:** Extra skills were a Superpowers con. Stages already split the work.
- **Rejected:** a separate brainstorming skill that owns create.

### D2 (chat before file) — Approve the design in chat, then write `spec.md`

- **Date:** 2026-10-24 · **Area:** create-spec
- **Why:** Superpowers' strength is the dialogue. Writing first freezes unexamined choices.
- **Rejected:** only reviewing after the file exists.

### D3 (skip empty approaches) — Approach rounds only when there is a real fork

- **Date:** 2026-10-24 · **Area:** create-spec
- **Why:** Fake options waste turns on forced work.
- **Rejected:** always requiring three approaches.

### D4 (ui at design) — Screen depth belongs in the design for UI-primary work

- **Date:** 2026-10-24 · **Area:** create-spec
- **Why:** Waiting until `ui.md` leaves screen behaviour unreviewed at the design gate.
- **Rejected:** leaving all screen detail to promote for UI-primary features.

### D5 (guided plan, not paste) — Approach uses guiding code; forbid pasteable full implementations

- **Date:** 2026-10-24 · **Area:** plan
- **Why:** Bare path-and-order Approach under-guides an LLM. Superpowers-style full-code tasks remove review and judgement. The target is a tight contract: little interpretation room after review, not a no-taste paste script.
- **Rejected:** (1) Approach as paths-only. (2) Superpowers "junior with poor taste / no judgement" full-code plan shape.

### D6 (no scm) — No branches, worktrees, or commits unless the user asks

- **Date:** 2026-10-24 · **Area:** skill bounds
- **Why:** Surprise SCM was a Superpowers con.
- **Rejected:** worktree creation as part of implement.

### D7 (no hooks) — Do not add session-start hooks for this design

- **Date:** 2026-10-24 · **Area:** plugin
- **Why:** The user invokes `/spec`. Hooks that steal every session are out of scope.
- **Rejected:** a using-superpowers style always-on injector.

## Open questions

### Q1 (ui trigger) — How does create-spec decide a feature is UI-primary?

- **Priority:** high · **Blocks:** phase 2 (UI depth at design) · **Owner:** Dan
- **Options:**
  - **A.** Primary surface is a screen, form, or interactive panel people use.
  - **B.** Only when the user says the work is UI, or asks for `ui.md` later.
  - **C.** When any goal needs a user-visible change, including copy-only.

> **Open:** Q1 (ui trigger)
