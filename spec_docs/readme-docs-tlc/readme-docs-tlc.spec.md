---
work_item: n/a
tracker_spec_url: n/a
document_id: n/a
document_url: n/a
---

# Project README docs TLC

**Progress:** plan
**Depth:** lite
**Depends on:** —

## TL;DR

- **What:** Strengthen the project README so newcomers understand `spec_docs/`, how to write and iterate specs, and practical tips.
- **Why:** Root README is install-and-actions thin; process and tips live only in `spec_docs/README.md` or nowhere.
- **v1 includes:** Root README folder docs, write/iterate process, tips list fed by an archive pass, light cross-links.
- **v1 excludes:** Skill edits, marketplace GHA, spec-bloat process changes, conventions placeholder fill.

## Doc index

| Doc | Read for | Present? |
| --- | -------- | -------- |
| This file (`readme-docs-tlc.spec.md`) | Scope, goals, journeys, constraints, work split | yes |
| readme-docs-tlc.logic.md | Rules, workflows, state transitions | not needed |
| readme-docs-tlc.contracts.md | Types, API contracts, state ownership, storage | not needed |
| readme-docs-tlc.ui.md | Layout, interaction, states, copy | not needed |
| [readme-docs-tlc.plan.md](./readme-docs-tlc.plan.md) | Phases and phase status | yes |

## Source

> `spec_docs/todos.md` § "Readme file for this project still needs TLC" (folder docs, write process, archive investigate, tips). Design chat: slug `readme-docs-tlc`; Depth lite; root README primary; archive pass feeds tips; no skill edits.

## Problem and current behaviour

**In short:** The project README ships the plugin and lists `/spec` actions, but does not teach the folder or the writing loop. Tips are missing.

- **Root README is thin.** Install, short action list, Linear, and local contrib. Full workflow is a single link to `spec_docs/README.md`.
- **`spec_docs/README.md` already explains gates.** Folder roles, Depth paths, markers, and conventions live there. Root readers may never open it.
- **Archive holds prior lessons.** Finished specs under `spec_docs/archive/` are not mined into tips or process prose.
- **Todo called out four gaps.** Docs about `spec_docs/`, better write/iterate process, archive investigate, and a tips list.

| Path | What it does today |
| ---- | ------------------ |
| `README.md` | Plugin intro, use list, Linear, contrib |
| `spec_docs/README.md` | Folder roles, Depth, markers, conventions |
| `spec_docs/archive/` | Finished specs; not summarized for tips |
| `spec_docs/todos.md` | Source note for this work |

## Goals and acceptance criteria

### G1 (folder docs) — Project README explains what `spec_docs/` is for

Source: todos.md

- A reader of the root README learns the folder's role without opening the skill.
- Layout of active specs vs `archive/` is stated in plain words.
- A clear link points to `spec_docs/README.md` for gates and conventions.

### G2 (write process) — Project README covers how authors write and iterate specs

Source: todos.md

- Create → iterate design → promote → plan → implement one phase → archive is described for humans.
- Depth (`lite` / `standard` / `full`) is named so authors know the path can be short.
- The prose does not replace or contradict `spec_docs/README.md`.

### G3 (tips list) — Project README includes practical tips, informed by the archive

Source: todos.md

- A short tips section helps authors use the system well.
- At least one tip is grounded in something noticed while reading `spec_docs/archive/` (or the tips section notes that the pass found nothing new).
- Tips stay advisory; they do not invent new skill rules.

## Non-goals

- Editing `skills/spec/` stages, templates, or `SKILL.md`.
- Marketplace / GHA plugin publish work (separate todo).
- Spec-bloat process changes drawn from `init-readme-fill` as a skill change (separate todo).
- Filling remaining `{{…}}` under Project conventions › Other commands.
- Republishing whole archived specs into the README.

## Users and context

- **Primary user:** A programmer installing or using the Spec plugin in a project.
- **When:** First open of the repo README, or when they want to start writing specs.
- **Who may do this:** Anyone with repo read access; authors edit README via normal PR flow.

## User journeys

### Discover the workflow from the project README

Starting point: A programmer opens the repo README to learn how Spec works.

1. They see what `spec_docs/` is and where finished work goes.
2. They skim how to write and iterate (create through archive), including Depth.
3. They read a short tips list and follow the link into `spec_docs/README.md` when they need gates or conventions.

End state: They know where to put work and how the loop runs before invoking `/spec`.

Goes wrong when:

- Root README stays action-list only — G1 (folder docs) and G2 (write process) fail.
- Tips invent skill behaviour that is wrong — G3 (tips list) fails.

Covers: G1 (folder docs), G2 (write process), G3 (tips list)

### Screen depth (UI-primary)

- **Layout regions:** Root README sections for folder overview, write/iterate process, and tips (plus existing install / Linear / contrib).
- **Main interactions:** Read and follow links into `spec_docs/README.md`.
- **Empty / error:** If the archive pass finds no new tip material, the tips section still ships with useful general tips and notes that the pass added nothing new.
- **Glance vs control:** n/a — documentation only.

## Constraints

- **Preserve:** Existing install, Linear, and local-contrib sections stay accurate unless a cross-link requires a small wording fix.
- **i18n:** n/a
- **Accessibility:** Markdown headings stay skimmable; no image-only content required.
- **Security:** n/a
- **Performance:** n/a

## Notes

- **Archive path name.** The todo said `spec_docs/archived`; the real folder is `spec_docs/archive/`.
- **`spec_docs/README.md` is already strong.** Prefer root README expansion and light cross-links over a rewrite of that file.

## Proposed solution

Expand the root `README.md` with three human-facing blocks: what `spec_docs/` is, how writing and iterating works (including Depth), and a tips list. Before drafting tips, skim finished specs under `spec_docs/archive/` and keep only durable advice. Keep `spec_docs/README.md` as the detailed gate reference; adjust it only if a cross-link or one-line pointer would otherwise contradict the root.

The matching section was removed from `spec_docs/todos.md` when this folder was created.

## Touched paths

| Path | Area | Change |
| ---- | ---- | ------ |
| `README.md` | docs | Folder, process, and tips sections |
| `spec_docs/README.md` | docs | Cross-link polish only if needed |
| `spec_docs/todos.md` | docs | Source item removed at create |
| `spec_docs/archive/` | docs | Read-only pass for tips |

## Work split

1. **Archive pass and README prose.** Covers G1 (folder docs), G2 (write process), G3 (tips list). Outcome: root README teaches folder, loop, and tips. Main surface: docs.

## Decisions

### D1 (root primary) — Root README is the primary surface; `spec_docs/README.md` stays the detailed reference

- **Date:** 2026-10-25 · **Area:** docs
- **Why:** The todo names the project README; `spec_docs/README.md` already covers gates.
- **Rejected:** Rewriting `spec_docs/README.md` as the main deliverable

### D2 (no skill edits) — Documentation only; do not change the skill

- **Date:** 2026-10-25 · **Area:** docs
- **Why:** Gaps are human-facing docs, not missing agent behaviour.
- **Rejected:** Encoding tips as new skill rules in this spec

### D3 (tip count) — Tips section is about 5–8 short bullets

- **Date:** 2026-10-25 · **Area:** docs
- **Why:** Matches G3 (tips list) “short tips”; skim-friendly for the root README.
- **Rejected:** Longer essay-style tips section (B)
