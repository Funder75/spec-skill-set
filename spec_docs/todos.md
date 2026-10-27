# Loose ideas before creating actual specs

Ideas for before moving into specs.

Once promoted to a spec - we should remove it entirely from here.

## Still too much details for small specs - spec bloat

Take a look at the init-readme-fill - I think is a good example of where there the specs are too bloated. 
We should investigate this and see if we could learn from this anything that could help shorten future processes.

## Epic specs

Some work is too large for a single implementable spec — an epic that would bloat design, tech, and plan if forced into one folder.

Support creating an **epic** that is not implemented directly. Instead it decomposes into smaller child specs that each go through the normal design → tech → plan → implement loop on their own.

Rough shape to explore:
- An epic doc that captures intent, boundaries, and the proposed split (not phases to implement)
- Child specs linked back to the epic (and maybe sequenced or dependency-aware)
- Clear rule that implementation happens only on children, never on the epic itself

## `converge` before archive, plus an "As built" note

**Borrowed from:** Spec Kit `converge`, OpenSpec `sync`/`archive`, GSD `VERIFICATION.md`, and Superpowers' final whole-branch review.

Today, archive moves the folder once every phase is Done or Deferred. Nothing checks that the shipped code still satisfies every `G…` goal and `R…` rule. Nothing checks that the spec still describes what was built, after Close-out deviations have piled up.

- Add a **Converge** step to `stages/implement.md` › Archive, running before the move. It is a read-only pass over the goals, rules, and acceptance scenarios against the code and the Close-out records. The step has two outcomes:
  - **Converged.** No gaps were found, and archive proceeds.
  - **Gaps found.** Each gap is appended as a **Follow-ups** row, or as a new phase that is `Not started`. The step never edits code.
- Add a short **As built** section to `<slug>.spec.md` at archive. It lists binding deviations, things that ended up Deferred, and where the behaviour now lives in the code. This is the cheap, single-folder version of OpenSpec's living specs.
- Borrow GSD's `human_needed` rule. Any acceptance scenario that depends on runtime behaviour with no automated test is listed as unverified, and must have been accepted by a person.

**Fits the bounds:** this is part of an existing action, and the reuse of the analysis checklist keeps it to one skill. It is not a new pipeline. It also gives `analysis-checklist.md` › Spec drift a concrete trigger.

## Bugfix kind

**Borrowed from:** Kiro bugfix specs and the Spec Kit bug extension (assess → fix → test, with a `verified` / `partial` / `failed` verdict).

Bugs currently go through the feature spec shape: journeys, Work split, and so on. That is a main source of the spec bloat noted in `spec_docs/todos.md`.

- Add a body line `Kind: feature | bugfix`. Missing means `feature`, so older folders are unaffected. Users invoke it with `create … as bugfix` (usually together with `lite`).
- For bugfix, replace journeys and Work split in `templates/spec.md` with three binding lists:
  - **Current behaviour:** "When … the system …"
  - **Expected behaviour:** "When … the system shall …"
  - **Unchanged behaviour:** "When … the system shall continue to …"
- Add **Root cause** (cited modules) under Problem and current behaviour.
- In the plan, the acceptance scenarios map one-to-one onto the three lists. The regression scenario needs **red-before-green evidence** in Close-out: the test fails without the fix and passes with it. This follows Superpowers' verification-before-completion rule. It is evidence for one scenario, not a general TDD requirement, so `plan.md` › "Require TDD unless Project conventions say so" still holds.

**Fits the bounds:** this is a Kind line and conditional template sections, not a new skill.

## `/spec explore` with a "no spec needed" exit

**Borrowed from:** OpenSpec `/opsx:explore`, Superpowers brainstorming ("a quick, clear task: do it"), and BMAD ("for obvious edits, skip the framework").

Today `/spec` with intent always heads toward creating a folder.

- Add a read-only **explore** action. It reads the code, restates the ask in project terms, and lays out two or three approaches. It ends with exactly one of the following:
  - "No spec needed. Here is the one-line change."
  - "Spec at Depth X, slug Y."
  - "Spike first." A spike is throwaway: no folder, no gates, and keeping the result is a new request.
- Explore writes nothing. If it ends in a spec, its findings seed create-spec's Investigate and Analysis steps, so they are not repeated.
- Add a short rule to the create-spec Depth round. When the ask is below the lite threshold, the skill says so and offers to skip the folder. The user can still insist.

