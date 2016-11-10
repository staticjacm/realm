
import vector;

alias Vector2f = Vector2!float;

/++
Represents a physical object that can inhabit a realm.
A conceptual abstract of floating (can move freely between grid locations) and fixed (affixed to the grid) objects
Each physical has a size for collision detection purposes
++/
class Physical {
  Vector2f position;
  float size;
  
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
  void overlap(Physical other){}
}