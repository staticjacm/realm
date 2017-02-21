module bush;

import std.random;
import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import vector;
import wall;
import agent;

class Bush_1 : Wall {
  static bool type_initialized = false;
  static uint image_1;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/walls/bush/bush_1_1.png".toStringz, 0);
    }
  }
  
  this(){
    animation = new Animation([image_1], 1, Vector2f(0.25f, 0), Vector2f(2, 2));
  }
  
  override string name(){ return "Bush"; }
  override string description(){ return "It's just a bush"; }
  override string standard_article(){ return "a"; }
}