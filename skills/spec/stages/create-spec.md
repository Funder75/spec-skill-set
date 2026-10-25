# Create spec

Write or resume `spec_docs/<slug>/<slug>.spec.md` (R1 (filename pattern), R3 (new names only)). For **Depth: lite**, also write a thin `<slug>.plan.md` in the same session after one approval. For **standard** and **full**, do not create tech siblings or a plan in this action. Do not rename existing bare siblings (R4 (no auto migrate)).

## Bootstrap

If `spec_docs/` does not exist:

1. Copy [templates/spec-docs-readme.md](../templates/spec-docs-readme.md) to `spec_docs/README.md` and add empty `spec_docs/archive/.gitkeep`.
2. Ask in chat whether to fill **Project conventions** now. Say the interview covers work items (tracker), verify tiers, complexity hotspots, stack notes, and other commands — one explained question at a time, and any answer may stay a placeholder. Complete this ask (and any opt-in interview) before Investigate, Clarify, or other stage work from the original `/spec` intent.
3. On explicit no, ignore, or a reply that continues the original action with no yes and no convention answers: leave the README unchanged and resume the original intent. Do not search the repo to fill conventions.
4. On explicit yes, or a reply that already answers interview questions: treat as opt-in. Run [fill-conventions.md](fill-conventions.md). Do not invent a second fill path. Then resume the original intent.

## Input

Read the whole input before asking or writing. Free text, every referenced document, or a work-item id. Nothing is stored in an inbox. `<slug>.spec.md` keeps a short **Source** note (where it came from).

For a work-item id, read **Work items** under **Project conventions** in `spec_docs/README.md` (R1 (conventions gate)). If that subsection is still the placeholder, ask how to fetch it. Do not invent a team or project. When conventions name Linear MCP `get_issue`, fetch with that tool only while Linear MCP is usable in this session (R21 (mcp session)). Store title, description, and acceptance criteria only. Map each acceptance criterion to a goal's **Source** line (for example `WI AC2`, or the id scheme this repo uses). A criterion with no goal is a gap: ask, or record a **Q** item. Do not paste the raw work-item payload into `<slug>.spec.md` (R2 (no body rewrite)).

## Investigate

Find what the input means in this repo before shaping the spec.

1. Restate it in project terms: which behaviour, surface, and user moment it changes.
2. In this repo, open the modules, routes, and types that already own that behaviour.
3. Follow real dependencies into related repos, packages, or shared libraries this code already imports. Read only what the input depends on. Do not tour unrelated codebases.
4. Note current behaviour, gaps, and constraints the spec must respect. Cite modules you actually opened.

Record the paths this spec will change in the **Touched paths** table, with the area and the change. Cite modules you opened in **Problem and current behaviour**.

## Analysis

Before writing, work out how the input becomes a review-ready `<slug>.spec.md`. Cover:

- What the input already decides, and what it leaves open.
- How today's code constrains v1: existing flows, APIs, and persistence.
- Scope and non-goals implied by the input and by what the code already does.
- The user journeys: who starts where, the steps from their side, the end state, and what goes wrong.
- Edge cases each goal must handle.
- A coarse work split: ordered slices, the goals each covers, and the main surface of each.
- Decisions that still need a person, versus assumptions safe to record.

Write the analysis in the working turn, specific enough that each section of `<slug>.spec.md` can be filled from the input and the code you opened. If a section cannot, add a **Q** item and point at it with `> **Open:** Q1 (short name)` instead of inventing it. Do not paste the analysis into `<slug>.spec.md` as its own section. Do not invent file-level deliverables.

## Depth round

Run after Analysis and before Clarify. Set `Depth: full | standard | lite` once for the folder (see [SKILL.md](../SKILL.md) › Depth). Do not invent a second skill.

**Skip the ask** when the user already said `as lite`, `as standard`, or `as full` (or clear equivalent). Record that Depth and continue.

Otherwise recommend one Depth and ask once (multiple choice). Heuristics:

- Prefer **lite** when touched paths are local (about ≤2 areas), no new persistence or external contract, ≤2 goals, no high-priority open question expected, no meaningful design fork, and/or the user said small / quick / just do X.
- Prefer **full** when multi-surface, new API or multi-step rules, cross-package, or unclear v1.
- Otherwise **standard**.

User override always wins. Do not write `<slug>.spec.md` until Depth is set (explicit or confirmed).

## Slug

Kebab-case, two to four words, unique under `spec_docs/` (not under `archive/`). If `spec_docs/<slug>/` already exists, resume that folder. Do not create a parallel folder or wipe content without asking. Confirm the slug when it is inferred from a work-item title.

## Clarify before writing

Skip questions already answered in the input or chat. Prefer multiple choice when the options are clear.

Must ask unless already answered: v1 scope, explicit out-of-scope, folder slug, persistence impact (in-memory vs stored vs external API).

Ask if unclear: primary surface, dependencies, whether any tech doc will be needed later, milestone for a real user test.

