module white_fence_1;

import std.random;
import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import vector;
import wall;
import agent;

class White_fence_1 : Wall {
  static bool type_initialized = false;
  static uint horizontal_image, vertical_image, corner_ul_image;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      horizontal_image = gr_load_image("assets/walls/white_fence/white_fence_horizontal_1.png".toStringz, 0);
      vertical_image   = gr_load_image("assets/walls/white_fence/white_fence_vertical_1.png".toStringz, 0);
      corner_ul_image  = gr_load_image("assets/walls/white_fence/white_fence_corner_ul_1.png".toStringz, 0);
    }
  }
  
  long endwait_time = 0;
  long endwait_delay = 100;
  bool waiting = false;
  
  this(Vector2f _position, int type){
    super(_position);
    switch(type){
      case 0:  animation = new Animation([horizontal_image], 1, Vector2f(0, 0), Vector2f(1, 2)); break;
      case 1:  animation = new Animation([vertical_image], 1, Vector2f(0, 0), Vector2f(1, 2)); break;
      default: animation = new Animation([corner_ul_image], 1, Vector2f(0, 0), Vector2f(1, 2)); break;
    }
    endwait_time = game_time + endwait_delay;
  }
  
  override string name(){ return "White Fence"; }
  override string description(){ return "Freshly painted"; }
  override string standard_article(){ return "a"; }
  
}