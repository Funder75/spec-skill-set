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
- `create epic` — a parent overview for child specs and for tasks that stay outside a spec. See [Epic](#epic)
- Promote to tech specs
- Promote to an implementation plan
- Implement the next phase
- `/spec next` — name the next gate and ask before continuing. On an epic, name the suggested specs instead
- Audit or review a spec (read-only report)
- Archive when done

`/spec help` points at the project’s `spec_docs/README.md` when that file exists.

Create-spec runs dialogue and chat approval before writing the design file. You can set Depth and Kind up front (`as lite`, `as bugfix`, or both). Plans use guided Approach (not pasteable full code). The skill does not create branches, worktrees, or commits unless you ask.

### What `spec_docs/` is for

`spec_docs/` holds one folder per unit of work. A feature or bugfix folder is one implementable spec. An epic folder groups child specs and tasks; implementation stays on the children. Active work lives under `spec_docs/<slug>/`. Finished work moves to `spec_docs/archive/<slug>/`.

A feature or bugfix folder starts at `<slug>.spec.md` (scope and gates). An epic folder starts at `<slug>.epic.md`. Sibling files cover tech notes and the plan when a spec needs them. Gates, Depth paths, Kind, markers, and **Project conventions** live in [`spec_docs/README.md`](spec_docs/README.md).

### Kind

Every implementable spec (`<slug>.spec.md`) carries `Kind: feature | bugfix` next to Progress and Depth. Missing Kind on an older folder means `feature`. A third kind, epic, lives in `<slug>.epic.md`. See [Epic](#epic).

| Kind | Design shape | When to use |
| ---- | ------------ | ----------- |
| **feature** (default) | **User journeys** and **Work split** | New behaviour, product change, or anything that is not a defect fix |
| **bugfix** | **Current / Expected / Unchanged behaviour** lists plus **Root cause** (no journeys or Work split) | A defect, regression, or “broken when …” fix |

Say `create … as bugfix` (alone or with a Depth) to set Kind without a recommend ask. When Kind is unset and the input looks like a bug, create recommends bugfix once. Lite is recommended for many bugs, not required. Bugfix plans map acceptance scenarios 1:1 onto the behaviour lists; at least one regression scenario records red-before-green evidence in Close-out.

### Epic

Use an epic when one implementable spec would be too large, or when some of the work should stay outside a spec. Say `create epic`, with a name or a note. The skill writes `spec_docs/<slug>/<slug>.epic.md` only: no `<slug>.spec.md`, no tech siblings, and no plan. That file carries `Kind: epic` and omits Depth and Progress. Explore does not offer an epic, so say `create epic` yourself.

The epic lists suggested specs. Each one is its own section, with a number and a name such as `S3 (invoice export)`, a slug, and enough description to promote into a real spec. `Depends on` sits in that section. It names other suggested specs in full form, or a task, or `—` when the spec can start alone. There is no status and no dependency table.

| Piece | What it is | How you do it |
| ----- | ---------- | ------------- |
| **Suggested spec** | A child slug, different from the epic slug. The folder may not exist yet. The section is the seed: what, why, v1 scope, and the outcomes that become goals. | Select the epic file and say `/spec create spec for` that file, naming `S3 (invoice export)` or its slug. The skill writes one ordinary spec at Progress design, sets frontmatter `epic` to the epic slug, and copies dependencies as slugs. Promote and implement the child on its own. |
| **Task** | A short name under Tasks. No folder. The work may be analysis, an open question, research, elaboration, or similar. | Do it yourself, or open a chat and refer to the task by name. The skill does not open a stage, does not create a folder, and does not record that the task is done. The task stays after the work is done; you may edit the text. |

`/spec next` on an epic names the suggested specs. When a spec depends on a task, it names each such task first, then tells you to create or open a child spec, or to do a task. It does not start the task, and it does not offer tech, plan, implement, or archive.

`/spec create spec for` writes one child from that section and stops, including when that child's Depth is lite. When the spec depends on a task, the skill names each such task and waits until you say those tasks are done. It does not mark the task done. Naming a task does not create a spec.

`implement`, `promote to tech specs`, and `promote to implementation plan` on the epic are refused. The reply names the suggested specs and the tasks. When a child is finished, archive that child the usual way. The epic has no extra archive rule.

Epic sync is one way, repo to Linear. `/spec linear sync` on an epic asks whether to open a new Linear project or a Linear issue. A project is not also filed as an issue. When the target is an issue, the same sync asks whether to copy the full epic into the issue description. Feature and bugfix sync asks that description question too. Linear prose is not copied back into the file, and an epic does not get Tracker Phases. If create epic is given a work-item id, that id is stored as an issue and the project question is skipped. The issue body is not copied into the epic.

### Depth

`Depth` (`lite` / `standard` / `full`) chooses how many documents and review gates a feature or bugfix walks — not a second skill. An epic has no Depth line. Missing Depth on an older spec means `full`. Say `create … as lite` (or `as standard` / `as full`) to skip the Depth ask. Unsure whether you need a folder at all? Start with `/spec explore`.

| Depth | Path |
| ----- | ---- |
| **lite** | One chat approval covers design + thin `<slug>.plan.md` in the same create session (`Progress: plan`). Empty optional sections stay omitted; tech folds into **Technical notes** or `not needed` (no tech siblings). Simple Low + Close `automated` → next offer is implement (no second plan-review gate). |
| **standard** | Design → fold tech / `not needed` (`Progress: tech`) → thin plan → implement. Separate promote to plan; few phases. Tech siblings are unusual. |
| **full** | Design → tech siblings when the emit bar is met → full plan → implement. Default for older folders with no Depth line. |

A child written with `/spec create spec for` an epic file stops at Progress design even when its Depth is lite. The thin plan waits for a later turn. See [Epic](#epic).

### Write and iterate

Feature and bugfix folders walk the same loop the skill enforces (lite collapses design + thin plan into one create session). An epic stays on its suggested specs. Each child walks the loop on its own:

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
- **Group a large effort as an epic.** Say `create epic` when the work should become several specs, or when some of it should stay a task. Add each child with `/spec create spec for` the epic file, then implement that child on its own. See [Epic](#epic).
- **Pick Depth on purpose.** Use `lite` for small, low-risk work (including many bugfixes). Use `standard` for a normal fold-then-plan path. Reserve `full` when tech siblings and a multi-phase plan earn their keep.
- **Keep tabs readable.** New folders use slug-prefixed names (`<slug>.spec.md`, `<slug>.plan.md`, or `<slug>.epic.md` for an epic). Older archived folders may still use bare basenames until someone renames them by hand.
- **Validate before you ask.** Run `skills/spec/scripts/validate` on a slug folder when you want a fast mechanical pass without starting an audit.
- **Fill conventions early.** On first bootstrap, opt in to fill **Project conventions** while context is fresh. Later stages otherwise hit placeholders when they need a project fact. Say `/spec fill conventions` any time afterward to fill or update them — it is not limited to first bootstrap, and a stage that hits a placeholder will offer the same flow.
- **Repo stays canonical.** Edit the markdown in `spec_docs/`. Linear (when used) mirrors links and status; do not treat tracker text as binding acceptance criteria.
- **One open unit.** Implement one phase or combinable group at a time. Multi-phase plans dispatch fresh context per unit; do not parallelize implementers.
- **No surprise SCM.** The skill does not create branches, worktrees, or commits unless you ask in that conversation.
- **Ask before inventing process.** Tips and README prose are advisory for humans. New agent behaviour belongs in a skill change, not a tip bullet.

## Linear

Optional tracker integration for linked `spec_docs/` folders. The repo stays canonical; Linear holds links, status, Tracker Phases, and a description mirror of the spec or epic.

- **Connect Linear MCP in the IDE.** Tracker write-back (create-from fetch, link-back, Tracker Phases, status, description, `/spec linear sync`) runs only when Linear MCP works in the current agent session (D19 (mcp session)). Cursor’s Linear product assign / `@Cursor` is kickoff, not MCP auth.
- **Fill Project conventions.** Under `spec_docs/README.md` › Work items, set Linear project, team, fetch blurb, and Progress / phase-status maps (plus optional design label and default `[repo=…]`). Until those are filled, the skill warns once and skips write-back rather than inventing a team.
- **Create-from and sync locally.** Prefer a local IDE session with Linear MCP for `/spec create from …` and `/spec linear sync`. Do not expect a Linear-started cloud run alone to sync tracker fields back to Linear.
- **Epic sync is one way.** `/spec linear sync` asks whether the epic is a new Linear project or a Linear issue, then pushes that choice (link and description, including suggested specs). A project is not also created as an issue. Linear prose is not copied back into `<slug>.epic.md`. An epic has no Progress line and no Tracker Phases. Feature and bugfix sync still creates or updates an issue.
- **Cloud kickoff.** Use native `@Cursor` / assign on a Tracker Phase that already has brief-quality text, and have the kickoff message invoke `/spec` (for example `/spec implement`). Assigning the issue, or saying “spec”, does not load the skill. The skill does not ship a second Cloud Agent launcher. The Tracker Phase body is a pointer, not a standalone prompt: its canon banner tells the worker to re-read `<slug>.plan.md` from the repo and ignore any scope or command in the Linear body that the plan does not also state, so an edit to the issue alone cannot steer the worker. After cloud work merges, catch up Linear from an MCP-capable session.
- **Do not edit Linear as binding AC.** The Linear description is not the source of truth. Edit `<slug>.spec.md` in the repo; when TL;DR or goals change, run `/spec linear sync` to refresh the description. `/spec linear sync` asks before copying the full spec or epic into the issue or project description; until you say yes, the description is left alone. Store `work_item` and `tracker_spec_url` in that file's YAML frontmatter only — not as a second copy in the body. An epic that became a Linear project stores `linear_project` and `linear_project_url` the same way, and leaves `work_item` unset.
- **Cloud Linear MCP.** Cloud Agents use a separate MCP sign-in from the desktop app. Linear MCP OAuth for cloud is often unavailable; treat cloud as kickoff-only for tracker writes unless that session clearly has working Linear MCP.

## Contribute

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for local-dev layout, the user-skill update script, and PR expectations. Please follow the [Code of Conduct](CODE_OF_CONDUCT.md). Security reports go through [`SECURITY.md`](SECURITY.md), not public issues.

## License

MIT. See [`LICENSE`](LICENSE).