Default assumptions when the user skips Q&A: v1 is the smallest shippable slice; no new packages without asking; follow patterns already in the touched code.

**When Depth is lite:** take the assumptions path by default. Do not run a multi-turn Clarify loop unless a must-ask answer is truly missing and cannot be assumed safely. Record assumptions as **Open questions** or **Decisions**.

**MUST:**

- Ask only missing clarifying questions after Investigate, Analysis, and Depth round.
- Ask exactly one clarifying question per turn while required answers are still missing (standard / full).
- Do not create `<slug>.spec.md` while required answers are still missing, unless the user takes the assumptions path below (lite defaults to that path).

**MUST NOT:**

- Ask several clarifying questions in one turn.
- Create `<slug>.spec.md` in the same turn as an unanswered must-ask question (unless assumptions path / lite default).

### Assumptions path

If the user says to proceed with assumptions (from Clarify or from Chat design approval), or Depth is lite (default):

1. Record those assumptions as **Open questions** or **Decisions** in `<slug>.spec.md`.
2. Unsettled forks that would change later docs stay **Priority** `high` open questions.
3. Only then may you write the file. Skip any remaining Approach round or sectional approval turns (lite: one whole-packet approval instead — see Chat design approval).

## Approach round

Run after Clarify is complete. Finish this round before Chat design approval. Skip this whole section when the assumptions path already allowed Write, or when Depth is lite and there is no meaningful design fork.

**When there is a real design fork:**

- Propose two or three approaches with trade-offs and a recommendation.
- Wait for the user to pick or adjust before Chat design approval.
- Even for lite: run this round when a real fork exists.

**When there is no meaningful fork:**

- Skip this round. Do not invent fake options.

**MUST NOT:** Write `<slug>.spec.md` during the approach round.

## Chat design approval

**When Depth is lite:** present the whole packet once (scope, goals, folded-tech intent, and that a one-phase plan will be written). One approval covers the design and readiness to write both files. Do not ask section-by-section.

**When Depth is standard or full:** present the design in short chat sections scaled to complexity. Ask for approval after sections, not only after a file exists.

**MUST:**

- Get approval of the design shape in chat before creating `<slug>.spec.md`, unless the assumptions path applies (lite may combine assumptions with the single packet approval).
- Hold the Write step until the user approves, or until the assumptions path has recorded unsettled items.

**MUST NOT:**

- Write `<slug>.spec.md` before chat approval or the assumptions path.
- Open Write in the same turn as an unanswered design-section question (standard / full).

If a section is rejected, revise that section in chat and ask again. Do not create the file until the design shape is approved (or the assumptions path applies).

## Write `<slug>.spec.md`

Only after Chat design approval, or after the assumptions path recorded unsettled items. Create `spec_docs/<slug>/` and write `<slug>.spec.md` from [templates/spec.md](../templates/spec.md), filled to review-ready quality. Set `**Depth:**` to the chosen value. Path is `spec_docs/<slug>/<slug>.spec.md` — never bare `spec.md` (G1 (slug prefix), R3 (new names only)).

- **standard / full:** Set `Progress: design`. Do not write tech siblings or a plan here.
- **lite:** Set doc index rows for logic / contracts / ui to `folded →` **Technical notes** anchors or `not needed`. Fill **Technical notes (folded)** when folding. Never emit `<slug>.logic.md`, `<slug>.contracts.md`, or `<slug>.ui.md`. After the spec file is ready, write the thin plan (below) and set `Progress: plan`.

Follow [writing-style.md](../writing-style.md).

The spec is semi-technical: what changes, why, v1 scope, non-goals, user journeys, edge cases, constraints, touched paths, and a coarse **Work split** (ordered slices, the goals each covers, and the main surface). No file-level deliverables, Done when, or acceptance scenarios in the spec body — those belong to the implementation plan. No component props — those belong in tech docs when Depth is full.

**Depth: full** — Make it elaborate. Iteration happens here; the tech docs translate behaviour already accepted. Every behaviour a reviewer must accept is decided here or is a **Q** item. A thin `<slug>.spec.md` that leaves behaviour to be discovered at promote is a defect. Length is fine; keep it skimmable with the TL;DR bullets, **In short:** lines, and short table cells.

**Depth: standard** — Same binding coverage (goals, journeys, edges, decisions). Prefer shorter prose; omit empty optional sections.

**Depth: lite** — Binding goals, journeys (or n/a), edges, constraints, and touched paths stay. Prefer short sections. Do not pad. Still decide every behaviour a reviewer must accept, or record a **Q** item. Do not leave behaviour to discover at a later promote (there is no separate tech promote).

**User journeys** is required. Cover every user-facing goal in at least one journey. When the feature has no user-facing flow, write one line: n/a, and why.

### UI-primary screen depth

A feature is **UI-primary** when any goal needs a user-visible change, including copy-only.

When the feature is UI-primary, the written `<slug>.spec.md` **MUST** cover:

- Layout regions
- Main interactions
- Empty and error states
- Glance versus control when both exist

