module rooted;

import vector;
import refable;
import animation;
import renderable;
import area;

class Rooted : Renderable {
  enum {
    subtype_rooted,
    subtype_ground,
    subtype_wall
  }
  
  Area area;
  
  this(Vector2f _position){
    super(_position);
  }
  
  override void destroy(){
    area = null;
    super.destroy;
  }
  
  int rooted_subtype_id(){ return subtype_rooted; }
  
  bool interacts(){ return true; }
  
  void update(long time, float dt){}
}