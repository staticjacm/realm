module fountain_wall;

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

class Fountain_wall_1 : Ground {
  static bool type_initialized = false;
  static uint image_1;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/misc/fountain_wall_1.png".toStringz, 0);
    }
  }
  
  bool onq = false;
  
  this(){
    animation = new Animation([image_1], 1.0f, Vector2f(0,0), Vector2f(1,1));
  }
  
  override string name(){ return "Wall of a Fountain"; }
  override string description(){ return "Don't fall in!"; }
  override string standard_article(){ return "a"; }
  
}