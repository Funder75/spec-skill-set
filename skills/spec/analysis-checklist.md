# Analysis checklist

Judgment bar for an audit. Read only when running [stages/audit.md](stages/audit.md).

Do not copy this file into `spec_docs/<slug>/`.

---

## Missing — docs

| Check | Flag when |
| ----- | --------- |
| **Implementer test** | Phase 1 cannot be executed from the plan and its links alone |
| **Progress line** | `<slug>.spec.md` body has no `Progress` line, or the line disagrees with the files (plan exists while `Progress` is `design`; folder is archived while `Progress` is not). Do not require Linear FKs in the body — those live in YAML frontmatter |
| **Required docs** | No `<slug>.spec.md`. No `<slug>.plan.md` once `Progress` is `plan` or later (R9 (helper doc cites)) |
| **Skipped gate** | An implementation plan exists while tech specs were never promoted (`Progress` jumped from `design` to `plan`) |
| **Business rules home** | Multi-step rules are scattered, and `<slug>.logic.md` is missing with no `folded →` line pointing at **Technical notes › Rules** |
| **Optional doc gap** | `<slug>.contracts.md` (or legacy `<slug>.data.md` / bare `data.md` until renamed) or `<slug>.ui.md` is omitted, the doc index does not say `folded` or `not needed`, and the only detail is a plan snippet |
| **Failure modes** | User-facing flows lack empty, error, or permission handling, and there is no explicit n/a |
| **Journeys** | `<slug>.spec.md` has no **User journeys** section and no n/a line, or a user-facing goal appears in no journey |
| **Thin spec** | `<slug>.spec.md` leaves behaviour to be discovered at promote: missing edge cases, journeys, or decisions a reviewer must accept |
| **Landing sites** | A tech-doc rule, type, or screen state names no file it is expected to change |
| **Journey trace** | An acceptance scenario names no journey step and no `Journey: —`, or `<slug>.ui.md` skips a screen-touching journey step |
| **Acceptance scenarios** | A phase has no `A<phase>.<n>` Given / When / Then |
| **Done when gaps** | A phase has deliverables and no testable Done when |
| **Traceability** | A goal ID is in no phase **Covers** line, or **Covers** names an ID the spec does not define |
| **Open vs blocker** | A **Q** item **Blocks** the active phase, or `> **Open:**` points at a question that does |
| **Placeholders** | `{{…}}` or an unaccepted `[SUGGESTION:` left in docs the folder treats as ready |

---

## Missing — implementation

| Check | Flag when |
| ----- | --------- |
| **Deliverable ghost** | The plan cites a file that does not exist and the phase is `Done` |
| **Undocumented surface** | A shipped route, command, table, or screen has no mention in the spec |
| **Phase partial** | A `Done` phase has unchecked Done-when items, or the behaviour is not observable |
| **Dependency** | The spec depends on another slug's outcome that is not in the code |
| **Close-out** | A `Done` or `Reviewing` phase has no **Close-out** record of what was verified |

---

## Conflicts — internal

| Check | Flag when |
| ----- | --------- |
| **Scope** | Goals contradict non-goals, or a phase delivers a non-goal |
| **Rules** | `<slug>.logic.md` disagrees with `<slug>.contracts.md` |
| **Persistence** | Schema in `<slug>.contracts.md` disagrees with the types in the same file |
| **Tech doc decides** | A tech doc settles a behaviour `<slug>.spec.md` does not decide, instead of pointing at a **Q** item |
| **UI vs rules** | `<slug>.ui.md` shows a flow the rules forbid |
| **Plan vs siblings** | Deliverables contradict `<slug>.spec.md` or a resolved decision |
| **Spec drift** | `<slug>.spec.md` scope, non-goals, or glossary no longer match a sibling |
| **Work split vs phases** | The plan restates the work-split rationale instead of pointing at it by goal ID, or a phase **Covers** a goal the spec does not list and does not say why |
| **Glossary** | The same term means different things across files |
| **Resolved vs Open** | A **D** item and a **Q** item contradict, or two **D** items contradict |
| **Phase order** | A later phase assumes something an earlier phase deferred, and **Depends on** does not say so |

---

## Conflicts — external

