# Spec

A Cursor plugin that ships the `/spec` skill: a gated workflow from design → technical specs → implementation plan → one phase at a time, then archive.

This repository is the plugin (not an npm package). Install it from GitHub with `/add-plugin`. We intend to publish to the [Cursor Marketplace](https://cursor.com/marketplace) later; until then, use the GitHub install below.

## Getting started

Requires Cursor 2.5+. In a new Agent chat, type the full command (it often does not appear in autocomplete):

```text
/add-plugin spec-skill-set@https://github.com/Funder75/spec-skill-set
```

Open Customize and confirm the Spec plugin and the `spec` skill are listed.

### Updates

GitHub `/add-plugin` installs can stay pinned to the commit from first install. Restart, Update/Reinstall, and running `/add-plugin` again often do **not** pull newer commits (known Cursor limitation).

To run a newer revision until that is fixed: clone or copy this repo into `~/.cursor/plugins/local/spec-skill-set` (a real directory under that folder — a symlink to a checkout elsewhere is rejected), then Developer: Reload Window. Prefer that over relying on the marketplace cache when you need the latest skill.

After we are listed on the official Marketplace, installs from there should pick up reviewed updates on restart or window focus.

## How to use

In a project that has (or will have) `spec_docs/`, invoke the skill with `/spec`. Saying “spec” does not load it.

Main actions:

- `/spec explore` — read-only: decide whether you need a folder (no spec / Depth+slug / spike); writes nothing under `spec_docs/`
- Create a spec
- Promote to tech specs
- Promote to an implementation plan
- Implement the next phase
- `/spec next` — name the next gate and ask before continuing
- Audit or review a spec (read-only report)
- Archive when done

`/spec help` points at the project’s `spec_docs/README.md` when that file exists.

Create-spec runs dialogue and chat approval before writing the design file. You can set Depth and Kind up front (`as lite`, `as bugfix`, or both). Plans use guided Approach (not pasteable full code). The skill does not create branches, worktrees, or commits unless you ask.

### What `spec_docs/` is for

`spec_docs/` holds one folder per unit of work (feature or bugfix). Active work lives under `spec_docs/<slug>/`. Finished work moves to `spec_docs/archive/<slug>/`.

Each folder starts at `<slug>.spec.md` (scope and gates). Sibling files cover tech notes and the plan when needed. Gates, Depth paths, Kind, markers, and **Project conventions** live in [`spec_docs/README.md`](spec_docs/README.md).

### Kind: feature vs bugfix

Every `<slug>.spec.md` carries `Kind: feature | bugfix` next to Progress and Depth. Missing Kind on an older folder means `feature`.

| Kind | Design shape | When to use |
| ---- | ------------ | ----------- |
| **feature** (default) | **User journeys** and **Work split** | New behaviour, product change, or anything that is not a defect fix |
| **bugfix** | **Current / Expected / Unchanged behaviour** lists plus **Root cause** (no journeys or Work split) | A defect, regression, or “broken when …” fix |

Say `create … as bugfix` (alone or with a Depth) to set Kind without a recommend ask. When Kind is unset and the input looks like a bug, create recommends bugfix once. Lite is recommended for many bugs, not required. Bugfix plans map acceptance scenarios 1:1 onto the behaviour lists; at least one regression scenario records red-before-green evidence in Close-out.

### Depth

`Depth` (`lite` / `standard` / `full`) chooses how many documents and review gates you walk — not a second skill. Missing Depth on an older folder means `full`. Say `create … as lite` (or `as standard` / `as full`) to skip the Depth ask. Unsure whether you need a folder at all? Start with `/spec explore`.

| Depth | Path |
| ----- | ---- |
| **lite** | One chat approval covers design + thin `<slug>.plan.md` in the same create session (`Progress: plan`). Empty optional sections stay omitted; tech folds into **Technical notes** or `not needed` (no tech siblings). Simple Low + Close `automated` → next offer is implement (no second plan-review gate). |
| **standard** | Design → fold tech / `not needed` (`Progress: tech`) → thin plan → implement. Separate promote to plan; few phases. Tech siblings are unusual. |
| **full** | Design → tech siblings when the emit bar is met → full plan → implement. Default for older folders with no Depth line. |

### Write and iterate

Authors walk the same loop the skill enforces (lite collapses design + thin plan into one create session):

1. **Design** — Create and iterate `<slug>.spec.md` until the shape is accepted (journeys / Work split for feature; behaviour lists + Root cause for bugfix).
2. **Tech** — Add or fold technical notes when the work needs them (`Progress: tech`). Skipped as a separate step on lite.
3. **Plan** — Write `<slug>.plan.md` with phases, Done when, and a **Close** of `automated` or `human` on each phase (`Progress: plan`).
4. **Implement** — One phase (or one combinable group) at a time (`Progress: implementing`).
5. **Archive** — Move the folder under `archive/` when the work is done.

More detail is in [`spec_docs/README.md`](spec_docs/README.md).

### Validate a folder

Create-spec, plan, and audit run a mechanical check first when the skill can launch it. You can run the same check by hand on any `spec_docs/<slug>/` folder:

```bash
/bin/sh skills/spec/scripts/validate spec_docs/<slug>/
```

Exit `0` means no mechanical findings. Non-zero prints one finding per line (placeholders, bare ID citations, Close/Gates mismatches, legacy bare basenames, and related checks). The script does not judge design quality. If it is missing or fails to launch, those stages fall back to their manual checklists; a findings exit is not a fallback.

### Tips

- **Explore first when unsure.** `/spec explore` restates the ask and exits with no folder, a named Depth+slug, or a spike — without writing `spec_docs/`.
- **Pick Kind on purpose.** Use `as bugfix` for defect fixes so create skips journeys and Work split. Leave feature (or omit Kind) for new behaviour.
- **Pick Depth on purpose.** Use `lite` for small, low-risk work (including many bugfixes). Use `standard` for a normal fold-then-plan path. Reserve `full` when tech siblings and a multi-phase plan earn their keep.
- **Keep tabs readable.** New folders use slug-prefixed names (`<slug>.spec.md`, `<slug>.plan.md`). Older archived folders may still use bare basenames until someone renames them by hand.
- **Validate before you ask.** Run `skills/spec/scripts/validate` on a slug folder when you want a fast mechanical pass without starting an audit.
- **Fill conventions early.** On first bootstrap, opt in to fill **Project conventions** while context is fresh. Later stages otherwise hit placeholders when they need a project fact. Say `/spec fill conventions` any time afterward to fill or update them — it is not limited to first bootstrap, and a stage that hits a placeholder will offer the same flow.
- **Repo stays canonical.** Edit the markdown in `spec_docs/`. Linear (when used) mirrors links and status; do not treat tracker text as binding acceptance criteria.
- **One open unit.** Implement one phase or combinable group at a time. Multi-phase plans dispatch fresh context per unit; do not parallelize implementers.
- **No surprise SCM.** The skill does not create branches, worktrees, or commits unless you ask in that conversation.
- **Ask before inventing process.** Tips and README prose are advisory for humans. New agent behaviour belongs in a skill change, not a tip bullet.

## Linear

Optional tracker integration for linked `spec_docs/` folders. The repo stays canonical; Linear holds links, status, Tracker Phases, and a Document mirror.

- **Connect Linear MCP in the IDE.** Tracker write-back (create-from fetch, link-back, Tracker Phases, status, Document, `/spec linear sync`) runs only when Linear MCP works in the current agent session (D19 (mcp session)). Cursor’s Linear product assign / `@Cursor` is kickoff, not MCP auth.
- **Fill Project conventions.** Under `spec_docs/README.md` › Work items, set Linear project, team, fetch blurb, and Progress / phase-status maps (plus optional design label and default `[repo=…]`). Until those are filled, the skill warns once and skips write-back rather than inventing a team.
- **Create-from and sync locally.** Prefer a local IDE session with Linear MCP for `/spec create from …` and `/spec linear sync`. Do not expect a Linear-started cloud run alone to sync tracker fields back to Linear.
- **Cloud kickoff.** Use native `@Cursor` / assign on a Tracker Phase that already has brief-quality text, and have the kickoff message invoke `/spec` (for example `/spec implement`). Assigning the issue, or saying “spec”, does not load the skill. The skill does not ship a second Cloud Agent launcher. The Tracker Phase body is a pointer, not a standalone prompt: its canon banner tells the worker to re-read `<slug>.plan.md` from the repo and ignore any scope or command in the Linear body that the plan does not also state, so an edit to the issue alone cannot steer the worker. After cloud work merges, catch up Linear from an MCP-capable session.
- **Do not edit Linear as binding AC.** Issue descriptions and the Document mirror are not the source of truth. Edit `<slug>.spec.md` in the repo; regenerate the Document from there when TL;DR or goals change. Store `work_item`, `tracker_spec_url`, `document_id`, and `document_url` in that file's YAML frontmatter only — not as a second copy in the body.
- **Cloud Linear MCP.** Cloud Agents use a separate MCP sign-in from the desktop app. Linear MCP OAuth for cloud is often unavailable; treat cloud as kickoff-only for tracker writes unless that session clearly has working Linear MCP.

## Contribute

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for local-dev layout, the user-skill update script, and PR expectations. Please follow the [Code of Conduct](CODE_OF_CONDUCT.md). Security reports go through [`SECURITY.md`](SECURITY.md), not public issues.

## License

MIT. See [`LICENSE`](LICENSE).
