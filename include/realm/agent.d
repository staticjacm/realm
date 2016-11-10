
module agent;

import vector;
import physical;
import dynamic;

float Vector2f = Vector2!float;

/++
A physical object that can move freely from position to position and have velocities, mass, etc to do so
++/
class Agent : Physical, Dynamical {
  
  Vector2f velocity;
  float mass;
  
  this(Vector2f _position, float _size){ super(_position, _size); }
  
  override int physical_subtype_id(){ return 1; }
}