module cactus1;

import std.random;
import std.stdio;
import std.string;
import sgogl;
import animation;
import vector;
import wall;
import agent;

class Cactus1 : Wall {
  static bool type_initialized = false;
  static uint image_1;
  static Animation animation_1;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/walls/cactus1/cactus1.png".toStringz, 0);
      writeln("image_1: ", image_1);
      animation_1 = new Animation([image_1], 1, Vector2f(0, 0), Vector2f(1, 2));
    }
  }
  
  long internal_time = 0;
  long under_timer = 0;
  long under_delay = 1000;
  bool waiting = false;
  
  this(Vector2f _position){
    super(_position);
    int selection = uniform(0,3);
    animation = animation_1;
  }
  
  override void render(long time){
    // if(waiting)
      // gr_color(1, 0, 0, 1);
    super.render(time);
    // gr_color_alpha(1);
  }
  
  override void update(long time, float dt){
    internal_time = time;
    // if(waiting) writefln("waiting %b, under_time %d, internal_time %d", waiting, under_timer, internal_time);
    if(waiting && under_timer < internal_time){
      waiting = false;
    }
  }
  
  override void collide(Agent agent){
    if(!waiting){
      // writeln("under agent");
      under_timer = internal_time + under_delay;
      waiting = true;
    }
    super.collide(agent);
  }
}