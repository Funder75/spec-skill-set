# Spec docs

Planning documents for this repo. One folder per feature spec. The spec workflow skill reads **Project conventions** below when it needs a project fact. It does not use the rest of this file as its process.

| Path | Role |
| ---- | ---- |
| `<slug>/` | Active spec. Start at `<slug>.spec.md` |
| `<slug>/<slug>.spec.md` | Scope, gates, and the coarse work split (or bugfix behaviour lists). Body lines: `Progress` (gate), `Depth` (full / standard / lite), and `Kind` (feature / bugfix; missing → feature). Linear FKs (`work_item`, URLs, Document ids) live in YAML frontmatter |
| `<slug>/<slug>.logic.md` | Rules, workflows, state transitions (when needed) |
| `<slug>/<slug>.contracts.md` | Types, API contracts, state ownership, storage (when needed) |
| `<slug>/<slug>.ui.md` | Layout, interaction, states, copy (when needed) |
| `<slug>/<slug>.plan.md` | Phases and the only phase status. Always emitted; for lite, written in the same create session as a thin 1-phase plan |
| `<slug>/<slug>.data.md` | Legacy data doc (same as contracts) after a hand rename of bare `data.md` |
| `archive/<slug>/` | Finished specs |

## How to use

`Depth` in `<slug>.spec.md` chooses how many documents and review gates you walk:

| Depth | Path |
| ----- | ---- |
| **lite** | One approval → `<slug>.spec.md` with tech folded or `not needed` + thin `<slug>.plan.md` (`Progress: plan`). Then implement. Say `create … as lite` to skip the Depth ask. |
| **standard** | Design → fold tech / `not needed` (`Progress: tech`) → thin plan → implement. |
| **full** | Design → tech siblings when needed → plan → implement (default for older folders with no Depth line). |

`Kind` in `<slug>.spec.md` is `feature` (default) or `bugfix`. Say `create … as bugfix` (alone or with a Depth) to set Kind without a recommend ask. Lite is recommended for many bugs, not required. Bugfix design uses behaviour lists and Root cause instead of User journeys and Work split. Older folders without Kind are treated as feature.

Full path:

1. **Spec design** — `<slug>.spec.md` only (`Progress: design`). Iterate here.
2. **Technical specs** — `<slug>.logic.md`, `<slug>.contracts.md`, and `<slug>.ui.md` when that concern needs its own file. Older folders may still have bare `data.md` until a person renames; after rename it is `<slug>.data.md` (same doc as contracts). Otherwise the notes stay in `<slug>.spec.md` under **Technical notes** (`Progress: tech`).
3. **Implementation plan** — `<slug>.plan.md`: phases, Done when, phase status, and **Close** (`automated` or `human`) (`Progress: plan`).
4. **Implement** one phase at a time (`Progress: implementing`). When the work is done, move the folder to `archive/` (`Progress: archived`).

`Progress` in `<slug>.spec.md` is the gate: `design`, `tech`, `plan`, `implementing`, or `archived`. Phase status (`Not started` through `Done`, plus `Deferred` and `Blocked`) lives only in `<slug>.plan.md`.

Invoke the **spec** skill with `/spec`. Examples: create a spec from a note or a work item (optionally `as lite`, `as bugfix`, or both), `/spec next`, promote to tech specs, promote to an implementation plan, implement the next phase, audit or review a spec, archive, sync with Linear.

Do not edit the skill to record progress.

## Reading these docs

| Marker | Meaning |
| ------ | ------- |
| `[SUGGESTION: …]` | A draft. It is not accepted until the marker is removed |
| `> **Open:** Q1 (name)` | Points at an open question in that spec's `<slug>.spec.md` |
| `(advisory)` | A hint. The implementer may deviate, and records the deviation in the phase **Close-out** |

Binding, and what a review checks against: goals, rules, deliverables, acceptance scenarios, Done when, Close, Gates, and field tables. Approach, sketches, and diagrams are advisory.

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

**Close** on each plan phase is `automated` or `human`. The same word is in the progress overview. `automated` means verify and the agent review can mark the phase Done. `human` means a person continues after that review. **Gates** names who runs each check.

## Project conventions

<!--
The skill reads this section when it needs a project fact. If a subsection is still {{…}}, the skill asks.
-->

### Work items

<!--
Bootstrap asks None vs Linear. To fill or update this section later, run `/spec fill conventions`.
None → replace this subsection with short prose: no work-item system; specs from chat / free text.
Linear → keep the fields below (names are stable for linear-sync). On fetch, keep title,
description, and acceptance criteria; map each criterion to a goal Source line (e.g. WI AC2).
Hand-fill either shape the same way.
-->

{{None: no work-item system prose | Linear: fill the fields below}}

- **Linear project:** {{id | n/a}}
- **Team:** {{name or id}}
- **Fetch:** {{use Linear MCP `get_issue` by id or URL}}
- **Tracker Spec Progress → state/label map:** {{design → …; tech → …; plan → …; implementing → …; archived → …}}
- **Tracker Phase status → state map:** {{Not started → …; Started → …; Reviewing → …; Done → …; Deferred → …; Blocked → …; Removed → …}}
- **Optional design-stage label:** {{label name/id, or omit}}
- **Optional default `[repo=…]`:** {{owner/name the cloud agent should use, or omit}}

### Verify tiers

<!--
A row is a real command, the placeholder {{command}}, or the explicit value `none`.
`none` is not the same as a placeholder: it means this repo has no command for that tier
(for example a docs-only or config-only tier). A phase whose tier row is `none` must either
set Close to human, or its Gates row must name review-observable evidence instead of a
command (see plan.md's Gates owner rule). Leaving the placeholder unresolved still means
"ask" — only `none` means "no command by design."
-->

| Tier | Verify |
| ---- | ------ |
| Low | {{command \| none}} |
| Medium | {{command \| none}} |
| High | {{command \| none}} |

{{Where to run the commands, and any setup they assume.}}

### Complexity hotspots

<!--
Areas the generic tier rubric cannot rate. Always keep this subsection. Empty list = none yet
(easy to extend later). The planner reads filled bullets when setting a phase tier; an empty
or still-placeholder list is not a question — use the generic rubric.
-->

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
