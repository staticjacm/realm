module effect;

import sllist;
import entity;

class Effect_list : LList!Effect {}

/*
  Does something when updated and attached to an entity
*/
class Effect {
  
  Entity entity;
  Effect_list.Index entity_index;
  
  this(){}
  ~this(){
    entity_index.remove;
  }
  
  void update(){}
  void initialize(){}
}