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
  
  override void destroy(){
    super.destroy;
  }
  
  override float render_depth(){ return 100; }
  
  override int rooted_subtype_id(){ return Rooted.subtype_wall; }
  
  override bool interacts(){ return true; }
  
  void collide(Agent agent){
    Vector2f pdif = agent.position.floor - position.floor;
    writeln("collided ", agent.position.floor, " - ", position, " = ", pdif);
    if(pdif.x == 1 && agent.velocity.x < 0){
      agent.velocity.x *= -1;
    }
    else if(pdif.x == -1 && 0 < agent.velocity.x){
      agent.velocity.x *= -1;
    }
    if(pdif.y == 1 && agent.velocity.y < 0){
      agent.velocity.y *= -1;
    }
    else if(pdif.y == -1 && 0 < agent.velocity.y){
      agent.velocity.y *= -1;
    }
  }
}