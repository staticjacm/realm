# To Do:

# Boring To dos:

* Test entity is stopping attacking like it should after losing target then regaining it

* Initialization seems to takes a strangely long time for some reason. This is a problem for every initialization function, apparently. It might not actually be being slowed by anything, the algorithms might just suck

* Agent friction increases when fps is low.
* When screen loses focus and then gains focus (or something like that) the frame_delta is fuckin huge and... well you can imagine the consequences

* Organize and implement a scheme for slowed / delayed updating of certain objects. For example: areas outside the view can be updated less often than areas inside the view. Only update agents every 0.1 ms, or whatever timing makes sense.

* ``core.exception.InvalidMemoryOperationError@src\core\exception.d(693): Invalid memory operation`` Doesn't apparently hurt anything but it is annoying. Happens at shutdown


# Future To Dos:

* Content

* Make apply_raycast actually work for Agent.move_by;

* Find a different compiler for release builds. Supposedly the gnu compiler produces much faster binaries than dmd


# Possible To Dos:

* Put all image / audio loading into its own module

# Already done:

* The ``Thread.sleep`` call should be adjusted every frame to maintain a constant fps (could also include a switch for unbound fps)

* Agents always experience four (4) collisions when colliding with an agent - two when agent A detects a collision with agent B (A.overlap(B), B.overlap(A)), and two when B detects a collision with agent A (B.overlap(A), A.overlap(B)). This can easily be avoided by only overlapping if one agents id is larger than the others, and detecting if the other will detect a collision with this one by checking its size. Note: this is probably solved, but I may have overlooked something.

* New collision system doesn't work lol
* Squares aren't going to cut it for collision detection when dealing with rotating objects. Implement a generic collision detection scheme for more precise collision shapes (which are guaranteed to be a contained in the agent's collision square) - can use virtual functions

* Replacing the testing fire_staff_1 produced fireball1 shots with rocket1's causes a strange lag after awhile

* Animation depth rendering isn't working properly again?

* GUI displaying stats
* GUI displaying items
  * Sample items
* GUI displaying accessory
  * Sample accessory
* GUI displaying weapon
  * Sample weapon
* GUI displaying armor
  * Sample armor
* GUI displaying hp
* GUI displaying energy

* World building through maps

* Text rendering

* Add entity ai controls

* Implement way to get all agents inside of a region

* Ground should be responsible for friction

* Write status_effect module

* Write Shot stats
* Implement functions which do damage to entities, shots, walls, grounds, etc

* Write Entity stats

* Write Drop module
* Write Item module
* Write Weapon module
* Write Accessory module
* Write Armor module
* Write Structured Entity module
* Write Metaobject module
* Write Decoration module

* Add Agent.create_shot for convenience

* Convert regular_attack to regular_attack_start, regular_attack_end for prolonged/held attacks
* Fix player.player_mouse_click_function so that left, right and middle clicks are registered correctly

* Combine generate and generate_adjacent

* Add effects due to height (shadow, higher y, etc)

* Some types have static initialize and some have static initialize_type, convert the latter to static initialize

* Find and implement a sound library

* World.update is slow because World.update's timing varies proportionally to the number of Areas in World. The timing of one Area.update is around 0.003 ms. Ideally there should be less than 1000 areas updating at any one time. Implement an updating scheme similar to Rooted.update_list. Area list now at 0.3 ms/frame latent. game.render() varies with number of areas. This delay is coming from world.render

* Add a function in Area and ground for when agent newly enters the area, and for when it leaves

* Fix shots freezing and not updating. All shots freeze independent of the rest of the game freezing. They freeze whenever one of them is destroyed. All agents after the deleted object in the Agent.master_list llist are frozen. It turns out that it was an extremely simple fix - llist.opApply didn't remember cel's next element and so when agent.update was called (which destroyed the agent and its master_list.index) cel's next was set to null, stopping the whole opApply until the next go 1 frame later.

* Create a master list of updating rooteds - most rooteds will not be updating every frame

* Move all global game related stuff into its own module
* Incorporate time, frame delta etc into game module

* Make it so that Agents can't push through solid objects by constantly accelerating towards them (just move the agent to the solid object's boundary when a collision takes place)

* Write agent-agent collision detection loop and test it with a test agent

* Render only whats in the view 

* Agent-wall, agent-ground collisions
