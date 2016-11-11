
module physical;

import vector;
import collidable;
import material;
import animation;

alias Vector2f = Vector2!float;

/++
Represents a physical object that can inhabit a realm.
A conceptual abstract of floating (can move freely between grid locations) and fixed (affixed to the grid) objects
Each physical has a size for collision detection purposes
++/
class Physical : Collidable {
  Material material;
  Animation* animation;
  Vector2f position;
  float height = 0;
  float size = 1;
  float angle = 0;
  
  this(Vector2f _position, float _size){
    position = _position;
    size = _size;
  }
  
  void move_by(Vector2f delta){
    position += delta;
  }
  
  void move_to(Vector2f new_position){
    position = new_position;
  }
  
  /// int type_id() is used for type identification
  abstract int physical_subtype_id(){ return 0; }
  
  /// void overlap(Physical) is called when a collision is detected (this's and other's collision squares intersect)
  override void overlap(Collidable other){
    if(material !is null) material.overlap(this, other);
  }
  
  void update(long time, float dt){
    if(material !is null) material.update(time, dt);
  }
  
  void render(){
    if(height > 0)
      gr_draw(*animation, position + Vector2f(0, height), height, angle);
    else
      gr_draw(*animation, position, 0, angle);
  }
}