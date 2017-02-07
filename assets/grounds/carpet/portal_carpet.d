module portal_carpet;

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

class Portal_carpet_1 : Ground {
  static bool type_initialized = false;
  static uint image_1;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/carpet/portal_carpet_1.png".toStringz, 0);
    }
  }
  
  bool onq = false;
  
  this(){
    animation = new Animation([image_1], 1.0f, Vector2f(0,0), Vector2f(1,1));
  }
  
  override string name(){ return "Portal Carpet"; }
  override string description(){ return "Ancient carpet woven before the world fell apart. It is commonly laid under portals"; }
  override string standard_article(){ return "a"; }
  
}