Scale how much layout detail you write to the size of the change. Still name empty or error states when they apply.

**MUST NOT:** Put component props or wireframes in `<slug>.spec.md`. Those belong in `<slug>.ui.md` at promote when Depth is full. For lite / standard, fold UI notes under **Technical notes › UI** or mark `not needed`.

Non-UI features keep journeys as `n/a` with a reason, as above.

Replace every `{{…}}` placeholder. Strip every HTML comment. Number goals `G1 (short name)`…. Use `[SUGGESTION: …]` for a concrete draft the user can accept, and remove the marker when they accept it. Record a settled choice under **Decisions**. Record a decision that needs a person under **Open questions**, and point at it from the text with `> **Open:** Q1 (short name)`. A long question list is normal at this gate (especially full). Set **Priority** to `high` when the answer would change the tech specs, the plan, or other goals; leave it `—` otherwise.

**Notes** hold context that needs no action. **Concerns** hold items that need a decision or a change, each with what goes wrong if left.

Omit **Glossary**, **Capabilities**, **Decisions**, **Open questions**, **Notes**, **Concerns**, and **Technical notes** when they would be empty. **Constraints** stays: write `n/a` on a line that does not apply. Nothing in **Non-goals** may be built in this spec.

If the assumptions path was used, ensure every recorded assumption appears as an **Open questions** or **Decisions** item before you finish the file.

When the input was a Linear work-item id and fetch succeeded, set frontmatter `work_item` to that id. Leave `tracker_spec_url`, `document_id`, and `document_url` as `n/a` until Linear returns them. Do not put these ids in the markdown body (optional one-line `Linked: …` is display only).

### Lite: thin plan in the same session

When Depth is lite, after `<slug>.spec.md` is written (doc index folded / `not needed`, Technical notes filled as needed):

1. Read [design-quality.md](../design-quality.md) and follow the phase shape in [plan.md](plan.md) › What to write.
2. Emit a thin `<slug>.plan.md` — typically **one** phase. Prefer Tier **Low** unless a deciding factor clearly raises it. **Read first** points at **Technical notes** anchors (or the spec) as needed.
3. Set `Progress: plan` and mark `<slug>.plan.md` Present? `yes` in the doc index.
4. Run the plan stage's Linear hooks when write-back is allowed: Progress → Tracker Spec, and Tracker Phase create / update / cancel ([plan.md](plan.md) › Update / Tracker Phases). Do not invent a second sync path.

**MUST NOT:** Emit tech sibling files for lite. Embed the plan inside `<slug>.spec.md`.

### Link-back after Work item

After `<slug>.spec.md` is written with frontmatter `work_item` set (not `n/a`), run [linear-sync.md](linear-sync.md) › Link-back when write-back is allowed (G1 (create from linear), R3 (first link back)). Then run [linear-sync.md](linear-sync.md) › Document › Create on first link (G5 (document mirror), D15 (document trigger)).

- **Allowed.** Conventions for write-back are filled and Linear MCP is usable → follow Link-back: `save_comment` with `spec_docs/<slug>/` path text; optional `addLabels` for the design-stage label; `links` only with a real URI; then write `tracker_spec_url` into `<slug>.spec.md` frontmatter after Linear returns it. Then create the Document mirror (TL;DR + goals/AC summary + do-not-edit banner) and write `document_id` / `document_url` into frontmatter after Linear returns them.
- **Not allowed.** MCP or required conventions missing → warn once; skip write-back only (including Document); still keep the `<slug>.spec.md` write (R1 (conventions gate), R21 (mcp session)). Do not invent a team, project, bare-path `links`, or half-link. Do not fail the create solely because Linear could not sync.
- **MUST NOT.** Rewrite the Linear issue description or set it to the full spec (R2 (no body rewrite)). Do not paste full `spec.md` or secrets into the Document (R19 (no secrets)).

For lite, run Link-back after the spec exists; Progress → Tracker Spec for `plan` runs with the thin-plan hooks above.

## Self-review

After writing `<slug>.spec.md` (and the lite plan, when applicable) and before asking for file review, check:

1. Placeholders (`{{…}}`) or leftover HTML author comments.
2. Contradictions between goals, non-goals, journeys, and decisions.
3. Scope leaks into **Non-goals** (or the reverse).
4. Bare ID citations (for example `G1` without `(short name)`).
5. `Depth` is set. For lite: doc index has no `pending` tech rows, no tech sibling files, and `<slug>.plan.md` exists with `Progress: plan`.

Fix cheap failures in the same turn. Call out failures that need a person in the review ask.

## Bounds

Do not create branches, worktrees, or commits unless the user explicitly asks in this conversation.

## Stop

**Depth: lite** — Present the spec and the thin plan. Ask for review. Next offer is implement (not promote-to-tech). Iterate on those two files until they implement or ask to change Depth.

**Depth: standard / full** — Present the spec and ask the user to review it. Iterate on `<slug>.spec.md` alone until they promote. Do not add sibling docs during this loop.
