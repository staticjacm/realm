module cactus;

import std.random;
import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import vector;
import wall;
import agent;

class Cactus_1 : Wall {
  static bool type_initialized = false;
  static uint image_1;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/walls/cactus/cactus_1.png".toStringz, 0);
    }
  }
  
  long endwait_time = 0;
  long endwait_delay = 100;
  bool waiting = false;
  
  this(){
    animation = new Animation([image_1], 1, Vector2f(0, 0), Vector2f(1, 2));
    endwait_time = game_time + endwait_delay;
  }
  
  override string name(){ return "Cactus"; }
  override string description(){ return "Very spiny, don't touch this!"; }
  override string standard_article(){ return "a"; }
  
  override void render(){
    if(waiting)
      gr_color(1, 0, 0, 1);
    super.render;
    gr_color_alpha(1);
  }
  
  override void update(){
    if(!waiting || endwait_time < game_time){
      waiting = false;
      set_updating = false;
    }
  }
  
  override void collide(Agent agent){
    if(!waiting){
      endwait_time = game_time + endwait_delay;
      set_updating = true;
      waiting = true;
    }
    super.collide(agent);
  }
}