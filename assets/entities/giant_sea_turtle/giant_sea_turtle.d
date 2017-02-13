module giant_sea_turtle;

/// This guy should actually be under structured entities, but it doesn't really matter for now

import std.stdio;
import std.string;
import std.random;
import make;
import game;
import animation;
import vector;
import entity;
import shot;
import agent;
import sgogl;

class Giant_sea_turtle_1 : Entity {
  static uint image_standing, image_walking_1, image_walking_2, image_hurt;
  static  Vector2f image_dimensions;
  static bool type_initialized = false;
  
  static initialize_type(){
    if(!type_initialized){
      image_dimensions = Vector2f(4, 3);
      image_standing  = gr_load_image("assets/entities/giant_sea_turtle/giant_sea_turtle_1_standing.png".toStringz, 0);
      image_walking_1 = gr_load_image("assets/entities/giant_sea_turtle/giant_sea_turtle_1_walking_1.png".toStringz, 0);
      image_walking_2 = gr_load_image("assets/entities/giant_sea_turtle/giant_sea_turtle_1_walking_2.png".toStringz, 0);
      image_hurt      = gr_load_image("assets/entities/giant_sea_turtle/giant_sea_turtle_1_hurt.png".toStringz, 0);
    }
  }
  
  Animation animation_standing, animation_walking, animation_hurt;
  
  bool attack_cooldown = false;
  bool attacking = false;
  long attack_end_time = 0;
  long attack_delay = 300;
  
  this(){
    super();
    animation_standing = new Animation([image_standing], 1, Vector2f(0.5, 0), image_dimensions);
    animation_walking  = new Animation([image_walking_1, image_walking_2], 10, Vector2f(0.5, 0), image_dimensions);
    animation_hurt     = new Animation([image_hurt], 1, Vector2f(0.5, 0), image_dimensions);
    animation = animation_walking;
    propel_rate = 3.0f;
    l_defence = 5.0f;
  }
  
  override string name(){ return "Giant sea turtle"; }
  override string description(){ return "A gigantic, ancient sea turtle corrupted by the destroyer!"; }
  override string standard_article(){ return "a"; }
  
  // override float targeting_range(){ return 5.0f; }
}