---
work_item: n/a
tracker_spec_url: n/a
document_id: n/a
document_url: n/a
---

# Reduce spec bloat

**Progress:** archived
**Depth:** standard
**Depends on:** —

## TL;DR

- **What:** Cut reading load and extra gates for small work in the Spec skill
- **Why:** Lite shortens sessions but not what humans must skim; tech siblings and plans often restate the design
- **v1 includes:** Explore-with-exit, stricter lite skim, one lite approval, harder tech-sibling bar
- **v1 excludes:** Bugfix kind, epic specs, a fourth Depth, embedding the plan in the spec

## Doc index

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file (`reduce-spec-bloat.spec.md`) | Scope, goals, journeys, constraints, work split | yes |
| reduce-spec-bloat.logic.md | Rules, workflows, state transitions | folded → [Technical notes › Rules](#rules) |
| reduce-spec-bloat.contracts.md | Types, API contracts, state ownership, storage | not needed |
| reduce-spec-bloat.ui.md | Layout, interaction, states, copy | not needed |
| reduce-spec-bloat.plan.md | Phases and phase status | yes |

## Source

> `spec_docs/todos.md` › "Still too much details for small specs - spec bloat", plus the chat design packet (explore exit, lite skim, one approval, tech bar). Related loose idea: `/spec explore` with a "no spec needed" exit (same file).

## Problem and current behaviour

**In short:** Small asks still produce a near-full design skeleton plus a separate plan review, and tech docs often restate goals instead of adding land-in detail.

- **Lite shortens gates, not reading.** Create still fills the same section set; empty optional sections and Constraints `n/a` lines pad the file.
- **Two human stops for tiny work.** Even when the thin plan is written in the same create session, the stop asks for review of both files as if they were a second design gate.
- **No clean "skip the folder" path.** Intent with a task heads toward creating `spec_docs/<slug>/`. Below-lite work has no first-class exit.
- **Tech siblings feel redundant.** Logic and contracts often rephrase journeys and goals. Soft fold guidance is not a hard emit bar.

| Path | What it does today |
| ---- | ------------------ |
| `skills/spec/SKILL.md` | Routes intent; defines Depth; no explore action |
| `skills/spec/stages/create-spec.md` | Depth round, lite packet, thin plan; weak omit rules |
| `skills/spec/stages/tech-specs.md` | Soft fold / Created because; siblings still common |
| `skills/spec/templates/spec.md` | Full section skeleton for every Depth |

## Goals and acceptance criteria

### G1 (explore exit) — Below-folder work can exit without a spec folder

Source: —

- `/spec explore` is a routed, read-only action.
- Explore restates the ask in project terms, sketches two or three approaches when useful, and ends with exactly one outcome: no spec needed (with the one-line change), spec at a named Depth and slug, or spike first (throwaway; no folder).
- Explore writes nothing under `spec_docs/`.
- When the outcome is a folder, explore findings seed create-spec Investigate and Analysis so those steps are not repeated from scratch.
- In create-spec's Depth round, when the ask is below the lite threshold, the skill says so and offers to skip the folder. The user may still insist on a folder.

### G2 (lite skim) — Lite specs are short for a human skim

Source: —

- A lite `<slug>.spec.md` omits empty optional sections (Notes, Concerns, Glossary, Capabilities, Decisions, Open questions, Technical notes when empty).
- Constraints lists only lines that apply. It does not pad with `n/a` rows.
- The human skim path is TL;DR, goals (and non-goals), touched paths, real constraints, and journeys or a single `n/a — …` line.
- Doc index and other agent scaffolding may remain when required by the skill, but create-spec MUST NOT invent filler prose for omitted sections.
- Binding behaviour for lite is still decided in the spec or recorded as a **Q** item. Nothing is deferred to a later tech promote.

### G3 (one approval) — Lite create has one human approval, then implement

Source: —

- One chat approval covers the lite design packet and readiness to write both `<slug>.spec.md` and the thin `<slug>.plan.md`.
- After those files exist, the next offer is implement. Create MUST NOT require a separate human "review the plan" gate when the plan is a single Low (or clearly Low) phase with **Close** `automated`.
- The thin plan file still exists for implement and Linear. Humans are not asked to re-read it as a second design document.

### G4 (tech bar) — Tech siblings emit only when they earn a file

Source: —

- Promote emits `<slug>.logic.md`, `<slug>.contracts.md`, or `<slug>.ui.md` only when a stated bar is met. Otherwise the concern is folded or marked `not needed`.
- Default bar (binding unless Project conventions override): logic when there are about three or more distinct rules, a multi-step workflow, or non-obvious state transitions; contracts when types, API, or persistence change beyond what the spec already states; ui when a surface is new or significantly changed.
- A sibling whose body mostly restates goals, journeys, or non-goals is a defect: fold it back.
- Each emitted sibling still opens with `Created because:` naming the bar it met.

## Non-goals

- Bugfix `Kind` and its template shape (later; see remaining todos).
- Epic parent specs and child decomposition (later).
- A fourth Depth such as `micro`.
- Embedding `<slug>.plan.md` inside `<slug>.spec.md` for lite (rejected; see D1 (plan stays)).
- Changing Linear write-back doctrine beyond what G3 (one approval) implies for human review.
- Auto-renaming legacy bare basenames.

## Users and context

- **Primary user:** Spec authors and reviewers using `/spec` in a project with `spec_docs/`
- **When:** Creating or promoting work that is small, local, or unclear whether a folder is needed
- **Who may do this:** Anyone who can invoke the Spec skill in the IDE

## User journeys

n/a — skill and process change for authors and agents; no end-user product UI.

## Constraints

- **Preserve:** Depth values `full` / `standard` / `lite`; monotonic Progress; D1 filename map; plan body as phase-status authority; Linear hooks that require `<slug>.plan.md`
- **i18n:** n/a
- **Accessibility:** n/a
- **Security:** Untrusted-content rules for explore and create stay in force
- **Performance:** n/a

## Notes

- **Todos overlap.** The loose explore write-up in `spec_docs/todos.md` is absorbed by G1 (explore exit) and should be removed from todos when this folder exists.
- **Agent vs human.** Gates, Close, and ID machinery stay for agents. This spec improves the human skim path; it does not delete agent contract fields the skill requires.

## Proposed solution

Add a read-only **explore** stage and route it from the skill intent table. Teach the Depth round to offer "no folder" when the ask is below lite. Tighten create-spec and the spec template so lite omits empty sections and drops Constraints padding. Collapse the lite human loop to one approval, then implement, while still emitting the thin plan for agents. Raise the tech-specs emit bar and treat restatement as a fold-back defect. Point README / `spec_docs/README` at explore and the lite skim contract so humans know the shorter path exists.

### Capabilities (v1)

- **Explore.** Read-only outcome triad; seeds create when a folder follows.
- **Lite skim contract.** Explicit omit rules in create-spec and template guidance.
- **Single lite approval.** Design + thin plan in one human stop.
- **Sibling bar.** Harder promote rules with Created because tied to the bar.

## Touched paths

| Path | Area | Change |
| ---- | ---- | ------ |
| `skills/spec/SKILL.md` | skill | Route explore; Depth / lite notes |
| `skills/spec/stages/explore.md` | skill | New read-only stage |
| `skills/spec/stages/create-spec.md` | skill | Below-lite offer; lite omit; one-approval stop |
| `skills/spec/stages/tech-specs.md` | skill | Sibling emit bar; restatement defect |
| `skills/spec/templates/spec.md` | templates | Lite omit / Constraints guidance |
| `README.md` | docs | Document explore and lite skim tips |
| `spec_docs/README.md` | docs | Depth / how-to notes for explore and lite |

## Work split

1. **Explore and skip-folder.** Covers G1 (explore exit). Outcome: explore is routable and Depth round can exit without a folder. Main surface: skill routing and new stage.
2. **Lite skim and one approval.** Covers G2 (lite skim), G3 (one approval). Outcome: lite create emits a short human skim and one approval then implement. Main surface: create-spec and spec template.
3. **Tech sibling bar.** Covers G4 (tech bar). Outcome: promote folds or skips siblings unless the bar is met; restatement folds back. Main surface: tech-specs (and README pointers as needed).

## Glossary

- **Human skim path:** The sections a person must read to judge lite scope: TL;DR, goals, non-goals, touched paths, real constraints, journeys or n/a.
- **Sibling bar:** The conditions under which a tech sibling file may be emitted instead of folded or marked `not needed`.
- **Spike:** Throwaway investigation with no `spec_docs/` folder and no gates; keeping the result is a new request.

## Technical notes (folded)

**In short:** Process rules for the Spec skill and its docs. No runtime types or product UI.

### Rules

#### R1 (explore route)

**Lands in:** `skills/spec/SKILL.md` › Infer table; stage detection as needed

- The skill MUST route `/spec explore` (and clear equivalents) to a new stage file `skills/spec/stages/explore.md`.
- Help text and stage detection MUST name explore when listing actions.

#### R2 (explore read only)

**Lands in:** `skills/spec/stages/explore.md` (new)

- Explore MUST restate the ask in project terms, and MAY sketch two or three approaches.
- Explore MUST end with exactly one outcome: no spec needed (plus the one-line change); spec at a named Depth and slug; or spike first (throwaway, no folder).
- Explore MUST NOT create or edit anything under `spec_docs/`.
- Untrusted-content rules from `SKILL.md` MUST apply to explore the same way as create-spec Investigate.

#### R3 (explore seeds create)

**Lands in:** `skills/spec/stages/explore.md`; `skills/spec/stages/create-spec.md` › Investigate / Analysis

- When the chosen outcome is a folder, explore findings MUST seed create-spec Investigate and Analysis so those steps are not repeated from scratch.
- See D2 (explore seeds create).

#### R4 (below lite skip)

**Lands in:** `skills/spec/stages/create-spec.md` › Depth round

- When Depth heuristics prefer **lite**, the Depth round MUST also offer **no folder** and say the ask may not need a `spec_docs/` folder.
- The user MAY still insist on a folder and a Depth.
- See G1 (explore exit).

#### R5 (lite omit empty)

**Lands in:** `skills/spec/stages/create-spec.md` › Write; `skills/spec/templates/spec.md` author guidance

- For **Depth: lite**, create-spec MUST omit empty optional sections: Notes, Concerns, Glossary, Capabilities, Decisions, Open questions, and Technical notes when empty.
- Create MUST NOT invent filler prose for omitted sections.
- Doc index and other agent scaffolding MAY remain when the skill requires them.
- See G2 (lite skim).

#### R6 (lite constraints)

**Lands in:** `skills/spec/stages/create-spec.md` › Write; `skills/spec/templates/spec.md` › Constraints

- For **Depth: lite**, Constraints MUST list only lines that apply.
- It MUST NOT pad with `n/a` rows.
- This overrides today's create-spec line that keeps every Constraints row with `n/a`.
- See G2 (lite skim).

#### R7 (lite skim path)

**Lands in:** `skills/spec/stages/create-spec.md` › Write (lite); README pointers

- The human skim path for lite MUST be TL;DR, goals (and non-goals), touched paths, real constraints, and journeys or a single `n/a — …` line.
- Binding behaviour for lite MUST still be decided in the spec or recorded as a **Q** item. Nothing is deferred to a later tech promote.

#### R8 (one lite approval)

**Lands in:** `skills/spec/stages/create-spec.md` › Chat design approval; Stop; Lite thin plan

- One chat approval MUST cover the lite design packet and readiness to write both `<slug>.spec.md` and the thin `<slug>.plan.md`.
- After those files exist, when the plan is a single Low (or clearly Low) phase with **Close** `automated`, create MUST NOT require a separate human "review the plan" gate. The next offer MUST be implement.
- The thin plan file MUST still exist for implement and Linear. Humans MUST NOT be asked to re-read it as a second design document in that case.
- If the thin plan is multi-phase, Tier above Low, or **Close** `human`, create SHOULD still present the plan for review before implement.
- See G3 (one approval) and D1 (plan stays).

#### R9 (sibling emit bar)

**Lands in:** `skills/spec/stages/tech-specs.md` › What to write / Standard fold

- Promote MUST emit `<slug>.logic.md`, `<slug>.contracts.md`, or `<slug>.ui.md` only when the default bar is met (unless Project conventions override).
- **Logic:** about three or more distinct rules, a multi-step workflow, or non-obvious state transitions.
- **Contracts:** types, API, or persistence change beyond what the spec already states.
- **UI:** a surface is new or significantly changed.
- Otherwise the concern MUST be folded or marked `not needed`.
- Each emitted sibling MUST open with `Created because:` naming the bar it met.
- See G4 (tech bar).

#### R10 (restatement defect)

**Lands in:** `skills/spec/stages/tech-specs.md`

- A sibling whose body mostly restates goals, journeys, or non-goals is a defect: fold it back into **Technical notes** or drop it.
- See G4 (tech bar).

#### R11 (docs pointers)

**Lands in:** `README.md`; `spec_docs/README.md`

- Project README and `spec_docs/README.md` SHOULD name explore and the lite skim / one-approval path so humans know the shorter path exists.
- They MUST NOT invent a second process that contradicts the skill stages.

### Explore workflow

1. User invokes explore with an ask — `SKILL.md` routes to `stages/explore.md`.
2. Stage restates the ask, optionally sketches approaches, picks exactly one outcome (R2 (explore read only)).
3. **No folder / spike:** stop in chat; write nothing under `spec_docs/`.
4. **Folder:** hand off to create-spec with seeded Investigate / Analysis (R3 (explore seeds create)); Depth round may still offer no folder (R4 (below lite skip)).

### Lite create stop

1. One packet approval (R8 (one lite approval)).
2. Write `<slug>.spec.md` under R5 (lite omit empty), R6 (lite constraints), R7 (lite skim path).
3. Write thin `<slug>.plan.md`; set `Progress: plan`.
4. Next offer: implement when R8's single Low + Close automated case holds; otherwise present the plan once, then implement.

## Decisions

### D1 (plan stays) — Lite keeps a separate thin plan file

- **Date:** 2026-10-27 · **Area:** process
- **Why:** Implement and Linear require `<slug>.plan.md`. Merging it into the spec fights R5 (plan body authority) and existing hooks.
- **Rejected:** Embed the plan in `<slug>.spec.md` for lite; invent a fourth Depth that skips the plan file

### D2 (explore seeds create) — Explore findings feed create-spec when a folder follows

- **Date:** 2026-10-27 · **Area:** process
- **Why:** Avoid repeating Investigate and Analysis after the user accepts "spec at Depth X."
- **Rejected:** Treat explore and create as fully isolated passes

### D3 (standard fold) — This folder uses standard Depth; tech folds at promote

- **Date:** 2026-10-27 · **Area:** process
- **Why:** Several goals and careful skill wording, but no runtime types or UI; rules belong folded or in the plan, not three siblings.
