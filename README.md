# Spec

A Cursor plugin that ships the `/spec` skill: a gated workflow from design → technical specs → implementation plan → one phase at a time, then archive.

This repository is the plugin (not an npm package). Install it from the Cursor Marketplace with `/add-plugin`.

## Getting started

1. In Cursor, run `/add-plugin` and install **Spec** (`spec-skill-set`).
2. Open Customize and confirm the Spec plugin and the `spec` skill are listed.

## How to use

In a project that has (or will have) `spec_docs/`, invoke the skill with `/spec` (or say “spec”).

Main actions:

- Create a spec
- Promote to tech specs
- Promote to an implementation plan
- Implement the next phase
- Archive when done

`/spec help` points at the project’s `spec_docs/README.md` when that file exists.

Create-spec runs dialogue and chat approval before writing `spec.md`. Plans use guided Approach (not pasteable full code). The skill does not create branches, worktrees, or commits unless you ask.

For the full workflow, gates, and project conventions, see [`spec_docs/README.md`](spec_docs/README.md).

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
