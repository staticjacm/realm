module shallow_ocean_water;

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

class Shallow_ocean_water_1 : Ground {
  static bool type_initialized = false;
  static uint image_1, image_2, image_3, image_4;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/water/shallow_ocean_water_1_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/grounds/water/shallow_ocean_water_1_2.png".toStringz, 0);
      image_3 = gr_load_image("assets/grounds/water/shallow_ocean_water_1_3.png".toStringz, 0);
      image_4 = gr_load_image("assets/grounds/water/shallow_ocean_water_1_4.png".toStringz, 0);
    }
  }
  
  this(){
    switch(uniform!"[]"(1, 4)){
      default:
      case 1: animation = new Animation([image_1, image_2, image_3, image_4], uniform(0.8f, 1.2f), Vector2f(0,0), Vector2f(1,1));  break;
      case 2: animation = new Animation([image_3, image_1, image_4, image_2], uniform(0.8f, 1.2f), Vector2f(0,0), Vector2f(1,1));  break;
      case 3: animation = new Animation([image_2, image_4, image_3, image_1], uniform(0.8f, 1.2f), Vector2f(0,0), Vector2f(1,1));  break;
      case 4: animation = new Animation([image_4, image_3, image_2, image_1], uniform(0.8f, 1.2f), Vector2f(0,0), Vector2f(1,1));  break;
    }
  }
  
  override string name(){ return "Ocean water"; }
  override string description(){ return "Shallow enough to stand in"; }
  override string standard_article(){ return "some"; }
  
  override float friction(){ return 45; }
  override float max_speed_mod(){ return 0.4; }
  
}