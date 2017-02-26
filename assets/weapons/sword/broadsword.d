module broadsword;

import std.stdio;
import std.string;
import dbg;
import game;
import make;
import sgogl;
import animation;
import world;
import area;
import entity;
import weapon;
import shot;

class Broadsword_1 : Weapon {
  static bool type_initialized = false;
  static uint image;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      make.initialize_type!"Slash_1";
      image = gr_load_image("assets/weapons/sword/broadsword_1_1.png".toStringz, 0);
    }
  }
  
  bool ready = true;
  long ready_time;
  long attack_delay = 500;
  
  this(){
    animation = new Animation([image], 1.0f, Vector2f(0.5f, 0.5f), Vector2f(1.0f, 1.0f));
    tier = 1;
  }
  
  override string name(){ return "Broadsword"; }
  override string description(){ return "Heavy, but strong"; }
  override string standard_article(){ return "a"; }
  
  override void use(Entity entity){
    if(ready){
      if(entity !is null && entity.valid){
        ready = false;
        ready_time = game_time + attack_delay;
        Shot slash = make_shot!"Slash_1";
        entity.created_shot(slash);
        slash.velocity = entity.direction * 10.0f;
      }
    }
    else if(ready_time < game_time)
      ready = true;
  }
}