module fire_staff;

import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import entity;
import weapon;
import fireball1;

class Fire_staff_1 : Weapon {
  static bool type_initialized = false;
  static uint image;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image = gr_load_image("assets/weapons/staff/fire_staff_1.png".toStringz, 0);
    }
  }
  
  bool ready = true;
  long ready_time;
  long attack_delay = 300;
  
  this(){
    animation = new Animation([image], 1.0f, Vector2f(0.5f, 0.5f), Vector2f(1.0f, 1.0f));
  }
  
  override void use(Entity entity){
    if(ready){
      if(entity !is null && entity.valid){
        Fireball1 fireball = new Fireball1;
        fireball.position = entity.position;
        fireball.velocity = entity.direction * 10;
        fireball.world = entity.world;
        ready = false;
        ready_time = game_time + attack_delay;
      }
    }
    else if(ready_time < game_time)
      ready = true;
  }
}