module effect;

import sllist;
import validatable;
import entity;
import shot;
import drop;
import agent;
import wall;
import ground;

class Effect_list : LList!Effect {}

/*
  Does something when updated and attached to an entity
*/
class Effect : Validatable {
  
  Entity entity;
  Effect_list.Index entity_index;
  
  this(){}
  ~this(){
    entity_index.remove;
  }
  
  void update(){}
  void initialize(){}
  void finalize(){}
  
  void collide(Entity other){}
  void collide(Shot other){}
  void collide(Drop other){}
  void collide(Agent other){}
  void collide(Wall wall){}
  void over(Ground ground){}
}