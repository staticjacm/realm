module wall;

import std.stdio;
import std.math;
import vector;
import agent;
import rooted;

class Wall : Rooted {
  this(Vector2f _position){
    super(_position);
  }
  
  // ~this(){
    // writeln("destructed wall ", id);
  // }
  
  override void destroy(){
    // if(area !is null)
      // area.wall = null;
    super.destroy;
  }
  
  override float render_depth(){ return 100; }
  
  override int rooted_subtype_id(){ return Rooted.subtype_wall; }
  
  override bool interacts(){ return true; }
  
  void collide(Agent agent){
    Vector2f pdif = agent.position.floor - position.floor;
    if(pdif.x == 1 && agent.velocity.x < 0){
      agent.velocity.x *= -1;
      agent.position.x = position.x + 1 + agent.size/2;
    }
    else if(pdif.x == -1 && 0 < agent.velocity.x){
      agent.velocity.x *= -1;
      agent.position.x = position.x - agent.size/2;
    }
    if(pdif.y == 1 && agent.velocity.y < 0){
      agent.velocity.y *= -1;
      agent.position.y = position.y + 1 + agent.size/2;
    }
    else if(pdif.y == -1 && 0 < agent.velocity.y){
      agent.velocity.y *= -1;
      agent.position.y = position.y - agent.size/2;
    }
  }
}