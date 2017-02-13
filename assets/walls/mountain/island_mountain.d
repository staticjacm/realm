module island_mountain;

import std.random;
import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import vector;
import wall;
import agent;

class Island_mountain_cliff_1 : Wall {
  static bool type_initialized = false;
  static uint image_1, image_2, image_3, image_4;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/walls/mountain/island_mountain_cliff_1_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/walls/mountain/island_mountain_cliff_1_2.png".toStringz, 0);
      image_3 = gr_load_image("assets/walls/mountain/island_mountain_cliff_1_3.png".toStringz, 0);
      image_4 = gr_load_image("assets/walls/mountain/island_mountain_cliff_1_4.png".toStringz, 0);
    }
  }
  
  this(){
    switch(uniform!"[]"(1, 4)){
      default:
      case 1: animation = new Animation([image_1], 1, Vector2f(0, 0), Vector2f(1, 4)); break;
      case 2: animation = new Animation([image_2], 1, Vector2f(0, 0), Vector2f(1, 4)); break;
      case 3: animation = new Animation([image_3], 1, Vector2f(0, 0), Vector2f(1, 4)); break;
      case 4: animation = new Animation([image_4], 1, Vector2f(0, 0), Vector2f(1, 4)); break;
    }
  }
  
  override string name(){ return "Cliff"; }
  override string description(){ return "Created by ancient (and not so ancient) flowing lava";}
  override string standard_article(){ return "a"; }
}