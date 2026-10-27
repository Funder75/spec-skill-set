# Linear sync › Status (selective)

Part of the shared Linear write-back doctrine — see [../linear-sync.md](../linear-sync.md) for Preconditions, Store, and the hook index. Plan, implement, and archive hooks call this file (G3 (status mirror), R11 (status mirror), R12 (selective tracker writes), R13 (progress log), R18 (archive gate)). Repo Progress and plan phase status own the truth; Linear never writes them (G7 (repo canonical)).

**In short:** Gate → Tracker Spec only; phase status → that Tracker Phase only; new progress comment on a real delta; archive asks before Tracker Spec Done if any referenced Tracker Phase is still open. Routine hooks MUST NOT run Explicit sync.

### Guards (every call)

1. **Unlinked / `n/a`.** Routine status write needs a stored id (R22 (reference gate)): Tracker Spec updates need frontmatter `work_item: <id>`; Tracker Phase updates need `Tracker phase: <id>`. Skip that field when the value is `n/a` (or missing); do not create tracker work as a side effect.
2. **MCP / conventions.** Required state map (Progress → Tracker Spec, or phase status → Tracker Phase) missing, or Linear MCP unusable → warn once; skip write-back; do not invent maps (R1 (conventions gate), R21 (mcp session)).
3. **Selective only.** Update only the affected object by stored id. MUST NOT run full Explicit sync from a gate, phase-status, or archive hook (R8 (direct and selective update), R12 (selective tracker writes)).

### Progress → Tracker Spec

When `Progress` in `<slug>.spec.md` changes (promote, implement start, archive) and write-back is allowed:

1. Map the new Progress value to Tracker Spec state and labels via conventions **Tracker Spec Progress → state/label map**.
2. `save_issue` update that Tracker Spec id only (`state` / `addLabels` / `removeLabels` as the map requires). Prefer label add/remove over a full label replace.
3. If Progress actually changed (not a no-op re-apply), post a progress-log comment (below).
4. Do not touch Tracker Phases on a Progress-only event.

### Phase status → Tracker Phase

When a plan phase (or combinable dispatch unit) status changes and write-back is allowed:

1. Read that unit’s stored `Tracker phase:` id. If `n/a`, skip (R22 (reference gate)).
2. Map the new plan status (`Not started` … `Blocked`) to Tracker Phase state via conventions **Tracker Phase status → state map**. Cancel of a removed unit uses the `Removed` key in that same map ([tracker-phases.md](tracker-phases.md) › Cancel removed unit).
3. `save_issue` update that Tracker Phase id only. Combined phases that share one id → one update. Write the least-advanced member’s status (`Not started`, then `Started`, then `Reviewing`, then `Done`). If any member is `Blocked`, write `Blocked`. Ignore `Deferred` unless every member is `Deferred` (R11 (status mirror)).
4. If the Tracker Phase status actually changed, post a progress-log comment on the Tracker Spec (below).
5. Do not update other Tracker Phases. Do not require a confirm prompt on every phase Done (R12 (selective tracker writes)).

### Progress-log comment

On a **real** Progress or referenced Tracker Phase status delta (R13 (progress log), D18 (append progress)):

1. `save_comment` on the Tracker Spec with **no** `id` (create a new comment only).
2. Body MUST open with the human-readable lead-in, then a short summary of what changed. The lead-in marks skill-authored timeline entries (not tracker-object identity):

```text
**Spec progress**

…
```

3. MUST NOT use an HTML comment marker (for example `<!-- spec-sync-progress: … -->`) as the visible heading.
4. MUST NOT edit prior progress comments in place (never pass `id` to `save_comment` for a progress entry). Existing comments that still open with the old HTML marker MAY be rewritten once to this lead-in when the person asks to fix them; that one-time rewrite does not change the append-only rule for routine sync.
5. MUST NOT post a progress comment on a no-op (same Progress / same Tracker Phase state re-applied, including a no-op explicit sync with no status delta).

### Archive gate

When archive is confirmed and the skill would mark the Tracker Spec Done (R18 (archive gate)):

1. For every plan phase with a stored `Tracker phase: <id>` (not `n/a`), check that Tracker Phase is Done or Deferred per the conventions map (Deferred follows the map).
2. If every referenced Tracker Phase is Done or Deferred → map archive Progress to Tracker Spec Done (and labels) and post a progress-log comment when Progress actually changed.
3. If any referenced Tracker Phase is still open → ask before marking the Tracker Spec Done. Do not silently complete it.
4. Status-only archive updates that leave the issue body alone are not blocked by conflict rules (R14 (conflict stop)).

### MUST NOT (Status)

- Overwrite plan phase status or `Progress` from Linear (G7 (repo canonical), A3.3).
- Prompt to confirm Linear on every phase Done.
- Run Explicit sync as a prerequisite for routine selective writes.
- Edit prior progress comments or invent an edit-in-place fallback when create fails.
