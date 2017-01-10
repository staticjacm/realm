module stability_boundary_1;

import std.random;
import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import vector;
import wall;
import agent;

class Stability_boundary_1 : Wall {
  static bool type_initialized = false;
  static uint image_1, image_2, image_3, image_4, image_5;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/walls/stability_boundary/stability_boundary_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/walls/stability_boundary/stability_boundary_2.png".toStringz, 0);
      image_3 = gr_load_image("assets/walls/stability_boundary/stability_boundary_3.png".toStringz, 0);
      image_4 = gr_load_image("assets/walls/stability_boundary/stability_boundary_4.png".toStringz, 0);
      image_5 = gr_load_image("assets/walls/stability_boundary/stability_boundary_5.png".toStringz, 0);
    }
  }
  
  this(Vector2f _position){
    super(_position);
    uint[] all_images = [image_1, image_2, image_3, image_4, image_5];
    uint[] frames_list;
    for(int i = 0; i < 4; i++){
      if(uniform(0, 100) > 10)
        frames_list ~= all_images[i];
    }
    animation = new Animation(frames_list, uniform(0.98f, 1.02f), Vector2f(0, 0), Vector2f(1, 2));
  }
}