# Defer human gates — contracts

> Created because: plan status vocabulary, pre-flight fields, Depends marker, and Tracker Phase map change beyond what defer-human-gates.spec.md already states

Types, document contracts, state ownership, and storage for **defer-human-gates**. [defer-human-gates.spec.md](./defer-human-gates.spec.md) owns scope and decisions; cite them in full form (`see D3 (depends marker)`).

Stack notes in `spec_docs/README.md` stay placeholders. This feature changes skill markdown and the validate script only. No UI library, API client, or app database applies.

## TL;DR

- Plan phase status gains `Awaiting sign-off`; Depends on gains an optional needs-sign-off mark.
- Pre-flight items and answers live in a top-level Pre-flight section (see D5 (pre-flight home)).
- Linear's Tracker Phase map and archive gate consume the new status.

## Summary of changes

| Layer | Change | Lands in | Persisted? |
| ----- | ------ | -------- | ---------- |
| Phase status set | Add `Awaiting sign-off` | plan template, implement, validate, READMEs | yes (plan body) |
| Depends on cell | Optional needs-sign-off mark | plan template, design-quality, validate | yes (plan body) |
| Pre-flight list | Items + answers on the plan | plan template, plan stage, validate | yes (plan body) |
| Tracker Phase map | New status key; archive treats as open | linear-sync status, Project conventions | yes (Linear state) |

## Existing types reused

| Type | Location | Usage in this feature |
| ---- | -------- | --------------------- |
| Phase status cell | `<slug>.plan.md` progress overview | Extend allowed values |
| Depends on cell | progress overview | Extend with optional mark |
| Ask-before line | phase packet | Source of predictable pre-flight items |
| Close | overview + phase | Unchanged words; drives awaiting transition |
| Tracker phase id | phase packet `Tracker phase:` | Status mirror target unchanged |

## Types and fields

### Phase status

**Lands in:** `skills/spec/templates/implementation-plan.md` › Status values — extend

Allowed values after this feature:

| Value | Meaning |
| ----- | ------- |
| `Not started` | No work yet |
| `Started` | In progress |
| `Reviewing` | Worker finished; agent review pending |
| `Awaiting sign-off` | Review passed; Close `human`; person not yet accepted |
| `Done` | Accepted finish |
| `Deferred` | Remaining work deliberately dropped |
| `Blocked` | Stuck after fix budget or person Ask-before |

Binding: `Awaiting sign-off` spelling matches D2 (status name). Docs that list status values MUST include it (`spec_docs/README.md`, template seed, skill README if present).

### Pre-flight item

**Lands in:** `skills/spec/templates/implementation-plan.md` — top-level Pre-flight section before the progress overview (see D5 (pre-flight home))

One recorded person input answered before phase 1.

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Label | short prose | yes | Names the ask | plan stage |
| Kind | enum-like tag | no | Examples: dependency, command, secret name, branch, cloud | plan stage |
| Answer | short prose | yes before phase 1 | Secret **name** only, never the value | person |
| Asked from | phase id or `global` | no | Ties to Ask-before or implement global stop | plan stage |

```text
# Shape sketch (advisory). Section placement is D5 (pre-flight home).

## Pre-flight

| Item | Kind | Answer | Asked from |
| ---- | ---- | ------ | ---------- |
| Add package X | dependency | yes | 2 |
| Secret name for API | secret name | MY_API_TOKEN | 3 |
```

### Needs-sign-off mark

**Lands in:** progress overview **Depends on** cell — suffix on the phase id (see D4 (marker syntax)), for example `1 (needs sign-off)`

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Target phase id | phase number | yes | Must name an existing phase | plan author |
| Needs sign-off | boolean mark | no | Absent → awaiting satisfies Depends on; present as ` (needs sign-off)` suffix | plan author / design-quality defaults |

Binding meaning is D3 (depends marker). Spelling is D4 (marker syntax).

### Tracker Phase status map key

**Lands in:** Project conventions **Tracker Phase status → state map** (when Linear is used) · `skills/spec/stages/linear-sync/status.md`

| Map key | Required | Notes |
| ------- | -------- | ----- |
| `Awaiting sign-off` | yes when map exists | Mirrors plan status; archive treats as open |

Folders with `work_item: n/a` skip Linear write-back; the map key still ships in docs and status.md prose.

## Commands

