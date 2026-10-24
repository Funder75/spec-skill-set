# Spec

A Cursor plugin that ships the spec skill: design, technical specs, an implementation plan, then one phase at a time.

This repository is the plugin. It is not an npm package. Marketplace listing is a later step. Until then, load it as a local Cursor plugin.

## Install locally

Cursor does not load a plugin just because the repo is open. It also skips a symlink whose target sits outside the local plugins folder. Copy the plugin, then reload.

1. Copy this repository into `~/.cursor/plugins/local/spec-skill-set`. The manifest must be at `.cursor-plugin/plugin.json` inside that folder.
2. Reload the window (`Developer: Reload Window`) or restart Cursor.
3. Open Customize and confirm the Spec plugin and the `spec` skill are listed.

After you change this repository, copy it into that folder again and reload. Cursor keeps running the copy it already loaded.

On an Enterprise account, local plugin imports are off until an admin allows them (Marketplace and Plugins, Allow Local Plugin Imports).

Opening this repo in Cursor does not replace a copy you already keep in the user skill store. After you load the plugin, treat this repository as the copy Cursor should follow. Stop editing only the older user-level skill, or the two copies will drift.

## What is in v1

The packaged skill matches the current spec workflow. It does not add brainstorming changes, session hooks, git worktrees, or automatic commits.

A later design, `adapt-superpowers`, is reserved for those workflow changes. It is not in this repository yet.

## Layout

```text
.cursor-plugin/plugin.json   plugin manifest
skills/spec/                 the spec skill
spec_docs/                   this repo's own specs
```

## License

MIT. See `LICENSE`.
