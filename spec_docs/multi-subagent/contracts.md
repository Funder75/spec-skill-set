# Serial subagent implement — contracts

> Created because: phase brief and env checklist need binding field shapes beyond spec.md.

Types and artifact contracts for **multi-subagent**. [spec.md](./spec.md) owns scope and decisions; cite them in full form (`see D3 (unit of dispatch)`).

This repo has no app data layer (see **Stack notes for spec docs**). Contracts here are markdown artifacts and skill instructions, not TypeScript types.

## TL;DR

- The phase brief is the implementer's only required packet for one dispatch unit.
- Cloud adds an env checklist beside the same brief.
- Progress overview status stays the persisted source of truth.

## Summary of changes

| Layer | Change | Lands in | Persisted? |
| ----- | ------ | -------- | ---------- |
| Skill policy | Implement-only serial subagent exception | `skills/spec/SKILL.md` | yes (repo) |
| Orchestrator | Serial SDD, review, stop/resume | `skills/spec/stages/implement.md` | yes (repo) |
| Phase brief | Binding field list for one unit | `stages/implement.md` (+ template clarity if needed) | no (chat-only; D7 (brief medium)) |
| Env checklist | Cloud-only companion fields | `stages/implement.md` | no (with chat brief) |
| Plan status | Worker write-back unchanged as source of truth | `implementation-plan.md` per spec | yes |

## Existing shapes reused

| Shape | Location | Usage in this feature |
| ----- | -------- | --------------------- |
| Progress overview row | `templates/implementation-plan.md` | Pick next legal unit; one active unit |
| Phase packet | same template | Source material for the brief |
| Status vocabulary | `stages/implement.md` | Started / Reviewing / Done / … |
| Verify tiers | `spec_docs/README.md` › Project conventions | Done-when default checks |
| Ask before list | `stages/implement.md` | Human-gate stops |

## Types and fields

### Phase brief

**Lands in:** `skills/spec/stages/implement.md` › Phase brief — new documented shape (not a typed export)

Self-contained chat-only packet for one dispatch unit. Used as the local subagent prompt and as paste text for cloud (G2 (phase brief), D3 (unit of dispatch), D7 (brief medium)). Not a durable file.

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Spec slug | string | yes | Existing `spec_docs/<slug>/` | Parent from path |
| Phase id(s) | string or list | yes | Progress overview ids in this unit | Plan |
| Unit name | string | yes | — | Plan phase name(s) |
| Goals covered | list of `G…` full forms | yes | Must match phase **Covers** | Plan |
| Read first | list of section links | yes | Tech sections only, not whole docs | Plan |
| Deliverables | list of path + change | yes | Binding paths | Plan |
| Done when | checklist items | yes | Verifiable | Plan |
| Tier | Low / Medium / High | yes | Combinable group = max member | Plan |
| Ask-before | list | yes | May be empty list | Plan + implement Ask before |
| Scoped paths | list of repo paths | yes | Subset of deliverables / Read first | Plan + Touched paths |
| Stop after this unit | boolean / instruction | yes | Must tell worker not to start N+1 | Parent |
| Non-goals for this unit | short list | no | — | Phase **Not in this phase** |

```text
Phase brief (advisory sketch)
- slug, phase id(s), unit name
- goals (full G forms), Read first, deliverables
- Done when, tier, Ask-before, scoped paths
- stop after this unit: yes
```

### Env checklist

**Lands in:** `skills/spec/stages/implement.md` › Phase brief (cloud companion)

Required when the unit runs in cloud (or is pasted for cloud). Accompanies the same phase brief (G7 (cloud ready brief)).

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Verify runnable | yes / no + notes | yes | Tier verify must be possible in env | Parent / human |
| Secrets or MCP expectations | list | yes | May be "none" | Project + phase |
| Repo hooks only | reminder | yes | Cloud cannot assume `~/.cursor` | Parent |
| Status write-back | reminder | yes | Worker MUST edit plan on checkout | G5 (status writeback) |
| Stop after this unit | reminder | yes | Same as brief | Parent |
| Integrate before next | notes | no | Project PR / merge story | Human / conventions |

### Review packet

**Lands in:** `skills/spec/stages/implement.md` › Review gate

