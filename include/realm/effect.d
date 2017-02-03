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
  
  string name(){ return "effect"; }
  string description(){ return "An undefined effect"; }
  string standard_article(){ return "an"; }
  
  void update(){}
  void initialize(){}
  void finalize(){}
  void kill(){}
  
  void collide(Entity other){}
  void collide(Shot other){}
  void collide(Drop other){}
  void collide(Agent other){}
  void collide(Wall wall){}
  void collide(Ground ground){}
}