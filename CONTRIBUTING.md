# Contributing

Thanks for helping with Spec. This repo is a Cursor plugin that ships the `/spec` skill — not an npm package.

By participating, you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## Ways to contribute

- **Bugs** — skill stages that skip a gate, wrong Depth/Kind behaviour, or install/discovery issues. Use the Bug report issue template.
- **Ideas** — clearer stage copy, better templates, or workflow gaps. Use the Feature request template.
- **Docs** — README, `spec_docs/README.md`, or stage markdown that confuses humans or agents.
- **Code / skill changes** — edits under `skills/spec/` (stages, templates, checklists) and small supporting scripts.

Prefer a focused PR over a large rewrite. Open an issue first if the change would alter gates, Depth paths, or Kind semantics.

## Development setup

Requires [Cursor](https://cursor.com) 2.5+.

### Try skill changes in another project

When the Spec plugin (or user-level `spec` skill) is already installed, Cursor will not reliably prefer a project copy that reuses the same skill name. A bare symlink of `skills/spec` into a project also fails when the folder name and frontmatter `name` disagree.

1. In the target project, create `.cursor/skills/spec-local/` as a **real directory** (not a symlink of the whole skill folder).
2. Copy `skills/spec/SKILL.md` into that directory and set frontmatter so `name` matches the folder:

   ```yaml
   ---
   name: spec-local
   description: >-
     LOCAL DEV copy of the spec skill. Invoke with /spec-local.
   disable-model-invocation: true
   ---
   ```

3. Symlink the shared assets from this repo:

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
   ln -s "$SRC/scripts" "$DEST/scripts"
   ```

4. Reload the window or open a new Agent chat, then invoke `/spec-local`.

Use `/spec` for the installed plugin/user skill and `/spec-local` for this checkout. Edits under `stages/`, `templates/`, `scripts/`, and the linked markdown files show up through the symlinks. Changes to `SKILL.md` itself must be re-copied into the project (with `name: spec-local` kept) because that file is not symlinked.

Do not commit `.cursor/skills/spec-local/` unless the team wants that layout shared.

### Update the user-level skill from this checkout

```bash
./scripts/update-user-spec-skill.sh
```

Use `--dry-run` to preview, `--yes` to skip delete prompts. Reload the window afterward. This does not change a Spec plugin install under `~/.cursor/plugins/`.

### Install from GitHub (smoke-test)

```text
/add-plugin spec-skill-set@https://github.com/Funder75/spec-skill-set
```

GitHub installs can stay pinned to the first-install commit; see the README **Updates** section if you need a newer revision.

## Pull requests

1. Branch from `main`.
2. Keep the diff scoped — one concern per PR when practical.
3. Match existing stage and template style (gates stay explicit; do not invent process in tip bullets alone).
4. If you change agent behaviour, update the relevant file under `skills/spec/stages/` (or related skill docs), not only the top-level README.
5. Fill out the PR template and link any related issue.

## Security

Do not open public issues for vulnerabilities. See [SECURITY.md](SECURITY.md).

## Questions

Use [GitHub Issues](https://github.com/Funder75/spec-skill-set/issues) for discussion. For usage of `/spec` inside a project, start with that project's `spec_docs/README.md` and this repo's [README](README.md).
