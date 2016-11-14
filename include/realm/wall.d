module wall;

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
  
  void collide(Agent agent){}
}