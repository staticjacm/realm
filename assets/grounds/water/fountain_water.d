module fountain_water;

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

class Fountain_water_1 : Ground {
  static bool type_initialized = false;
  static uint image_1, image_2;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/water/fountain_water_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/grounds/water/fountain_water_2.png".toStringz, 0);
    }
  }
  
  bool onq = false;
  
  this(){
    switch(uniform!"[]"(0, 1)){
      default:
      case 0: animation = new Animation([image_1, image_2], uniform(0.8f, 1.2f), Vector2f(0,0), Vector2f(1,1));  break;
      case 1: animation = new Animation([image_1, image_2], uniform(0.8f, 1.2f), Vector2f(0,0), Vector2f(1,1));  break;
    }
  }
  
  override string name(){ return "Refreshing Fountain Water"; }
  override string description(){ return "Negative ions!"; }
  override string standard_article(){ return "some"; }
  
  override float friction(){ return 45; }
  override float max_speed_mod(){ return 0.5; }
  
}