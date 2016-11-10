
module material;

import Collidable;

/++
Extendible class which allows for modifiable responses to collisions and events
++/
abstract class Material {
  
  /++
  owner has this material, other is the one owner is overlapping
  ++/
  void overlap(Collidable owner, Collidable other){}
  void update(long time, float dt){}
}