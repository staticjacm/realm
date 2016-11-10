
module collidable;

/++
Small class that represents any objects which can interact through collisions (overlapping of their collision squares)
++/
abstract class Collidable {
  
  /// void overlap(Collidable) is called when a collision is detected (this's and other's collision squares intersect)
  void overlap(Collidable other){}
}