
module dynamics;

import std.stdio;
import vector;

alias Vector2f = Vector2!float;

/++
A little class just to clear up dynamical physicals later
holds all physics related information
++/
class Dynamics {
  Vector2f velocity = Vector2f(0, 0);
  float mass = 1;
  float restitution = 0; /// Set to zero for inelastic collisions
  bool moving = false;
  
  void set_velocity(Vector2f _velocity){
    velocity = _velocity;
  }
  
  void accelerate(Vector2f acceleration, float dt){
    velocity += acceleration*dt;
    if(velocity.x != 0 || velocity.y != 0)
      moving = true;
  }
  
  void apply_impulse(Vector2f force, float dt){
    accelerate(force / mass, dt);
    moving = true;
  }
  
  void update_position(ref Vector2f position, float dt){
    position += velocity*dt;
  }
}