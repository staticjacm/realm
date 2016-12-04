
module material;

import wall;
import agent;
import ground;

/++
Extendible class which allows for modifiable responses to collisions and events
++/
abstract class Material {
  
  /++
  owner has this material, other is the one owner is overlapping
  ++/
  void overlap(Agent owner, Agent other){}
  void collide(Agent owner, Wall wall){}
  void over(Agent owner, Ground ground){}
  void update(){}
}