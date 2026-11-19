## Detailed review — changes needed before merge

The overall direction is coherent, but the current implementation has contract contradictions and validator false negatives. I would not merge this version yet.

### High priority

1. **Blocked phases still freeze all execution** (`skills/spec/stages/implement.md`, Phase selection / Serial SDD / Phase status).
   - Phase selection always resumes `Blocked` first.
   - `Blocked` also occupies the sole active slot.
   - Therefore the new promise that an unrelated ready phase may start can never be satisfied.
   - Park `Blocked` outside the active slot, select only `Started`/`Reviewing` first, and resume a blocked unit explicitly.

2. **The validator can permit required human sign-off to be bypassed** (`skills/spec/scripts/validate`).
   - A fixture with scenario `Check: agent`, Gates owner `human`, and phase `Close: automated` exits 0.
   - The script validates each vocabulary independently but never enforces Check ↔ Gates owner parity or derives Close from owners.
   - Parse scenario-to-owner mappings and require `Close: human` whenever any owner is human. Also require `Awaiting sign-off` to pair with human Close.

3. **The supported conventions interview cannot configure the new Linear contract** (`skills/spec/stages/fill-conventions.md`).
   - Q5 omits `Awaiting sign-off`.
   - The interview and emitted schema omit `Close → label map` entirely.
   - `/spec fill conventions` therefore produces configuration that cannot mirror the new status and always skips Close labels.

### Linear consistency

4. **`needs sign-off` dependencies are skipped by blocker sync** (`linear-sync/tracker-phases.md`). `1 (needs sign-off)` is valid plan syntax but the blocker parser accepts only bare phase numbers. Strip the suffix before phase lookup.

5. **Unmarked awaiting dependencies disagree between the repo and Linear.** Repo execution treats unmarked `Awaiting sign-off` as satisfied, while `blockedBy` is retained until Done/Deferred. Linear can show a phase blocked while `/spec implement` is allowed to run it. Reconcile blockers on status transitions or explicitly make them structural rather than runnable-state blockers.

6. **Tracker Phase bodies omit the new `agent` Gates owner** (`linear-sync/tracker-phases.md`). The cloud-ready summary still documents only automated/human, so agent observation and evidence requirements can be lost.

7. **Explicit sync does not reliably reconcile Tracker Phase state.** A phase created/repaired after work started can keep its default/stale Linear state because explicit phase sync updates body/labels/blockers but does not run the selective status mirror.

### Validator correctness

8. **Invalid or missing Check values are silently skipped.** `Check: manual` exits 0 because the parser records only already-valid-looking values; the later invalid-value branch is unreachable. Capture every Check value, then validate it, including missing/duplicate fields.

9. **Allowed Gates ranges produce false failures.** A valid `A1.1–A1.3` row reports A1.2 unmatched because only endpoints are extracted. Expand same-phase ranges before matching. The template currently recommends this range form.

10. **Owner mismatches pass.** A human scenario Check paired with an automated Gates owner exits 0.

11. **Some prohibited Done-when forms escape.** Comma-separated scenario lists such as `A1.1, A1.2 pass` are not rejected.

12. **Dash handling is locale-dependent.** The en-dash range check works under UTF-8 but can pass under `LC_ALL=C`; normalize/test the UTF-8 bytes explicitly.

13. **Depends-on tokenization allows pathname expansion.** Unquoted `set -- $depends` can turn malformed glob-like input into a valid phase id depending on files in the invocation directory. Parse comma-separated tokens literally with awk/read instead.

### State recovery and compatibility

14. **Cascade reopen leaves stale state.** It does not require rejected/reopened scenario checkboxes to be unchecked, does not bind downstream target statuses, and does not persist which later phases ran during an awaiting interval. This contradicts the scenario transition contract and makes non-linear recovery ambiguous.

15. **Legacy human-close plans regress.** A plan that passed the main-branch validator can now fail solely because it lacks Pre-flight. If old plans are intentionally supported, add an opt-in/version marker or document and test the migration.

16. **Archive routing is inconsistent for deliberately dropped Not-started phases.** Explicit archive text allows them, while `/spec next` only offers archive for Done/Deferred. Pick one contract.

### Quality / verification

- `git diff --check`, shell syntax, and all newly added/changed spec-folder validations pass.
- Repro fixtures confirmed the invalid Check, Check/Owner mismatch, valid-range false positive, locale, and glob-token defects.
- No CI checks are configured, ShellCheck is unavailable, and this 200+ line parser expansion has no persistent regression suite.
- Add fixture-based tests covering valid/invalid values, owner/Close consistency, ranges, locales, blank cells, glob-like tokens, and legacy compatibility.

The PR is mechanically clean, but the scheduler contradiction and human-sign-off validation gap are merge blockers.
