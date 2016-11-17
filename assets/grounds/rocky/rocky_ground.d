module rocky_ground;

import std.random;
import std.stdio;
import std.string;
import sgogl;
import animation;
import vector;
import ground;
import agent;

class Rocky_ground : Ground {
  static bool type_initialized = false;
  static uint image_1, image_2, image_3;
  static Animation animation_1, animation_2, animation_3;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/rocky/rocky1.png".toStringz, 0);
      image_2 = gr_load_image("assets/grounds/rocky/rocky2.png".toStringz, 0);
      image_3 = gr_load_image("assets/grounds/rocky/rocky3.png".toStringz, 0);
      animation_1 = new Animation([image_1], 1, Vector2f(0, 0), Vector2f(1, 1));
      animation_2 = new Animation([image_2], 1, Vector2f(0, 0), Vector2f(1, 1));
      animation_3 = new Animation([image_3], 1, Vector2f(0, 0), Vector2f(1, 1));
    }
  }
  
  long internal_time = 0;
  long under_timer = 0;
  long under_delay = 1000;
  bool waiting = false;
  
  this(Vector2f _position){
    super(_position);
    int selection = uniform(0,3);
    switch(uniform(0, 3)){
      case 0: animation = animation_1;  break;
      case 1: animation = animation_2;  break;
      case 2: animation = animation_3;  break;
      default: animation = animation_1; break;
    }
  }
  
  override void render(long time){
    if(waiting)
      gr_color(1, 0, 0, 1);
    super.render(time);
    gr_color_alpha(1);
  }
  
  override void update(long time, float dt){
    internal_time = time;
    // if(waiting) writefln("waiting %b, under_time %d, internal_time %d", waiting, under_timer, internal_time);
    if(waiting && under_timer < internal_time){
      waiting = false;
    }
  }
  
  override bool interacts(){ return true; }
  
  override void under(Agent agent){
    if(!waiting){
      // writeln("under agent");
      under_timer = internal_time + under_delay;
      waiting = true;
    }
  }
}