# Loose ideas before creating actual specs

Ideas for before moving into specs.

Once promoted to a spec - we should remove it entirely from here.

## Skip processed

It should be possible to skip tech specs or implemeation plan for smaller tasks.

Problem:
Using this system to create smaller features is cumbersome: you have to go through several iterations for each spec file and often ends up taking longer than just implementing it manually.

Goal:
Find a way to to create small specs by skipping steps / files in the spec creation process - even down to only the spec.md file that includes everything needed.

Investigation:
How can we do this in a good way. One way could be to make an analysis either before creating the first spec doc or after. So add a pre- or post- analysis to the create spec process that evaluates the need for spec depth. This could result in giving the programmer some options.

## use spec slug for file name and cursor plan for implementation plan

When working with several specs, it is hard to see which spec an open file belongs to as they have the same names.

We could solve this by using the slug name as the first part of the spec:
[slug].spec.md
[slug].business-logic.md
...

We should see if we can shorten / abbreviate the long files for easier tab reading.

We may also benefit from using the cursors built in plan format as the implementation plan. I think all we need to do is use the .plan.md extension. In that case this fits with the above.

## Init project for spec

Today a programmer must manually fill out placeholders in the /spec_docs/README.md file. This should be automated.

When initting the project instead of just writing the README.md and leaving the placeholders, ask the user if the agent should fill them out automatically. 

When asking list the placeholders so the user can also write some of the things them selves in the agent chat

## REadme file for this project still needs TLC

Missing:
- Docs about the spec_docs folder.
- Better docs on how to write specs - the iterations, process etc.

## Create GHA for updating the plugin on the market place

Investigate

## Still to much info for small specs

Take a look at the init-readme-fill - I think is a good example of where there the specs are too bloated. 
We should investigate this and see if we could learn from this anything that could help shorten future processes.