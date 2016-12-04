
module shot;

import vector;
import entity;
import agent;

alias Vector2f = Vector2!float;

/++
An agent that is primarily intended to exchange information between entities
++/
class Shot : Agent {
  
  float energy; /// A catch-all stat for shots which represents how much of an effect it can have on other things
  
  this(Vector2f _position, float _size){
    super(_position, _size);
  }
  
  override void destroy(){
    super.destroy;
  }
  
  override int agent_subtype_id(){ return 2; }
  int shot_subtype_id(){ return 0; }
  
}