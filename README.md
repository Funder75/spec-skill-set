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

In a project that has (or will have) `spec_docs/`, invoke the skill with `/spec` (or say “spec”).

Main actions:

- Create a spec
- Promote to tech specs
- Promote to an implementation plan
- Implement the next phase
- Archive when done

`/spec help` points at the project’s `spec_docs/README.md` when that file exists.

Create-spec runs dialogue and chat approval before writing the design file. Plans use guided Approach (not pasteable full code). The skill does not create branches, worktrees, or commits unless you ask.

### What `spec_docs/` is for

`spec_docs/` holds one folder per feature. Active work lives under `spec_docs/<slug>/`. Finished work moves to `spec_docs/archive/<slug>/`.

Each folder starts at `<slug>.spec.md` (scope and gates). Sibling files cover tech notes and the plan when needed. Gates, Depth paths, markers, and **Project conventions** live in [`spec_docs/README.md`](spec_docs/README.md).

### Write and iterate

Authors walk the same loop the skill enforces:

1. **Design** — Create and iterate `<slug>.spec.md` until the shape is accepted.
2. **Tech** — Add or fold technical notes when the feature needs them (`Progress: tech`).
3. **Plan** — Write `<slug>.plan.md` with phases and Done when (`Progress: plan`).
4. **Implement** — One phase (or one combinable group) at a time (`Progress: implementing`).
5. **Archive** — Move the folder under `archive/` when the work is done.

**Depth** (`lite` / `standard` / `full`) shortens how many documents and review gates you walk. Say `create … as lite` for small work that can ship a thin plan in the same create session. Details and the Depth table are in [`spec_docs/README.md`](spec_docs/README.md).

### Tips

- **Pick Depth on purpose.** Use `lite` for small, low-risk work. Reserve `full` when tech siblings and a multi-phase plan earn their keep.
- **Keep tabs readable.** New folders use slug-prefixed names (`<slug>.spec.md`, `<slug>.plan.md`). Older archived folders may still use bare basenames until someone renames them by hand.
- **Fill conventions early.** On first bootstrap, opt in to fill **Project conventions** while context is fresh. Later stages otherwise hit placeholders when they need a project fact.
- **Repo stays canonical.** Edit the markdown in `spec_docs/`. Linear (when used) mirrors links and status; do not treat tracker text as binding acceptance criteria.
- **One open unit.** Implement one phase or combinable group at a time. Multi-phase plans dispatch fresh context per unit; do not parallelize implementers.
- **No surprise SCM.** The skill does not create branches, worktrees, or commits unless you ask in that conversation.
- **Ask before inventing process.** Tips and README prose are advisory for humans. New agent behaviour belongs in a skill change, not a tip bullet.

## Linear

Optional tracker integration for linked `spec_docs/` folders. The repo stays canonical; Linear holds links, status, Tracker Phases, and a Document mirror.

- **Connect Linear MCP in the IDE.** Tracker write-back (create-from fetch, link-back, Tracker Phases, status, Document, `/spec linear sync`) runs only when Linear MCP works in the current agent session (D19 (mcp session)). Cursor’s Linear product assign / `@Cursor` is kickoff, not MCP auth.
- **Fill Project conventions.** Under `spec_docs/README.md` › Work items, set Linear project, team, fetch blurb, and Progress / phase-status maps (plus optional design label and default `[repo=…]`). Until those are filled, the skill warns once and skips write-back rather than inventing a team.
- **Create-from and sync locally.** Prefer a local IDE session with Linear MCP for `/spec create from …` and `/spec linear sync`. Do not expect a Linear-started cloud run alone to sync tracker fields back to Linear.
- **Cloud kickoff.** Use native `@Cursor` / assign on a Tracker Phase that already has brief-quality text. The skill does not ship a second Cloud Agent launcher. After cloud work merges, catch up Linear from an MCP-capable session.
- **Do not edit Linear as binding AC.** Issue descriptions and the Document mirror are not the source of truth. Edit `<slug>.spec.md` in the repo; regenerate the Document from there when TL;DR or goals change. Store `work_item`, `tracker_spec_url`, `document_id`, and `document_url` in that file's YAML frontmatter only — not as a second copy in the body.
- **Cloud Linear MCP.** Cloud Agents use a separate MCP sign-in from the desktop app. Linear MCP OAuth for cloud is often unavailable; treat cloud as kickoff-only for tracker writes unless that session clearly has working Linear MCP.

## Contribute

### Local development against a project

When you already have the Spec plugin (or user-level `spec` skill) installed, Cursor will not reliably prefer a project copy that reuses the same skill name. A bare symlink of `skills/spec` into a project also fails discovery when the folder name and frontmatter `name` disagree.

To try skill changes from this repository inside another project without reinstalling the plugin:

1. In the target project, create `.cursor/skills/spec-local/` as a **real directory** (not a symlink of the whole skill folder).
2. Copy `skills/spec/SKILL.md` into that directory and change frontmatter so `name` matches the folder:

   ```yaml
   ---
   name: spec-local
   description: >-
     LOCAL DEV copy of the spec skill. Invoke with /spec-local.
   disable-model-invocation: true
   ---
   ```

   Cursor requires `name` to match the parent folder name. If they differ, the skill will not appear in `/` autocomplete.

3. Symlink the shared assets from this repo so edits here apply immediately:

   ```bash
   SRC=/absolute/path/to/spec-skill-set/skills/spec
   DEST=/absolute/path/to/<project>/.cursor/skills/spec-local
   mkdir -p "$DEST"
   # After placing SKILL.md with name: spec-local, link the rest:
   ln -s "$SRC/analysis-checklist.md" "$DEST/analysis-checklist.md"
   ln -s "$SRC/design-quality.md" "$DEST/design-quality.md"
   ln -s "$SRC/writing-style.md" "$DEST/writing-style.md"
   ln -s "$SRC/stages" "$DEST/stages"
   ln -s "$SRC/templates" "$DEST/templates"
   ```

4. Reload the window or open a new Agent chat, then invoke `/spec-local`.

Use `/spec` for the installed plugin/user skill and `/spec-local` for this checkout. Edits under `stages/`, `templates/`, and the linked markdown files show up through the symlinks. Changes to `SKILL.md` itself must be re-copied into the project (with `name: spec-local` kept) because that file is not symlinked.

Do not commit `.cursor/skills/spec-local/` to the project unless the team wants that layout shared.

## License

MIT. See [`LICENSE`](LICENSE).
