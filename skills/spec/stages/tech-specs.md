# Promote to technical specs

Create the technical docs for `spec_docs/<slug>/`. Do not write `implementation-plan.md`.

## Preconditions

- The user asked to promote to tech specs, or confirmed that step after `/spec next`.
- `Progress` is `design`. If it is already `tech` or later, resume missing docs. Do not wipe existing files.
- If `spec.md` is still a draft the user has not accepted, ask before generating siblings.

## What to write

Read `spec.md`. Then read each module in **Touched paths** — enough to know where each rule, type, and screen state lands and which existing symbols and patterns it extends. Do not stop once a file can be named. Before `contracts.md` or `ui.md`, read **Stack notes for spec docs** under **Project conventions**. If that block is missing or still a placeholder, ask. Do not bake a UI library or a database into the doc.

Create a sibling only when that concern needs its own file:

| File | Include when |
| ---- | ------------ |
| [business-logic.md](../templates/business-logic.md) | Multi-step workflows, conditions, state transitions, or more than ~5 rules |
| [contracts.md](../templates/contracts.md) | Types, API contracts, state ownership, or storage beyond `spec.md` |
| [ui.md](../templates/ui.md) | A new or significantly changed surface |

Otherwise fold the notes into `spec.md` under **Technical notes (folded)**, one subsection per concern (Rules, Contracts, UI), and set that doc index row to `folded → [Technical notes › …](#…)`. A tech doc that would only repeat `spec.md` is a defect: fold it back. Set a row to `not needed` when the concern does not apply. In a folder that already has `data.md`, keep that name.

## Close to the code

A tech doc is specific enough to implement from. Length follows the feature.

- Each rule, type, command, and screen state names the file it is expected to change, and the existing symbol when there is one. A new symbol names the file it will be added to, following that package's folder layout.
- Each workflow step and error case names the function that handles it, when that function exists or is about to be added.
- Types and components follow the patterns already in those files. Add a short code sketch where the shape would otherwise be ambiguous.
- Field tables and rules are binding. Paths and sketches are advisory; a phase that departs records it in **Close-out**.
- `ui.md` covers every journey step in `spec.md` that touches a screen.
- When reading the code shows a behaviour `spec.md` did not decide, add a **Q** item to `spec.md` and point at it with `> **Open:** Q1 (short name)`. Do not fill the gap in the tech doc.

Do not add a feature `README.md`. `spec.md` is the overview.

## Writing

Follow [writing-style.md](../writing-style.md) and the table rule in `SKILL.md`. Start from [templates/](../templates/). They are guidelines, not a required outline. Skip a section that this feature does not need. Replace a section when another shape is clearer. Keep the binding facts (rules, contracts). Match the spec's scope, glossary, and non-goals. Open each doc with its TL;DR. Replace every `{{…}}` placeholder. Strip every HTML comment. Justify each new file in one line at its top (`> Created because: …`).

One fact, one home. A tech doc owns only its concern. Link to `spec.md` for scope, non-goals, glossary, journeys, touched paths, and the work split. Do not restate them. Number rules `R1 (short name)`… and write them with MUST, MUST NOT, and SHOULD.

Do not add a decisions or open-questions section to a tech doc. Record those in `spec.md`. Do not resolve a question by guessing. A **Priority** `high` question is one whose answer would change these docs.

## Update spec.md

Do not rewrite the spec. Set `Progress: tech` and update the doc index. `Present?` is `yes` (and link the name), `folded →` an anchor, `not needed`, or `pending`.

## Stop

Tell the user which docs were included and which were omitted, which template sections were skipped or replaced, and the open questions — **Priority** `high` first. Wait for review before an implementation plan.
