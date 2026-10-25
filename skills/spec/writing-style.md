# Writing style

Applies to text written into `spec_docs/`: `<slug>.spec.md`, the tech docs (`<slug>.logic.md`, `<slug>.contracts.md`, `<slug>.ui.md`), `<slug>.plan.md`, and the audit report in chat (R9 (helper doc cites)). It wins where it differs from the sentences in this skill. The skill's own text is written for the agent; do not copy its density.

## Reader

A developer who was not in the chat and does not know this code. They skim first and read closely only where they must act.

## Sentences and paragraphs

- About 25 words or fewer per sentence. One idea per sentence.
- At most 4 sentences per paragraph.
- Meaning first, identifier second: "the device's capability types (`exposeTypes`)", not "`exposeTypes`".
- Spell out each abbreviation once per doc, on first use. Do not invent shorthand, nicknames, or arrow chains (`A → B → fails`).
- Name the problem in plain words. A checklist label or code name is not an explanation.

## Skimming

- A section over about 15 lines opens with an **In short:** line.
- Bullets that carry a separate point start with a bold lead-in: `- **Lead-in.** Detail.`
- Omit an empty section. Do not write "None".

## Tables

- A cell holds a name, ID, status, value, or path, in about 10 words.
- Anything longer goes in a list: one item per row, with a heading or bold lead-in.
- A cell with more than one sentence is a defect.

## IDs

- Define and cite goals, rules, decisions, and questions in the full form: `G1 (writing style)`. Letter, number, and a 2–4 word lowercase name.
- A bare `G1` in prose is a defect. Acceptance scenarios (`A2.1`) and audit findings (`C1`, `W1`, `O1`) keep their short form.
- Never reuse a number. A rename updates every citation in the folder; search for `G1 (`.

## Examples

Bad:

> Uses `getGroupedRowModel` w/ D6 so grp rows → collapsible; Q2 TBD.

Good:

> Rows are grouped by room, and each group can be collapsed. The table library's grouping (`getGroupedRowModel`) does this; see D6 (row grouping). Whether groups start collapsed is open: Q2 (default collapse).

Bad table cell:

> | G3 | The dashboard must show every device in its room, keep the order the user chose last time, and fall back to alphabetical when no order is stored. |

Good:

> ### G3 (room order) — Devices appear under their room
>
> - Each device is listed under its room.
> - The order the user chose last is kept.
> - With no stored order, rooms are alphabetical.

Bad audit finding:

> **W2 — Spec drift.** Glossary mismatch.

Good:

> **W2 — "Group" means two things**
>
> - **What's wrong:** `<slug>.spec.md` uses "group" for a room. `<slug>.ui.md` uses it for a collapsible table row.
> - **Why it matters:** A phase that reads only `<slug>.ui.md` will build the wrong filter.
