
module entity;

import vector;
import agent;

alias Vector2f = Vector2!float;

/++
An agent with stats
++/
class Entity : Agent {
  Vector2f direction = Vector2f(1, 0); /// What direction they are aiming in
  
  this(Vector2f _position, float _size){
    super(_position, _size);
  }
  
  override void destroy(){
    super.destroy;
  }
  
  override int agent_subtype_id(){ return 1; }
  int entity_subtype_id(){ return 0; }
  
  /// detected(agent) is called when Agent agent is detected
  void detected(Agent agent){}
  
  void regular_attack(){}
}