What the parent passes the required review subagent after the implementer returns.

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Spec slug + phase id(s) | string | yes | Same unit as brief | Parent |
| Goals and rules in scope | list of full IDs | yes | From phase **Covers** / Read first | Plan + tech docs |
| Deliverables and Done when | list | yes | — | Plan |
| Diff or changed paths | list | yes | Scoped to unit | Worker / git |
| Human gate after pass | reminder | yes | Leave Reviewing for human when still required | G3 (review agent), D9 (done timing) |

## Commands

| Name | Lands in | Validates | Mutates |
| ---- | -------- | --------- | ------- |
| Select next unit | `stages/implement.md` | R2 (one active unit) | Phase status → Started |
| Build phase brief | `stages/implement.md` | R5 (phase brief) | Chat payload only (D7 (brief medium)) |
| Dispatch implementer | `stages/implement.md` | R1, R3 | Worker session; plan via worker |
| Run unit review | `stages/implement.md` | R7 (required review) | Done / fix re-dispatch / Blocked (D8, D9) |
| Halt for human | `stages/implement.md` | R8 (stop resume) | Leave Reviewing or Blocked |
| Resume unit | `stages/implement.md` | R8 | Continue same unit |

### Select next unit

Picks the next legal dispatch unit from the progress overview.

**Payload** (binding):

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| Progress overview | table | yes | One active unit max | Plan |
| Depends on | cell | yes | All Done or Deferred | Plan |
| Combinable with | cell | no | Same unit if combining | Plan |

**Side effects:**

- Sets the chosen unit to `Started` when newly started.
- MUST NOT select a second active unit.

### Build phase brief

Assembles the Phase brief (and Env checklist when cloud) from the phase packet.

**Side effects:**

- Brief becomes the implementer's chat/paste input (no durable file).
- MUST include stop-after-this-unit.

### Dispatch implementer

Starts one fresh implementer (or parent path under R4 (parent path)).

**Side effects:**

- Worker MUST update the plan (R6 (worker writeback)).
- MUST NOT spawn a parallel implementer.

### Run unit review

Runs one review subagent with the Review packet.

**Side effects:**

- Parent MUST NOT mark `Done` until this step passes (R7, D9 (done timing)).
- On fail: bounded implementer fix loop; if budget exhausted, mark `Blocked` with findings in Close-out / Follow-ups (D8 (review fail)).
- On pass + agent-closable: parent marks `Done`. On pass + human still required: leave `Reviewing` and halt.

## External contracts

### Cursor Task / subagent dispatch

- **Kind:** platform API (advisory wiring) · **Lands in:** `stages/implement.md` (instruction text only)
- **Request:** Phase brief (and env checklist when cloud) as the worker prompt; Review packet for the reviewer
- **Response:** Worker finishes scoped work with plan edits; reviewer returns pass or findings
- **Boundary validation:** Parent enforces one implementer at a time and required review before close
- **Errors:** Missing brief fields → do not dispatch; SCM without consent → refuse (R9)

No HTTP routes or storage schemas ship in this feature.

## State ownership and lifecycle

| State | Owner | Load | Refresh | Invalidate | Persisted? |
| ----- | ----- | ---- | ------- | ---------- | ---------- |
| Phase status | Worker → Reviewing; parent → Done / Blocked | Open plan | After unit work / review | Next unit start | yes — plan file |
| Phase brief | Parent (builder) | At dispatch | Per unit | After unit ends | no — chat-only (D7 (brief medium)) |
| Env checklist | Parent | Cloud dispatch | Per cloud unit | After unit ends | no — with chat brief |
| Runner halt reason | Parent | On human gate / Blocked | On resume | When gate clears | yes — status / Blocked reason |

## Persistence changes

### `implementation-plan.md` (per active spec)

**Lands in:** each `spec_docs/<slug>/implementation-plan.md` (no schema migration)

| Column / path | Type | Purpose |
| ------------- | ---- | ------- |
| Progress overview Status | enum | Source of truth for next unit |
| Done when checkboxes | checklist | Worker updates per unit |
| Close-out | prose lines | Worker fills Verified / Deviations / Follow-ups |

No new store. No access-control change. No migration.

## Rollout and compatibility

- Skill markdown only. Reload the local plugin after implement edits (see **Other commands** in `spec_docs/README.md`).
- Existing plans keep working: serial SDD reads the same progress overview and phase packets.
- One-phase / thin plans keep the parent path; brief stays chat/paste only when used (D7 (brief medium)).
