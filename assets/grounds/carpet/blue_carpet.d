module blue_carpet;

import std.random;
import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import vector;
import ground;
import agent;
import validatable;

class Blue_carpet_1 : Ground {
  static bool type_initialized = false;
  static uint image_1;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/carpet/blue_carpet_1.png".toStringz, 0);
    }
  }
  
  this(){
    animation = new Animation([image_1], 1.0f, Vector2f(0,0), Vector2f(1,1));
  }
  
  override string name(){ return "Blue Carpet"; }
  override string description(){ return "A blue carpet. Stylish!"; }
  override string standard_article(){ return "a"; }
  
}


class Blue_carpet_2 : Ground {
  static bool type_initialized = false;
  static uint image_1;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/carpet/blue_carpet_2.png".toStringz, 0);
    }
  }
  
  this(){
    super();
    animation = new Animation([image_1], 1.0f, Vector2f(0,0), Vector2f(1,1));
  }
  
  override string name(){ return "Blue Carpet"; }
  override string description(){ return "A blue carpet. Stylish!"; }
  override string standard_article(){ return "a"; }
  
}