module commoner;

/// This guy should actually be under structured entities, but it doesn't really matter for now

import std.stdio;
import std.string;
import std.random;
import game;
import animation;
import vector;
import structured_entity;
import shot;
import agent;
import fireball1;
import fireball2;
import rocket1;
import sgogl;

alias Vector2f = Vector2!float;

class Commoner : Structured_entity {
  static uint image_standing, image_walking_1, image_walking_2, image_hurt;
  static  Vector2f image_dimensions;
  static bool type_initialized = false;
  
  static initialize_type(){
    if(!type_initialized){
      Fireball1.initialize_type;
      Fireball2.initialize_type;
      Rocket1.initialize_type;
      image_dimensions = Vector2f(1, 1);
      image_standing  = gr_load_image("assets/structured_entities/commoner/standing.png".toStringz, 0);
      image_walking_1 = gr_load_image("assets/structured_entities/commoner/walking_1.png".toStringz, 0);
      image_walking_2 = gr_load_image("assets/structured_entities/commoner/walking_2.png".toStringz, 0);
      image_hurt      = gr_load_image("assets/structured_entities/commoner/hurt.png".toStringz, 0);
    }
  }
  
  this(){
    standing_animation = new Animation([image_standing], 1, Vector2f(0.5, 0), image_dimensions);
    walking_animation  = new Animation([image_walking_1, image_walking_2], 10, Vector2f(0.5, 0), image_dimensions);
    hurt_animation     = new Animation([image_hurt], 1, Vector2f(0.5, 0), image_dimensions);
    collider_size_x = 0.33;
    collider_size_y = 0.33;
    l_defence = 0.0f;
    m_defence = 100.0f;
    propel_rate = 50.0f;
    max_speed = 5.0f;
    super();
  }
  
  override string name(){ return "Filthy Commoner"; }
  override string description(){ return "A pleb"; }
  override string standard_article(){ return "a"; }
  
  override int entity_subtype_id(){ return 1; }
  
  // override float targeting_range(){ return 5.0f; }
  
  override void kill(){
    for(int i = 0; i < 10; i++){
      Shot fireball = create_shot(new Fireball1);
      fireball.set_velocity = rvector(4.0f);
    }
    super.kill;
  }
}