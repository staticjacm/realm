module free_soul;

/// This guy should actually be under structured entities, but it doesn't really matter for now

import std.stdio;
import std.string;
import std.random;
import game;
import animation;
import vector;
import entity;
import shot;
import agent;
import sgogl;

alias Vector2f = Vector2!float;

class Free_soul : Entity {
  static uint image_1, image_2;
  static bool type_initialized = false;
  
  static initialize_type(){
    if(!type_initialized){
      image_1 = gr_load_image("assets/entities/free_soul/image_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/entities/free_soul/image_2.png".toStringz, 0);
    }
  }
  
  this(){
    super();
    walking_animation = new Animation([image_1, image_2], 2.0f, Vector2f(0.5f, 0.0f), Vector2f(1.0f, 1.0f));
    standing_animation = walking_animation;
    hurt_animation = walking_animation;
    collider_size_x = 0.2;
    collider_size_y = 0.2;
    max_speed   = 5.0f;
    propel_rate = 40.0f;
    m_defence = 0.1f;
  }
  
  override string name(){ return "Free Soul"; }
  override string description(){ return "A soul dissociated from a body"; }
  override string standard_article(){ return "a"; }
}