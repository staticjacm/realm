module kernel_house_tall;

import std.random;
import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import vector;
import wall;
import agent;
import validatable;

class Kernel_house_tall_1 : Wall {
  static bool type_initialized = false;
  static uint left_image_1, left_image_2, right_image_1, right_image_2;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      left_image_1  = gr_load_image("assets/walls/kernel_house/kernel_house_tall_1_left_1.png".toStringz, 0);
      left_image_2  = gr_load_image("assets/walls/kernel_house/kernel_house_tall_1_left_2.png".toStringz, 0);
      right_image_1 = gr_load_image("assets/walls/kernel_house/kernel_house_tall_1_right_1.png".toStringz, 0);
      right_image_2 = gr_load_image("assets/walls/kernel_house/kernel_house_tall_1_right_2.png".toStringz, 0);
    }
  }
  
  this(){
    set_type(uniform!"[]"(0, 1));
  }
  
  void set_type(int type){
    if(type == 0)
      switch(uniform!"[]"(0, 1)){
        default:
        case 0: animation = new Animation([left_image_1], 1.0f, Vector2f(0,0), Vector2f(1,3));  break;
        case 1: animation = new Animation([left_image_2], 1.0f, Vector2f(0,0), Vector2f(1,3));  break;
      }
    else
      switch(uniform!"[]"(0, 1)){
        default:
        case 0: animation = new Animation([right_image_1], 1.0f, Vector2f(0,0), Vector2f(1,3));  break;
        case 1: animation = new Animation([right_image_2], 1.0f, Vector2f(0,0), Vector2f(1,3));  break;
      }
  }
  
  override string name(){ return "House Wall"; }
  override string description(){ return "Must house many people (or a few very wealthy ones)"; }
  override string standard_article(){ return "a"; }
  
}