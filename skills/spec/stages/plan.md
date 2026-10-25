# Create implementation plan

Write `spec_docs/<slug>/<slug>.plan.md` from the reviewed spec and tech docs (G3 (plan extension), R1 (filename pattern), R3 (new names only)). This is the execution contract: phases, the **Depends on** and **Combinable with** columns, Done when, acceptance scenarios, and the only phase status. Phase status, Done when, Close-out, tier, Ask-before, and acceptance scenarios live in the markdown body only — do not add Cursor YAML `todos` or other Plan Mode frontmatter (R5 (plan body authority)). Do not rename existing bare siblings (R4 (no auto migrate)).

## Preconditions

- The user asked to promote to an implementation plan, or confirmed that step after `/spec next`.
- Read `Depth` from `<slug>.spec.md` (missing → treat as `full`).
- **Depth: lite** — Create already wrote the thin plan. If `<slug>.plan.md` exists, resume or edit it only; do not regenerate from scratch without asking. If it is missing (interrupted create), write the thin 1-phase plan now, ensure tech rows are folded / `not needed`, and set `Progress: plan`.
- **Depth: standard** — `Progress` should be `tech` with doc index rows folded or `not needed` (no pressure for siblings). If still `design`, run a fold-tech step first in this session (set index + **Technical notes** as needed, `Progress: tech`), then write the plan — do not leave tech as `pending`. Prefer few phases.
- **Depth: full** (or missing) — `Progress` is `tech`. If it is still `design`, ask whether to write tech specs first. Do not skip that gate.
- `<slug>.spec.md` has no `{{…}}` left and no `[SUGGESTION:`. If a suggestion is still there, the user has not accepted it — stop and ask.
- Read [design-quality.md](../design-quality.md) before drafting. Do not read it on other actions.

## What to write

Follow [writing-style.md](../writing-style.md). Start from the seed [templates/implementation-plan.md](../templates/implementation-plan.md) (R6 (template seeds stay)); emit as `<slug>.plan.md`. Phases may refine the spec's **Work split**. Point at it by goal ID in **Covers**. Do not copy its rationale into the plan. When Depth is lite or standard, keep the plan thin (lite: typically one phase).

Each phase uses the same block:

| Section | Content |
| ------- | ------- |
| **Goal** | One outcome |
| **Covers** | Goal and rule IDs this phase satisfies, in full form |
| **Tracker phase** | `<id> \| n/a` — default `n/a`; shared across a combinable unit |
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
- Set each phase's **Tier** with [Phase tier](../design-quality.md#phase-tier). Rate this phase, not the feature, and not by file count. The label in the progress overview matches the phase block. Read **Complexity hotspots** in `spec_docs/README.md` when that subsection has filled bullets. If it is missing, empty, or still a placeholder, use the generic rubric and do not ask.
- The tier selects the default commands in **Verify tiers**. If that subsection is still the placeholder, ask. Do not invent a build pipeline. A phase that needs a stronger check names that command in **Done when** and keeps its tier.
- Phases start at **Not started**.
- **Depends on** and **Combinable with** in the progress overview are the order gate. `—` means none. A Mermaid graph is optional, and only when there are more than four phases; the table stays the source of truth.
- **Read first** links each tech-doc section or **Technical notes** anchor the phase needs, not whole docs. Do not restate them.
- Each acceptance scenario names the `<slug>.spec.md` journey step it checks, or `Journey: —` for a rule with no journey step. A journey step no scenario checks is a gap.
- Replace every `{{…}}` placeholder. Strip every HTML comment.
- Omit empty **Prerequisites**, **Follow-ups**, **Risks**, and **Decisions**. A plan decision continues the `<slug>.spec.md` ID sequence and does not repeat a decision already recorded there. Open questions stay in `<slug>.spec.md`.
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
- Add Cursor YAML `todos` (or other Plan Mode frontmatter) as a second status store (R5 (plan body authority)).

### Bounds

Do not create branches, worktrees, or commits unless the user explicitly asks in this conversation.

## Ready to implement

Walk the checklist in [design-quality.md](../design-quality.md). Fix gaps, or add a **Q** item in `<slug>.spec.md` and point at it with `> **Open:** Q1 (short name)`. A question may remain only if its **Blocks** line does not include phase 1.

## Update `<slug>.spec.md`

Do not rewrite the spec. Set `Progress: plan` and add `<slug>.plan.md` to the doc index.

When `Progress` changes to `plan` (this promote) or any later gate change lands from this stage’s path, run [linear-sync.md](linear-sync.md) › Status (selective) › Progress → Tracker Spec when write-back is allowed (G3 (status mirror), R11 (status mirror), R12 (selective tracker writes)). Update **only** the Tracker Spec by its stored frontmatter `work_item` id. On a real Progress delta, append a progress-log comment; no-op → none (R13 (progress log)). MUST NOT run full explicit sync for a routine gate change. `work_item: n/a` (or missing) → skip (R22 (reference gate)). MCP / map missing → warn once; skip write-back (R1 (conventions gate), R21 (mcp session)). Linear MUST NOT drive Progress (G7 (repo canonical)).

## Tracker Phases after plan write or edit

After the plan file is written or a dispatch-unit change lands (phase added, removed, renumbered, renamed, or combinable grouping changed), run [linear-sync.md](linear-sync.md) › Tracker Phase create / update / cancel when write-back is allowed (G2 (tracker phases), R4 (freeze before plan)).

**Plan file.** This stage emits `<slug>.plan.md`. Treat “plan exists” as that file **or** bare `implementation-plan.md` already in the folder (R4 (no auto migrate)). Do not auto-rename. Without either file, Tracker Phase work is a no-op (R5 (thin noop)) — this hook only runs after a plan write, so that case does not apply here.

**Every phase packet** MUST include `Tracker phase: <id> | n/a` (template default `n/a`). Combinable phases in one dispatch unit share one value (R6 (repo-stored phase identity)).

### When write-back is allowed

Frontmatter `work_item` is a real id (not `n/a`), Work items conventions for create are filled, and Linear MCP is usable:

1. Build dispatch units from the progress overview (one phase, or one combinable group).
2. For each unit whose phases still say `Tracker phase: n/a` → create one Tracker Phase (`parentId` = Tracker Spec id) and write the returned id onto every phase in that unit.
3. For each unit that already has a stored id → update that id in place when body source fields changed. Preserve the id through renames and renumbering; never title-search (R8 (direct and selective update)).
4. When a unit with a stored id is removed → cancel + reason comment, then remove the repo field (R9 (cancel removed)). Leave unreferenced Linear work alone (R7 (unreferenced leave)).

### When write-back is not allowed

- **`work_item: n/a` (or missing).** Skip all Tracker Phase writes on this routine hook. Do not call Linear discovery (R22 (reference gate)). Explicit `/spec linear sync` remains available for create/repair ([linear-sync.md](linear-sync.md) › Explicit sync).
- **MCP or conventions missing.** Warn once; skip write-back; keep the plan file as written (R1 (conventions gate), R21 (mcp session)).

Do not create Tracker Phases before the plan exists. Do not invent a skill Cloud Agent launcher or auto-assign Cursor (R16 (human gated launch)). Routine plan hooks stay selective — they MUST NOT run full explicit sync (R8 (direct and selective update), R12 (selective tracker writes)).

## Stop

Tell the user the folder path, the first phase, its tier and the reason, its Done when, remaining open questions, and that implementation is `/spec` implement on this folder — one phase per session unless the plan marks phases combinable.
