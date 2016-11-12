
module agent;

import vector;
import physical;
import sllist;
import dynamics;

alias Vector2f = Vector2!float;

/++
A physical with dynamics
++/
class Agent : Physical {
  Dynamics dynamics;
  
  this(Vector2f _position, float _size){ super(_position, _size); }
  
  override void destroy(){
    dynamics.destroy;
    super.destroy;
  }
  
  override int physical_subtype_id(){ return 1; }
  
  int agent_subtype_id(){ return 0; }
}