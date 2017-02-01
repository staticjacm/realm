module rooted;

import std.stdio;
import vector;
import game;
import validatable;
import animation;
import renderable;
import area;
import sllist;

class Rooted_list : LList!Rooted {}

class Rooted : Renderable {
  
  static bool type_initialized = false;
  static Rooted_list update_list;
  static int gid = 0;
  
  // static this(){
    // update_list = new Rooted_list;
  // }
  static initialize_type(){
    if(!type_initialized){
      update_list = new Rooted_list;
    }
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
    super();
    position = _position;
    id = gid++;
  }
  
  string name(){ return "rooted object"; }
  string description(){ return "An undefined rooted object"; }
  string standard_article(){ return "a"; }
  
  // ~this(){
    // writeln("destructured rooted at ", position);
  // }
  
  ~this(){
    update_index.remove;
  }
  
  int rooted_subtype_id(){ return subtype_rooted; }
  
  bool interacts(){ return true; }
  
  void update(){}
  
  bool updates(){ return update_index.valid; }
  
  override bool draw_shadow(){ return false; }
  
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