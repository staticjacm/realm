module portal;

import std.stdio;
import world;
import agent;

class Portal : Agent {
  
  World exit_world = null;
  Vector2f exit_position = Vector2f(0, 0);
  
  this(){}
  ~this(){}
  
  override string name(){ return "portal"; }
  override string description(){ return "An undefined portal"; }
  override string standard_article(){ return "a"; }
  
  override int agent_subtype_id(){ return Agent.subtype_portal; }
  
  override void activate(Agent agent){
    agent.world = exit_world;
    agent.position = exit_position;
  }
  
}