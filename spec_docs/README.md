# Spec docs

Planning documents for this repo. One folder per feature spec. The spec workflow skill reads **Project conventions** below when it needs a project fact. It does not use the rest of this file as its process.

| Path | Role |
| ---- | ---- |
| `<slug>/` | Active spec. Start at `<slug>.spec.md` |
| `<slug>/<slug>.spec.md` | Scope, gates, and the coarse work split. The body `Progress` line is the gate; Linear FKs (`work_item`, URLs, Document ids) live in YAML frontmatter |
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

Invoke the user-level **spec** skill (`/spec`) and say what to do. Examples: create a spec from a note or a work item, promote to tech specs, promote to an implementation plan, implement the next phase, archive, sync with Linear.

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

### Work items

Ticket system for this repo is Linear. On fetch, keep title, description, and acceptance criteria. Map each acceptance criterion into a goal's Source line (for example `WI AC2`).

- **Linear project:** The Spec skill set (`P-OAK-5`)
- **Team:** Oakhillgames (`OAK`)
- **Fetch:** use Linear MCP `get_issue` by id or URL
- **Tracker Spec Progress → state/label map:** design → Todo; tech → Todo; plan → In Progress; implementing → In Progress; archived → Done
- **Tracker Phase status → state map:** Not started → Todo; Started → In Progress; Reviewing → In Review; Done → Done; Deferred → Canceled; Blocked → Blocked
- **Optional default `[repo=…]`:** Funder75/spec-skill-set

### Verify tiers

| Tier | Verify |
| ---- | ------ |
| Low | n/a |
| Medium | n/a |
| High | n/a |

n/a

### Complexity hotspots

### Stack notes for spec docs

The skill reads this when filling `<slug>.contracts.md` and `<slug>.ui.md`.

- **UI library:** n/a
- **Data access:** n/a
- **Validation:** n/a
- **Errors:** n/a
- **i18n:** n/a

### Other commands

| Task | Command | Notes |
| ---- | ------- | ----- |
| {{dev server}} | {{…}} | {{…}} |
