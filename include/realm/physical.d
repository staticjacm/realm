
module physical;

import std.conv;
import vector;
import collidable;
import material;
import animation;
import sllist;

alias Vector2f = Vector2!float;

float under_render_depth = 1000;
float level_render_depth = 100;
float over_render_depth  = 1;

/++
Proxy class from LList!Physical
++/
class Physical_list : LList!Physical {}

/++
Represents a physical object that can inhabit a realm.
A conceptual abstract of floating (can move freely between grid locations) and fixed (affixed to the grid) objects
Each physical has a size for collision detection purposes
++/
class Physical : Collidable {
  static int gid = 0; int id = 0;
  Physical_list.Index index;
  Material material;
  Animation animation;
  Vector2f position;
  float height = 0;
  float size = 1;
  float angle = 0;
  bool moved = false;
  
  this(Vector2f _position, float _size){
    id = gid++;
    position = _position;
    size = _size;
  }
  
  override string toString(){ return "Physical "~id.to!string; }
  
  void destroy(){
    index.remove;
    material.destroy;
    animation.destroy;
    object.destroy(this);
  }
  
  void move_by(Vector2f delta){
    position += delta;
    moved = true;
  }
  
  void move_to(Vector2f new_position){
    position = new_position;
    moved = true;
  }
  
  /// int type_id() is used for type identification
  abstract int physical_subtype_id(){ return 0; }
  
  float render_depth(){ return under_render_depth; }
  
  /// void overlap(Physical) is called when a collision is detected (this's and other's collision squares intersect)
  override void overlap(Collidable other){
    if(material !is null) material.overlap(this, other);
  }
  
  void update(long time, float dt){
    if(material !is null) material.update(time, dt);
  }
  
  bool check_for_collisions(){ return true; }
  
  void render(long time){
    if(animation !is null){
      if(height > 0)
        gr_draw(animation, position + Vector2f(0, height), render_depth + position.y, angle);
      else
        gr_draw(animation, position, 0, angle);
    }
  }
}