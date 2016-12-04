module ground;

import std.stdio;
import vector;
import agent;
import rooted;

class Ground : Rooted {
  this(Vector2f _position){
    super(_position);
  }
  
  // ~this(){
    // writeln("destructed ground ", id);
  // }
  
  override void destroy(){
    // if(area !is null)
      // area.ground = null;
    super.destroy;
  }
  
  override float render_depth(){ return 300; }
  
  override int rooted_subtype_id(){ return Rooted.subtype_ground; }
  
  override bool interacts(){ return false; }
  
  void under(Agent agent){}
  void entered(Agent agent){}
  void exited(Agent agent){}
}