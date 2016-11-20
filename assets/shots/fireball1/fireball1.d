module fireball1;

/// This guy should actually be under structured entities, but it doesn't really matter for now

import std.stdio;
import std.string;
import animation;
import vector;
import shot;
import entity;
import sgogl;

alias Vector2f = Vector2!float;

class Fireball1 : Shot {
  static uint image_1, image_2, image_3;
  static bool type_initialized = false;
  
  static initialize_type(){
    if(!type_initialized){
      image_1 = gr_load_image("assets/shots/fireball1/fireball1_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/shots/fireball1/fireball1_2.png".toStringz, 0);
      image_3 = gr_load_image("assets/shots/fireball1/fireball1_3.png".toStringz, 0);
    }
  }
  
  bool time_generated = false;
  long creation_time = 0;
  long end_time = 100;
  long lifetime = 1000;
  
  this(Vector2f _position, float _size){
    super(_position, _size);
    animation = new Animation([image_1, image_2, image_3], 1, Vector2f(0.5, 0.5), Vector2f(1, 1));
    friction = 0;
  }
  
  override void update(long time, float dt){
    super.update(time, dt);
    if(!time_generated){
      creation_time = time;
      end_time = creation_time + lifetime;
      time_generated = true;
    }
    if(end_time < time){
      destroy;
    }
  }
  
  override void initialize(Entity entity){
    velocity = entity.direction * 10;
    moving = true;
  }
}