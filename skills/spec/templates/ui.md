<!-- Author guidance is in HTML comments. Strip every HTML comment when writing the doc. {{…}} is fill-in. Follow writing-style.md in the skill folder. -->

<!-- Seed basename ui.md stays on disk (R6). Emitted filename is {{feature-slug}}.ui.md. Write this after reading each module in {{feature-slug}}.spec.md Touched paths. Each surface and screen state names the component file it is expected to change, and the existing component when there is one. Follow the patterns already in those files. Interactions and states are binding; paths and wireframes are advisory. A behaviour {{feature-slug}}.spec.md did not decide is a Q item there, pointed at with > **Open:** Q1 (short name). Do not fill the gap here. -->

# {{Feature title}} — UI

> Created because: {{one line}}

Layout and interaction for **{{feature-slug}}**. [{{feature-slug}}.spec.md](./{{feature-slug}}.spec.md) owns scope, journeys, and decisions; cite them in full form (`see D3 (short name)`).

Read **Stack notes for spec docs** in `spec_docs/README.md` before filling this file. Do not guess component props.

**Design reference:** {{Figma link, screenshot path, or "none"}}

## TL;DR

<!-- required. At most three one-line bullets. -->

- {{…}}

## Journey steps covered

<!-- required when spec.md has user journeys. Every journey step that touches a screen appears once. -->

| Journey | Step | Surface | State |
| ------- | ---- | ------- | ----- |
| {{journey title}} | {{n}} | {{surface}} | {{state, or —}} |

## Principles

<!-- include when: a constraint is specific to this feature. Do not restate general UI rules. -->

- {{…}}

## Information architecture

<!-- required -->

| Surface | Route / location | Route name | Auth | Iframe | Change |
| ------- | ---------------- | ---------- | ---- | ------ | ------ |
| {{view or panel}} | {{path, or where it opens from}} | {{ROUTE_NAMES value, or —}} | {{required / opt-out / —}} | {{behaviour, or n/a}} | {{what changes}} |

## {{Surface}}

<!-- required. Repeat this section per surface. -->

**Location / opens from:** {{…}}

**Component:** `{{path}}` — {{extend `ExistingComponent`, or new because: one-line reason}}

### Layout

{{structure}}

### Interactions

<!-- Binding. -->

| Action | Control | Result |
| ------ | ------- | ------ |
| {{action}} | {{control}} | {{result}} |

### States

<!-- Binding. Write n/a when a state cannot happen. Name the component or composable that renders or sets the state when it is not the surface component. -->

- **Empty:** {{copy and next step}}
- **Loading:** {{… or n/a}}
- **Error:** {{inline or toast, and the copy}}
- **No permission:** {{… or n/a}}
- **Success:** {{feedback, or n/a}}

### Copy

<!-- include when: the surface has user-facing strings -->

| String | i18n key |
| ------ | -------- |
| {{exact copy}} | {{key, or —}} |

### Wireframe

<!-- include when: the layout is easier to show than to describe. Advisory. -->

```
{{rough layout}}
```

### Components to reuse

<!-- include when: an existing component is reused -->

| Component | Location | Usage |
| --------- | -------- | ----- |
| {{name}} | `{{path}}` | {{about 10 words}} |

## Accessibility

<!-- include when: focus, labels, or reduced motion need more than the Accessibility line in spec.md Constraints -->

- {{…}}

## Responsive

<!-- include when: a breakpoint or a mobile deferral changes the layout -->

- {{…}}
