---
work_item: n/a
tracker_spec_url: n/a
linear_project: n/a
linear_project_url: n/a
---

<!-- Author guidance is in HTML comments. Strip every HTML comment when writing the epic doc. {{…}} is fill-in. Follow writing-style.md in the skill folder. -->

<!-- Emitted filename is {{epic-slug}}.epic.md. This file replaces {{epic-slug}}.spec.md. Create epic is the only writer. Do not also emit {{epic-slug}}.spec.md, a tech sibling, or {{epic-slug}}.plan.md. Do not emit a Progress line, a Depth line, a file-level Depends on line, a dependency overview table, a doc index, or a standing-rules section. Frontmatter stays n/a unless the input was a work-item id (work_item only) or Linear sync stored a returned id. linear_project is set only when sync created a Linear project; work_item stays n/a in that case. Do not set both to a real id. Do not copy those ids into the body. A task does not get a folder. -->

# {{Epic title}}

<!-- Kind is epic. Do not add Progress, Depth, or Depends on above or below this line. -->
**Kind:** epic

## TL;DR

<!-- required. Exactly these four one-line bullets. No code identifiers. -->

- **What:** {{…}}
- **Why:** {{…}}
- **v1 includes:** {{…}}
- **v1 excludes:** {{…}}

## Source

<!-- required. Where this came from: a short note, a document path, or a work-item title plus description. A work-item id may appear here. Not the raw work-item payload. Acceptance criteria go under the goals, not here. -->

> {{…}}

## Goals and acceptance criteria

<!-- required. Binding. One subsection per outcome. The name in parentheses is 2–4 lowercase words and is used in every citation. Children cite a goal in full form. There is no standing-rules section. Source is a short note, or —. -->

### G1 ({{short name}}) — {{goal in one line}}

Source: {{…}}

- {{observable outcome}}

## Non-goals

<!-- required. Binding. Concrete deferrals. Nothing listed here may be built as a child unless it is also a suggested spec. -->

- {{…}}

## Suggested specs

<!-- required. One section only. When there are no specs, the body is the single word none and there is no ### heading. Do not drop this section, and do not write a capitalised None. When specs exist, replace none with one ### section per spec, using the shape in the comment below. Do not emit a dependency table. Number from S1 upward and never reuse a number. The parenthetical name is 2–4 lowercase words. Slug is kebab-case, unique, and different from the epic slug. Depends on is the single character — when the spec can start alone, or a comma-and-space list of other suggested specs in full form (S1 (short name)) and task names from ## Tasks. It does not name a phase, a slug, or this spec's own id. No status, tier, or verify line. The four bullets plus Outcomes are the seed a later create spec for copies into the child. Add prose when that create would otherwise need another scope interview. -->

none

<!-- Section shape when specs exist. Strip this comment. Do not emit a section when the body is none.

### S1 ({{short name}}) — {{one line}}

**Slug:** {{child-slug}}
**Depends on:** —

- **What:** {{…}}
- **Why:** {{…}}
- **v1 includes:** {{…}}
- **v1 excludes:** {{…}}

{{Further prose the child spec needs. As long as that promote requires. No code and no plan.}}

**Outcomes:**

- {{observable outcome that becomes a child goal}}
-->

## Tasks

<!-- required. When there are no tasks, the body is the single word none and there is no ### heading. Do not drop this section. A task is not a suggested spec, has no slug, and has no folder. The heading is the short name: spaces are allowed, a comma is not, and it must not equal a suggested-spec slug. Depends on uses the same form as a suggested spec. -->

none

<!-- Section shape when tasks exist. Strip this comment.

### {{short name}}

{{what the task covers}}

**Depends on:** —
-->
