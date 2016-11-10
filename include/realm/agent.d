
module agent;

import vector;
import physical;
import dynamical;
import sllist;

float Vector2f = Vector2!float;

/++
Proxy class from LList!Agent
++/
class Agent_list : LList!Agent {}

/++
A dynamical physical
++/
class Agent : Physical, Dynamical {
  
  this(Vector2f _position, float _size){ super(_position, _size); }
  
  override int physical_subtype_id(){ return 1; }
}