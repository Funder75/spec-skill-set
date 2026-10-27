---
work_item: {{id, or "n/a"}}
tracker_spec_url: n/a
document_id: n/a
document_url: n/a
---

<!-- Author guidance is in HTML comments. Strip every HTML comment when writing the spec doc. {{…}} is fill-in. Follow writing-style.md in the skill folder. -->

<!-- This doc is written and reviewed before any tech doc. It is elaborate: goals, journeys, edge cases, constraints, and the decisions a reviewer must accept. Tech docs translate it. Code sketches, per-field type tables, and component props belong in the tech docs, not here. A long {{feature-slug}}.spec.md is fine; a hard-to-skim one is not. Emitted filename is {{feature-slug}}.spec.md (R1 (filename pattern)). -->

# {{Feature title}}

**Progress:** design
<!-- Depth: full | standard | lite. Chosen at create after Analysis. Missing on older folders → treat as full. lite folds tech and writes a thin plan in the same create session. -->
**Depth:** {{full | standard | lite}}
**Depends on:** {{`spec_docs/<slug>`, a named external deliverable, or "—"}}

## TL;DR

<!-- required. Exactly these four one-line bullets. No code identifiers. A reader who stops here must not misjudge the scope. -->

- **What:** {{…}}
- **Why:** {{…}}
- **v1 includes:** {{…}}
- **v1 excludes:** {{…}}

## Doc index

