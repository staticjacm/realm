module rocky_ground;

import std.stdio;
import sgogl;
import animation;
import physical;
import vector;

class Rocky_ground : Physical {
  static bool type_initialized = false;
  static uint image_1, image_2, image_3;
  static Animation animation_1, animation_2, animation_3;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/rocky/rocky1.png", 0);
      image_2 = gr_load_image("assets/grounds/rocky/rocky2.png", 0);
      image_3 = gr_load_image("assets/grounds/rocky/rocky3.png", 0);
      animation_1 = new Animation([image_1], 1, Vector2f(0, 0), Vector2f(1, 1));
      animation_2 = new Animation([image_2], 1, Vector2f(0, 0), Vector2f(1, 1));
      animation_3 = new Animation([image_3], 1, Vector2f(0, 0), Vector2f(1, 1));
    }
  }
  
  this(Vector2f _position, float _size){
    super(_position, _size);
    animation = animation_1;
  }
  
  override bool check_for_collisions(){ return false; }
  override int physical_subtype_id(){ return -1; }
}