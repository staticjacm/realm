module stone_wall_1;

import std.random;
import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import vector;
import wall;
import agent;

class Stone_wall_1 : Wall {
  static bool type_initialized = false;
  static uint image_1, image_2, image_3;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/walls/stone_wall/stone_wall_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/walls/stone_wall/stone_wall_2.png".toStringz, 0);
      image_3 = gr_load_image("assets/walls/stone_wall/stone_wall_3.png".toStringz, 0);
    }
  }
  
  this(Vector2f _position){
    super(_position);
    switch(uniform!"[]"(0, 2)){
      default:
      case 0:  animation = new Animation([image_1], 1, Vector2f(0, 0), Vector2f(1, 2)); break;
      case 1:  animation = new Animation([image_2], 1, Vector2f(0, 0), Vector2f(1, 2)); break;
      case 2:  animation = new Animation([image_3], 1, Vector2f(0, 0), Vector2f(1, 2)); break;
    }
  }
}