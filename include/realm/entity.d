
module entity;

import std.stdio;
import std.math;
import vector;
import sllist;
import animation;
import game;
import agent;
import effect;
import item;
import drop_tiers;
import drop;
import shot;
import ground;
import wall;
import timer;
import sgogl;
import sgogl_interface;

alias Vector2f = Vector2!float;

Timer test_timer;

class Entity_list : LList!Entity {}

/++
An agent with stats
++/
class Entity : Agent {
  static int targeting_cycle = 1_000; // Delay between finding targets
  
  enum {
    subtype_entity,
    subtype_structured_entity
  }
  
  Effect_list effects;
  Vector2f direction = Vector2f(1, 0); /// What direction they are aiming in
  
  Animation walking_animation, standing_animation, hurt_animation;
  bool facing_rightward = true;
  
  bool is_walking = false;
  long walking_switch_time;
  int walking_switch_delay = 200;
  
  bool is_hurt    = false;
  long hurt_switch_time;
  int hurt_switch_delay = 100;
  
  Item[] items;
  
  // Targeting and control
  bool automatic_controls = true; // Should behavior be automatic? / should the entity be controlled by the computer?
  Entity target = null;           // The target entity that the
  long targeting_time = 0;        // Time when another target is sought
  
  bool regular_attack_started = false;
  bool special_attack_started = false;
  
  /* Stats */
  // defence
  float l_defence = 0;       // decreases incoming dmg additively (newdmg = olddmg - ldef)
  float m_defence = 1.0;     // decreases incoming dmg multiplicatively (newdmg = olddmg / mdef)
  float energy_defence = 0;  // decreases incoming energy damage additively (newnrgdmg = oldnrgdmg - nrgdef)
  // health
  float health      = 5;     // health, hp<0 => death (hp)
  float health_max  = 10;    // max health (hpmax)
  float health_rate = 0.1;   // health generation rate (hpr)
  // energy - a generic magic / stamina
  float energy = 0;          // current energy (nrg)
  float energy_max  = 10;    // max energy (nrgmax)
  float energy_rate = 0.1;   // energy generation rate (nrgr)
  // movement, attack
  float propel_rate = 1;     // rate at which the entity can propel itself (self acceleration)
  float max_speed = 1;       // maximum velocity magnitude where the entity can still accelerate themselves in the direction of velocity
  float attack_power = 1;    // determines the energy of shots produced due to physical / contact attacks
  
  this(){
    super();
    effects = new Effect_list;
    items.length = 8;
    animation = standing_animation;
  }
  ~this(){
    if(effects !is null)
      foreach(Effect effect; effects){
        if(effect !is null && effect.valid)
          effect.finalize;
          destroy(effect);
      }
    
    // items as drop
    if(world !is null){
      int tier_decider = -1;
      for(int i = 0; i < items.length; i++){
        if(items[i] !is null){
          tier_decider = i;
          break;
        }
      }
      if(0 <= tier_decider){
        Drop drop = drop_decide_tier(items[tier_decider].tier);
        drop.position = position;
        world.place_agent(drop);
        for(int i = 0; i < items.length; i++){
          drop.items[i] = items[i];
          items[i] = null;
        }
      }
    }
  }
  
  override int agent_subtype_id(){ return Agent.subtype_entity; }
  int entity_subtype_id(){ return subtype_entity; }
  
  /// detected(agent) is called when Agent agent is detected
  void detected(Agent agent){}
  
  void regular_attack_start(){
    regular_attack_started = true;
  }
  void regular_attack_end(){
    regular_attack_started = false;
  }
  void special_attack_start(){
    special_attack_started = true;
  }
  void special_attack_end(){
    special_attack_started = false;
  }
  
  void add_effect(Effect effect){
    effect.entity = this;
    effect.entity_index = effects.add(effect);
  }
  
  void apply_damage(float damage){
    if(0 < damage){
      is_hurt = true;
      hurt_switch_time = game_time + hurt_switch_delay;
      health -= fmax(damage - l_defence, 0) / m_defence;
      if(health <= 0){
        kill;
        destroy(this);
      }
    }
  }
  
