module generic_portal;

import std.stdio;
import std.string;
import agent;
import animation;
import vector;
import sgogl;
import portal;
import world;

class Generic_portal_1 : Portal {
  static bool type_initialized = false;
  static uint image_1, image_2;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/portals/generic_portal/generic_portal_1_1.png", 0);
      image_2 = gr_load_image("assets/portals/generic_portal/generic_portal_1_2.png", 0);
    }
  }
  
  this(){
    animation = new Animation([image_1, image_2], 0.5f, Vector2f(0.5f, 0.1f), Vector2f(1.0f, 2.0f));
    collider_size_x = 0.5;
  }
  
  override string name(){ return "Portal"; }
  override string description(){ return "A connection between worlds"; }
  override string standard_article(){ return "a"; }
  
}