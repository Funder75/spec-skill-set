# Design quality

Judgment bar for an implementation plan. Read only while writing or revising `<slug>.plan.md` (R9 (helper doc cites)). The short checklist also lives in [stages/plan.md](stages/plan.md).

Do not copy this file into `spec_docs/<slug>/`. Spec folders use the templates.

---

## Ready to implement

Before handing the folder to an implement session:

| Check | Pass when |
| ----- | --------- |
| **Implementer test** | Someone who was not in the chat can run phase 1 using only the plan, the linked sections, and the cited paths |
| **Decisions closed or Open** | Every architecture, persistence, or UX fork is a **D** or a **Q** item with **Blocks** set |
| **Traceability** | Each goal is in a **Covers** line; phases list their rules, scenarios, and Done when |
| **Named IDs** | Every `G`, `R`, `D`, `Q` citation uses the full form, such as `G1 (short name)` |
| **Journey trace** | Each acceptance scenario names its journey step, or `Journey: —` |
| **Read first** | Each phase links the tech-doc sections it needs, not whole docs |
| **Failure modes** | Empty, error, and permission (or an explicit "n/a") where the work touches users or stored data |
| **Phase sizing** | As few phases as safely possible; verify for the phase tier passes at the end; split only for a real reason — see [Phase sizing](#phase-sizing) |
| **Tier** | Each phase has a tier and a reason naming its deciding factor. The tier is rated for that phase alone, and the overview label matches the phase block — see [Phase tier](#phase-tier) |
| **Non-goals are real** | Out-of-scope names concrete deferrals |
| **Concrete paths** | Deliverables name real modules discovered while exploring |
| **New files justified** | Every proposed new doc or module has a one-line reason. Default is extend |
| **Risks are selective** | Risks only list items that change approach, sequencing, or testing |
| **Spec and siblings agree** | No scope, glossary, or non-goal drift between `<slug>.spec.md` and the other docs |

A **Q** item may remain only if its **Blocks** line does not include phase 1.

Multi-phase serial implement expects a brief-sized phase packet (linked **Read first** plus **Done when**) so the orchestrator can build the chat-only phase brief without the full plan.

---

## Phase sizing

**Default: as few phases as safely possible.** A phase is one reviewable outcome. Extra phases cost a full session of loading the plan, the linked docs, and the source.

**Split a phase only when one of these is true:**

- It would span unrelated surfaces.
- It cannot reach a passing verify partway through.
- It is honestly easier to review in two passes, for a stated reason.

**Do not split a phase just because:**

- The suggested approach has several tightly coupled steps.
- It feels tidier to use one phase per file or per layer when those layers always ship together.

A typical spec lands in **2–5 phases**. More than that needs a one-line reason in the progress overview. No reason is a finding for an audit.

Name true siblings in **Combinable with** so a later implement session can combine them. **Depends on** is the order gate. Add a Mermaid graph only when there are more than four phases; the progress table stays the source of truth.

Deferrals belong in **Non-goals**. There is no stretch list.

---

## Phase tier

**Tier** rates how hard this phase is to implement correctly, assuming every phase in its **Depends on** cell is already `Done`. It exists so the implementer, person or agent, can choose effort: which model to use, how hard to reason, how much to read, and how carefully to check.

It rates complexity, not size. File count and line count do not set the tier. It rates this phase, not the feature. A late phase of a hard feature can be Low.

The tier selects the default row in **Verify tiers**. A phase that needs a stronger check names that command in **Done when** and keeps its tier. Config, dependency, or generated-type changes that only a full `build` catches are the usual case.

### Levels

- **Low.** The implementer applies a change that is already decided. The deliverables and tech docs say what to write. Mistakes show up in lint or typecheck. Size does not matter: a rename across 40 files can be Low.
- **Medium.** The implementer makes local design choices within a known pattern. That includes composing existing pieces, wiring a new view, route, or composable, and handling the listed empty, error, and permission states. Mistakes show up in typecheck or when running the feature locally.
- **High.** The implementer has to reason about behaviour that cannot be seen in one place: ordering, lifecycle, contracts other code relies on, security, or stored data. Mistakes can pass lint and typecheck, then surface only at runtime, on another surface, or for another user.

### Factors that raise complexity

- A new or changed contract that other code relies on: an exported SDK symbol, a cross-service or iframe message, an event payload, route params or query, or a shared composable signature.
- A persisted or shared state shape, such as `localStorage` keys or cached data, especially when existing stored values must keep working.
- Async ordering and lifecycle: races, cancellation, subscriptions and cleanup, router guards, handshakes, and retries.
- Auth, permissions, tenancy, or secrets.
- Many interacting rules or edge cases, such as several **R** rows with exceptions or a state machine.
- A wide blast radius: changed behaviour in code many callers use, or removing legacy code whose callers are hard to find.
- No pattern to follow: the first instance of something in this repo, or an unfamiliar or poorly documented third-party API.
- Weak feedback: the result can only be verified manually, inside an embedding host, or at build time.
- The phase deliberately leaves real choices to the implementer.

### Factors that lower complexity

- A nearby example the phase can copy, because it is the second instance of an existing pattern.
- Mechanical or repetitive edits.
- A fully specified change, where field tables, copy, and rules are already in the tech docs.
- Strong feedback: typecheck catches most mistakes, and the behaviour is visible when the page runs.
- Additive and isolated work, such as a new view nobody else imports, that is easy to revert.

### How to apply

- Start from the strongest factor that raises complexity. Drop one level only when a lowering factor clearly covers that same factor.
- Write a one-line reason naming the deciding factor, for example `High — overlay cleanup order across router navigation`.
- A combinable group takes the highest tier among its members. A sub-task takes its phase's tier.
- Tier is not a reason to split. Use [Phase sizing](#phase-sizing). A phase that is High because it bundles an unrelated hard part already meets the unrelated-surfaces split rule.
- Read **Complexity hotspots** in `spec_docs/README.md` when that subsection has filled bullets. It names project areas the generic factors cannot see. An empty list means none yet — use the generic rubric.

---

## Bad vs good

### Done when

| Bad | Good |
| --- | ---- |
| Improved booking UX | User can create a desk booking from the chat composer; conflict shows inline error copy X |
| Types updated | `Booking` includes `resourceId`; `createBooking` rejects a missing resource with validation error Y |
| Works on mobile | Primary flow usable at 390px width; no horizontal scroll on the booking sheet |

### Non-goals

| Bad | Good |
| --- | ---- |
| Stretch / polish later | Recurring bookings; admin bulk import; iCal feed |
| Not in v1 | Side-panel conflict calendar (chat-only conflict message in v1) |

### Phase sizing

| Bad | Good |
| --- | ---- |
| Phase 1 schema, Phase 2 API, Phase 3 UI — always shipped and reviewed together | One phase: schema, API, and UI for the create flow |
| One phase that also includes empty states and a full accessibility pass | Phase 1: schema and repository; Phase 2: command, validation, and the composer UI |
| 7 phases, no reason | 7 phases — noted under the progress overview: migration needs a backfill check before enforcing NOT NULL |

### Deliverables

| Bad | Good |
| --- | ---- |
| Add UI | Extend `ItemList` at `src/features/items/` with an empty state |
| Create `itemService.ts` with no reason | Extend `Item.commands.ts` with `createItem` |
| A new utils file for one helper used once | Inline the helper in the file that uses it |

### Approach (guiding vs pasteable)

| Bad | Good |
| --- | ---- |
| Approach lists only `src/a.ts` then `src/b.ts` with no shape | Approach names those paths, then a short signature or sketch for the ambiguous edge |
| Approach pastes a full module ready to drop into the repo | Approach shows a 5–15 line sketch or do/do-not pair; Done when stays the binding check |
| Approach is a 2–5 minute micro-step checklist as the default unit | Approach stays outcome-sized; micro-steps only when Project conventions require them |

### Phase tier

| Bad | Good |
| --- | ---- |
| A prop rename across 30 components marked High because many files change | Low — the edit is mechanical, and typecheck catches misses |
| A settings view built from existing form and list composables marked Low | Medium — a new route and its states, with a pattern to follow |
| A small host-message payload change marked Medium because the diff is small | High — a contract with another runtime, and only manual testing can verify it |
| A new persisted filter preference marked Low | Medium — or High when existing stored values must keep working |
| A one-file edit to token refresh marked Low | High — auth and async ordering |
| A copy-only change marked Medium because users see it | Low |

### Risks

| Bad | Good |
| --- | ---- |
| Might be complex | Backfill `resourceId` before enforcing NOT NULL |
| Users might not like it | Omit. Taste is not an implementation risk unless it changes the v1 surface |

---

## Author habits

1. Prefill from the code, then cut anything the implementer does not need.
2. Prefer one sentence over a padded subsection. Prefer no section over an empty one.
3. Default a new file to "no" until there is a concrete reason.
4. Re-read as someone starting phase 1. Anything you would ask in chat becomes a doc fix or a **Q** item.
5. Keep glossary terms the same in `<slug>.spec.md`, the tech docs, and `<slug>.plan.md`. If `<slug>.spec.md` changes later, update the siblings that reference the change before calling the edit done.
