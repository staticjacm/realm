module stone_ground;

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

class Stone_ground_1 : Ground {
  static bool type_initialized = false;
  static uint image_1, image_2, image_3, image_4, image_5, image_6;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/stone/stone_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/grounds/stone/stone_2.png".toStringz, 0);
      image_3 = gr_load_image("assets/grounds/stone/stone_3.png".toStringz, 0);
      image_4 = gr_load_image("assets/grounds/stone/stone_4.png".toStringz, 0);
      image_5 = gr_load_image("assets/grounds/stone/stone_5.png".toStringz, 0);
      image_6 = gr_load_image("assets/grounds/stone/stone_6.png".toStringz, 0);
    }
  }
  
  bool onq = false;
  
  this(){
    set_type(uniform!"[]"(0, 1));
  }
  
  void set_type(int type){
    if(type <= 0){
      switch(uniform!"[]"(0, 2)){
        default:
        case 0: animation = new Animation([image_1], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
        case 1: animation = new Animation([image_2], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
        case 2: animation = new Animation([image_3], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
      }
    }
    else if(type >= 1){
      switch(uniform!"[]"(3, 5)){
        default:
        case 3: animation = new Animation([image_4], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
        case 4: animation = new Animation([image_5], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
        case 5: animation = new Animation([image_6], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
      }
    }
  }
  
  override string name(){ return "Stone"; }
  override string description(){ return "A hard, smooth stone surface"; }
  override string standard_article(){ return "some"; }
  
}