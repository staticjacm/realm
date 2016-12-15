module fireball2;

/// This guy should actually be under structured entities, but it doesn't really matter for now

import std.stdio;
import std.string;
import std.random;
import animation;
import vector;
import game;
import shot;
import entity;
import sgogl;

alias Vector2f = Vector2!float;

class Fireball2 : Shot {
  static uint image_1, image_2, image_3;
  static bool type_initialized = false;
  
  static initialize_type(){
    if(!type_initialized){
      image_1 = gr_load_image("assets/shots/fireball2/fireball2_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/shots/fireball2/fireball2_2.png".toStringz, 0);
      image_3 = gr_load_image("assets/shots/fireball2/fireball2_3.png".toStringz, 0);
    }
  }
  
  long end_time = 100;
  long lifetime = 300;
  
  this(){
    super();
    animation = new Animation([image_1, image_2, image_3], 1, Vector2f(0.5, 0.5), Vector2f(1, 1));
    friction = 0;
    end_time = game_time + lifetime;
  }
  
  override void update(){
    super.update;
    if(end_time < game_time){
      destroy(this);
    }
  }
}