<!-- required. Present? is one of: yes · folded → [Technical notes › Rules](#rules) · not needed · pending. Link the doc name only when Present? is yes. -->

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file (`{{feature-slug}}.spec.md`) | Scope, goals, journeys, constraints, work split | yes |
| {{feature-slug}}.logic.md | Rules, workflows, state transitions | pending |
| {{feature-slug}}.contracts.md | Types, API contracts, state ownership, storage | pending |
| {{feature-slug}}.ui.md | Layout, interaction, states, copy | pending |
| {{feature-slug}}.plan.md | Phases and phase status | pending |

## Source

<!-- required. Where this came from: a short note, a document path, or a work-item title plus description. Not the raw work-item payload. Acceptance criteria go under the goals, not here. -->

> {{…}}

## Problem and current behaviour

<!-- required. What pain exists today, the current behaviour, and the surfaces it affects. Open with an In short line when the section runs over about 15 lines. Bold lead-ins on bullets. -->

**In short:** {{…}}

- **{{Lead-in}}.** {{…}}

<!-- include when: modules were opened while investigating. Cite only files actually opened. -->

| Path | What it does today |
| ---- | ------------------ |
| `{{path}}` | {{about 10 words}} |

## Goals and acceptance criteria

<!-- required. Binding. One subsection per outcome. The name in parentheses is 2–4 lowercase words and is used in every citation. Source is the work-item acceptance criterion (for example WI AC2), or —. -->

### G1 ({{short name}}) — {{goal in one line}}

Source: {{…}}

- {{observable acceptance criterion}}

## Non-goals

<!-- required. Binding. Concrete deferrals. Nothing listed here may be built in this spec. Mark a later item with "(later)". Cite the decision behind a deferral in full form. -->

- {{…}}

## Users and context

<!-- required -->

- **Primary user:** {{persona}}
- **When:** {{workflow moment}}
- **Who may do this:** {{roles or permissions}}

## User journeys

<!-- required. One subsection per journey. Steps are from the user's side, with no code names. A feature with no user-facing flow replaces this section with one line: "n/a — {{why}}". -->

<!-- UI-primary (any goal needs a user-visible change, including copy-only): also cover screen depth in journeys or an adjacent short subsection — layout regions, main interactions, empty and error states, and glance versus control when both exist. Do not put component props or wireframes here; those belong in {{feature-slug}}.ui.md at promote. Scale layout detail to the change; still name empty or error states when they apply. -->

### {{Journey title}}

Starting point: {{who, and what they want}}.

1. {{step}}
2. {{step}}
3. {{step}}

End state: {{…}}

Goes wrong when:

- {{failure, and the goal that prevents or handles it}}

Covers: {{G1 (short name), …}}

<!-- include when: UI-primary. Optional short block next to journeys; omit for non-UI features. -->

### Screen depth (UI-primary)

- **Layout regions:** {{…}}
- **Main interactions:** {{…}}
- **Empty / error:** {{…}}
- **Glance vs control:** {{… or "n/a — only one surface"}}

## Constraints

<!-- required for standard/full: one line each; write n/a when it does not apply.
     Depth lite (R6 (lite constraints)): list only lines that apply — no n/a padding rows. Drop the section only when no line applies. -->

- **Preserve:** {{behaviour that must survive, or n/a}}
- **i18n:** {{… or n/a}}
- **Accessibility:** {{… or n/a}}
- **Security:** {{auth, iframe, data exposure — or n/a}}
- **Performance:** {{… or n/a}}

## Notes

<!-- include when: context a later reader needs. Depth lite (R5 (lite omit empty)): omit this section when empty — do not invent filler. -->

- **{{Lead-in}}.** {{…}}

## Concerns

<!-- include when: something needs a decision or a change. Each item says what would go wrong if it is left, and cites the goal, decision, or question it touches. Depth lite: omit when empty. -->

- **{{Lead-in}}.** {{the problem}}. If left: {{consequence}}.

## Proposed solution

<!-- required. A few short paragraphs. Semi-technical. Not file-level steps. -->

{{…}}

### Capabilities (v1)

<!-- include when: the solution has named capabilities the goals do not already state. Depth lite: omit when empty. -->

- **{{name}}.** {{…}}

## Touched paths

<!-- required. Repo-relative paths this spec changes. A listed path may be read. One row may be "this repo only". -->

| Path | Area | Change |
| ---- | ---- | ------ |
| {{path}} | {{UI / domain / contracts}} | {{about 10 words}} |

## Work split

<!-- required. Ordered slices for review. The implementation plan turns these into phases. Do not list files, Done when, or acceptance scenarios. -->

1. **{{Slice name}}.** Covers {{G1 (short name)}}. Outcome: {{what exists when this slice is done}}. Main surface: {{area — not a file list}}.

## Glossary

<!-- include when: a term is ambiguous, or its code name differs from the spec name. Depth lite (R5 (lite omit empty)): omit when empty. -->

- **{{Term}}:** {{definition}}. In code: {{type or identifier, or omit}}.

## Technical notes (folded)

<!-- include when: a tech doc was folded at promote-to-tech, or lite folded notes at create. One subsection per folded concern. Delete the subsections that were not folded. Omit the whole section when empty (lite R5). Name the file each item lands in, as the tech-doc templates do. -->

### Rules

<!-- Binding. Use MUST, MUST NOT, SHOULD. -->

- **R1 ({{short name}}).** {{…}}

### Contracts

<!-- Field tables are binding. Sketches are advisory. -->

{{…}}

### UI

{{…}}

## Decisions

<!-- include when: a choice is settled. Binding. One subsection per decision. No index table. Depth lite: omit when empty. -->

### D1 ({{short name}}) — {{decision in one line}}

- **Date:** {{…}} · **Area:** {{…}}
- **Why:** {{…}}
- **Rejected:** {{alternatives, or omit the line}}

## Open questions

<!-- include when: a decision needs a person. A long list at design is normal (especially full). Depth lite: omit when empty — still record unsettled assumptions as Q or D when they exist. Priority is high when the answer would change later specs, the plan, or other goals; otherwise —. Blocks names the phase or gate that cannot proceed, or —. -->

### Q1 ({{short name}}) — {{question in one line}}

- **Priority:** {{high / —}} · **Blocks:** {{phase 1, a gate, or —}} · **Owner:** {{…}}
- **Options:**
  - **A.** {{…}}
  - **B.** {{…}}
