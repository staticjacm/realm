module slash;

/// This guy should actually be under structured entities, but it doesn't really matter for now

import std.math;
import std.stdio;
import std.string;
import std.random;
import animation;
import game;
import vector;
import shot;
import entity;
import sgogl;

alias Vector2f = Vector2!float;

class Slash_1 : Shot {
  static uint image_1, image_2;
  static bool type_initialized = false;
  
  static initialize_type(){
    if(!type_initialized){
      image_1 = gr_load_image("assets/shots/slash/slash_1_1.png".toStringz, 0);
    }
  }
  
  long end_time;
  long lifetime = 300;
  
  this(){
    super();
    animation = new Animation([image_1], 1, Vector2f(0.5, 0.25), Vector2f(2, 2));
    end_time = game_time + lifetime;
    height = 1.0f;
    collider_size_x = 0.5;
    collider_size_y = 0.5;
    end_time = game_time + lifetime;
  }
  
  override string name(){ return "Slash"; }
  override string description(){ return "Something sharp made this"; }
  override string standard_article(){ return "a"; }
  
  override bool uses_friction(){ return false; }
  
  override bool destroy_on_agent_collision(){ return true; }
  override bool destroy_on_wall_collision(){ return true; }
  
  override float render_angle(){ return velocity.angled; }
  
  override float damage(){
    return 1.5f;
  }
  
  override void update(){
    super.update;
    // accelerate(rvector(1));
    if(end_time < game_time){ kill; }
  }
}
