module ring_of_defence;

import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import accessory;

class Ring_of_defence_1 : Accessory {
  static bool type_initialized = false;
  static uint image;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image = gr_load_image("assets/accessories/ring/ring_of_defence_1.png".toStringz, 0);
    }
  }
  
  this(){
    animation = new Animation([image], 1.0f, Vector2f(0.5f, 0.5f), Vector2f(1.0f, 1.0f));
  }
  
  override float modify_damage(float damage){
    return damage - 1;
  }
  
}