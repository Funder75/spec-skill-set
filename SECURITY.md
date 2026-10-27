# Security policy

## Supported versions

Security fixes are applied on the latest commit on `main`. There are no long-lived release branches yet.

## Reporting a vulnerability

Please **do not** open a public GitHub issue for security reports.

Prefer one of:

1. **[GitHub private vulnerability reporting](https://github.com/Funder75/spec-skill-set/security/advisories/new)** (preferred) — use *Report a vulnerability* on the Security tab.
2. Email **dan@oakhillgames.com** with a short description, impact, and steps to reproduce if you have them.

You should get an acknowledgement within a few days. If the report is accepted, we will work on a fix and credit you if you want that. If it is declined, we will say why.

## Scope

In scope for this repository:

- The Cursor plugin and `/spec` skill content under `skills/spec/`
- Scripts in this repo that run on a contributor or maintainer machine
- Supply-chain concerns in published plugin metadata (for example misleading install instructions that could lead users to a malicious fork)

Out of scope:

- Third-party tools the skill mentions (Cursor, Linear, GitHub, and so on)
- Misuse of the skill to generate insecure application code in a consumer project — report that in the consumer project when it matters
- Social engineering or physical attacks

## Disclosure

We aim to fix confirmed issues promptly and disclose after a fix is available on `main`, unless coordinated disclosure needs more time.
