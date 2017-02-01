module kernel_house_short_1;

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

class Kernel_house_short_1 : Wall {
  static bool type_initialized = false;
  static uint left_image_1, left_image_2, right_image_1, right_image_2;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      left_image_1  = gr_load_image("assets/walls/kernel_house/kernel_house_short_1_left_1.png".toStringz, 0);
      left_image_2  = gr_load_image("assets/walls/kernel_house/kernel_house_short_1_left_2.png".toStringz, 0);
      right_image_1 = gr_load_image("assets/walls/kernel_house/kernel_house_short_1_right_1.png".toStringz, 0);
      right_image_2 = gr_load_image("assets/walls/kernel_house/kernel_house_short_1_right_2.png".toStringz, 0);
    }
  }
  
  this(Vector2f _position, int type){
    super(_position);
    if(type == 0)
      switch(uniform!"[]"(0, 1)){
        case 0: animation = new Animation([left_image_1], 1.0f, Vector2f(0,0), Vector2f(1,3));  break;
        case 1: animation = new Animation([left_image_2], 1.0f, Vector2f(0,0), Vector2f(1,3));  break;
        default: goto case 0; break;
      }
    else
      switch(uniform!"[]"(0, 1)){
        case 0: animation = new Animation([right_image_1], 1.0f, Vector2f(0,0), Vector2f(1,3));  break;
        case 1: animation = new Animation([right_image_2], 1.0f, Vector2f(0,0), Vector2f(1,3));  break;
        default: goto case 0; break;
      }
  }
  
  override string name(){ return "House Wall"; }
  override string description(){ return "A building where people generally live"; }
  override string standard_article(){ return "a"; }
  
}