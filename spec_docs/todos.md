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

## Readme file for this project still needs TLC

Missing:
- Docs about the spec_docs folder.
- Better docs on how to write specs - the iterations, process etc.

## Create GHA for updating the plugin on the market place

Investigate
See:
https://cursor.com/docs/plugins#creating-plugins
https://agent-plugins.org/plugin-authors/build-an-agent-plugin

## Still too much details for small specs - spec bloat

Take a look at the init-readme-fill - I think is a good example of where there the specs are too bloated. 
We should investigate this and see if we could learn from this anything that could help shorten future processes.
