
module entity;

import vector;
import game;
import agent;
import drop;
import shot;
import ground;
import wall;
import sgogl;
import sgogl_interface;

alias Vector2f = Vector2!float;

/++
An agent with stats
++/
class Entity : Agent {
  
  Vector2f direction = Vector2f(1, 0); /// What direction they are aiming in
  
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
  float max_speed = 1;       // maximum velocity magnitude where the entity can still accelerate themselves in the direction of velocity
  float attack_power = 1;    // determines the energy of shots produced due to physical / contact attacks
  
  this(){
    super();
  }
  
  override int agent_subtype_id(){ return Agent.subtype_entity; }
  int entity_subtype_id(){ return 0; }
  
  /// detected(agent) is called when Agent agent is detected
  void detected(Agent agent){}
  
  void regular_attack_start(){}
  void regular_attack_end(){}
  void special_attack_start(){}
  void special_attack_end(){}
  
  override void update(){
    super.update;
  }
  
  override void render(){
    gr_color(0.0, 0.0, 1.0, 1.0);
    gr_draw_line(position, position + direction, 1);
    gr_color_alpha(1.0);
    super.render;
  }
  
  void apply_damage(float damage){
    health -= (damage - l_defence) / m_defence;
  }
  
  override void collide(Entity other){}
  override void collide(Shot other){}
  override void collide(Drop other){}
  override void collide(Agent other){}
  override void collide(Wall wall){}
  override void over(Ground ground){}
}