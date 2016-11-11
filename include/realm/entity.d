
module entity;

import vector;
import agent;
import behavior;

alias Vector2f = Vector2!float;

/++
An agent with some behaviors
++/
class Entity : Agent {
  Behavior behavior = null;
  bool uses_behavior = true;
  Vector2f direction = Vector2f(1, 0); /// What direction they are aiming in
  
  this(Vector2f _position, float _size){ super(_position, _size); }
  
  override int agent_subtype_id(){ return 1; }
  int entity_subtype_id(){ return 0; }
  
  override void update(long time, float dt){
    super.update(time, dt);
    behavior.update(time, dt);
  }
  
  /// detected(agent) is called when Agent agent is detected
  void detected(Agent agent){
    behavior.detected(agent);
  }
  
  void regular_attack(){
    behavior.regular_attack();
  }
}