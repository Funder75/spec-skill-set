# Create implementation plan

Write `spec_docs/<slug>/implementation-plan.md` from the reviewed spec and tech docs. This is the execution contract: phases, the **Depends on** and **Combinable with** columns, Done when, acceptance scenarios, and the only phase status.

## Preconditions

- The user asked to promote to an implementation plan, or confirmed that step after `/spec next`.
- `Progress` is `tech`. If it is still `design`, ask whether to write tech specs first. Do not skip that gate.
- `spec.md` has no `{{…}}` left and no `[SUGGESTION:`. If a suggestion is still there, the user has not accepted it — stop and ask.
- Read [design-quality.md](../design-quality.md) before drafting. Do not read it on other actions.

## What to write

Follow [writing-style.md](../writing-style.md). Start from [templates/implementation-plan.md](../templates/implementation-plan.md). Phases may refine the spec's **Work split**. Point at it by goal ID in **Covers**. Do not copy its rationale into the plan.

Each phase uses the same block:

| Section | Content |
| ------- | ------- |
| **Goal** | One outcome |
| **Covers** | Goal and rule IDs this phase satisfies, in full form |
| **Read first** | Links to the tech-doc sections this phase needs. The implementer reads only these |
| **Not in this phase** | Adjacent work the implementer must leave alone |
| **Deliverables** | Concrete files: `extend`, `new`, or `remove`. `new` needs a one-line reason. Prefer `extend` |
| **Approach** (advisory) | Ordered steps with real source paths, plus guiding code, do/do-not examples, and code-design notes when shape would otherwise be ambiguous. Omit when deliverables alone are enough |
| **Acceptance scenarios** | `A<phase>.<n>` list items, Given / When / Then, each traced to a journey step. Behaviour only |
| **Tier** | Label plus a one-line reason naming the deciding factor. See [Phase tier](../design-quality.md#phase-tier) |
| **Done when** | The tier's default verify first, plus any stronger command this phase needs, then the scenario IDs, then phase-specific regressions |
| **Close-out** | Leave blank. The implementer fills it |
| **Sub-tasks** | Optional. Each sized for one implement session, with a Status cell |

Rules:

- As few phases as safely possible. Split only when a phase would span unrelated surfaces, cannot pass verify midway, or is honestly easier to review in two passes. More than about five phases needs a one-line reason under the progress overview. Detail: [design-quality.md](../design-quality.md).
- Phase size stays outcome-based. Do not default to 2–5 minute micro-steps.
- Set each phase's **Tier** with [Phase tier](../design-quality.md#phase-tier). Rate this phase, not the feature, and not by file count. The label in the progress overview matches the phase block. Read **Complexity hotspots** in `spec_docs/README.md` when that subsection exists and is filled in. If it is missing or still a placeholder, use the generic rubric and do not ask.
- The tier selects the default commands in **Verify tiers**. If that subsection is still the placeholder, ask. Do not invent a build pipeline. A phase that needs a stronger check names that command in **Done when** and keeps its tier.
- Phases start at **Not started**.
- **Depends on** and **Combinable with** in the progress overview are the order gate. `—` means none. A Mermaid graph is optional, and only when there are more than four phases; the table stays the source of truth.
- **Read first** links each tech-doc section or **Technical notes** anchor the phase needs, not whole docs. Do not restate them.
- Each acceptance scenario names the `spec.md` journey step it checks, or `Journey: —` for a rule with no journey step. A journey step no scenario checks is a gap.
- Replace every `{{…}}` placeholder. Strip every HTML comment.
- Omit empty **Prerequisites**, **Follow-ups**, **Risks**, and **Decisions**. A plan decision continues the `spec.md` ID sequence and does not repeat a decision already recorded there. Open questions stay in `spec.md`.
- Risks only when they change approach, sequencing, or testing.

### Approach contract

**Approach** stays advisory. **Done when** and acceptance scenarios stay the binding check.

**MUST:**

- Cite real source paths and order when Approach is present.
- When shape would otherwise be ambiguous, include guiding code (short signatures, sketches, or snippets), do/do-not examples, and code-design notes so an implementer has little room to invent a different shape.
- Keep guiding code short: show shape, not a drop-in file.

**MUST NOT:**

- Ship pasteable full implementation blocks meant to be copied into the repo without further design.
- Require TDD unless **Project conventions** say so.
- Default phases to 2–5 minute micro-steps.

### Bounds

Do not create branches, worktrees, or commits unless the user explicitly asks in this conversation.

## Ready to implement

Walk the checklist in [design-quality.md](../design-quality.md). Fix gaps, or add a **Q** item in `spec.md` and point at it with `> **Open:** Q1 (short name)`. A question may remain only if its **Blocks** line does not include phase 1.

## Update spec.md

Do not rewrite the spec. Set `Progress: plan` and add the plan to the doc index.

## Stop

Tell the user the folder path, the first phase, its tier and the reason, its Done when, remaining open questions, and that implementation is `/spec` implement on this folder — one phase per session unless the plan marks phases combinable.
