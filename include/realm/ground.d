module ground;

import std.stdio;
import vector;
import agent;
import rooted;

class Ground : Rooted {
  this(){
    super();
  }
  
  override string name(){ return "Ground"; }
  override string description(){ return "An undefined ground"; }
  override string standard_article(){ return "a"; }
  
  override float render_depth(){ return 10600; }
  
  override int rooted_subtype_id(){ return Rooted.subtype_ground; }
  
  override bool interacts(){ return false; }
  
  float friction(){ return 30.0f; }
  // max_speed_mod multiplies on entity max_speed values
  float max_speed_mod(){ return 1.0f; }
  
  void collide(Agent agent){}
  void entered(Agent agent){}
  void exited(Agent agent){}
}