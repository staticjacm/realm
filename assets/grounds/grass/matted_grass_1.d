module matted_grass_1;

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

class Matted_grass_1 : Ground {
  static bool type_initialized = false;
  static uint image_1, image_2;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/grass/matted_grass_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/grounds/grass/matted_grass_2.png".toStringz, 0);
    }
  }
  
  bool onq = false;
  
  this(Vector2f _position){
    super(_position);
    switch(uniform!"[]"(0, 1)){
      case 0: animation = new Animation([image_1], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
      case 1: animation = new Animation([image_2], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
      default: goto case 0; break;
    }
  }
}