
module agent;

import vector;
import physical;
import dynamics;
import sllist;

alias Vector2f = Vector2!float;

/++
Proxy class from LList!Agent
++/
class Agent_list : LList!Agent {}

/++
A physical with dynamics
++/
class Agent : Physical {
  Dynamics dynamics;
  
  this(Vector2f _position, float _size){ super(_position, _size); }
  
  override int physical_subtype_id(){ return 1; }
  
  int agent_subtype_id(){ return 0; }
}