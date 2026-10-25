# Loose ideas before creating actual specs

## Skip processed

It should be possible to skip tech specs or implemeation plan for smaller tasks.

Problem:
Using this system to create smaller features is cumbersome: you have to go through several iterations for each spec file and often ends up taking longer than just implementing it manually.

Goal:
Find a way to to create small specs by skipping steps / files in the spec creation process - even down to only the spec.md file that includes everything needed.

Investigation:
How can we do this in a good way. One way could be to make an analysis either before creating the first spec doc or after. So add a pre- or post- analysis to the create spec process that evaluates the need for spec depth. This could result in giving the programmer some options.

## Use a multiple sub agent process

Superpowers have the ability process the impllemtation plan using parralel sub processors.
For some design this may be a good way, for others not. We have create a system that enables this.

In general we also need to prepare this system for using in cloud agents.

Investigate how superpowers does this.

**Investigation (25 Oct 2026):** [investigations/multi-subagent.md](./investigations/multi-subagent.md) — Direction settled: serial Superpowers-style SDD (fresh context per phase, required review subagent); one-phase stays in parent; parallel implementers rejected; Combinable stays same-session; cloud = brief + env (Linear later). Gap is policy flip + phase brief, not a parallel runner. Ready to promote to a spec.

## Integrate with Linear

Goal:
Have a deep integration with linear so that  it is possible to:
- Create a spec from a Linear issue
- Create subtask in linear from a spec
- Update progress and status in linear according to the spec progress
- Being able to start a cursor cloud agent to implement a spec

Concerns:
We have to make sure that the spec in the repo and the linear issues are not out of sync. This is especially a concern while reviewing / changing the spec. This is high priority that we solve this - if not it is may be a deal breaker

Investigation:
See [linear-integration-investigation.md](./linear-integration-investigation.md) (2026-10-25). Pre-spec; sync doctrine is the blocking decision.

## use spec slug for file name and cursor plan for implementation plan

When working with several specs, it is hard to see which spec an open file belongs to as they have the same names.

We could solve this by using the slug name as the first part of the spec:
[slug].spec.md
[slug].business-plan.md
...

We may also benefit from using the cursors built in plan format as the implementation plan. I think all we need to do is use the .plan.md extension. In that case this fits with the above.

## Init project for spec

Today a programmer must manually fill out placeholders in the /spec_docs/README.md file. This should be automated.

When initting the project instead of just writing the README.md and leaving the placeholders, ask the user if the agent should fill them out automatically. 

When asking list the placeholders so the user can also write some of the things them selves in the agent chat

## REadme file for this project still needs TLC

Missing:
- Docs about the spec_docs folder.
- Better docs on how to write specs - the iterations, process etc.