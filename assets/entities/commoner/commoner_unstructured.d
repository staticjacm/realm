module commoner_unstructured;

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

alias Vector2f = Vector2!float;

class Commoner : Entity {
  static uint image_standing, image_walking_1, image_walking_2, image_hurt;
  static  Vector2f image_dimensions;
  static bool type_initialized = false;
  
  static initialize_type(){
    if(!type_initialized){
      make.initialize_type!"Fireball_1";
      make.initialize_type!"Fireball_2";
      make.initialize_type!"Rocket_1";
      image_dimensions = Vector2f(1, 1);
      image_standing  = gr_load_image("assets/entities/commoner/standing.png".toStringz, 0);
      image_walking_1 = gr_load_image("assets/entities/commoner/walking_1.png".toStringz, 0);
      image_walking_2 = gr_load_image("assets/entities/commoner/walking_2.png".toStringz, 0);
      image_hurt      = gr_load_image("assets/entities/commoner/hurt.png".toStringz, 0);
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
    propel_rate = 1.0f;
    l_defence = 0.0f;
    m_defence = 100.0f;
  }
  
  override string name(){ return "Filthy Commoner"; }
  override string description(){ return "A pleb"; }
  override string standard_article(){ return "a"; }
  
  override int entity_subtype_id(){ return 1; }
  
  
  override void update(){
    super.update;
    // writeln("attacking ", attacking);
    // writeln("update ", attacking, " ", attack_cooldown);
    if(attack_cooldown){
      if(attack_end_time < game_time)
        attack_cooldown = false;
    }
    else if(attacking){
      attack_cooldown = true;
      attack_end_time = game_time + attack_delay;
      if(attacking){
        for(int i = 0; i < 4; i++){
          if(uniform(0.0f, 100.0f) < 50.0){
            Shot fireball = create_shot(make_shot!"Fireball_1");
            fireball.set_velocity = (direction * 10.0f + Vector2f(uniform(-1.0f, 1.0f), uniform(-1.0f, 1.0f)));
          }
          else {
            Shot fireball = create_shot(make_shot!"Fireball_2");
            fireball.set_velocity = (direction * 10.0f + Vector2f(uniform(-1.0f, 1.0f), uniform(-1.0f, 1.0f)));
          }
        }
        // Rocket1 rocket = cast(Rocket1)create_shot(new Rocket1);
        // rocket.set_velocity = (direction * 15.0f);
        // rocket.angle = direction.angled;
      }
    }
  }
  
  // override float targeting_range(){ return 5.0f; }
  
  override void kill(){
    writeln("dead");
    for(int i = 0; i < 10; i++){
      Shot fireball = create_shot(make_shot!"Fireball_1");
      fireball.set_velocity = rvector(4.0f);
    }
    super.kill;
  }
  
  override void apply_damage(float damage){
    super.apply_damage(damage);
    // if(valid)
      // writeln(id, "'s hp is now ", health);
  }
  
  override void regular_attack_start(){
    attacking = true;
    super.regular_attack_start;
  }
  
  override void regular_attack_end(){
    attacking = false;
    super.regular_attack_end;
  }
}