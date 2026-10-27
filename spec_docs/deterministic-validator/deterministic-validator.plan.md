# Deterministic validator — implementation plan

Phases for [deterministic-validator.spec.md](./deterministic-validator.spec.md).

**Status values:** `Not started` · `Started` · `Reviewing` · `Done` · `Deferred` · `Blocked`

## Progress overview

| Phase | Status | Name | Tier | Close | Depends on | Combinable with |
| ----- | ---- | ------ | ---- | ----- | ---------- | --------------- |
| **1** | Not started | Script and stage hooks | Low | automated | — | — |

## Phase 1 — Script and stage hooks

**Tracker phase:** n/a

**Goal:** A POSIX validate script reports the mechanical checks on a slug folder, and create-spec, plan, and audit call it with manual fallback when it fails to run.

**Covers:** G1 (validate script), G2 (stage hooks), R1 (posix only), R2 (folder argument), R3 (exit codes), R4 (fallback), R5 (check set), R6 (templates excluded), R7 (no network), D1 (cli folder), D2 (findings vs launch), D3 (human readable), D4 (basename list)

**Read first:**

- [deterministic-validator.spec.md › Rules](./deterministic-validator.spec.md#rules)
- [deterministic-validator.spec.md › Contracts](./deterministic-validator.spec.md#contracts)
- [deterministic-validator.spec.md › D1 (cli folder)](./deterministic-validator.spec.md#d1-cli-folder)
- [deterministic-validator.spec.md › D2 (findings vs launch)](./deterministic-validator.spec.md#d2-findings-vs-launch)
- [deterministic-validator.spec.md › D4 (basename list)](./deterministic-validator.spec.md#d4-basename-list)

**Tier:** Low — rules and call sites are decided; mistakes show when the script or stage text is wrong

**Close:** automated

**Ask-before:** —

**Not in this phase:** CI wiring, auto-fix, judgment checklist rewrite, OpenSpec parity

**Deliverables:**

- `skills/spec/scripts/validate` — new, because: no scripts tree exists under the skill; reused by create-spec, plan, and audit
- `skills/spec/stages/create-spec.md` — extend: Self-review runs the script first; fallback to today's manual list when it fails to run
- `skills/spec/stages/plan.md` — extend: after plan Write / before Stop, run the script; same fallback
- `skills/spec/stages/audit.md` — extend: at workflow start after resolving the folder, run the script; same fallback; continue with judgment checklist

**Approach** (advisory):

1. Add `skills/spec/scripts/validate` as POSIX `sh`. Take one folder argument. Print one finding per line. Exit non-zero on findings (R1–R3, R5–R7).
2. Cover each R5 (check set) item with simple text scans. For Close mismatch and Gates↔Check, parse the plan markdown lightly; prefer clear false-negative avoidance over clever parsers.
3. Basename findings cover the D4 (basename list) set (`implementation-plan.md`, `spec.md`, `business-logic.md`, `contracts.md`, `ui.md`, `data.md`).
4. In create-spec, plan, and audit, resolve the script next to the skill root, run it on `spec_docs/<slug>/`, then keep only judgment self-review / checklist steps when the run succeeds (R4 (fallback), D2 (findings vs launch)).

Do:

- Keep findings human-readable (D3 (human readable)).
- Document the invoke path so a person can run the script by hand.

Do not:

- Add Node/Python or package managers.
- Treat a findings exit as fallback.
- Scan skill `templates/` as if they were a slug folder.

### Acceptance scenarios

- **A1.1 — Clean folder exits zero**
  - Journey: —
  - Check: automated
  - Given a slug folder with no R5 (check set) defects
  - When `skills/spec/scripts/validate` runs on that folder
  - Then exit status is 0 and there are no finding lines

- **A1.2 — Defects exit non-zero with lines**
  - Journey: —
  - Check: automated
  - Given a folder that still has a `{{…}}` placeholder or a bare goal citation without `(short name)`
  - When the script runs on that folder
  - Then exit status is non-zero and stdout/stderr names the path and reason

- **A1.3 — Stages document call and fallback**
  - Journey: —
  - Check: automated
  - Given the three stage files after this phase
  - When the implementer greps for the validate path and fallback wording
  - Then create-spec, plan, and audit each instruct: run the script first; on fail-to-run only, use the manual path; on findings, fix or report (do not skip)

### Done when

- [ ] Verify tiers Low is n/a (no command in Project conventions); Close-out notes n/a
- [ ] A1.1–A1.3 pass
- [ ] Script runs with `/bin/sh` (or equivalent POSIX) with no extra packages
- [ ] Basename check covers D4 (basename list)

### Gates

| Check | Owner | Evidence |
| ----- | ----- | -------- |
| Verify (n/a) | automated | Close-out notes n/a |
| A1.1 | automated | Script exit 0 on a clean folder (fixture or this folder once clean) |
| A1.2 | automated | Script non-zero + finding lines on a deliberate defect sample |
| A1.3 | automated | Stage files contain invoke path and fail-to-run fallback wording |
| No new runtime | automated | Script shebang / body uses only POSIX shell + usual host tools |

### Close-out

- Verified:
- Deviations:
- Follow-ups:
