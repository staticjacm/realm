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
  
  Animation animation_standing, animation_walking, animation_hurt;
  
  this(){
    super();
    animation_standing = new Animation([image_standing], 1, Vector2f(0.5, 0), image_dimensions);
    animation_walking  = new Animation([image_walking_1, image_walking_2], 10, Vector2f(0.5, 0), image_dimensions);
    animation_hurt     = new Animation([image_hurt], 1, Vector2f(0.5, 0), image_dimensions);
    animation = animation_walking;
    l_defence = 0.0f;
    m_defence = 100.0f;
  }
  
  override int entity_subtype_id(){ return 1; }
  
  // override float targeting_range(){ return 5.0f; }
  
  override void kill(){
    writeln("dead");
    for(int i = 0; i < 10; i++){
      Shot fireball = create_shot(new Fireball1);
      fireball.set_velocity = rvector(4.0f);
    }
    super.kill;
  }
}