  float targeting_range(){ return 15.0f; }
  
  // Should target new_target be prefered over the current target current_target?
  bool compare_targets(Entity current_target, Entity new_target){
    return new_target.health < current_target.health;
  }
  
  void find_new_target(){
    // test_timer.start;
    if(world !is null){
      Entity_list candidate_entities;
      candidate_entities = world.get_entities_nearby(position, targeting_range);
      // if(target is null || !target.valid && candidate_entities.length > 0 && target !is candidate_entities.first.value)
        // target = candidate_entities.first.value;
      if(target is this)
        target = null;
      if(target !is null && target.valid && (target.position - position).norm > targeting_range){
        target = null;
      }
      foreach(Entity entity; candidate_entities){
        // already targeting something
        if(target !is null && target.valid) {
          if(entity !is null && entity.valid && entity !is this && compare_targets(target, entity))
            target = entity;
        }
        // no target
        else if(target !is entity && entity !is this && entity !is null && entity.valid)
          target = entity;
      }
    }
    // test_timer.report("find_new_target ");
  }
  
  void behavior(){
    if(target !is null && target.valid){
      Vector2f pdif = target.position - position;
      direction = pdif.normalize;
      if(!regular_attack_started)
        regular_attack_start;
      propel((direction.rotate_by(PI/2) + pdif.normalize*(pdif.norm - 10.0f)).normalize*50.0);
    }
    else if(regular_attack_started){
      regular_attack_end;
    }
  }
  
  void propel(Vector2f direction){
    is_walking = true;
    walking_switch_time = game_time + walking_switch_delay;
    if(speed < max_speed){
      accelerate(direction.normalize * propel_rate);
    }
  }
  
  void select_animation(){
    facing_rightward = (direction.x <= 0);
    flip_horizontally = facing_rightward;
    if(is_walking)
      animation = walking_animation;
    else
      animation = standing_animation;
    if(is_hurt)
      animation = hurt_animation;
  }
  
  override void update(){
    if(automatic_controls){
      if(targeting_time < game_time){
        targeting_time = game_time + targeting_cycle;
        find_new_target;
      }
      behavior;
    }
    select_animation;
    if(is_walking && walking_switch_time < game_time)
      is_walking = false;
    if(is_hurt && hurt_switch_time < game_time)
      is_hurt = false;
    foreach(Effect effect; effects){
      effect.update;
    }
    super.update;
  }
  
  override void render(){
    gr_color(0.0, 0.0, 1.0, 1.0);
    gr_draw_line(position, position + direction, 1);
    gr_color_alpha(1.0);
    super.render;
  }
  
  // Calculate damaged from a collision based on some speed change
  float collision_damage(float speed_delta){
    if(speed_delta < 100.0f)
      return 0.0f;
    else
      return speed_delta*speed_delta / 10_000.0f;
  }
  override void set_velocity(Vector2f new_velocity){
    apply_damage(collision_damage((new_velocity - velocity).norm));
    if(valid)
      super.set_velocity(new_velocity);
  }
  
  alias collide = Agent.collide;
  override void collide(Entity other){
    foreach(Effect effect; effects){
      effect.collide(other);
    }
    if(valid)
      super.collide(other);
  }
  override void collide(Shot other){
    foreach(Effect effect; effects){
      effect.collide(other);
    }
    if(valid)
      super.collide(other);
    
  }
  override void collide(Drop other){
    foreach(Effect effect; effects){
      effect.collide(other);
    }
    if(valid)
      super.collide(other);
    
  }
  override void collide(Agent other){
    foreach(Effect effect; effects){
      effect.collide(other);
    }
    if(valid)
      super.collide(other);
    
  }
  override void collide(Wall wall){
    foreach(Effect effect; effects){
      effect.collide(wall);
    }
    if(valid)
      super.collide(wall);
    
  }
  override void collide(Ground ground){
    foreach(Effect effect; effects){
      effect.collide(ground);
    }
    if(valid)
      super.collide(ground);
    
  }
}