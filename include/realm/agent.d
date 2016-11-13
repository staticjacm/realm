
module agent;

import std.stdio;
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
  
  this(Vector2f _position, float _size){
    super(_position, _size);
    dynamics = new Dynamics;
  }
  
  override void destroy(){
    dynamics.destroy;
    super.destroy;
  }
  
  override void update(long time, float dt){
    if(dynamics.moving){
      dynamics.update_position(position, dt);
      moved = true;
    }
  }
  
  override int physical_subtype_id(){ return 1; }
  
  override float render_depth(){ return physical.level_render_depth; }
  
  int agent_subtype_id(){ return 0; }
  
  void accelerate(Vector2f acceleration, float dt){ dynamics.accelerate(acceleration, dt); }
  void apply_impulse(Vector2f force, float dt){ dynamics.apply_impulse(force, dt); }
}