**Fits the bounds:** explore is an action routed by the existing intent table. It also addresses the spec-bloat todo directly.

## `/spec status` across active folders

**Borrowed from:** GSD `STATE.md` and `/gsd-progress`, and the OpenSpec dashboard.

`/spec next` answers the question for one slug. Teams with several folders have no overview.

- Add a read-only **status** action. It lists each `spec_docs/<slug>/` with Progress, Depth, Kind, the active phase and its status, any Blocked reason, and pending human Gates rows. It never opens `archive/`.
- It is read-only and keeps no new state file. The plan stays the only status store, as required by R5 (plan body authority).

## Project principles and a pointer to existing rule files

**Borrowed from:** the Spec Kit constitution, Kiro steering, OpenSpec `config.yaml`, and BMAD's verified `AGENTS.md` block.

**Project conventions** already holds facts such as tracker and verify tiers, but nothing holds non-negotiables.

- Add an optional **Principles** subsection to `templates/spec-docs-readme.md`, for example "no new runtime dependencies" or "every API change needs a contract test". Add a matching question to `fill-conventions.md`.
- `plan.md` › Ready to implement and the review packet then cite any principle a phase touches.
- In the same subsection, *point at* existing `AGENTS.md` or `.cursor/rules/` files instead of duplicating them.

## Deterministic validator

**Borrowed from:** OpenSpec `validate --strict` and Superpowers' helper scripts.

Many of Spec's rules are mechanical:

- leftover `{{…}}` placeholders, HTML comments, or `[SUGGESTION:` markers
- bare `G1` citations
- duplicate or reused IDs
- a missing or duplicated `Progress` line
- an overview `Close` that disagrees with the phase line
- a Gates row for every scenario Check
- bare basenames such as `implementation-plan.md`

A small script in the plugin (for example `skills/spec/scripts/validate`) can check all of these in milliseconds. That frees the agent's tokens for judgement. Self-review in create-spec and plan, and the start of audit, would call the script and then handle only what it cannot check.

Ship a plain `sh` or POSIX script with no new runtime dependency. If it is missing or fails to run, the skill falls back to today's manual self-review.

## Builder check on full-Depth specs

**Borrowed from:** the Superpowers brainstorming builder check.

Before asking for file review of a `full` spec, a fresh reader looks at it as the implementer would. Its questions are sorted into three piles:

- **Answered already:** written into the spec.
- **Minor:** settled by the agent and marked as its call.
- **Theirs:** asked in one batched message.

This catches the class of gap that the audit currently finds only after the fact.

**Bound conflict:** `SKILL.md` says create, promote, and audit **must not** spawn subagents. There are two ways to resolve it:

- Allow exactly one read-only builder-check subagent at `full` Depth.
- Do what Superpowers does when no subagent tool is available, and have the parent "read the document as that builder" as an extra self-review step.

The second option keeps the bound intact. This is the user's decision.

## Red flags and rationalisation tables

**Borrowed from:** Superpowers and Agent Skills.

Add short "Thought → Reality" tables to `implement.md` and `create-spec.md` for the few rules agents most often bend. Examples:

- "The worker said tests pass" → check the diff and the Close-out output.
- "This tiny edit doesn't need the review" → the review always runs.

Superpowers' own guidance says to use this form only for **discipline** failures, not for omissions. Add a table only where an eval (B1) shows a real violation, so the tables do not add bloat.

## Visual companion for UI-primary specs

**Borrowed from:** the Superpowers visual companion and GSD `UI-SPEC.md`.

When create-spec detects a UI-primary feature, offer once, in its own message, a throwaway HTML mockup or a Cursor Canvas. Show layout regions and empty and error states side by side. The mockup is advisory. The binding text stays in `<slug>.spec.md` and `<slug>.ui.md`.

## Retrospective at archive

**Borrowed from:** BMAD retrospective and Superpowers finishing-a-branch.

After converge (A1), ask one question: "Anything to add to **Project conventions**?" Examples are a missing verify command, a new hotspot, or a principle. If the answer is yes, route to `fill-conventions.md`. This makes each finished spec improve the next one.

## The conventions should cover things that should included in specs or offered as an option at spec creation interview

For example: 
- Always include documentation in code for public interfaces
- Update readme.md and other documentation files
