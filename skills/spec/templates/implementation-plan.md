<!-- Author guidance is in HTML comments. Strip every HTML comment when writing the plan. {{…}} is fill-in. Follow writing-style.md in the skill folder. Seed basename implementation-plan.md stays on disk (R6). Emitted filename is {{feature-slug}}.plan.md (G3 (plan extension), R5 (plan body authority)). Phase status lives in this markdown body only — no Cursor YAML todos frontmatter. -->

# {{Feature title}} — implementation plan

Phases for [{{feature-slug}}.spec.md](./{{feature-slug}}.spec.md).

**Status values:** `Not started` · `Started` · `Reviewing` · `Done` · `Deferred` · `Blocked`

## Progress overview

<!-- required. Depends on and Combinable with are the order gate. — means none. Goal text stays in the phase, not here. -->

<!-- Tier: Low / Medium / High from Phase tier in the spec skill's design-quality.md. Rate the hardest factor in this phase, not the feature and not the file count. The label here matches the phase block. -->

| Phase | Status | Name | Tier | Depends on | Combinable with |
| ----- | ---- | ------ | ---- | ---------- | --------------- |
| **1** | Not started | {{name}} | {{Low / Medium / High}} | — | — |
| **2** | Not started | {{name}} | {{…}} | 1 | 3 |
| **3** | Not started | {{name}} | {{…}} | 1 | 2 |

<!-- include when: more than about five phases. One line, for example "6 phases — migration needs a backfill-verify step before enforcing NOT NULL." -->

{{reason}}

<!-- include when: more than four phases. The table above is the source of truth. Solid arrow = required order. Dashed link = combinable siblings. -->

```mermaid
flowchart LR
  P1[1 Foundation] --> P2[2 API]
  P1 --> P3[3 UI]
  P2 -.->|combinable| P3
```

## Prerequisites

<!-- include when: an external prerequisite blocks a phase (deployed endpoint, env var, access, upstream spec). Omit when there are none. -->

- [ ] {{…}}

## Phase {{n}} — {{name}}

<!-- required. Repeat this block for every phase. Same sections each time. Goal, Read first, Deliverables, Done when, Tier, and Ask-before feed the serial-SDD phase brief (no new columns). -->

**Goal:** {{one outcome — what exists when this phase is complete}}

**Covers:** {{G1 (short name), R2 (short name), …}}

**Read first:**

<!-- The tech-doc sections this phase needs, each as a link to its heading. The implementer reads these, {{feature-slug}}.spec.md, and this phase — nothing else from the tech docs. -->

- {{[{{feature-slug}}.contracts.md › TypeName](./{{feature-slug}}.contracts.md#typename)}}

**Tier:** {{Low / Medium / High}} — {{deciding factor, one line}}

**Not in this phase:** {{adjacent work the implementer must leave alone}}

**Deliverables:**

<!-- Binding. extend, new, or remove. new needs a one-line reason. Prefer extend. -->

- `{{path}}` — extend: {{what changes}}
- `{{path}}` — new, because: {{reason — reused by 2+ callers, existing file would be unwieldy, or a real lifecycle boundary}}
- `{{path}}` — remove: {{what, and why}}

**Approach** (advisory):

<!-- include when: the steps are not obvious from the deliverables. The implementer may deviate and records it in Close-out. -->

1. {{step with real source paths}}

### Sub-tasks

<!-- include when: the phase is too large for one implement session. Each sub-task is one session. -->

| Sub-task | Deliverable | Done when | Status |
| -------- | ----------- | --------- | ------ |
| {{n}}a | `{{path}}` | {{about 10 words, verifiable}} | Not started |

### Acceptance scenarios

<!-- required. Binding. Behaviour only. Trace each scenario to the {{feature-slug}}.spec.md journey step it checks, or write "Journey: —" when it checks a rule with no journey step. -->

- **A{{n}}.1 — {{short title}}**
  - Journey: {{journey title}}, step {{n}}
  - Given {{precondition}}
  - When {{action}}
  - Then {{observable result}}

### Done when

<!-- required. Binding. The tier selects the default Verify tiers row. Add a stronger command on its own line when this phase needs one (config, dependency, or generated types that only a full build catches). That does not change the tier. -->

- [ ] Tier verify passes (Project conventions in `spec_docs/README.md`)
- [ ] A{{n}}.1–A{{n}}.x pass
- [ ] {{regression: existing behaviour X unchanged}}

### Close-out

<!-- The implementer fills this at Reviewing or Done. Leave the three lines blank. -->

- Verified:
- Deviations:
- Follow-ups:

## Follow-ups

<!-- include when: a row exists. The implementer logs an out-of-scope finding here instead of fixing it in the current phase. Destination is a later phase, a new spec, or a work item. -->

| Added | Found in phase | Task | Destination |
| ----- | -------------- | ---- | ----------- |
| {{date}} | {{n}} | {{…}} | {{…}} |

## Risks

<!-- include when: the risk changes approach, sequencing, or testing -->

- **{{Risk}}.** Mitigation: {{…}}

## Decisions

<!-- include when: a decision made while planning or implementing is not already in {{feature-slug}}.spec.md. Continue the {{feature-slug}}.spec.md ID sequence. Do not reuse an ID. No index table. -->

### D{{n}} ({{short name}}) — {{decision in one line}}

- **Date:** {{…}} · **Area:** {{…}}
- **Why:** {{…}}
- **Rejected:** {{alternatives, or omit the line}}
