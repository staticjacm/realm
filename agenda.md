
# To do:

* Agents always experience four (4) collisions when colliding with an agent - two when agent A detects a collision with agent B (A.overlap(B), B.overlap(A)), and two when B detects a collision with agent A (B.overlap(A), A.overlap(B)). This can easily be avoided by only overlapping if one agents id is larger than the others, and detecting if the other will detect a collision with this one by checking its size
* Squares aren't going to cut it for collision detection when dealing with rotating objects. Implement a generic collision detection scheme for more precise collision shapes (which are guaranteed to be a contained in the agent's collision square) - can use virtual functions

* Organize and implement a scheme for slowed / delayed updating of certain objects. For example: areas outside the view can be updated less often than areas inside the view. Only update agents every 0.1 ms, or whatever timing makes sense.
* The ``Thread.sleep`` call should be adjusted every frame to maintain a constant fps (could also include a switch for unbound fps)

* Move all global game related stuff into its own module

* Write Item module
* Write Weapon module
* Write Accessory module
* Write Armor module
* Write Drop module
* Write Structured Entity module

* ``core.exception.InvalidMemoryOperationError@src\core\exception.d(693): Invalid memory operation`` Doesn't apparently hurt anything but it is annoying. Happens at shutdown

* Find and implement a sound library

# Possible To Dos:

* Agent.size could be an overridable function instead of a variable

* There should be some way to get all agents, rooted etc in a region - a way to check overlaps within an arbitrary area of space


# Already done:

* Add a function in Area and ground for when agent newly enters the area, and for when it leaves

* Fix shots freezing and not updating. All shots freeze independent of the rest of the game freezing. They freeze whenever one of them is destroyed. All agents after the deleted object in the Agent.master_list llist are frozen. It turns out that it was an extremely simple fix - llist.opApply didn't remember cel's next element and so when agent.update was called (which destroyed the agent and its master_list.index) cel's next was set to null, stopping the whole opApply until the next go 1 frame later.

* Create a master list of updating rooteds - most rooteds will not be updating every frame

* Incorporate time, frame delta etc into game module

* Make it so that Agents can't push through solid objects by constantly accelerating towards them (just move the agent to the solid object's boundary when a collision takes place)

* Write agent-agent collision detection loop and test it with a test agent

* Render only whats in the view 

* Agent-wall, agent-ground collisions