| Check | Flag when |
| ----- | --------- |
| **Sibling spec** | Two active specs claim the same v1 surface |
| **Depends-on** | This spec assumes an outcome the other spec's non-goals exclude |
| **Project conventions** | The plan's verify steps contradict **Project conventions** in `spec_docs/README.md` |
| **Archive** | An active folder repeats an archived spec and does not say it replaces it |
| **Touched paths** | The spec changes a service or package that **Touched paths** does not list |

---

## Docs versus code

| Check | Flag when |
| ----- | --------- |
| **Paths** | A deliverable path is wrong or renamed and the plan was not updated |
| **Commands** | Names, payloads, or validation differ from `<slug>.contracts.md` or the business rules |
| **Schema** | Migrations differ from `<slug>.contracts.md` |
| **UI** | Components, routes, or copy differ from `<slug>.ui.md` with no note in the plan |
| **Behaviour** | Edge handling differs from the `<slug>.logic.md` table |
| **Status lag** | The code finishes phase N and the plan still says `Not started` or `Started` |

**Critical** when behaviour breaks a rule. **Warning** when the docs are stale. **Optimization** when the docs should catch up to a deliberate improvement.

---

## Bloat

| Check | Flag when |
| ----- | --------- |
| **Unjustified new file** | A file exists in code with no `new` deliverable and no one-line reason |
| **Duplicate logic** | A command, helper, or component re-implements something already nearby |
| **Undocumented growth** | Files in the change that the plan never mentions |
| **Over-styled markup** | Markup the project's own styling rules would flag, when the phase touched UI |
| **Thin doc** | `<slug>.contracts.md`, `<slug>.ui.md`, or `<slug>.logic.md` only repeats `<slug>.spec.md` or is a couple of filled rows — fold it back |
| **Doc restatement** | A sibling re-explains something another doc owns |

---

## Readability

Follow [writing-style.md](writing-style.md). Length alone is not a finding.

| Check | Flag when |
| ----- | --------- |
| **Long table cell** | A table cell holds more than one sentence |
| **Bare ID** | A goal, rule, decision, or question is cited without its short name, for example `G3` instead of `G3 (room order)` |
| **Hard to skim** | A TL;DR is not the required bullets or holds code names; a section over ~15 lines has no **In short:** line |
| **Shorthand** | An abbreviation is never spelled out, or the text uses invented shorthand or arrow chains |
| **Notes vs concerns** | A note needs action, or a concern does not say what goes wrong if left |

---

## Optimizations

| Check | Consider |
| ----- | -------- |
| **Phase sizing** | More than about five phases with no reason, or a phase that spans unrelated surfaces. See [design-quality.md](design-quality.md) |
| **Phase tier** | A tier with no reason, a reason the deliverables do not support, an overview label that differs from the phase block, or a clear mis-rating. See [Phase tier](design-quality.md#phase-tier) |
| **Phase merge** | Adjacent phases that always ship together and have no separate verify |
| **Duplication** | The same deliverable in more than one phase or doc |
| **Scope creep** | A phase builds something the non-goals exclude |
| **Vague deliverables** | "Add a service" with no path |
| **Stale risk** | A risk already handled by an earlier phase |
| **Deferred work** | A `Deferred` phase with no note of what was dropped |

Optimizations are not blockers unless they hide a Critical or Warning issue.

---

## Evidence

| Vague | Specific |
| ----- | -------- |
| Docs are inconsistent | `<slug>.logic.md` says RESTRICT when children exist; `<slug>.contracts.md` shows `ON DELETE CASCADE` |
| Code doesn't match | The list command filters inactive rows; the visibility table says admins still see them, and the code has no admin branch |
| File bloat | Phase 2 lists one file; the change also adds a single-use helper that is not in the plan |

---

## Reviewer habits

1. Read `Progress` first. That decides how deep to go. Do not open `spec_docs/archive/` unless asked.
2. Write the report in chat. Do not create a canvas or a report file.
3. Build a traceability table when a plan exists.
4. Cite a file and a section. Distinguish draft (`[SUGGESTION: …]`), decided (a **D** item), and blocked (a **Q** item, or `> **Open:** Q1 (short name)` pointing at one).
5. Describe each finding in plain words. A check name from this file is not the explanation.
6. End with one next step.
