
module material;

import wall;
import entity;
import shot;
import drop;
import agent;
import validatable;
import ground;

/++
Extendible class which allows for modifiable responses to collisions and events
++/
abstract class Material : Validatable {
  
  Agent agent;
  
  this(){ super(); }
  
  /++
  owner has this material, other is the one owner is overlapping
  ++/
  void collide(Entity other){}
  void collide(Shot other){}
  void collide(Drop other){}
  void collide(Agent other){}
  void collide(Wall wall){}
  void over(Ground ground){}
  void update(){}
}