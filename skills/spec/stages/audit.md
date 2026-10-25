# Audit

Read-only. Report in chat. Do not edit spec docs or code unless the user explicitly asks to fix findings. Do not write a report file or a canvas.

Read [analysis-checklist.md](../analysis-checklist.md) for pass/fail cues. Read [design-quality.md](../design-quality.md) only when the user asked for a pre-implement check.

## When

The user asked to audit or review a named spec. Do not run this as part of `/spec next`.

Optional scope, when the user gives it: docs only, implementation only, one phase, pre-implement, or bloat. Default is docs plus implementation.

## Workflow

1. Resolve `spec_docs/<slug>/` from the title or slug. Do not open `spec_docs/archive/` unless they asked for an archived audit. If the slug is unclear, ask.
2. Read the `Progress` and `Depth` lines (missing Depth → treat as `full`), then `<slug>.spec.md`, then D1 siblings that exist (`<slug>.logic.md`, `<slug>.contracts.md`, `<slug>.ui.md`, `<slug>.plan.md`, and `<slug>.data.md` when present — see [SKILL.md](../SKILL.md) › Spec docs), then the plan's progress overview and the phases in scope (R3 (new names only)). Do not dual-read bare basenames or prompt to migrate (R4 (no auto migrate)).
3. Map cited paths to code. Grep for the slug, domain nouns, and command names. Do not run a full code review.
4. Apply the checklist dimensions. Skip a dimension only when it does not apply, and say why. Required-doc checks use the D1 names (R1 (filename pattern)). Interpret **Skipped gate** and **Optional doc gap** against Depth ([analysis-checklist.md](../analysis-checklist.md)).
5. Merge findings that share a root cause into one finding that lists every place it shows up.
6. Write the report below, following [writing-style.md](../writing-style.md). Include every important finding. There is no cap.

## Report

```markdown
# Spec audit: <slug>

**Progress:** <design | tech | plan | implementing | archived> · **Depth:** <full | standard | lite | missing→full> · **Scope:** <full | docs-only | …>

## Executive summary
- **Verdict:** <safe to continue, or not, and to which step>
- **Top risk:** <one line, citing the finding ID>
- **Counts:** <n> critical · <n> warning · <n> optimization

## Findings

### Critical

#### C1 — <plain-words title of the problem>
- **What's wrong:** <the problem in plain words; not a checklist label>
- **Why it matters:** <what would go wrong if it is ignored>
- **Where:** `path` › <section> — "<short quote>"
- **Suggested actions:**
  - <action>
  - <another action, when more than one fix would work>

### Warning

#### W1 — …

### Optimization

#### O1 — …

### Clean passes
- <what was checked and held>

## Traceability
| Goal | Phase | Acceptance scenarios | Implementation | Status |
| ---- | ----- | -------------------- | -------------- | ------ |
| G1 (short name) | | A1.1 | | |

## Recommended next step
1. …
```

Number findings `C1`, `W1`, `O1` per severity. They take no parenthetical name. Cite spec IDs in full form (`G1 (short name)`). When a finding is a choice for the user, the suggested actions are the options.

| Level | Use when |
| ----- | -------- |
| **Critical** | The next gate or the current phase would do the wrong thing; specs contradict; code breaks a stated rule |
| **Warning** | A gap that will mislead the next session; drift in finished work; an **Open** item that blocks the active phase |
| **Optimization** | Clearer phasing, less duplication, a thin doc that should fold back |

End with one next step: fix docs, fix code, a product decision, or continue with implement. If the findings are fixable here, ask before editing.
