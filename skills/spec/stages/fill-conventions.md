# Fill Project conventions

Shared interview for Bootstrap after the README copy. Bootstrap calls this on opt-in; do not invent a second fill path.

Write only **Project conventions** in `spec_docs/README.md`. Strip HTML author comments as the template intends. Do not edit other README sections or the template on disk.

## Rules

**In short:** One explained question per turn. Leave placeholders when unsure. Chat answers win. Write once at the end.

1. Ask exactly **one** question per turn while answers are still needed for the interview.
2. Each question includes a short **why it matters** in plain language. Prefer multiple choice when options are clear.
3. Every question allows **leave as placeholder / skip**. Unanswered fields stay `{{…}}` (or the None / empty-list shapes below).
4. Chat answers win over drafts. Never invent secrets, tokens, private URLs, or Linear states not returned by Linear MCP or named by the user.
5. Do not search the repo to invent conventions. Draft only from obvious project facts the user already confirmed, or from Linear MCP when this stage says to.
6. When the interview finishes, or the user says **done / leave the rest**, write **Project conventions** once, then return to Bootstrap so it can resume the original `/spec` intent.
7. Keep the **Complexity hotspots** subsection always. If the user chooses none, write an empty bullet list (no items). Do not omit the subsection.

## Opt-in (Bootstrap owns this)

Bootstrap asks whether to fill **Project conventions** before calling this file. Opt-in is an explicit yes, or a reply that already answers interview questions. Silence, ignore, bare continue of the original action, and explicit no are not opt-in — Bootstrap leaves the README unchanged and does not enter this stage.

## Interview order

Run groups in this order. Skip questions already answered in the opt-in reply. Stop early when the user says done / leave the rest (write what you have; leave the rest as `{{…}}` or the empty-hotspots list).

1. Work items
2. Verify tiers
3. Complexity hotspots
4. Stack notes for spec docs
5. Other commands

---

## Work items

### Q1 — Tracker

**Ask:** Where do feature tickets live for this repo?

- **A.** None — specs come from chat or free text only
- **B.** Linear

**Why:** The skill uses this when creating a spec from a ticket id, and when mirroring Progress / phase status back to a tracker. Choosing None skips every Linear field.

**On A (None):** Plan to write no-tracker prose (same shape as below). Skip Q2–Q7. Continue with Verify tiers.

```markdown
### Work items

This repo has no work-item system. Specs come from chat or free text. If a future id scheme appears, keep title, description, and acceptance criteria, and map each criterion to a goal **Source** line (for example `WI AC2`).
```

**On B (Linear):** Continue Q2–Q7. Default **Fetch** to: use Linear MCP `get_issue` by id or URL (user may override later if you ask; otherwise keep that default).

**On leave / skip:** Leave the whole Work items subsection as the template Linear schema with `{{…}}` placeholders, or ask nothing further for Work items if they said leave this group.

### Linear MCP

When the tracker is Linear and a question needs live choices:

1. Linear MCP must be usable in this session. Cursor assign / `@Cursor` is not Linear MCP auth.
2. Use `list_teams`, `list_projects`, and `list_issue_statuses` (team required for statuses). Present choices from the live result; the user may paste a name/id instead, or leave a placeholder.
3. If MCP is missing or unauthorized: warn once; continue with manual name/id asks; leave map fields as `{{…}}` unless the user supplies state names. Do not invent workspace states or silent half-maps.

### Q2 — Team

**Ask:** Which Linear team should new Tracker Specs and Tracker Phases be created in?

**Why:** Creates and status updates need a team. Wrong team means tickets land in the wrong place.

If MCP works: offer `list_teams` results as choices. Else ask for team name or id.

**Leave / skip** → `{{name or id}}`.

### Q3 — Linear project

**Ask:** Which Linear project should those issues belong to?

- Paste a project id / name, pick from `list_projects` when MCP works, or **n/a** if issues are not under a project.

**Why:** Optional on some teams; required when your workspace puts work under a project.

**Leave / skip** → `{{id | n/a}}`.

### Q4 — Tracker Spec Progress → state/label map

**Ask:** How should each repo **Progress** value map to a Linear state (and optional label) on the parent Tracker Spec?

Cover: `design`, `tech`, `plan`, `implementing`, `archived`.

**Why:** When a spec moves gates (design → tech → … → archived), the skill updates the linked Linear issue. This map is the only place those Linear state names live.

If MCP works and team is known: call `list_issue_statuses` for that team. Propose a suggested mapping from those live statuses. User accepts, edits, or leaves placeholders. Do not invent state names.

