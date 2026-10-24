<!-- Author guidance is in HTML comments. Strip every HTML comment when writing the doc. {{…}} is fill-in. Follow writing-style.md in the skill folder. -->

<!-- Write this after reading each module in spec.md Touched paths. Each type, command, and contract names the file it is expected to change, and the existing symbol when there is one. A new symbol names the file it will be added to, following that package's folder layout. Follow the patterns already in those files. Field tables are binding; paths and sketches are advisory. A behaviour spec.md did not decide is a Q item there, pointed at with > **Open:** Q1 (short name). Do not fill the gap here. -->

# {{Feature title}} — contracts

> Created because: {{one line}}

Types, API contracts, state ownership, and storage for **{{feature-slug}}**. [spec.md](./spec.md) owns scope and decisions; cite them in full form (`see D3 (short name)`).

Read **Stack notes for spec docs** in `spec_docs/README.md` before filling this file.

## TL;DR

<!-- required. At most three one-line bullets. -->

- {{…}}

## Summary of changes

<!-- include when: more than one layer changes -->

| Layer | Change | Lands in | Persisted? |
| ----- | ------ | -------- | ---------- |
| {{types / contract / state / schema}} | {{about 10 words}} | `{{path}}` | {{yes / no}} |

## Existing types reused

<!-- include when: an existing type is reused. No changes unless noted. -->

| Type | Location | Usage in this feature |
| ---- | -------- | --------------------- |
| `{{TypeName}}` | `{{path}}` | {{about 10 words}} |

## Types and fields

<!-- include when: types change. The table is binding. -->

### `{{TypeName}}`

**Lands in:** `{{path}}` — {{extend `ExistingSymbol` / new}}

{{purpose}}

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| {{…}} | {{…}} | {{yes / no}} | {{rule, or —}} | {{user / API / derived}} |

<!-- include when: the shape would otherwise be ambiguous. Advisory — the table above is the contract. Match the style of the target file. -->

```ts
export interface {{TypeName}} {
  // {{fields}}
}
```

## Commands

<!-- include when: a command or use-case is added or changed -->

| Name | Lands in | Validates | Mutates |
| ---- | -------- | --------- | ------- |
| `{{Name}}` | `{{path}}` | {{R1 (short name)}} | {{…}} |

### `{{Name}}`

{{purpose}}

**Payload** (binding):

| Field | Type | Required | Validation | Source |
| ----- | ---- | -------- | ---------- | ------ |
| {{…}} | {{…}} | {{yes / no}} | {{…}} | {{…}} |

**Side effects:**

- {{…}}

## External contracts

<!-- include when: the feature calls or changes an API, storage, or message. Binding. One subsection per contract. -->

### {{Client method, route, or store}}

- **Kind:** {{API / storage / message}} · **Lands in:** `{{path}}` › `{{symbol}}`
- **Request:** {{shape}}
- **Response:** {{shape}}
- **Boundary validation:** {{schema or guard, and where it runs}}
- **Errors:** {{how each failure maps to the caller, and the function that handles it}}

## State ownership and lifecycle

<!-- include when: the feature holds state -->

| State | Owner | Load | Refresh | Invalidate | Persisted? |
| ----- | ----- | ---- | ------- | ---------- | ---------- |
| {{…}} | `{{path}}` › `{{composable or component}}` | {{when}} | {{when, or —}} | {{when, or —}} | {{yes / no}} |

## Persistence changes

<!-- include when: schema, migration, or access control changes. Omit subsections that do not apply. -->

### {{Store or table}}

**Lands in:** `{{path}}`

| Column / path | Type | Purpose |
| ------------- | ---- | ------- |
| {{…}} | {{…}} | {{about 10 words}} |

<!-- include when: a sketch helps. Advisory — the table above is the contract. -->

```
{{schema sketch}}
```

### Access control

- {{policy or isolation rule}}

### Migration

1. {{order: add, backfill, enforce}}
2. {{rollback}}

## Rollout and compatibility

<!-- include when: an API version, a stored shape, or a feature flag changes -->

- {{…}}
