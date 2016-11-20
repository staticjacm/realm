
module shot;

import vector;
import entity;
import agent;

alias Vector2f = Vector2!float;

/++
An agent that is primarily intended to exchange information between entities
++/
class Shot : Agent {
  
  this(Vector2f _position, float _size){
    super(_position, _size);
  }
  
  void initialize(Entity entity){}
  
  override void destroy(){
    super.destroy;
  }
  
  override int agent_subtype_id(){ return 2; }
  int shot_subtype_id(){ return 0; }
  
}