| Name | Lands in | Validates | Mutates |
| ---- | -------- | --------- | ------- |
| Pre-flight collect | `skills/spec/stages/plan.md` | R1 (pre-flight collect) | Plan pre-flight fields |
| Skip recorded Ask-before | `skills/spec/stages/implement.md` | R2 (no re-ask) | — |
| Move to awaiting | `skills/spec/stages/implement.md` › Review gate | R3 (awaiting after review) | Phase status |
| Batch accept / reject | `skills/spec/stages/implement.md` › Stop and resume | R8 (batched sign-off), R9 (cascade reopen) | Phase status, Close-out |
| Validate plan shape | `skills/spec/scripts/validate` | D6 (validator checks) | — (report only) |

### Validate plan shape

Mechanical checks for this feature. Binding set is D6 (validator checks).

**Payload:**

| Check | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Unknown status | report | yes | Status not in the allowed set (includes `Awaiting sign-off`) | progress overview |
| Malformed marker | report | yes | Token is not a bare phase id and not `<id> (needs sign-off)` (D4 (marker syntax)) | Depends on cell |
| Missing Pre-flight section | report | yes when any Close is `human` | Top-level Pre-flight section absent (D5 (pre-flight home)) | plan body |
| Marker on unknown id | report | yes | Depends on target is not a phase in the overview | Depends on cell |
| Needs-sign-off on automated Close | report | yes | Marked target has Close `automated` | Depends on + Close |
| Empty Pre-flight shape | report | yes when at least one predictable Ask-before was collectable | Pre-flight section has no item rows / answer fields | Pre-flight section |
| Unanswered pre-flight | report | yes when any phase is past `Not started` | Pre-flight item has a blank Answer | Pre-flight section |

**Side effects:**

- Emit findings only. Do not rewrite the plan.

## External contracts

### Plan body (phase status authority)

- **Kind:** storage · **Lands in:** `spec_docs/<slug>/<slug>.plan.md`
- **Request:** Status, Depends on, Close, Ask-before, and pre-flight fields written in markdown
- **Response:** Implement and validate read the body only (skill plan-body authority — phase status lives in the markdown body)
- **Boundary validation:** `skills/spec/scripts/validate` after plan write; implement Phase selection guards at run time
- **Errors:** Unknown status or unsatisfied Depends on → stop and name the defect; do not invent status

### Tracker Phase status mirror

- **Kind:** API · **Lands in:** `skills/spec/stages/linear-sync/status.md` › Phase status → Tracker Phase
- **Request:** Plan status including `Awaiting sign-off` when the unit has a stored Tracker phase id
- **Response:** Linear state via conventions map
- **Boundary validation:** Skip when `Tracker phase: n/a` or `work_item: n/a`
- **Errors:** Map missing → warn once; skip write-back

### Archive gate

- **Kind:** API / gate · **Lands in:** `linear-sync/status.md` › Archive gate · `implement.md` › Archive
- **Request:** Every referenced Tracker Phase Done or Deferred; every plan phase Done or Deferred
- **Response:** Allow Tracker Spec Done / folder move only when no `Awaiting sign-off` remains
- **Boundary validation:** Treat `Awaiting sign-off` as open
- **Errors:** Ask before completing Tracker Spec if any phase still open

## State ownership and lifecycle

| State | Owner | Load | Refresh | Invalidate | Persisted? |
| ----- | ----- | ---- | ------- | ---------- | ---------- |
| Phase status | `<slug>.plan.md` progress overview | Implement / continue | On each unit transition | — | yes |
| Pre-flight answers | plan pre-flight fields | Plan stage / implement start | When person answers | — | yes |
| Needs-sign-off marks | Depends on cells | Plan authoring | Plan edit | — | yes |
| Tracker Phase Linear state | Linear issue via stored id | Status mirror hook | On plan status delta | Cancel removed unit | yes (Linear) |
| Progress gate | `<slug>.spec.md` | Stage detection | Promote / implement / archive | — | yes |

## Persistence changes

### Plan markdown

**Lands in:** `skills/spec/templates/implementation-plan.md` and emitted `<slug>.plan.md`

| Column / path | Type | Purpose |
| ------------- | ---- | ------- |
| Status values line | prose list | Include `Awaiting sign-off` |
| Depends on cell | phase id + optional mark | Order gate + sign-off wait |
| Pre-flight section or rows | field table | Items and answers before phase 1 |

### Access control

- Anyone who can edit the plan and answer Ask-before / sign-off may change these fields.
- Secret **values** MUST NOT be persisted (R11 (secret names only) in logic).

### Migration

1. New plans use the extended template.
2. Existing plans in other repos are out of scope (spec non-goal).
3. No automated rewrite of foreign plans.

## Rollout and compatibility

- Skill docs and validate ship together so authors and the runner agree on status and marks.
- Marker spelling, pre-flight home, and validator breadth are settled: D4 (marker syntax), D5 (pre-flight home), D6 (validator checks).
