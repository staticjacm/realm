
# To do:

* Find a sound library

* Move all global game related stuff into its own module

* Incorporate time, frame delta etc into game module

* Write Item module
* Write Weapon module
* Write Accessory module
* Write Armor module
* Write Drop module
* Write Structured Entity module




# Already done:

* Write agent-agent collision detection loop and test it with a test agent

* Render only whats in the view 

* Agent-wall, agent-ground collisions



# Possible To Dos:

* Agent.size could be an overridable function instead of a variable

* Integrate global frame delta variable, global time variable - so that these don't need to be passed down every time

* There should be some way to get all agents, rooted etc in a region - a way to check overlaps within an arbitrary area of space