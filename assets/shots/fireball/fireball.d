module fireball;

/// This guy should actually be under structured entities, but it doesn't really matter for now

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

class Fireball_1 : Shot {
  static uint image_1, image_2, image_3;
  static bool type_initialized = false;
  
  static initialize_type(){
    if(!type_initialized){
      image_1 = gr_load_image("assets/shots/fireball/fireball_1_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/shots/fireball/fireball_1_2.png".toStringz, 0);
      image_3 = gr_load_image("assets/shots/fireball/fireball_1_3.png".toStringz, 0);
    }
  }
  
  long end_time;
  long lifetime = 1000;
  
  this(){
    super();
    animation = new Animation([image_1, image_2, image_3], 30, Vector2f(0.5, 0.5), Vector2f(1, 1));
    end_time = game_time + lifetime + uniform(0, 500);
    height = 0.5;
    collider_size_x = 0.5;
    collider_size_y = 0.5;
    restitution = 0;
  }
  
  override string name(){ return "Fireball"; }
  override string description(){ return "Wow! That's hot!"; }
  override string standard_article(){ return "a"; }
  
  override bool uses_friction(){ return false; }
  
  void set_lifetime(long lifetime_){
    lifetime = lifetime_;
    end_time = game_time + lifetime_;
  }
  
  override bool destroy_on_agent_collision(){ return true; }
  override bool destroy_on_wall_collision(){ return false; }
  
  override float damage(){
    return 0.1f;
  }
  
  override void update(){
    super.update;
    // accelerate(rvector(1));
    accelerate(rvector(100));
    if(end_time < game_time){ kill; }
  }
}

class Fireball_2 : Shot {
  static uint image_1, image_2, image_3;
  static bool type_initialized = false;
  
  static initialize_type(){
    if(!type_initialized){
      image_1 = gr_load_image("assets/shots/fireball/fireball_2_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/shots/fireball/fireball_2_2.png".toStringz, 0);
      image_3 = gr_load_image("assets/shots/fireball/fireball_2_3.png".toStringz, 0);
    }
  }
  
  long end_time = 100;
  long lifetime = 300;
  
  this(){
    super();
    animation = new Animation([image_1, image_2, image_3], 1, Vector2f(0.5, 0.5), Vector2f(1, 1));
    end_time = game_time + lifetime;
  }
  
  override string name(){ return "Hot Fireball"; }
  override string description(){ return "Damn! That's REALLY hot!"; }
  override string standard_article(){ return "a"; }
  
  override bool uses_friction(){ return false; }
  
  override bool destroy_on_agent_collision(){ return true; }
  override bool destroy_on_wall_collision(){ return false; }
  
  override float damage(){
    return 0.4;
  }
  
  override void update(){
    super.update;
    if(end_time < game_time){ kill; }
  }
}