**Leave / skip** → keep `{{design → …; tech → …; plan → …; implementing → …; archived → …}}`.

### Q5 — Tracker Phase status → state map

**Ask:** How should each plan phase status map to a Linear state on a Tracker Phase child?

Cover: `Not started`, `Started`, `Reviewing`, `Done`, `Deferred`, `Blocked`.

**Why:** When a phase status changes in the plan, the skill updates that child issue. Same rule: only your map names the Linear states.

If MCP works: reuse the team’s `list_issue_statuses` result; propose a suggestion; user accepts, edits, or leaves placeholders.

**Leave / skip** → keep `{{Not started → …; Started → …; Reviewing → …; Done → …; Deferred → …; Blocked → …}}`.

### Q6 — Optional design-stage label

**Ask:** When a spec is first linked, should the skill add a design-stage label on the Tracker Spec?

- Label name/id, or **omit**.

**Why:** Some teams mark early specs with a label (for example `spec:design`). Skip if you do not use one.

**Leave / skip** → omit the bullet, or leave `{{label name/id, or omit}}`.

### Q7 — Optional default `[repo=…]`

**Ask:** Default GitHub (or other) `owner/name` for cloud-agent briefs, or omit?

**Why:** Tracker Phase bodies can include `[repo=…]` so a cloud agent knows which remote to use. Omit if you do not use that.

**Leave / skip** → omit the bullet, or leave the placeholder.

### Linear Work items write shape

When tracker is Linear, write the schema field names the skill already reads (do not rename):

```markdown
### Work items

Ticket system for this repo is Linear. On fetch, keep title, description, and acceptance criteria. Map each acceptance criterion into a goal's Source line (for example `WI AC2`).

- **Linear project:** …
- **Team:** …
- **Fetch:** use Linear MCP `get_issue` by id or URL
- **Tracker Spec Progress → state/label map:** …
- **Tracker Phase status → state map:** …
- **Optional design-stage label:** …
- **Optional default `[repo=…]`:** …
```

Omit the optional bullets when the user chose omit / none for those questions.
---

## Verify tiers

### Q8 — Verify commands

**Ask:** What should the implementer run to verify a phase at Low, Medium, and High tier? Where are those commands run, and what setup do they assume?

**Why:** Each plan phase picks a tier. The skill tells the implementer to run the matching row and record it under phase Close-out.

Offer the three rows plus a one-line “where to run” note. User may fill some rows and leave others as `{{command}}`.

**Leave / skip** → leave the template table and where-to-run line as `{{…}}`.

---

## Complexity hotspots

### Q9 — Hotspots

**Ask:** Are there areas of this repo where a phase is harder than the generic tier rubric suggests?

- **A.** None — write an **empty** bullet list under the subsection (keep the heading).
- **B.** List areas — each bullet: area, and why touching it raises tier.

**Why:** The planner reads this when setting phase Tier. An empty list is fine and easy to extend later. Do not omit the subsection.

**Leave / skip** → leave `- {{area — why a phase that touches it is harder}}`, or write an empty list if they said none without choosing B.

---

## Stack notes for spec docs

### Q10 — Stack notes

**Ask:** For tech docs later, what should the skill assume about:

- **UI library** — component library, and where to look up props
- **Data access** — how this repo calls APIs or storage
- **Validation** — how untrusted data is checked at the boundary
- **Errors** — the type used for expected failures
- **i18n** — where user-facing copy lives, or `none`

**Why:** Used when filling `<slug>.contracts.md` and `<slug>.ui.md`. Skip any bullet you do not know yet (`{{…}}`).

One turn covers all five. Fill what the user knows; leave the rest as placeholders. Do not split into five turns unless the user answers piecemeal across turns.

---

## Other commands

### Q11 — Other commands

**Ask:** Any other recurring commands the skill should know (dev server, reload plugin, migrate, …)?

- Rows of Task / Command / Notes, or **none** (leave a single placeholder row, or a short “none yet” note with an empty-ready table — prefer one placeholder row if unsure).

**Why:** Handy for implement and verify; not required for Linear sync.

**Leave / skip** → leave the template placeholder row.

---

## Write

After the interview (or early done):

1. Apply answers into **Project conventions** only in `spec_docs/README.md`.
2. Strip HTML author comments in that section as the template intends.
3. Unanswered items stay `{{…}}` except: None tracker → no-tracker prose; Complexity hotspots none → empty list under the heading.
4. Do not invent facts that contradict answers already given.
5. Return to Bootstrap; resume the original `/spec` intent.
