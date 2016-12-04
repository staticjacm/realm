module rooted;

import std.stdio;
import vector;
import game;
import refable;
import animation;
import renderable;
import area;
import sllist;

class Rooted_list : LList!Rooted {}

class Rooted : Renderable {
  
  static Rooted_list update_list;
  static int gid = 0;
  
  static this(){
    update_list = new Rooted_list;
  }

  enum {
    subtype_rooted,
    subtype_ground,
    subtype_wall
  }
  
  Area area;
  Rooted_list.Index update_index;
  int id;
  
  this(Vector2f _position){
    super(_position);
    id = gid++;
  }
  
  // ~this(){
    // writeln("destructured rooted at ", position);
  // }
  
  override void destroy(){
    update_index.remove;
    area = null;
    super.destroy;
  }
  
  int rooted_subtype_id(){ return subtype_rooted; }
  
  bool interacts(){ return true; }
  
  void update(){}
  
  bool updates(){ return update_index.valid; }
  
  void set_updating(bool ud){
    // writeln("setting updating to ", ud);
    if(ud){
      if(!update_index.valid){
        update_index = update_list.add(this);
      }
    }
    else{
      if(update_index.valid){
        update_index.remove;
      }
    }
  }
}