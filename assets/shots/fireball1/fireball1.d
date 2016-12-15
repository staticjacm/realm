module fireball1;

/// This guy should actually be under structured entities, but it doesn't really matter for now

import std.stdio;
import std.string;
import std.random;
import animation;
import game;
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
  
  long end_time;
  long lifetime = 1000;
  
  this(){
    super();
    animation = new Animation([image_1, image_2, image_3], 30, Vector2f(0.5, 0.5), Vector2f(1, 1));
    friction = 0;
    end_time = game_time + lifetime + uniform(0, 500);
    restitution = 0;
  }
  
  void set_lifetime(long lifetime_){
    lifetime = lifetime_;
    end_time = game_time + lifetime_;
  }
  
  override void update(){
    super.update;
    // accelerate(rvector(1));
    accelerate(rvector(100));
    if(end_time < game_time){
      destroy(this);
    }
  }
}