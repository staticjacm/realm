module drop_tiers;

import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import drop;

void initialize_drop_tiers(){
  Drop_tier_0.initialize_type;
  Drop_tier_1.initialize_type;
}

Drop drop_decide_tier(float tier){
  if(tier < 1)
    return new Drop_tier_0;
  else if(true)
    return new Drop_tier_1;
  
}

class Drop_tier_0 : Drop {
  static bool type_initialized = false;
  static uint image;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image = gr_load_image("assets/drops/drop_tier_0_1.png".toStringz, 0);
    }
  }
  
  this(){
    animation = new Animation([image], 1.0f, Vector2f(0.5f, 0.5f), Vector2f(1.0f, 1.0f));
    collider_size_x = 0.5;
    collider_size_y = 0.5;
  }
  
}

class Drop_tier_1 : Drop {
  static bool type_initialized = false;
  static uint image;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image = gr_load_image("assets/drops/drop_tier_0_1.png".toStringz, 0);
    }
  }
  
  this(){
    animation = new Animation([image], 1.0f, Vector2f(0.5f, 0.5f), Vector2f(1.0f, 1.0f));
    collider_size_x = 0.5;
    collider_size_y = 0.5;
  }
  
}