module commoner;

/// This guy should actually be under structured entities, but it doesn't really matter for now

import std.string;
import std.random;
import game;
import animation;
import vector;
import entity;
import agent;
import fireball1;
import fireball2;
import rocket1;
import sgogl;

alias Vector2f = Vector2!float;

class Commoner : Entity {
  static uint image_standing, image_walking_1, image_walking_2, image_hurt;
  static  Vector2f image_dimensions;
  static bool type_initialized = false;
  
  static initialize_type(){
    if(!type_initialized){
      Fireball1.initialize_type;
      Fireball2.initialize_type;
      Rocket1.initialize_type;
      image_dimensions = Vector2f(1, 1);
      image_standing  = gr_load_image("assets/entities/commoner/standing.png".toStringz, 0);
      image_walking_1 = gr_load_image("assets/entities/commoner/walking_1.png".toStringz, 0);
      image_walking_2 = gr_load_image("assets/entities/commoner/walking_2.png".toStringz, 0);
      image_hurt      = gr_load_image("assets/entities/commoner/hurt.png".toStringz, 0);
    }
  }
  
  Animation animation_standing, animation_walking, animation_hurt;
  
  this(Vector2f _position, float _size){
    super(_position, _size);
    animation_standing = new Animation([image_standing], 1, Vector2f(0.5, 0), image_dimensions);
    animation_walking  = new Animation([image_walking_1, image_walking_2], 10, Vector2f(0.5, 0), image_dimensions);
    animation_hurt     = new Animation([image_hurt], 1, Vector2f(0.5, 0), image_dimensions);
    animation = animation_walking;
  }
  
  override int entity_subtype_id(){ return 1; }
  
  override void regular_attack(){
    //for(int i = 0; i < 4; i++){
    //  if(uniform(0.0f, 100.0f) < 50.0){
    //    Fireball1 fireball = new Fireball1(position, 1);
    //    fireball.world = world;
    //    fireball.set_velocity = (direction * 10.0f + Vector2f(uniform(-1.0f, 1.0f), uniform(-1.0f, 1.0f)));
    //  }
    //  else {
    //    Fireball2 fireball = new Fireball2(position, 1);
    //    fireball.world = world;
    //    fireball.set_velocity = (direction * 10.0f + Vector2f(uniform(-1.0f, 1.0f), uniform(-1.0f, 1.0f)));
    //  }
    //}
    Rocket1 rocket = new Rocket1(position, 1);
    rocket.world = world;
    rocket.set_velocity = (direction * 15.0f);
    rocket.angle = direction.angled;
  }
}