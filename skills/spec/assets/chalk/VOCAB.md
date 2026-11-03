# Chalk vocabulary (for wireframe generation)

Source: chalk-css / okatarismet/chalk **v0.2.0** (see `VERSION`). Read this file when writing `<slug>.wire.html`. Do not invent classes.

## Constraints

- Complete HTML file; link stylesheet as `<link rel="stylesheet" href="https://unpkg.com/chalk-css@0.2.0/chalk.css">` (pin must match `VERSION`).
- Use only `wf-*` class names from the vocabulary below (plus documented modifiers such as `.primary`, `.active`).
- No custom CSS. No `<style>` blocks. Inline `style` only for `width` and `min-height`.
- Black and white only — no color values.
- Sketch, not product UI. Prefer boxes and labels over polish.
- Show **default**, **empty**, and **error** states side by side (or clearly labeled sections) when the feature has those states.

## Vocabulary (prefix: `wf-`)

Layout: screen, centered, row, col, layout, spacer, grid (cols-2 / cols-3 / cols-4)

Shell: nav, topbar, sidebar (.wide / .narrow), main, panel, panel-header

Typography: h1, h2, h3, h4, label, text, muted, placeholder, annotation, code, link

Box / card: box (.shaded / .dashed / .ghost), card (.compact), card-title, card-meta, card-footer, stat

Forms: input (.large / .error), textarea, select, searchbar, field, field-error, checkbox (.checked), radio (.selected), toggle (.on)

Buttons: btn (.primary / .secondary / .ghost / .danger / .sm / .lg / .full / .icon), btn-group

Badges: badge (.dark / .outline / .pill / .dot)

Table: table (.compact)

Navigation: tabs, tab-bar (.tab, .tab.active), tab-content, breadcrumb (.crumb, .sep), pagination (.page, .page.active, .page.disabled)

Feedback: alert (.info / .warning / .error / .success), progress (.track, .fill), stepper (.step, .step-circle, .step-label, .step-line), toast (.dark), empty (.empty-icon, .empty-title, .empty-text)

Kanban: kanban, kanban-col (.col-header, .col-body), kanban-card (.card-id)

Timeline: timeline, timeline-item, timeline-dot (.filled), timeline-body, timeline-title, timeline-time, timeline-text

Modal: modal-backdrop, modal (.modal-header, .modal-title, .modal-close, .modal-body, .modal-footer)

Media: img, video, avatar (.sm / .lg / .xl / .square), avatar-group

Utility: divider (.light / .dashed), note, redline, blueline

## Do not

- Write Tailwind, Bootstrap, or product-app classes.
- Resolve Open questions by guessing layout the user has not settled.
- Put binding interactions, copy tables, or acceptance criteria only in the HTML — those stay in `<slug>.spec.md` / `<slug>.ui.md`.
