module shirt;

import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import entity;
import armor;

class Shirt_1 : Armor {
  static bool type_initialized = false;
  static uint image;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image = gr_load_image("assets/armors/shirt/shirt_1.png".toStringz, 0);
    }
  }
  
  this(){
    animation = new Animation([image], 1.0f, Vector2f(0.5f, 0.5f), Vector2f(1.0f, 1.0f));
  }
  
  override string name(){ return "Justashirt"; }
  override string description(){ return "A shirt, what more do you expect?"; }
  override string standard_article(){ return "a"; }
  
  override float modify_damage(float damage){
    return damage - 1;
  }
  
}