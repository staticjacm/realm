module brick_path_1;

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

class Brick_path_1 : Ground {
  static bool type_initialized = false;
  static uint image_1, image_2, image_3, image_4, image_5, image_6;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/brick/brick_path_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/grounds/brick/brick_path_2.png".toStringz, 0);
      image_3 = gr_load_image("assets/grounds/brick/brick_path_3.png".toStringz, 0);
      image_4 = gr_load_image("assets/grounds/brick/brick_path_4.png".toStringz, 0);
    }
  }
  
  bool onq = false;
  
  this(Vector2f _position){
    super(_position);
    switch(uniform!"[]"(0, 3)){
      case 0: animation = new Animation([image_1], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
      case 1: animation = new Animation([image_2], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
      case 2: animation = new Animation([image_3], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
      case 3: animation = new Animation([image_4], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
      default: goto case 0; break;
    }
  }
}