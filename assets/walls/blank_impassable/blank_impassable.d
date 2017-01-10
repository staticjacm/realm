module blank_impassable;

import std.random;
import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import vector;
import wall;
import agent;

class Blank_impassable : Wall {
  static bool type_initialized = false;
  static uint image_1, image_2, image_3;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
    }
  }
  
  this(Vector2f _position){
    super(_position);
  }
}