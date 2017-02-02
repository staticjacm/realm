module fire_staff;

import std.stdio;
import std.string;
import dbg;
import game;
import sgogl;
import animation;
import world;
import area;
import entity;
import weapon;
import fireball1;
import rocket1;

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
  long attack_delay = 100;
  
  this(){
    animation = new Animation([image], 1.0f, Vector2f(0.5f, 0.5f), Vector2f(1.0f, 1.0f));
    tier = 1;
  }
  
  override string name(){ return "Common Staff of Fire"; }
  override string description(){ return "Shoots not-so-powerful fireballs"; }
  override string standard_article(){ return "a"; }
  
  override void use(Entity entity){
    if(ready){
      if(entity !is null && entity.valid){
        Fireball1 fireball = new Fireball1;
        fireball.position = entity.position;
        fireball.velocity = entity.direction * 30;
        entity.world.place_agent(fireball);
        fireball.faction_id = entity.faction_id;
        // debug_add_line(entity.position, 1);
        // entity.world.apply_raycast_2((float distance, Vector2f pos, Area area){
          // writeln("pos ", pos, " area ", area);
          // debug_add_line(pos, 2);
          // debug_add_line(pos, 1);
          // if(10.0f < distance || area is null || area.wall !is null){
            // return false;
          // }
          // return true;
        // }, entity.position, entity.direction, true);
        ready = false;
        ready_time = game_time + attack_delay;
      }
    }
    else if(ready_time < game_time)
      ready = true;
  }
}