---
work_item: n/a
tracker_spec_url: n/a
document_id: n/a
document_url: n/a
---

# Deterministic validator

**Progress:** implementing
**Depth:** lite
**Depends on:** —

## TL;DR

- **What:** A POSIX script that checks Spec folders for mechanical doc defects
- **Why:** Agents spend tokens on checklist hygiene that a script can settle in milliseconds
- **v1 includes:** `skills/spec/scripts/validate`, the listed checks, stage hooks with manual fallback
- **v1 excludes:** Judgment checks, new runtimes, required CI, OpenSpec parity, auto-fix

## Doc index

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file (`deterministic-validator.spec.md`) | Scope, goals, journeys, constraints, work split | yes |
| deterministic-validator.logic.md | Rules, workflows, state transitions | folded → [Technical notes › Rules](#rules) |
| deterministic-validator.contracts.md | Types, API contracts, state ownership, storage | folded → [Technical notes › Contracts](#contracts) |
| deterministic-validator.ui.md | Layout, interaction, states, copy | not needed |
| [deterministic-validator.plan.md](./deterministic-validator.plan.md) | Phases and phase status | yes |

## Source

> `spec_docs/todos.md` › "Deterministic validator" (lines 52–68). Borrowed flavour from OpenSpec `validate --strict` and Superpowers helper scripts. Chat: Depth lite; packet approved.

## Problem and current behaviour

**In short:** Create-spec self-review, plan readiness, and audit start re-check the same mechanical rules by eye. There is no shared runner.

- **Manual self-review only.** Create-spec lists placeholders, bare IDs, and lite shape checks. Plan and audit restate overlapping rules in prose and the analysis checklist.
- **No script tree.** The skill has no `scripts/` directory. Repo `scripts/update-user-spec-skill.sh` copies the skill but does not validate folders.

| Path | What it does today |
| ---- | ------------------ |
| `skills/spec/stages/create-spec.md` | Manual Self-review after Write |
| `skills/spec/stages/plan.md` | Plan readiness rules in prose; no script call |
| `skills/spec/stages/audit.md` | Checklist-driven audit; no script call |
| `skills/spec/analysis-checklist.md` | Judgment bar including mechanical cues |
| `scripts/update-user-spec-skill.sh` | Copies skill tree to user install |

## Goals and acceptance criteria

### G1 (validate script) — A POSIX script reports the mechanical failures

Source: todos › check list and plain `sh` / POSIX

- Running the script on a `spec_docs/<slug>/` folder reports each of: leftover `{{…}}`, HTML comments, `[SUGGESTION:` markers; bare `G`/`R`/`D`/`Q` citations; duplicate or reused IDs; missing or duplicated `Progress`; overview `Close` that disagrees with the phase line; a scenario Check with no matching Gates row; bare basenames `implementation-plan.md`, `spec.md`, `business-logic.md`, `contracts.md`, `ui.md`, and `data.md` (D4 (basename list)).
- The script needs no new runtime beyond a POSIX shell and usual Unix tools already assumed on the host.
- Exit status is non-zero when any finding exists, and zero when the folder is clean of those checks.

### G2 (stage hooks) — Create-spec, plan, and audit call the script first

Source: todos › self-review and audit call sites

- Create-spec self-review, plan readiness (after Write / before stop), and audit start invoke the script on the folder in scope.
- After a successful run, the agent only handles judgment items the script cannot check.
- If the script is missing or fails to run (not: reports findings), the stage falls back to today's manual self-review / checklist path without blocking the stage.

## Non-goals

- Judgment checks: contradictions, scope leaks, thin-spec quality, implementer test, docs-versus-code
- New language runtimes (Node, Python, etc.) or package installs
- Required CI gate or marketplace publish automation (later)
- Full OpenSpec `validate --strict` surface parity
- Auto-fixing documents when findings appear

## Users and context

- **Primary user:** The Spec agent running create-spec, plan, or audit
- **When:** Immediately after writing or before an audit report
- **Who may do this:** Any agent session with the Spec skill installed; a person may run the script by hand

## User journeys

n/a — agent and CLI tooling; no end-user UI.

## Constraints

- **Preserve:** Manual self-review / checklist path when the script cannot run
- **i18n:** n/a
- **Accessibility:** n/a
- **Security:** Script reads markdown under the given folder only; MUST NOT need network
- **Performance:** A typical folder finishes in well under a second on a laptop

## Proposed solution

Ship one POSIX script beside the skill. Stages resolve it relative to the skill root and pass the active `spec_docs/<slug>/` path. Findings print as short lines a person or agent can skim. A non-zero exit means "fix these"; a launch failure means "fall back to manual."

Judgment stays in the stage prose. The script never claims a folder is "good design."

### Capabilities (v1)

- **Validate folder.** Scan emitted docs in one slug folder for the mechanical rules in G1 (validate script).
- **Stage-first hook.** Create-spec, plan, and audit try the script before manual mechanical review.
- **Graceful fallback.** Missing file, non-executable script, or shell launch error → manual path.

## Touched paths

| Path | Area | Change |
| ---- | ---- | ------ |
| `skills/spec/scripts/validate` | skill tooling | new validate script |
| `skills/spec/stages/create-spec.md` | skill stages | call script in Self-review |
| `skills/spec/stages/plan.md` | skill stages | call script at readiness |
| `skills/spec/stages/audit.md` | skill stages | call script at start |

## Work split

1. **Script and hooks.** Covers G1 (validate script), G2 (stage hooks). Outcome: validate runs on a folder; three stages call it with fallback. Main surface: skill scripts and stages.

## Glossary

- **Fails to run:** Script missing, not executable, or the shell cannot launch it. Distinct from a run that prints findings.
- **Finding:** One mechanical defect the script reports for a path or ID.

## Technical notes (folded)

### Rules

- **R1 (posix only).** The validator MUST be plain `sh` / POSIX with no new runtime dependency.
- **R2 (folder argument).** Invocation MUST take one `spec_docs/<slug>/` directory path (or equivalent absolute path to that folder).
- **R3 (exit codes).** Exit `0` when no mechanical findings. Exit non-zero when one or more findings exist. Launch failure is a shell / missing-file error, not a findings exit — stages treat that as fallback.
- **R4 (fallback).** Create-spec, plan, and audit MUST fall back to today's manual mechanical review when the script fails to run. They MUST NOT treat a findings exit as fallback.
- **R5 (check set).** v1 MUST cover: `{{…}}` placeholders; HTML comments in emitted docs; `[SUGGESTION:`; bare `G`/`R`/`D`/`Q` citations (letter+digits without `(short name)`); duplicate or reused numeric IDs of the same letter; missing or duplicated `Progress` line in `<slug>.spec.md`; progress-overview `Close` disagreeing with the phase `Close` line; every acceptance-scenario `Check` lacking a Gates row; bare basenames `implementation-plan.md`, `spec.md`, `business-logic.md`, `contracts.md`, `ui.md`, and `data.md` (D4 (basename list)).
- **R6 (templates excluded).** The script MUST NOT treat skill `templates/` seed files as the folder under test. It validates the given `spec_docs/<slug>/` only.
- **R7 (no network).** The script MUST NOT require network access.

### Contracts

| Concern | Binding detail |
| ------- | -------------- |
| CLI | `validate <folder>` (name may be `skills/spec/scripts/validate`) |
| stdout/stderr | One finding per line; path and short reason |
| Scope of files | Markdown under the given folder (slug-prefixed role filenames) |
| Persistence | none |

## Decisions

### D1 (cli folder) — CLI takes the slug folder path

- **Date:** 2026-10-27 · **Area:** contracts
- **Why:** Stages always have a folder in scope; one argument stays simple.
- **Rejected:** Multi-file argv; scanning all of `spec_docs/` by default

### D2 (findings vs launch) — Findings exit ≠ fail to run

- **Date:** 2026-10-27 · **Area:** rules
- **Why:** Agents must fix findings, not skip the script when it works.
- **Rejected:** Treating any non-zero exit as fallback

### D3 (human readable) — Findings are human-readable lines

- **Date:** 2026-10-27 · **Area:** contracts
- **Why:** Agents and people both skim the same output; no JSON dependency.
- **Rejected:** Required machine-only JSON output in v1

### D4 (basename list) — Fail every legacy bare role basename

- **Date:** 2026-10-27 · **Area:** rules
- **Why:** Matches the skill stop-and-rename rule for bare names outside the role-map filenames, not only the plan example.
- **Rejected:** A — only `implementation-plan.md` in v1
- **Choice:** Fail when any of these bare basenames appear in the slug folder: `implementation-plan.md`, `spec.md`, `business-logic.md`, `contracts.md`, `ui.md`, `data.md`.

## Concerns

- **Bare `data.md`.** Skill doctrine still allows bare `data.md` as the contracts sibling until a person renames it. D4 (basename list) fails that name anyway — confirm at implement if the skill exception should carve it out.
