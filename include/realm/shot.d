
module shot;

import vector;
import drop;
import wall;
import ground;
import entity;
import agent;

alias Vector2f = Vector2!float;

/++
An agent that is primarily intended to exchange information between entities
++/
class Shot : Agent {
  
  float energy; /// A catch-all stat for shots which represents how much of an effect it can have on other things
  
  this(){
    super();
  }
  
  override int agent_subtype_id(){ return Agent.subtype_shot; }
  int shot_subtype_id(){ return 0; }
  
  float damage(){ return 0; }
  
  bool destroy_on_agent_collision(){ return true; }
  bool destroy_on_wall_collision(){ return true; }
  
  alias collide = Agent.collide;
  
  override void collide(Wall wall){
    super.collide(wall);
    // if(destroy_on_wall_collision){
      // kill;
      // destroy(this);
    // }
  }
  
  override void collide(Entity other){
    super.collide(other);
    if(other.faction_id != faction_id){
      other.apply_damage(damage);
      // if(destroy_on_agent_collision){
        // kill;
        // destroy(this);
      // }
    }
  }
  
}