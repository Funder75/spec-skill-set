# Spec docs

Planning documents for this repo. One folder per feature spec. The spec workflow skill reads **Project conventions** below when it needs a project fact. It does not use the rest of this file as its process.

| Path | Role |
| ---- | ---- |
| `<slug>/` | Active spec. Start at `<slug>.spec.md` |
| `<slug>/<slug>.spec.md` | Scope, gates, and the coarse work split. The `Progress` line is the gate |
| `<slug>/<slug>.logic.md` | Rules, workflows, state transitions (when needed) |
| `<slug>/<slug>.contracts.md` | Types, API contracts, state ownership, storage (when needed) |
| `<slug>/<slug>.ui.md` | Layout, interaction, states, copy (when needed) |
| `<slug>/<slug>.plan.md` | Phases and the only phase status. Added after technical specs are reviewed |
| `<slug>/<slug>.data.md` | Legacy data doc (same as contracts) after a hand rename of bare `data.md` |
| `archive/<slug>/` | Finished specs |

## How to use

Work moves through three reviewed documents, then implementation (R7 (skill surface complete)):

1. **Spec design** — `<slug>.spec.md` only (`Progress: design`). Iterate here.
2. **Technical specs** — `<slug>.logic.md`, `<slug>.contracts.md`, and `<slug>.ui.md` when that concern needs its own file. Older folders may still have bare `data.md` until a person renames; after rename it is `<slug>.data.md` (same doc as contracts). Otherwise the notes stay in `<slug>.spec.md` under **Technical notes** (`Progress: tech`).
3. **Implementation plan** — `<slug>.plan.md`: phases, Done when, and phase status (`Progress: plan`).
4. **Implement** one phase at a time (`Progress: implementing`). When the work is done, move the folder to `archive/` (`Progress: archived`).

`Progress` in `<slug>.spec.md` is the gate: `design`, `tech`, `plan`, `implementing`, or `archived`. Phase status (`Not started` through `Done`, plus `Deferred` and `Blocked`) lives only in `<slug>.plan.md`.

Invoke the user-level **spec** skill (`/spec`) and say what to do. Examples: create a spec from a note or a work item, promote to tech specs, promote to an implementation plan, implement the next phase, archive.

Do not edit the skill to record progress.

## Reading these docs

| Marker | Meaning |
| ------ | ------- |
| `[SUGGESTION: …]` | A draft. It is not accepted until the marker is removed |
| `> **Open:** Q1 (name)` | Points at an open question in that spec's `<slug>.spec.md` |
| `(advisory)` | A hint. The implementer may deviate, and records the deviation in the phase **Close-out** |

Binding, and what a review checks against: goals, rules, deliverables, acceptance scenarios, Done when, and field tables. Approach, sketches, and diagrams are advisory.

IDs carry a short name, for example `G1 (writing style)`:

- **G** — goal and its acceptance criteria, in `<slug>.spec.md`.
- **R** — rule, in `<slug>.logic.md` or in **Technical notes**.
- **D** — decision, in `<slug>.spec.md`.
- **Q** — open question, in `<slug>.spec.md`. **Blocks** names what cannot proceed.
- **A2.1** — acceptance scenario 1 of phase 2. No name.
- **C1 / W1 / O1** — critical, warning, and optimization findings in an audit report. No name.

To find every citation of an ID, search for the ID and the opening parenthesis, for example `G1 (`. A plain `G1` search also hits `G10`.

Phase status: `Not started`, `Started`, `Reviewing`, `Done`, `Deferred`, `Blocked`.

**Tier** rates how hard a phase is to implement (Low / Medium / High) so the implementer can choose effort. It also selects the default verify row under **Project conventions**.

## Project conventions

<!--
The skill reads this section when it needs a project fact. If a subsection is still {{…}}, the skill asks.
-->

### Work items

Schema the skill reads for Linear (fill at init-project or by hand). Keep the title, description, and acceptance criteria on fetch. Map each acceptance criterion into a goal's Source line, for example `WI AC2`.

- **Linear project:** {{id | n/a}}
- **Team:** {{name or id}}
- **Fetch:** {{use Linear MCP `get_issue` by id or URL}}
- **Tracker Spec Progress → state/label map:** {{design → …; tech → …; plan → …; implementing → …; archived → …}}
- **Tracker Phase status → state map:** {{Not started → …; Started → …; Reviewing → …; Done → …; Deferred → …; Blocked → …}}
- **Optional design-stage label:** {{label name/id, or omit}}
- **Optional default `[repo=…]`:** {{owner/name the cloud agent should use, or omit}}

### Verify tiers

| Tier | Verify |
| ---- | ------ |
| Low | {{command}} |
| Medium | {{command}} |
| High | {{command}} |

{{Where to run the commands, and any setup they assume.}}

### Complexity hotspots

<!-- include when: this repo has areas the generic tier rubric cannot rate. Omit the subsection when there are none. The planner reads this when setting a phase tier. A missing or placeholder subsection is not a question. -->

- {{area — why a phase that touches it is harder}}

### Stack notes for spec docs

The skill reads this when filling `<slug>.contracts.md` and `<slug>.ui.md`.

- **UI library:** {{component library, and where to look up props}}
- **Data access:** {{how this repo calls APIs or storage}}
- **Validation:** {{how untrusted data is checked at the boundary}}
- **Errors:** {{the type used for expected failures}}
- **i18n:** {{where user-facing copy lives, or "none"}}

### Other commands

| Task | Command | Notes |
| ---- | ------- | ----- |
| {{dev server}} | {{…}} | {{…}} |
