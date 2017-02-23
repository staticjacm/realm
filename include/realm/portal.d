module portal;

import std.stdio;
import make;
import world;
import agent;

class Portal : Agent {
  
  World exit_world = null;
  string default_world_class = "";
  Vector2f exit_position = Vector2f(0, 0);
  
  this(){}
  ~this(){}
  
  override string name(){ return "portal"; }
  override string description(){ return "An undefined portal"; }
  override string standard_article(){ return "a"; }
  
  override int agent_subtype_id(){ return Agent.subtype_portal; }
  
  override void activate(Agent agent){
    if(exit_world is null && default_world_class != ""){
      exit_world = make_world(default_world_class);
      exit_position = exit_world.entrance_position;
    }
    if(agent !is null && exit_world !is null){
      agent.position = exit_position;
      exit_world.place_agent(agent);
    }
  }
  
}