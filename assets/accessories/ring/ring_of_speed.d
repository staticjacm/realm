module ring_of_speed;

import std.stdio;
import std.string;
import game;
import structured_entity;
import sgogl;
import animation;
import accessory;

class Ring_of_speed_1 : Accessory {
  static bool type_initialized = false;
  static uint image;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image = gr_load_image("assets/accessories/ring/ring_of_speed_1.png".toStringz, 0);
    }
  }
  
  this(){
    animation = new Animation([image], 1.0f, Vector2f(0.5f, 0.5f), Vector2f(1.0f, 1.0f));
  }
  
  override string name(){ return "Common Ring of Speed"; }
  override string description(){ return "Slightly increases speed"; }
  override string standard_article(){ return "a"; }
  
  override void equipped(Structured_entity entity){
    entity.max_speed += 10.0f;
  }
  override void dequipped(Structured_entity entity){
    entity.max_speed -= 10.0f;
  }
  
}